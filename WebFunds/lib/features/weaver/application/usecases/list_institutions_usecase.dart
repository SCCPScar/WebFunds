import '../../../../core/result/result.dart';
import '../../../../core/usecase/use_case.dart';
import '../../domain/repositories/bank_repository.dart';

class ListInstitutionsUseCase extends UseCase<List<BankInstitution>, String> {
  const ListInstitutionsUseCase(this._repository);

  final BankRepository _repository;

  @override
  Future<Result<List<BankInstitution>>> call(String country) => _repository.listInstitutions(country);
}
