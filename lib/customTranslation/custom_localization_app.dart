import 'package:flutter/material.dart';
import 'package:translation_test/customTranslation/asset_loader.dart';
import './custom_localization.dart';

import 'custom_localization_controller.dart';

class CustomLocalization extends StatefulWidget {
  final String path;
  final Widget child;
  final CustomAssetLoader assetLoader;
  final Locale currentLocale;
  final List<Locale> supportedLocales;

  const CustomLocalization({
    Key? key,
    required this.path,
    required this.child,
    required this.currentLocale,
    required this.supportedLocales,
    this.assetLoader = const CustomDefaultAssetLoader(),
  }) : super(key: key);

  // ignore: library_private_types_in_public_api
  static _CustomLocalizationProvider? of(BuildContext context) =>
      _CustomLocalizationProvider.of(context);

  @override
  State<CustomLocalization> createState() => _CustomLocalizationState();
}

class _CustomLocalizationState extends State<CustomLocalization> {
  late CustomLocalizationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = CustomLocalizationController(
      locale: widget.currentLocale,
      path: widget.path,
      assetLoader: widget.assetLoader,
    );

    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // @override
  // void didUpdateWidget(covariant CustomLocalization oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (oldWidget.currentLocale != widget.currentLocale) {
  //     print('custom loader lang updated ${widget.currentLocale}');
  //     _controller.setupLocale(widget.currentLocale).then((_) {
  //       print('builder should get called');
  //       setState(() {});
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    print('provider builder called');
    return _CustomLocalizationProvider(
      widget,
      _controller,
      delegate:
          _CustomLocalizationDelegate(_controller, widget.supportedLocales),
    );
  }
}

class _CustomLocalizationProvider extends InheritedWidget {
  final CustomLocalization _parent;
  final Locale currentLocale;
  final CustomLocalizationController _controller;
  final _CustomLocalizationDelegate delegate;

  _CustomLocalizationProvider(this._parent, this._controller,
      {Key? key, required this.delegate})
      : currentLocale = _controller.locale,
        super(key: key, child: _parent.child);

  static _CustomLocalizationProvider? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_CustomLocalizationProvider>();

  @override
  bool updateShouldNotify(_CustomLocalizationProvider oldWidget) {
    return oldWidget.currentLocale != _controller.locale;
  }

  setLocale(Locale locale) {
    if (_controller.locale != locale) {
      _controller.setupLocale(locale);
    }
  }
}

class _CustomLocalizationDelegate
    extends LocalizationsDelegate<LocalizationHelper> {
  final CustomLocalizationController _controller;
  final List<Locale> supportedLocals;

  _CustomLocalizationDelegate(this._controller, this.supportedLocals);

  @override
  bool isSupported(Locale locale) => supportedLocals.contains(locale);

  @override
  Future<LocalizationHelper> load(Locale locale) async {
    if (_controller.translation == null) {
      await _controller.loadTranslation();
    }

    LocalizationHelper.load(_controller.translation);
    return Future.value(LocalizationHelper.instance);
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<LocalizationHelper> old) =>
      false;
}
