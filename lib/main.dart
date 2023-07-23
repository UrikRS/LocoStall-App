import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:locostall/screens/home.dart';
import 'package:locostall/services/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget languageWrap(langCode, context, Widget w) {
  return Localizations.override(
    context: context,
    locale: Locale(langCode),
    child: Builder(
      builder: (context) {
        return w;
      },
    ),
  );
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  Locale locale = const Locale('en');
  String _langCode = 'en';
  String userId = '0';
  final ApiClient apiClient = ApiClient();

  void setLocale(Locale value) {
    setState(() {
      locale = value;
    });
  }

  Future<void> _loadLangCode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _langCode = prefs.getString('langCode') ?? 'en';
    });
  }

  @override
  Widget build(BuildContext context) {
    _loadLangCode();
    setLocale(Locale(_langCode));

    return MaterialApp(
      title: 'LocoStall',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // darkTheme: ThemeData.dark(),
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ja'),
        Locale('en'),
        Locale.fromSubtags(
          languageCode: 'zh',
          scriptCode: 'Hant',
          countryCode: 'TW',
        ),
      ],
      home: const Home(),
    );
  }
}
