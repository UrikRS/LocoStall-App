import 'package:flutter/material.dart';
import 'package:locostall/services/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OldLogin extends StatefulWidget {
  final ApiClient apiClient;

  const OldLogin({super.key, required this.apiClient});

  @override
  State<OldLogin> createState() => _LoginState();
}

class _LoginState extends State<OldLogin> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoggedIn = false;
  bool loginFailed = false;

  Future<void> _authenticate(BuildContext context) async {
    final String email = emailController.text;
    final String password = passwordController.text;
    final bool isAuthenticated =
        await widget.apiClient.authenticateUser(email, password);

    if (isAuthenticated) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', true);
      setState(() {
        isLoggedIn = true;
      });
    } else {
      setState(() {
        loginFailed = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // if (isLoggedIn) {
    //   Navigator.of(context).pushReplacement(
    //       MaterialPageRoute(builder: (context) => const Home()));
    // }
    // if (loginFailed) {
    //   showDialog(
    //     context: context,
    //     builder: (context) => AlertDialog(
    //       title: const Text('Login Failed'),
    //       content: const Text('Invalid email or password.'),
    //       actions: [
    //         TextButton(
    //           onPressed: () => Navigator.pop(context),
    //           child: const Text('OK'),
    //         ),
    //       ],
    //     ),
    //   );
    // }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.translate),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _authenticate(context),
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
