enum Environment { development, staging, production }

class FlavorConfig {
  final Environment environment;
  final String firebaseProjectId;
  final String algoliaAppId;
  final String algoliaSearchKey;
  final String stripePublishableKey;
  final bool enableCrashlytics;
  final bool enableAnalytics;
  final bool showDebugBanner;

  const FlavorConfig({
    required this.environment,
    required this.firebaseProjectId,
    required this.algoliaAppId,
    required this.algoliaSearchKey,
    required this.stripePublishableKey,
    required this.enableCrashlytics,
    required this.enableAnalytics,
    required this.showDebugBanner,
  });

  bool get isDevelopment => environment == Environment.development;
  bool get isProduction => environment == Environment.production;

  static late FlavorConfig _instance;
  static FlavorConfig get instance => _instance;

  static void initialize(FlavorConfig config) {
    _instance = config;
  }
}
