// Enable Banking proxy — Milestone 6 (Banking).
//
// Runs server-side only: this is the one place ENABLE_BANKING_PRIVATE_KEY
// is allowed to exist. The Flutter app never sees it — every request to
// Enable Banking must be signed with it (RS256 JWT, `kid` = the
// Application ID), and doing that client-side in a public GitHub Pages
// web build would expose the key to anyone. The Flutter app calls this
// Function through `supabase_flutter`'s FunctionsClient, which attaches
// the caller's Supabase session automatically, and Supabase verifies
// that JWT before this code ever runs (no custom auth here) — same
// shape as `weaver-suggest-category`.
//
// Enable Banking access is read-only (Account Information only, no
// Payment Initiation service was requested at registration) — this
// Function has no way to move money even if it wanted to.

const APPLICATION_ID = Deno.env.get("ENABLE_BANKING_APPLICATION_ID");
const PRIVATE_KEY_PEM = Deno.env.get("ENABLE_BANKING_PRIVATE_KEY");
const API_BASE = "https://api.enablebanking.com";

const CORS_HEADERS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

function jsonResponse(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...CORS_HEADERS, "Content-Type": "application/json" },
  });
}

function base64UrlEncode(bytes: Uint8Array): string {
  let binary = "";
  for (const byte of bytes) binary += String.fromCharCode(byte);
  return btoa(binary).replace(/\+/g, "-").replace(/\//g, "_").replace(/=+$/, "");
}

function pemToDer(pem: string): Uint8Array {
  const base64 = pem
    .replace("-----BEGIN PRIVATE KEY-----", "")
    .replace("-----END PRIVATE KEY-----", "")
    .replace(/\s+/g, "");
  const binary = atob(base64);
  const bytes = new Uint8Array(binary.length);
  for (let i = 0; i < binary.length; i++) bytes[i] = binary.charCodeAt(i);
  return bytes;
}

let cachedSigningKey: CryptoKey | null = null;

async function getSigningKey(): Promise<CryptoKey> {
  if (cachedSigningKey) return cachedSigningKey;
  const der = pemToDer(PRIVATE_KEY_PEM ?? "");
  cachedSigningKey = await crypto.subtle.importKey(
    "pkcs8",
    der,
    { name: "RSASSA-PKCS1-v1_5", hash: "SHA-256" },
    false,
    ["sign"],
  );
  return cachedSigningKey;
}

// A fresh, short-lived JWT per request — simpler and safer than caching
// one across invocations of a stateless Edge Function.
async function signRequestJwt(): Promise<string> {
  const nowSeconds = Math.floor(Date.now() / 1000);
  const header = { alg: "RS256", typ: "JWT", kid: APPLICATION_ID };
  const payload = {
    iss: "enablebanking.com",
    aud: "api.enablebanking.com",
    iat: nowSeconds,
    exp: nowSeconds + 3600,
  };

  const headerB64 = base64UrlEncode(new TextEncoder().encode(JSON.stringify(header)));
  const payloadB64 = base64UrlEncode(new TextEncoder().encode(JSON.stringify(payload)));
  const signingInput = `${headerB64}.${payloadB64}`;

  const key = await getSigningKey();
  const signature = await crypto.subtle.sign(
    "RSASSA-PKCS1-v1_5",
    key,
    new TextEncoder().encode(signingInput),
  );

  return `${signingInput}.${base64UrlEncode(new Uint8Array(signature))}`;
}

async function callEnableBanking(
  path: string,
  init: RequestInit = {},
): Promise<{ status: number; data: unknown }> {
  const jwt = await signRequestJwt();
  const response = await fetch(`${API_BASE}${path}`, {
    ...init,
    headers: {
      ...(init.headers ?? {}),
      "Authorization": `Bearer ${jwt}`,
      "Content-Type": "application/json",
    },
  });
  const data = await response.json().catch(() => null);
  return { status: response.status, data };
}

interface ListInstitutionsRequest {
  action: "list_institutions";
  country: string;
}

interface StartAuthorizationRequest {
  action: "start_authorization";
  aspspName: string;
  aspspCountry: string;
  redirectUrl: string;
}

interface ExchangeSessionRequest {
  action: "exchange_session";
  code: string;
}

interface GetAccountDetailsRequest {
  action: "get_account_details";
  accountId: string;
}

interface GetBalancesRequest {
  action: "get_balances";
  accountId: string;
}

interface GetTransactionsRequest {
  action: "get_transactions";
  accountId: string;
  continuationKey?: string;
}

type BankingRequest =
  | ListInstitutionsRequest
  | StartAuthorizationRequest
  | ExchangeSessionRequest
  | GetAccountDetailsRequest
  | GetBalancesRequest
  | GetTransactionsRequest;

function isBankingRequest(value: unknown): value is BankingRequest {
  if (typeof value !== "object" || value === null) return false;
  const v = value as Record<string, unknown>;
  switch (v.action) {
    case "list_institutions":
      return typeof v.country === "string";
    case "start_authorization":
      return (
        typeof v.aspspName === "string" &&
        typeof v.aspspCountry === "string" &&
        typeof v.redirectUrl === "string"
      );
    case "exchange_session":
      return typeof v.code === "string";
    case "get_account_details":
      return typeof v.accountId === "string";
    case "get_balances":
      return typeof v.accountId === "string";
    case "get_transactions":
      return typeof v.accountId === "string";
    default:
      return false;
  }
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: CORS_HEADERS });
  }

  if (!APPLICATION_ID || !PRIVATE_KEY_PEM) {
    return jsonResponse(
      {
        error:
          "Banking is not configured (missing ENABLE_BANKING_APPLICATION_ID/ENABLE_BANKING_PRIVATE_KEY).",
      },
      503,
    );
  }

  let body: unknown;
  try {
    body = await req.json();
  } catch {
    return jsonResponse({ error: "Invalid JSON body." }, 400);
  }

  if (!isBankingRequest(body)) {
    return jsonResponse({ error: "Missing or invalid action/fields." }, 400);
  }

  try {
    switch (body.action) {
      case "list_institutions": {
        const { status, data } = await callEnableBanking(
          `/aspsps?country=${encodeURIComponent(body.country)}`,
        );
        return jsonResponse(data, status);
      }
      case "start_authorization": {
        // 10 days is Enable Banking's own maximum consent validity per
        // their docs' quick-start sample.
        const validUntil = new Date(Date.now() + 10 * 24 * 60 * 60 * 1000).toISOString();
        const { status, data } = await callEnableBanking("/auth", {
          method: "POST",
          body: JSON.stringify({
            access: { valid_until: validUntil },
            aspsp: { name: body.aspspName, country: body.aspspCountry },
            state: crypto.randomUUID(),
            redirect_url: body.redirectUrl,
            psu_type: "personal",
          }),
        });
        return jsonResponse(data, status);
      }
      case "exchange_session": {
        const { status, data } = await callEnableBanking("/sessions", {
          method: "POST",
          body: JSON.stringify({ code: body.code }),
        });
        return jsonResponse(data, status);
      }
      case "get_account_details": {
        const { status, data } = await callEnableBanking(
          `/accounts/${encodeURIComponent(body.accountId)}/details`,
        );
        return jsonResponse(data, status);
      }
      case "get_balances": {
        const { status, data } = await callEnableBanking(
          `/accounts/${encodeURIComponent(body.accountId)}/balances`,
        );
        return jsonResponse(data, status);
      }
      case "get_transactions": {
        const query = body.continuationKey
          ? `?continuation_key=${encodeURIComponent(body.continuationKey)}`
          : "";
        const { status, data } = await callEnableBanking(
          `/accounts/${encodeURIComponent(body.accountId)}/transactions${query}`,
        );
        return jsonResponse(data, status);
      }
    }
  } catch (error) {
    return jsonResponse({ error: `Banking request failed: ${(error as Error).message}` }, 502);
  }
});
