
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import '../generated/intl/messages_all.dart';
import '../generated/l10n.dart';
import '../helpers/services/navigation_service.dart';

class L10nX extends S {
  // ...
  L10nX();

  static L10nX? _current;

  static L10nX get current {
    assert(_current != null,
    'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegatel10nX delegate = AppLocalizationDelegatel10nX();

  static Future<L10nX> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = L10nX();
      L10nX._current = instance;
      return instance;
    });
  }
  static S get getStr {
    BuildContext context = NavigationService.globalContext!;
    final instance = L10nX.maybeOf(context);
    assert(instance != null,
    'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }
  static L10nX of() {
    BuildContext context = NavigationService.globalContext!;
    final instance = L10nX.maybeOf(context);
    assert(instance != null,
    'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }
  static L10nX? maybeOf(BuildContext context) {
    return Localizations.of<L10nX>(context, L10nX);
  }

  String getStringByKey(String key,List<String>? args) {
    return Intl.message(
      'Missing string key',
      name: key,
      desc: '',
      args: args,
    );
  }
}
class AppLocalizationDelegatel10nX extends LocalizationsDelegate<L10nX> {
  const AppLocalizationDelegatel10nX();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'vi'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<L10nX> load(Locale locale) => L10nX.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegatel10nX old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
