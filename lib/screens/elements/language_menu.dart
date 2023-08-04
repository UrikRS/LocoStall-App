import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:locostall/bloc/all.dart';

class LangMenu extends StatefulWidget {
  const LangMenu({super.key, required this.iconButtonTitle});
  final String iconButtonTitle;

  @override
  State<LangMenu> createState() => _LangMenuState();
}

class _LangMenuState extends State<LangMenu> {
  final FocusNode _buttonFocusNode = FocusNode(debugLabel: 'Menu Button');
  var _langCode = 'en';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final languageBloc = BlocProvider.of<LanguageBloc>(context);
    return MenuAnchor(
      childFocusNode: _buttonFocusNode,
      menuChildren: <Widget>[
        RadioMenuButton<dynamic>(
          value: 'ja',
          groupValue: _langCode,
          onChanged: (value) {
            languageBloc.add(ChangeLanguageEvent('ja'));
            setState(() => _langCode = 'ja');
          },
          child: const Text('日本語'),
        ),
        RadioMenuButton<dynamic>(
          value: 'en',
          groupValue: _langCode,
          onChanged: (value) {
            languageBloc.add(ChangeLanguageEvent('en'));
            setState(() => _langCode = 'en');
          },
          child: const Text('English'),
        ),
        RadioMenuButton<dynamic>(
          value: 'zh',
          groupValue: _langCode,
          onChanged: (value) {
            languageBloc.add(ChangeLanguageEvent('zh'));
            setState(() => _langCode = 'zh');
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
            color: Colors.white,
          ),
          label: Row(
            children: [
              Text(
                widget.iconButtonTitle,
                style: const TextStyle(color: Colors.white),
              ),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 20,
                color: Colors.white,
              )
            ],
          ),
        );
      },
    );
  }
}
