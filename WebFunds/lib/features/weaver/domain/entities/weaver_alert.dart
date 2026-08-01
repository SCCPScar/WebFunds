/// `Critical` is reserved for the day a real risk signal exists (e.g. a
/// synced Bank connection failing) — v1's only detectable condition
/// (a negative Account balance) is `warning`, never `critical`.
enum WeaverAlertSeverity { info, warning, critical }

/// Something the owner should probably look at soon — the one
/// `WeaverEngine` output that's meant to interrupt, sparingly.
class WeaverAlert {
  const WeaverAlert({
    required this.severity,
    required this.title,
    required this.description,
  });

  final WeaverAlertSeverity severity;
  final String title;
  final String description;
}
