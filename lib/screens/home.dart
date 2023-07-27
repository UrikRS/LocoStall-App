import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:locostall/bloc/drawer_bloc.dart';
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
    // initCamera();
  }

  Future<void> initCamera() async {
    WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    firstCamera = cameras.first;
  }

  @override
  Widget build(BuildContext context) {
    final drawerBloc = BlocProvider.of<DrawerBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('LocoStall'),
        centerTitle: true,
        actions: <Widget>[
          LangMenu(iconButtonTitle: AppLocalizations.of(context)!.language)
        ],
      ),
      body: BlocBuilder<DrawerBloc, DrawerState>(
        builder: (context, state) {
          switch (state.tab) {
            case TabPage.shops:
              return const ShopsTab();
            case TabPage.orders:
              return const OrdersTab();
            case TabPage.login:
              return const LoginTab();
            case TabPage.register:
              return const RegisterTab();
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
              selected: drawerBloc.state.tab == TabPage.shops,
              onTap: () {
                drawerBloc.add(ItemTappedEvent(TabPage.shops));
                Navigator.pop(context);
                setState(() {});
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart_outlined),
              title: Text(AppLocalizations.of(context)!.orders),
              selected: drawerBloc.state.tab == TabPage.orders,
              onTap: () {
                drawerBloc.add(ItemTappedEvent(TabPage.orders));
                Navigator.pop(context);
                setState(() {});
              },
            ),
            ListTile(
              leading: const Icon(Icons.login),
              title: Text(AppLocalizations.of(context)!.logreg),
              selected: drawerBloc.state.tab == TabPage.login,
              onTap: () {
                drawerBloc.add(ItemTappedEvent(TabPage.login));
                Navigator.pop(context);
                setState(() {});
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(AppLocalizations.of(context)!.settings),
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
