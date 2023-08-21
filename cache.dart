import 'package:localstorage/localstorage.dart';

class CacheManager {
  static const Duration _defaultExpiryDuration = Duration(days: 1);
  static const String _cacheKey = 'cache';

  final LocalStorage _storage;

  CacheManager() : _storage = LocalStorage(_cacheKey);

  Future<dynamic>? get(String key) async {
    await _storage.ready;
    final cachedData = _storage.getItem(key);
    if (cachedData == null || isExpired(cachedData['expiry'])) {
      return null;
    }
    return cachedData['data'];
  }

  Future<void> save(String key, dynamic data, {Duration duration = _defaultExpiryDuration}) async {
    await _storage.ready;
    final value = {
      'data': data,
      'expiry': DateTime.now().add(duration).millisecondsSinceEpoch,
    };
    _storage.setItem(key, value);
  }

  Future<void> remove(String key) async {
    await _storage.ready;
    _storage.deleteItem(key);
  }

  Future<void> clearCache() async {
    await _storage.ready;
    _storage.clear();
  }

  bool isExpired(int expiry) {
    return DateTime.now().millisecondsSinceEpoch > expiry;
  }
}
