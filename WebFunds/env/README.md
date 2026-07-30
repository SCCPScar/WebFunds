# Environment Files

Each `.json` here is passed to Flutter via `--dart-define-from-file` and
read at compile time by `lib/config/env_config.dart`.

    flutter run \
      --target lib/main_development.dart \
      --dart-define-from-file=env/development.json

## Before this project has a real Supabase account

All three files ship with empty `SUPABASE_URL` / `SUPABASE_ANON_KEY`
placeholders on purpose. `EnvConfig.isSupabaseConfigured` returns `false`
until real values are filled in, and no code requires them to be set —
every service that touches Supabase fails safe (no exceptions, no crash).

## Once real keys exist

- Never commit `staging.json` or `production.json` with real secrets to
  Git. Once you fill in real values, add that specific file to
  `.gitignore` and keep a safe, empty copy under a different name
  (e.g. `staging.example.json`).
- The Supabase anon key is safe to ship inside the compiled app, but
  still shouldn't sit in public Git history if avoidable.