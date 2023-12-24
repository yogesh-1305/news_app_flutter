import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:path_provider/path_provider.dart';

class ApiCacheOptions {
  /// singleton instance
  static ApiCacheOptions? instance;

  /// internal constructor
  ApiCacheOptions._internal();

  /// factory constructor to get instance of [ApiCacheOptions]
  factory ApiCacheOptions() {
    return instance ??= ApiCacheOptions._internal();
  }

  Future<CacheOptions> getCacheOptions() async {
    var cacheDir = await getTemporaryDirectory();
    var cacheStore = HiveCacheStore(
      cacheDir.path,
      hiveBoxName: "news_app_flutter_cache",
    );
    var cacheOptions = CacheOptions(
      store: cacheStore,
      policy: CachePolicy.forceCache,
      priority: CachePriority.high,
      maxStale: const Duration(minutes: 5),
      hitCacheOnErrorExcept: [401, 404],
      keyBuilder: (request) {
        return request.uri.toString();
      },
      allowPostMethod: false,
    );
    return cacheOptions;
  }
}
