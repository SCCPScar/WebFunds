import '../../../../core/result/result.dart';
import '../../../../core/usecase/use_case.dart';
import '../../domain/repositories/bank_repository.dart';
import '../../domain/repositories/linked_bank_account_repository.dart';

/// What `/banking/callback` calls once Enable Banking redirects back with
/// a `code` — exchanges it for the linked Accounts, then persists them
/// locally (Enable Banking itself has no "list my accounts" call).
class CompleteBankLinkUseCase extends UseCase<List<BankAccount>, String> {
  const CompleteBankLinkUseCase(this._bankRepository, this._linkedBankAccountRepository);

  final BankRepository _bankRepository;
  final LinkedBankAccountRepository _linkedBankAccountRepository;

  @override
  Future<Result<List<BankAccount>>> call(String code) async {
    final exchangeResult = await _bankRepository.exchangeAuthorizationCode(code);
    if (exchangeResult case ResultError(:final failure)) {
      return ResultError(failure);
    }
    final accounts = exchangeResult.dataOrNull ?? const <BankAccount>[];

    final saveResult = await _linkedBankAccountRepository.saveAll(accounts);
    if (saveResult case ResultError(:final failure)) {
      return ResultError(failure);
    }

    return Success(accounts);
  }
}
