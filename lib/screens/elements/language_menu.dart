import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locostall/bloc/all.dart';
import 'package:locostall/theme.dart';

class LangMenu extends StatefulWidget {
  const LangMenu({super.key, required this.iconButtonTitle});
  final String iconButtonTitle;

  @override
  State<LangMenu> createState() => _LangMenuState();
}

class _LangMenuState extends State<LangMenu> {
  final FocusNode _buttonFocusNode = FocusNode(debugLabel: 'Menu Button');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final languageBloc = BlocProvider.of<LanguageBloc>(context);
    final userBloc = BlocProvider.of<UserBloc>(context);
    return MenuAnchor(
      childFocusNode: _buttonFocusNode,
      menuChildren: <Widget>[
        RadioMenuButton<dynamic>(
          value: 'ja',
          groupValue: languageBloc.state.langCode,
          onChanged: (value) {
            languageBloc.add(ChangeLanguageEvent('ja'));
            if (userBloc.state.user != null) {
              userBloc.add(UpdateEvent(nLang: 'jp'));
            }
          },
          child: const Text('日本語'),
        ),
        RadioMenuButton<dynamic>(
          value: 'en',
          groupValue: languageBloc.state.langCode,
          onChanged: (value) {
            languageBloc.add(ChangeLanguageEvent('en'));
            if (userBloc.state.user != null) {
              userBloc.add(UpdateEvent(nLang: 'en'));
            }
          },
          child: const Text('English'),
        ),
        RadioMenuButton<dynamic>(
          value: 'zh',
          groupValue: languageBloc.state.langCode,
          onChanged: (value) {
            languageBloc.add(ChangeLanguageEvent('zh'));
            if (userBloc.state.user != null) {
              userBloc.add(UpdateEvent(nLang: 'zh'));
            }
          },
          child: const Text('中文'),
        ),
      ],
      builder:
          (BuildContext context, MenuController controller, Widget? child) {
        return TextButton.icon(
          focusNode: _buttonFocusNode,
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          icon: const Icon(
            Icons.translate,
            color: lsDark,
            size: 20,
          ),
          label: Row(
            children: [
              Text(
                widget.iconButtonTitle,
                style: const TextStyle(
                  color: lsDark,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 20,
                color: lsDark,
              )
            ],
          ),
        );
      },
    );
  }
}
