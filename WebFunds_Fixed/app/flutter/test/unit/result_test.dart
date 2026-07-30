import 'package:flutter_test/flutter_test.dart';
import 'package:webfunds/core/errors/app_exception.dart';
import 'package:webfunds/core/errors/failure.dart';
import 'package:webfunds/core/errors/failure_mapper.dart';
import 'package:webfunds/core/result/result.dart';

void main() {
  group('Result', () {
    test('Success exposes data and folds into onSuccess', () {
      const result = Success<int>(42);

      expect(result.isSuccess, isTrue);
      expect(result.isError, isFalse);
      expect(result.dataOrNull, 42);
      expect(result.failureOrNull, isNull);

      final folded = result.fold(
        onSuccess: (data) => 'got $data',
        onError: (failure) => 'error',
      );
      expect(folded, 'got 42');
    });

    test('ResultError exposes failure and folds into onError', () {
      const failure = NetworkFailure();
      const result = ResultError<int>(failure);

      expect(result.isSuccess, isFalse);
      expect(result.isError, isTrue);
      expect(result.dataOrNull, isNull);
      expect(result.failureOrNull, failure);

      final folded = result.fold(
        onSuccess: (data) => 'got $data',
        onError: (f) => 'error: ${f.message}',
      );
      expect(folded, 'error: Sem ligação à internet.');
    });
  });

  group('mapExceptionToFailure', () {
    test('maps each AppException subtype to the matching Failure subtype', () {
      expect(
        mapExceptionToFailure(const NetworkException('no network')),
        isA<NetworkFailure>(),
      );
      expect(
        mapExceptionToFailure(const ServerException('server down')),
        isA<ServerFailure>(),
      );
      expect(
        mapExceptionToFailure(const BiometricException('biometric failed')),
        isA<AuthFailure>(),
      );
    });
  });
}
