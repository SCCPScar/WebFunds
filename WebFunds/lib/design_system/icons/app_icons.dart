import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/widgets.dart';

/// WebFunds icon tokens (ADR 001 — Bootstrap Icons is the single icon
/// library). Every icon reference used by the app is centralized here.
class AppIcons {
  const AppIcons._();

  // --- Navigation ---
  static const IconData central = BootstrapIcons.house;
  static const IconData finances = BootstrapIcons.walletFill;
  static const IconData vault = BootstrapIcons.safe2Fill;
  static const IconData mysteries = BootstrapIcons.searchHeartFill;
  static const IconData weaver = BootstrapIcons.stars;
  static const IconData profile = BootstrapIcons.personCircle;

  // --- Generic / foundation-level icons ---
  static const IconData back = BootstrapIcons.chevronLeft;
  static const IconData close = BootstrapIcons.x;
  static const IconData check = BootstrapIcons.check2;
  static const IconData eyeVisible = BootstrapIcons.eye;
  static const IconData eyeHidden = BootstrapIcons.eyeSlash;
  static const IconData error = BootstrapIcons.exclamationCircle;

  /// Bootstrap Icons has no dedicated "Face ID" glyph — `fingerprint` is
  /// used generically to represent biometric authentication.
  static const IconData biometric = BootstrapIcons.fingerprint;

  static const IconData activity = BootstrapIcons.clockHistory;
}