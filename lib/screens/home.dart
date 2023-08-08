import 'package:camera/camera.dart';
import 'package:locostall/screens/tabs/markets.dart';
import 'package:locostall/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:locostall/bloc/drawer_bloc.dart';
import 'package:locostall/bloc/user_bloc.dart';
import 'package:locostall/screens/take_picture.dart';
import 'package:locostall/screens/tabs/all.dart';
import 'package:locostall/screens/elements/edit_profile.dart';
import 'package:locostall/screens/elements/language_menu.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late CameraDescription firstCamera;

  @override
  void initState() {
    super.initState();
    initCamera();
  }

  Future<void> initCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    firstCamera = cameras.first;
  }

  @override
  Widget build(BuildContext context) {
    final drawerBloc = BlocProvider.of<DrawerBloc>(context);
    final userBloc = BlocProvider.of<UserBloc>(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('LocoStall'),
        centerTitle: true,
        actions: <Widget>[LangMenu(iconButtonTitle: l10n.language)],
      ),
      body: BlocBuilder<DrawerBloc, DrawerState>(
        builder: (context, state) {
          switch (state.tab) {
            case TabPage.markets:
              return const MarketsTab();
            case TabPage.shops:
              return const ShopsTab();
            case TabPage.waiting:
              return const WaitingTab();
            case TabPage.login:
              return LoginTab(
                onSubmitted: (email, password) {
                  userBloc.add(LoginEvent(email!, password!));
                  drawerBloc.add(ItemTappedEvent(TabPage.shops));
                },
              );
            case TabPage.register:
              return RegisterTab(
                onSubmitted: (email, password) async {
                  final prefs = await SharedPreferences.getInstance();
                  userBloc.add(RegisterEvent(
                      email!, password!, prefs.getString('langCode') ?? 'en'));
                  drawerBloc.add(ItemTappedEvent(TabPage.shops));
                },
              );
            case TabPage.settings:
              return const Center(child: Text("TODO:"));
          }
        },
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: lsPrimary),
              accountName:
                  Text(userBloc.state.userData?.name ?? 'edit profile'),
              accountEmail: Text(userBloc.state.userData?.email ?? 'not login'),
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
              title: Text(l10n.stalls),
              selected: drawerBloc.state.tab == TabPage.shops,
              onTap: () {
                drawerBloc.add(ItemTappedEvent(TabPage.shops));
                Navigator.pop(context);
                setState(() {});
              },
            ),
            ListTile(
              leading: const Icon(Icons.ramen_dining_outlined),
              title: Text(l10n.orders),
              selected: drawerBloc.state.tab == TabPage.waiting,
              onTap: () {
                drawerBloc.add(ItemTappedEvent(TabPage.waiting));
                Navigator.pop(context);
                setState(() {});
              },
            ),
            ListTile(
              leading: Icon(
                  userBloc.state.user == null ? Icons.login : Icons.logout),
              title: Text(userBloc.state.user == null ? l10n.logreg : 'Logout'),
              selected: (drawerBloc.state.tab == TabPage.login) |
                  (drawerBloc.state.tab == TabPage.register),
              onTap: () {
                drawerBloc.add(ItemTappedEvent(TabPage.login));
                if (userBloc.state.user == null) {
                  Navigator.pop(context);
                  setState(() {});
                } else {
                  userBloc.add(LogoutEvent());
                  setState(() {});
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(l10n.settings),
              selected: drawerBloc.state.tab == TabPage.settings,
              onTap: () {
                drawerBloc.add(ItemTappedEvent(TabPage.settings));
                Navigator.pop(context);
                setState(() {});
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => TakePicture(camera: firstCamera),
          ));
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}
