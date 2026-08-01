import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../dreams/presentation/controllers/dream_providers.dart';
import '../../../mysteries/presentation/controllers/mystery_providers.dart';
import '../../../subscriptions/presentation/controllers/subscription_providers.dart';
import '../../../transactions/presentation/controllers/transaction_providers.dart';
import '../../application/usecases/search_usecase.dart';

final searchUseCaseProvider = Provider<SearchUseCase>((ref) {
  return SearchUseCase(
    ref.watch(transactionRepositoryProvider),
    ref.watch(dreamRepositoryProvider),
    ref.watch(mysteryRepositoryProvider),
    ref.watch(subscriptionRepositoryProvider),
  );
});
