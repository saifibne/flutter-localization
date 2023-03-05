import 'dart:convert';
import 'dart:ui';

import 'package:flutter/services.dart';

/// abstract class used to building your Custom AssetLoader
/// Example:
/// ```
///class FileAssetLoader extends AssetLoader {
///  @override
///  Future<Map<String, dynamic>> load(String path, Locale locale) async {
///    final file = File(path);
///    return json.decode(await file.readAsString());
///  }
///}
/// ```
abstract class CustomAssetLoader {
  const CustomAssetLoader();
  Future<Map<String, dynamic>?> load(String path, Locale locale);
}

///
/// default used is RootBundleAssetLoader which uses flutter's assetLoader
///
class CustomDefaultAssetLoader extends CustomAssetLoader {
  const CustomDefaultAssetLoader();

  String getLocalePath(String basePath, Locale locale) {
    return '$basePath/${locale.toString()}.json';
  }

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) async {
    var localePath = getLocalePath(path, locale);
    return json.decode(await rootBundle.loadString(localePath));
  }
}
