import 'package:flutter/widgets.dart';

import '../../../../design_system/icons/app_icons.dart';
import '../../domain/entities/account_type.dart';

/// Presentation-only label/icon mapping for [AccountType]. Kept out of the
/// Domain entity — the enum has no business reason to know how it's drawn.
extension AccountTypePresentation on AccountType {
  String get label => switch (this) {
    AccountType.checking => 'Conta à ordem',
    AccountType.savings => 'Poupança',
    AccountType.cash => 'Dinheiro',
    AccountType.creditCard => 'Cartão de crédito',
    AccountType.investment => 'Investimento',
  };

  IconData get icon => switch (this) {
    AccountType.checking => AppIcons.accountChecking,
    AccountType.savings => AppIcons.accountSavings,
    AccountType.cash => AppIcons.accountCash,
    AccountType.creditCard => AppIcons.accountCreditCard,
    AccountType.investment => AppIcons.accountInvestment,
  };
}
