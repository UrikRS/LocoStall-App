import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:locostall/bloc/all.dart';
import 'package:locostall/bloc/waiting_bloc.dart';
import 'package:locostall/screens/home.dart';
import 'package:locostall/theme.dart';

void main() => runApp(MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LanguageBloc(),
        ),
        BlocProvider(
          create: (context) => CartBloc(),
        ),
        BlocProvider(
          create: (context) => OrderBloc(),
        ),
        BlocProvider(
          create: (context) => DrawerBloc(),
        ),
        BlocProvider(
          create: (context) => UserBloc(),
        ),
        BlocProvider(
          create: (context) => WaitingBloc(),
        ),
      ],
      child: const Root(),
    ));

class Root extends StatefulWidget {
  const Root({super.key});

  @override
  State<Root> createState() => _RootState();
}

class _RootState extends State<Root> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LocoStall',
      theme: locostallTheme,
      locale: Locale(context.read<LanguageBloc>().state.langCode),
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
      home: MultiBlocListener(
        listeners: [
          BlocListener<LanguageBloc, LanguageState>(
            listener: (context, state) => setState(() {}),
          ),
          BlocListener<CartBloc, CartState>(
            listener: (context, state) => setState(() {}),
          ),
          BlocListener<UserBloc, UserState>(listener: (context, state) {
            final languageBloc = BlocProvider.of<LanguageBloc>(context);
            languageBloc.add(ChangeLanguageEvent(
                state.userData?.nLang ?? languageBloc.state.langCode));
          }),
          BlocListener<WaitingBloc, WaitingState>(
            listener: (context, state) => setState(() {}),
          ),
        ],
        child: const Home(),
      ),
    );
  }
}
