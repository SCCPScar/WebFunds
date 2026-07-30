import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Controls the application's [ThemeMode]. Defaults to [ThemeMode.dark]
/// because Dark Mode is the primary experience. In-memory only for now —
/// persisting the owner's choice is deferred to a later milestone.
final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.dark;

  void setThemeMode(ThemeMode mode) => state = mode;

  void toggle() {
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }
}