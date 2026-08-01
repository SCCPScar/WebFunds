import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/widgets.dart';

/// WebFunds icon tokens (ADR 001 — Bootstrap Icons is the single icon
/// library). Every icon reference used by the app is centralized here.
class AppIcons {
  const AppIcons._();

  // --- Navigation ---
  static const IconData central = BootstrapIcons.house;
  static const IconData finances = BootstrapIcons.wallet_fill;
  static const IconData vault = BootstrapIcons.safe2_fill;
  static const IconData mysteries = BootstrapIcons.search_heart_fill;
  static const IconData weaver = BootstrapIcons.stars;
  static const IconData profile = BootstrapIcons.person_circle;

  // --- Generic / foundation-level icons ---
  static const IconData back = BootstrapIcons.chevron_left;
  static const IconData close = BootstrapIcons.x;
  static const IconData check = BootstrapIcons.check2;
  static const IconData eyeVisible = BootstrapIcons.eye;
  static const IconData eyeHidden = BootstrapIcons.eye_slash;
  static const IconData error = BootstrapIcons.exclamation_circle;
  static const IconData add = BootstrapIcons.plus_lg;
  static const IconData archive = BootstrapIcons.archive;

  /// Bootstrap Icons has no dedicated "Face ID" glyph — `fingerprint` is
  /// used generically to represent biometric authentication.
  static const IconData biometric = BootstrapIcons.fingerprint;

  static const IconData activity = BootstrapIcons.clock_history;

  // --- Account types ---
  static const IconData accountChecking = BootstrapIcons.bank2;
  static const IconData accountSavings = BootstrapIcons.piggy_bank;
  static const IconData accountCash = BootstrapIcons.cash_stack;
  static const IconData accountCreditCard = BootstrapIcons.credit_card_fill;
  static const IconData accountInvestment = BootstrapIcons.graph_up_arrow;

  // --- Dreams ---
  static const IconData dreams = BootstrapIcons.rocket_takeoff_fill;
  static const IconData dreamWithdraw = BootstrapIcons.dash_circle;

  // --- Subscriptions ---
  static const IconData subscriptions = BootstrapIcons.arrow_repeat;
}