/// `docs/02-Domain/09-Notifications.md` Priority. `critical` is reserved
/// for security events — this app has no security-event detector yet, so
/// nothing ever creates one in v1.
enum NotificationPriority { low, normal, high, critical }
