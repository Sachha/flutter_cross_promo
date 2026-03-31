import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/app_info.dart';
import 'app_catalog.dart';

/// Fetches the app catalog from the remote Git repo.
///
/// Falls back to the embedded [fallbackCatalog] if the fetch fails.
class CatalogService {
  /// Base raw URL for the Git repo containing catalog.json and assets/.
  /// Override this if you host the repo elsewhere.
  final String repoRawBaseUrl;

  /// Timeout for the HTTP request.
  final Duration timeout;

  List<AppInfo>? _cache;

  CatalogService({
    required this.repoRawBaseUrl,
    this.timeout = const Duration(seconds: 5),
  });

  /// Returns the full icon URL for a given icon filename.
  String iconUrl(String iconFilename) => '$repoRawBaseUrl/assets/$iconFilename';

  /// Fetches the catalog. Returns cached result if already fetched.
  Future<List<AppInfo>> getCatalog() async {
    if (_cache != null) return _cache!;

    try {
      final response = await http
          .get(Uri.parse('$repoRawBaseUrl/catalog.json'))
          .timeout(timeout);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body) as List;
        _cache = jsonList
            .map((e) => AppInfo.fromJson(e as Map<String, dynamic>))
            .toList();
        return _cache!;
      }
    } catch (_) {
      // Network error, timeout, parse error — fall through to fallback
    }

    _cache = fallbackCatalog;
    return _cache!;
  }

  /// Clears the cache so the next [getCatalog] call fetches fresh data.
  void clearCache() => _cache = null;
}
