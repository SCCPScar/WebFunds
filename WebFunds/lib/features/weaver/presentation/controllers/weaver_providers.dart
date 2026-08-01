import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../services/supabase/supabase_service.dart';
import '../../application/usecases/suggest_category_usecase.dart';
import '../../domain/repositories/weaver_repository.dart';
import '../../infrastructure/repositories/supabase_weaver_repository.dart';

final weaverRepositoryProvider = Provider<WeaverRepository>((ref) {
  return SupabaseWeaverRepository(ref.watch(supabaseServiceProvider));
});

final suggestCategoryUseCaseProvider = Provider<SuggestCategoryUseCase>((ref) {
  return SuggestCategoryUseCase(ref.watch(weaverRepositoryProvider));
});
