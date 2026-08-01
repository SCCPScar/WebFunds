import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../../../shared/models/money.dart';
import '../../application/usecases/create_dream_usecase.dart';
import '../../domain/entities/dream.dart';
import 'dream_providers.dart';

sealed class CreateDreamState {
  const CreateDreamState();
}

final class CreateDreamIdle extends CreateDreamState {
  const CreateDreamIdle();
}

final class CreateDreamLoading extends CreateDreamState {
  const CreateDreamLoading();
}

final class CreateDreamSuccess extends CreateDreamState {
  const CreateDreamSuccess(this.dream);
  final Dream dream;
}

final class CreateDreamFailed extends CreateDreamState {
  const CreateDreamFailed(this.failure);
  final Failure failure;
}

final createDreamControllerProvider =
    NotifierProvider<CreateDreamController, CreateDreamState>(CreateDreamController.new);

class CreateDreamController extends Notifier<CreateDreamState> {
  @override
  CreateDreamState build() => const CreateDreamIdle();

  Future<void> submit({
    required String name,
    required Money targetAmount,
    String? description,
    DateTime? targetDate,
    String? category,
  }) async {
    state = const CreateDreamLoading();

    final result = await ref.read(createDreamUseCaseProvider).call(
          CreateDreamParams(
            name: name,
            targetAmount: targetAmount,
            description: description,
            targetDate: targetDate,
            category: category,
          ),
        );

    state = switch (result) {
      Success<Dream>(:final data) => CreateDreamSuccess(data),
      ResultError<Dream>(:final failure) => CreateDreamFailed(failure),
    };
  }

  void reset() => state = const CreateDreamIdle();
}
