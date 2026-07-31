import '../../domain/entities/transaction_type.dart';

/// Presentation-only label mapping for [TransactionType].
extension TransactionTypePresentation on TransactionType {
  String get label => switch (this) {
    TransactionType.income => 'Receita',
    TransactionType.expense => 'Despesa',
    TransactionType.transfer => 'Transferência',
  };
}
