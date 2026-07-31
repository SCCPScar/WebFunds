import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../../../shared/models/money.dart';
import '../../application/usecases/create_account_usecase.dart';
import '../../domain/entities/account.dart';
import '../../domain/entities/account_type.dart';
import 'account_providers.dart';

/// State for the "create account" form.
sealed class CreateAccountState {
  const CreateAccountState();
}

final class CreateAccountIdle extends CreateAccountState {
  const CreateAccountIdle();
}

final class CreateAccountLoading extends CreateAccountState {
  const CreateAccountLoading();
}

final class CreateAccountSuccess extends CreateAccountState {
  const CreateAccountSuccess(this.account);
  final Account account;
}

final class CreateAccountFailed extends CreateAccountState {
  const CreateAccountFailed(this.failure);
  final Failure failure;
}

final createAccountControllerProvider =
    NotifierProvider<CreateAccountController, CreateAccountState>(
  CreateAccountController.new,
);

class CreateAccountController extends Notifier<CreateAccountState> {
  @override
  CreateAccountState build() => const CreateAccountIdle();

  Future<void> submit({
    required String name,
    required AccountType type,
    required Money openingBalance,
  }) async {
    state = const CreateAccountLoading();

    final useCase = ref.read(createAccountUseCaseProvider);
    final result = await useCase(
      CreateAccountParams(name: name, type: type, openingBalance: openingBalance),
    );

    state = switch (result) {
      Success<Account>(:final data) => CreateAccountSuccess(data),
      ResultError<Account>(:final failure) => CreateAccountFailed(failure),
    };
  }

  void reset() => state = const CreateAccountIdle();
}
