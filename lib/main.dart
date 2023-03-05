import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:translation_test/customTranslation/custom_localization.dart';
import 'package:translation_test/customTranslation/custom_localization_app.dart';
import 'package:translation_test/easy_localization.dart';
import 'package:translation_test/src/easy_localization_controller.dart';
import 'package:translation_test/src/localization.dart';

// GlobalKey gbKey = GlobalKey<EasyLocalization>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('vi')],
      path:
          'assets/translations', // <-- change the path of the translation files
      fallbackLocale: const Locale('en'),
      child: Builder(
        builder: (BuildContext context) => CustomLocalization(
          path: 'assets/translations/list',
          currentLocale: context.locale,
          supportedLocales: context.supportedLocales,
          child: MyApp(),
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        ...context.localizationDelegates,
        CustomLocalization.of(context)?.delegate as LocalizationsDelegate,
      ],
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var a = LocalizationHelper.instance.getRawData('test');
    print('working $a');
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'hello'.tr(),
            ),
            Text(LocalizationHelper.instance.getRawData('test').toString()),
            ElevatedButton(
              onPressed: () {
                if (EasyLocalization.of(context)!.currentLocale ==
                    const Locale('vi')) {
                  EasyLocalization.of(context)!.setLocale(const Locale('en'));
                  CustomLocalization.of(context)!.setLocale(const Locale('en'));
                } else {
                  EasyLocalization.of(context)!.setLocale(const Locale('vi'));
                  CustomLocalization.of(context)!.setLocale(const Locale('vi'));
                }
              },
              child: const Text('ok'),
            ),
          ],
        ),
      ),
    );
  }
}
