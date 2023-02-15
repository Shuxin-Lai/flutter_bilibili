import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bilibili/constants/tokens.dart';
import 'package:flutter_bilibili/providers/locale_provider.dart';
import 'package:flutter_bilibili/providers/theme_provider.dart';
import 'package:flutter_bilibili/router/router.dart';
import 'package:flutter_bilibili/themes/themes.dart';
import 'package:provider/provider.dart';
import 'package:vt_logger/vt_logger.dart';
import 'package:vt_utils/vt_utils.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  VtLogger.ensureIntialized();

  VtLogger.verbose('bootstrap');
  await Future.wait([
    EasyLocalization.ensureInitialized(),
    VtSpUtils.getInstance(),
  ]);

  FlutterError.onError = (details) {
    VtLogger.error(
      'unhandled error: $details',
      error: details.exception,
      stackTrace: details.stack,
    );
  };

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LocaleProvider(),
        ),
      ],
      child: EasyLocalization(
        supportedLocales: const [Locale('en', 'US'), Locale('zh', 'CN')],
        path:
            'assets/translations', // <-- change the path of the translation files
        fallbackLocale: const Locale('en', 'US'),
        child: MyApp(
          key: appGlobalKey,
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ThemeProvider>();

    return MaterialApp.router(
      title: 'Flutter Demo',
      themeMode: provider.themeMode,
      darkTheme: Themes.darkTheme,
      theme: Themes.lightTheme,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      routerConfig: router,
    );
  }
}
