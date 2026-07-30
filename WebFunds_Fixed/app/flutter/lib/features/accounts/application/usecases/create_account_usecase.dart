import '../../../../core/errors/failure.dart';
import '../../../../core/result/result.dart';
import '../../../../core/usecase/use_case.dart';
import '../../../../shared/models/money.dart';
import '../../domain/entities/account.dart';
import '../../domain/entities/account_type.dart';
import '../../domain/repositories/account_repository.dart';

class CreateAccountParams {
  const CreateAccountParams({
    required this.name,
    required this.type,
    required this.openingBalance,
  });

  final String name;
  final AccountType type;
  final Money openingBalance;
}

class CreateAccountUseCase extends UseCase<Account, CreateAccountParams> {
  const CreateAccountUseCase(this._repository);

  final AccountRepository _repository;

  @override
  Future<Result<Account>> call(CreateAccountParams params) async {
    if (params.name.trim().isEmpty) {
      return const ResultError(ValidationFailure(message: 'O nome da conta é obrigatório.'));
    }
    return _repository.create(
      name: params.name.trim(),
      type: params.type,
      openingBalance: params.openingBalance,
    );
  }
}
