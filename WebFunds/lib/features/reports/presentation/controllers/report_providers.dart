import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../financial_cycles/presentation/controllers/financial_cycle_providers.dart';
import '../../../transactions/presentation/controllers/transaction_providers.dart';
import '../../application/usecases/get_cycle_report_usecase.dart';

final getCycleReportUseCaseProvider = Provider<GetCycleReportUseCase>((ref) {
  return GetCycleReportUseCase(
    ref.watch(transactionRepositoryProvider),
    ref.watch(financialCycleRepositoryProvider),
  );
});
