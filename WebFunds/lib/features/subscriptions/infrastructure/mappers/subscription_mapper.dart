import '../../../../services/database/app_database.dart';
import '../../../../shared/models/money.dart';
import '../../domain/entities/subscription.dart';
import '../../domain/entities/subscription_frequency.dart';
import '../../domain/entities/subscription_status.dart';

/// The single place in WebFunds that knows both the Drift schema and the
/// `Subscription` Domain entity.
class SubscriptionMapper {
  const SubscriptionMapper._();

  static Subscription toDomain(SubscriptionRow row) {
    return Subscription(
      id: row.id,
      merchant: row.merchant,
      expectedAmount: Money.fromMinorUnits(
        row.expectedAmountMinorUnits,
        currency: row.expectedAmountCurrency,
      ),
      frequency: SubscriptionFrequency.values.byName(row.frequency),
      status: SubscriptionStatus.values.byName(row.status),
      nextExpectedDate: row.nextExpectedDate,
      category: row.category,
      notes: row.notes,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
    );
  }

  static SubscriptionRow toRow(Subscription subscription) {
    return SubscriptionRow(
      id: subscription.id,
      merchant: subscription.merchant,
      expectedAmountMinorUnits: subscription.expectedAmount.minorUnits,
      expectedAmountCurrency: subscription.expectedAmount.currency,
      frequency: subscription.frequency.name,
      status: subscription.status.name,
      nextExpectedDate: subscription.nextExpectedDate,
      category: subscription.category,
      notes: subscription.notes,
      createdAt: subscription.createdAt,
      updatedAt: subscription.updatedAt,
    );
  }
}
