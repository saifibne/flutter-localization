class LocalizationHelper {
  Map<String, dynamic>? _translations;
  static LocalizationHelper? _instance;
  static LocalizationHelper get instance =>
      _instance ?? (_instance = LocalizationHelper());

  LocalizationHelper();

  static load(dynamic translations) {
    instance._translations = translations;
  }

  dynamic getRawData(String key) {
    return _translations?[key];
  }
}
