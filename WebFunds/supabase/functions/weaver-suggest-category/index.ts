// Weaver AI — category suggestion for one Transaction.
//
// Runs server-side only: this is the one place the ANTHROPIC_API_KEY is
// allowed to exist. The Flutter app never sees it — it calls this
// Function through `supabase_flutter`'s FunctionsClient, which attaches
// the caller's Supabase session automatically, and Supabase verifies
// that JWT before this code ever runs (no custom auth here).
//
// Per docs/02-Domain/06-Weaver.md: Weaver only ever suggests — it never
// writes anything itself. This Function returns a suggestion; applying
// it is a decision the owner makes in the app.

const ANTHROPIC_API_KEY = Deno.env.get("ANTHROPIC_API_KEY");
const ANTHROPIC_MODEL = "claude-haiku-4-5-20251001";

interface SuggestCategoryRequest {
  type: "income" | "expense" | "transfer";
  amountMajorUnits: number;
  currency: string;
  merchant?: string | null;
}

interface CategorySuggestion {
  category: string;
  confidenceScore: number;
  reasoning: string;
}

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

function isValidRequest(value: unknown): value is SuggestCategoryRequest {
  if (typeof value !== "object" || value === null) return false;
  const v = value as Record<string, unknown>;
  return (
    (v.type === "income" || v.type === "expense" || v.type === "transfer") &&
    typeof v.amountMajorUnits === "number" &&
    typeof v.currency === "string"
  );
}

async function suggestCategory(request: SuggestCategoryRequest): Promise<CategorySuggestion> {
  const prompt = [
    `Transaction type: ${request.type}`,
    `Amount: ${request.amountMajorUnits} ${request.currency}`,
    request.merchant ? `Merchant: ${request.merchant}` : "Merchant: (not provided)",
    "",
    "Suggest one short spending category for this transaction (e.g. Groceries, " +
      "Transport, Dining, Utilities, Salary, Entertainment, Health, Housing). " +
      "Reply with ONLY a JSON object, no other text, matching exactly this shape: " +
      '{"category": string, "confidenceScore": number (0-100), "reasoning": string (one short sentence)}.',
  ].join("\n");

  const response = await fetch("https://api.anthropic.com/v1/messages", {
    method: "POST",
    headers: {
      "content-type": "application/json",
      "x-api-key": ANTHROPIC_API_KEY ?? "",
      "anthropic-version": "2023-06-01",
    },
    body: JSON.stringify({
      model: ANTHROPIC_MODEL,
      max_tokens: 256,
      messages: [{ role: "user", content: prompt }],
    }),
  });

  if (!response.ok) {
    const body = await response.text();
    throw new Error(`Anthropic API error (${response.status}): ${body}`);
  }

  const data = await response.json();
  const text: string = data.content?.[0]?.text ?? "";
  const jsonMatch = text.match(/\{[\s\S]*\}/);
  if (!jsonMatch) {
    throw new Error("Anthropic response did not contain JSON.");
  }

  const parsed = JSON.parse(jsonMatch[0]);
  if (typeof parsed.category !== "string" || typeof parsed.confidenceScore !== "number") {
    throw new Error("Anthropic response JSON missing required fields.");
  }

  return {
    category: parsed.category,
    confidenceScore: Math.max(0, Math.min(100, Math.round(parsed.confidenceScore))),
    reasoning: typeof parsed.reasoning === "string" ? parsed.reasoning : "",
  };
}

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: CORS_HEADERS });
  }

  if (!ANTHROPIC_API_KEY) {
    return jsonResponse({ error: "Weaver is not configured (missing ANTHROPIC_API_KEY)." }, 503);
  }

  let body: unknown;
  try {
    body = await req.json();
  } catch {
    return jsonResponse({ error: "Invalid JSON body." }, 400);
  }

  if (!isValidRequest(body)) {
    return jsonResponse({ error: "Missing or invalid type/amountMajorUnits/currency." }, 400);
  }

  try {
    const suggestion = await suggestCategory(body);
    return jsonResponse(suggestion);
  } catch (error) {
    return jsonResponse({ error: `Failed to get a suggestion: ${(error as Error).message}` }, 502);
  }
});
