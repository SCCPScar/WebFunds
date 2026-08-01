import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/errors/failure_mapper.dart';
import '../../../../core/result/result.dart';
import '../../../../services/supabase/supabase_service.dart';
import '../../../../shared/models/money.dart';
import '../../../transactions/domain/entities/transaction_type.dart';
import '../../domain/entities/category_suggestion.dart';
import '../../domain/entities/confidence_level.dart';
import '../../domain/repositories/weaver_repository.dart';

/// Real [WeaverRepository] — calls the `weaver-suggest-category` Supabase
/// Edge Function, which is the only place the Anthropic API key exists.
/// Nothing here ever holds that key: `supabase_flutter` attaches the
/// caller's session automatically, and the Function verifies it.
class SupabaseWeaverRepository implements WeaverRepository {
  const SupabaseWeaverRepository(this._supabaseService);

  final SupabaseService _supabaseService;

  static const _functionName = 'weaver-suggest-category';

  @override
  Future<Result<CategorySuggestion>> suggestCategory({
    required TransactionType type,
    required Money amount,
    String? merchant,
  }) async {
    if (!_supabaseService.isInitialized) {
      return const ResultError(
        ServerFailure(message: 'A Weaver AI ainda não está configurada.'),
      );
    }

    try {
      final response = await _supabaseService.client.functions.invoke(
        _functionName,
        body: {
          'type': type.name,
          'amountMajorUnits': amount.majorUnits,
          'currency': amount.currency,
          if (merchant != null) 'merchant': merchant,
        },
      );

      final data = response.data;
      if (data is! Map || data['category'] is! String || data['confidenceScore'] is! num) {
        throw const ServerException('A Weaver AI devolveu uma resposta inesperada.');
      }

      final score = (data['confidenceScore'] as num).round();
      return Success(
        CategorySuggestion(
          category: data['category'] as String,
          confidenceScore: score,
          confidenceLevel: ConfidenceLevelFromScore.fromScore(score),
          reasoning: data['reasoning'] as String? ?? '',
        ),
      );
    } on AppException catch (e) {
      return ResultError(mapExceptionToFailure(e));
    } on Exception catch (e) {
      return ResultError(
        mapExceptionToFailure(
          ServerException('Não foi possível obter uma sugestão da Weaver AI.', cause: e),
        ),
      );
    }
  }
}
