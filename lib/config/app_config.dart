import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Centralized configuration class managing environment variables.
class AppConfig {
  static const String defaultBaseUrl = 'https://api-colombia.com/api/v1';
  static const String defaultAppName = 'Colombia Datos Abiertos';

  /// Initializes the environment configuration.
  /// Falls back to default values if the .env file is missing or cannot be loaded.
  static Future<void> initialize() async {
    try {
      await dotenv.load(fileName: '.env');
    } catch (_) {
      // Fallback in case .env was not packaged or fails on specific platforms
    }
  }

  /// Base URL for API Colombia endpoints.
  static String get apiBaseUrl {
    if (dotenv.isInitialized) {
      return dotenv.env['API_BASE_URL'] ?? defaultBaseUrl;
    }
    return defaultBaseUrl;
  }

  /// Application display name.
  static String get appName {
    if (dotenv.isInitialized) {
      return dotenv.env['APP_NAME'] ?? defaultAppName;
    }
    return defaultAppName;
  }
}
