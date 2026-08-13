abstract final class AppEnvironment {
  static const _configuredApiBaseUrl = String.fromEnvironment('API_BASE_URL');

  static String get apiBaseUrl {
    final value = _configuredApiBaseUrl.trim();
    if (value.isEmpty) {
      throw StateError(
        'API_BASE_URL is required. Start Flutter with '
        '--dart-define=API_BASE_URL=https://your-api.example/api',
      );
    }

    return value.endsWith('/') ? value.substring(0, value.length - 1) : value;
  }
}
