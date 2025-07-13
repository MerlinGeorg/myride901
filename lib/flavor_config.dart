enum Flavor { CLASSIC, PRO }

enum Environment { STAGING, PRODUCTION }

class FlavorValues {
  final Map<String, bool> features;
  final String apiUrl;
  final bool showBanner;

  FlavorValues(
      {required this.features, required this.apiUrl, required this.showBanner});
}

class FlavorConfig {
  final Flavor flavor;
  final FlavorValues values;

  static late FlavorConfig _instance;

  factory FlavorConfig({required Flavor flavor, required FlavorValues values}) {
    _instance = FlavorConfig._internal(flavor, values);
    return _instance;
  }

  FlavorConfig._internal(this.flavor, this.values);

  static FlavorConfig get instance => _instance;

  static Flavor get getFlavor => _instance.flavor;
  static Map<String, bool> get features => _instance.values.features;
  static String get apiUrl => _instance.values.apiUrl;
}
