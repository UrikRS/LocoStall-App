import 'package:flutter/material.dart';
import 'package:locostall/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    _loadLangCode();
  }

  Future<void> _loadLangCode() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _langCode = prefs.getString('langCode') ?? 'en';
    });
  }

  Future<void> _saveLangCode() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('langCode', _langCode);
  }

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      childFocusNode: _buttonFocusNode,
      menuChildren: <Widget>[
        RadioMenuButton<dynamic>(
          value: 'ja',
          groupValue: _langCode,
          onChanged: (value) {
            setState(() {
              _langCode = 'ja';
              _saveLangCode();
              MyApp.of(context)?.setLocale(const Locale('ja'));
            });
          },
          child: const Text('日本語'),
        ),
        RadioMenuButton<dynamic>(
          value: 'en',
          groupValue: _langCode,
          onChanged: (value) {
            setState(() {
              _langCode = 'en';
              _saveLangCode();
              MyApp.of(context)?.setLocale(const Locale('en'));
            });
          },
          child: const Text('English'),
        ),
        RadioMenuButton<dynamic>(
          value: 'zh',
          groupValue: _langCode,
          onChanged: (value) {
            setState(() {
              _langCode = 'zh';
              _saveLangCode();
              MyApp.of(context)?.setLocale(const Locale('zh'));
            });
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
          label: Text(
            widget.iconButtonTitle,
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }
}
