import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bilibili/constants/tokens.dart';

class LocaleProvider with ChangeNotifier {
  Locale get currentLocale {
    final ctx = appGlobalKey.currentContext;
    return ctx!.locale;
  }

  void setLocaleByLanguageCode(String languageCode) {
    var countryCode = 'US';
    if (languageCode == 'zh') {
      countryCode = 'CN';
    }
    appGlobalKey.currentContext!.setLocale(Locale(
      languageCode,
      countryCode,
    ));
  }

  bool get isEn => currentLocale.languageCode.toString() == 'en';
  bool get isZh => currentLocale.languageCode.toString() == 'zh';
}
