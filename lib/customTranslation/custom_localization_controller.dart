import 'dart:ui';

import 'package:flutter/cupertino.dart';

import 'asset_loader.dart';

class CustomLocalizationController extends ChangeNotifier {
  late Locale locale;
  final String path;
  final CustomAssetLoader assetLoader;
  Map<String, dynamic>? _translation;

  Map<String, dynamic>? get translation => _translation;

  CustomLocalizationController({
    required this.locale,
    required this.path,
    required this.assetLoader,
  });

  Future<void> loadTranslation() async {
    _translation = await assetLoader.load(path, locale);
    // print(_translation);
  }

  Future<void> setupLocale(Locale l) async {
    locale = l;
    await loadTranslation();
    print('$locale $translation');
  }
}
