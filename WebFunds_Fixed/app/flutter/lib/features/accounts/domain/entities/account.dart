import '../../../../shared/models/money.dart';
import 'account_type.dart';

class Account {
  const Account({
    required this.id,
    required this.name,
    required this.type,
    required this.openingBalance,
    required this.createdAt,
    this.isArchived = false,
  });

  final String id;
  final String name;
  final AccountType type;
  final Money openingBalance;
  final DateTime createdAt;
  final bool isArchived;
}
