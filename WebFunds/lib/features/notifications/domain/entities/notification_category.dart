/// `docs/02-Domain/09-Notifications.md` Categories. Only `dream` and
/// `mystery` have a working detector in v1 (see
/// `DetectNotificationsUseCase`) — `financialCycle`, `subscription` and
/// `system` stay in the enum because the schema should already match the
/// doc's full category list, but nothing creates them yet: each needs
/// infrastructure this app doesn't have (background scheduling for
/// subscription renewals, cycle-inactivity heuristics, import/export
/// events).
enum NotificationCategory { financialCycle, mystery, dream, subscription, system }
