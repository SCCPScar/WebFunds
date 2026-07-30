import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../config/env_config.dart';
import '../logging/app_logger.dart';

/// A small, dependency-free retry interceptor. Holds a reference to the
/// *same* [Dio] instance it's attached to (injected, not created fresh) —
/// retrying through a brand-new `Dio()` would silently drop every other
/// interceptor configured on the real client.
class _RetryInterceptor extends Interceptor {
  _RetryInterceptor(this._dio, this._logger) : maxRetries = 2;

  final Dio _dio;
  final AppLogger _logger;
  final int maxRetries;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final isRetryable =
        err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError;

    final attempt = (err.requestOptions.extra['retryAttempt'] as int?) ?? 0;

    if (isRetryable && attempt < maxRetries) {
      final nextAttempt = attempt + 1;
      _logger.warning(
        'Retrying request ($nextAttempt/$maxRetries): ${err.requestOptions.path}',
        tag: 'Dio',
      );
      await Future<void>.delayed(Duration(milliseconds: 400 * nextAttempt));

      final options = err.requestOptions;
      options.extra['retryAttempt'] = nextAttempt;

      try {
        final response = await _dio.fetch<dynamic>(options);
        handler.resolve(response);
        return;
      } on DioException catch (retryError) {
        handler.next(retryError);
        return;
      } catch (retryError, stackTrace) {
        // _dio.fetch() is expected to only throw DioException, but if
        // something else escapes, the original request's Future must
        // still complete — an uncaught error here would leave it pending
        // forever, since neither resolve(), next(), nor reject() would
        // ever be called.
        _logger.error(
          'Unexpected error retrying request: ${err.requestOptions.path}',
          tag: 'Dio',
          error: retryError,
          stackTrace: stackTrace,
        );
        handler.next(err);
        return;
      }
    }

    handler.next(err);
  }
}

/// The shared Dio instance for every HTTP call the app makes outside of
/// `supabase_flutter`.
final dioProvider = Provider<Dio>((ref) {
  final logger = ref.watch(appLoggerProvider);

  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Content-Type': 'application/json'},
    ),
  );

  dio.interceptors.add(_RetryInterceptor(dio, logger));

  if (EnvConfig.enableNetworkLogging && EnvConfig.environment.isDebuggable) {
    dio.interceptors.add(
      LogInterceptor(
        requestBody: false,
        responseBody: false,
        logPrint: (message) => logger.debug(message.toString(), tag: 'Dio'),
      ),
    );
  }

  return dio;
});