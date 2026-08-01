/// `docs/02-Domain/04-Dreams.md` describes Contributions and Withdrawals
/// as separate concepts with separate fields; modeled here as one type
/// on a single movement, the same "always-positive amount, direction
/// from type" shape `Transaction` already uses.
enum DreamMovementType { contribution, withdrawal }
