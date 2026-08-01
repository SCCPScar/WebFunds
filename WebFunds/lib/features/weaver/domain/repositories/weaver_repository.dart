import '../../../../core/result/result.dart';
import '../../../../shared/models/money.dart';
import '../../../transactions/domain/entities/transaction_type.dart';
import '../entities/category_suggestion.dart';

/// Contract for Weaver's suggestions. Mock/Supabase (Edge Function) are
/// equally valid implementations, same Repository pattern as everywhere
/// else in WebFunds.
abstract class WeaverRepository {
  /// Suggests a category for a not-yet-created Transaction. Never
  /// persists anything — Weaver only ever suggests
  /// (`docs/02-Domain/06-Weaver.md`).
  Future<Result<CategorySuggestion>> suggestCategory({
    required TransactionType type,
    required Money amount,
    String? merchant,
  });
}
