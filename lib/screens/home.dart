import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:locostall/screens/take_picture.dart';
import 'package:locostall/screens/tabs/all.dart';
import 'package:locostall/screens/elements/edit_profile.dart';
import 'package:locostall/screens/elements/language_menu.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
  static _HomeState? of(BuildContext context) =>
      context.findAncestorStateOfType<_HomeState>();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  static const List<Widget> _widgetOptions = <Widget>[
    StallsTab(),
    Text(
      'TODO:',
      style: optionStyle,
    ),
    LoginTab(),
    RegisterTab(),
    Text(
      'TODO:',
      style: optionStyle,
    ),
    Text(
      'TODO:',
      style: optionStyle,
    ),
    Text(
      'TODO:',
      style: optionStyle,
    ),
  ];

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LocoStall'),
        centerTitle: true,
        actions: <Widget>[
          LangMenu(iconButtonTitle: AppLocalizations.of(context)!.language)
        ],
      ),
      body: Center(
        child: _widgetOptions[_selectedIndex],
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              accountName: const Text('name'),
              accountEmail: const Text('edit profile'),
              arrowColor: Colors.white,
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
              ),
              onDetailsPressed: () => showDialog(
                context: context,
                builder: (context) => const EditProfile(),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.storefront),
              title: Text(AppLocalizations.of(context)!.stalls),
              selected: _selectedIndex == 0,
              onTap: () {
                onItemTapped(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.onetwothree),
              title: Text(AppLocalizations.of(context)!.other),
              selected: _selectedIndex == 1,
              onTap: () {
                onItemTapped(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.login),
              title: Text(AppLocalizations.of(context)!.logreg),
              selected: _selectedIndex == 2,
              onTap: () {
                onItemTapped(2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(AppLocalizations.of(context)!.settings),
              selected: _selectedIndex == 4,
              onTap: () {
                onItemTapped(4);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          WidgetsFlutterBinding.ensureInitialized();
          final cameras = await availableCameras();
          final firstCamera = cameras.first;
          await Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => TakePicture(camera: firstCamera),
          ));
        },
        child: const Icon(Icons.camera),
      ),
    );
  }
}
