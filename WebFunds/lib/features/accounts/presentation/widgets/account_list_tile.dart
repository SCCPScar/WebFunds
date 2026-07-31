import 'package:flutter/material.dart';

import '../../../../design_system/icons/app_icons.dart';
import '../../../../shared/models/money.dart';
import '../../domain/entities/account.dart';
import '../utils/account_type_presentation.dart';

class AccountListTile extends StatelessWidget {
  const AccountListTile({
    super.key,
    required this.account,
    required this.balance,
    required this.onArchive,
  });

  final Account account;

  /// The Account's *current* balance (opening balance + its
  /// Transactions) — never `account.openingBalance` directly, which only
  /// reflects what the Account started with.
  final Money balance;
  final VoidCallback onArchive;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: ListTile(
        leading: Icon(account.type.icon, color: theme.colorScheme.primary),
        title: Text(account.name),
        subtitle: Text(account.type.label),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(balance.format(), style: theme.textTheme.titleLarge),
            IconButton(
              icon: const Icon(AppIcons.archive),
              tooltip: 'Arquivar conta',
              onPressed: onArchive,
            ),
          ],
        ),
      ),
    );
  }
}
