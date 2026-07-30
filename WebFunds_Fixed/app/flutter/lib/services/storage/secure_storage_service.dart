import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/errors/app_exception.dart';

class SecureStorageService {
  const SecureStorageService(this._storage);

  final FlutterSecureStorage _storage;

  Future<void> write({required String key, required String value}) async {
    try {
      await _storage.write(key: key, value: value);
    } on Exception catch (e) {
      throw CacheException('Não foi possível guardar dados seguros.', cause: e);
    }
  }

  Future<String?> read({required String key}) async {
    try {
      return await _storage.read(key: key);
    } on Exception catch (e) {
      throw CacheException('Não foi possível ler dados seguros.', cause: e);
    }
  }

  Future<void> delete({required String key}) async {
    try {
      await _storage.delete(key: key);
    } on Exception catch (e) {
      throw CacheException('Não foi possível remover dados seguros.', cause: e);
    }
  }

  Future<void> deleteAll() async {
    try {
      await _storage.deleteAll();
    } on Exception catch (e) {
      throw CacheException('Não foi possível limpar dados seguros.', cause: e);
    }
  }
}

final secureStorageServiceProvider = Provider<SecureStorageService>((ref) {
  const storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  return const SecureStorageService(storage);
});
