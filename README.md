# flutter_helpers
helper_classes

## 1) cache.dart
Реализация кэша с истечением срока действия.
Используется пакет localstorage 4.0.1 (https://pub.dev/packages/localstorage)

Пример использования:
```
// кэширование api-запроса получения списка АЗС
class MapService {
  static final CacheManager _cache = CacheManager();
  static const String _cacheKey = 'api-petrols';

   static Future<List<Petrol>> getData() async {
    List<Petrol> res = [];
    final cachedData = await _cache.get(_cacheKey);
    if (cachedData == null) {
      res = await fetchMapData(); // получение данных через API
    } else {
      res.addAll(cachedData.whereType<Petrol>()); 
    }
    return res;
  }
  
  static Future<List<Petrol>> fetchMapData() async {
    try {
      final Response resp = await SiteApi.get('/map/');
      if (resp.statusCode == 200) {
        final List data = json.decode(resp.body)['petrols'];
        final List<Petrol> res = List.from(data.map((e) => Petrol.fromJson(e)));
        _cache.save(_cacheKey, res, duration: const Duration(days: 3));
        return res;
      } else {
        throw Exception('Ошибка получения списка АЗС. Код ответа: ${resp.statusCode}');
      }
    } catch (e) {
      throw Exception("Ошибка получения списка АЗС: $e");
    }
  }
}
```
