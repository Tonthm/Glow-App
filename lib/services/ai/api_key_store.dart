import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Where the user's API key lives. Never the database, a backup, or a log.
abstract interface class ApiKeyStore {
  Future<String?> read();
  Future<void> write(String key);
  Future<void> delete();
}

/// Android's secure storage; on the web, the browser's own storage, which is
/// less safe (the settings screen says so).
class SecureApiKeyStore implements ApiKeyStore {
  static const _name = 'ai_api_key';
  static const _storage = FlutterSecureStorage();

  @override
  Future<String?> read() => _storage.read(key: _name);

  @override
  Future<void> write(String key) => _storage.write(key: _name, value: key);

  @override
  Future<void> delete() => _storage.delete(key: _name);
}

/// For tests.
class MemoryApiKeyStore implements ApiKeyStore {
  String? _key;

  MemoryApiKeyStore([this._key]);

  @override
  Future<String?> read() async => _key;

  @override
  Future<void> write(String key) async => _key = key;

  @override
  Future<void> delete() async => _key = null;
}
