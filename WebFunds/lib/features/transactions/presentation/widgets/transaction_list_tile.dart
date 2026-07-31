import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/transaction.dart';
import '../../domain/entities/transaction_type.dart';
import '../utils/transaction_type_presentation.dart';

class TransactionListTile extends StatelessWidget {
  const TransactionListTile({super.key, required this.transaction, required this.onTap});

  final Transaction transaction;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Every color here comes from the theme, never from AppColors directly
    // — WebFunds hasn't defined a "success" ColorScheme slot yet, so
    // Income borrows primary rather than inventing a new token for one
    // widget.
    final amountColor = switch (transaction.type) {
      TransactionType.income => theme.colorScheme.primary,
      TransactionType.expense => theme.colorScheme.error,
      TransactionType.transfer => theme.colorScheme.onSurface,
    };
    final sign = switch (transaction.type) {
      TransactionType.income => '+',
      TransactionType.expense => '-',
      TransactionType.transfer => '',
    };

    return Card(
      child: ListTile(
        onTap: onTap,
        title: Text(transaction.merchant ?? transaction.type.label),
        subtitle: Text(
          [
            if (transaction.category != null) transaction.category!,
            DateFormat('dd/MM/yyyy').format(transaction.transactionDate),
          ].join(' · '),
        ),
        trailing: Text(
          '$sign${transaction.amount.format()}',
          style: theme.textTheme.titleLarge?.copyWith(color: amountColor),
        ),
      ),
    );
  }
}
