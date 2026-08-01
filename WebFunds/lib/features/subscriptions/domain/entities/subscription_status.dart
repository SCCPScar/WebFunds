/// `docs/02-Domain/08-Subscriptions.md` Lifecycle. `detected` and
/// `suggested` aren't stored states — a [SubscriptionSuggestion] is
/// computed fresh each time, never persisted, so the schema only needs
/// the stages that exist once the owner has confirmed one.
enum SubscriptionStatus { active, paused, cancelled, archived }
