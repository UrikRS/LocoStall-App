/*
  Flutter UI
  ----------
  lib/screens/simple_login.dart
*/

import 'package:flutter/material.dart';
import 'package:locostall/screens/home.dart';
import 'package:locostall/screens/elements/input_field.dart';
import 'package:locostall/screens/elements/form_button.dart';

class LoginTab extends StatefulWidget {
  /// Callback for when this form is submitted successfully. Parameters are (email, password)
  final Function(String? email, String? password)? onSubmitted;

  const LoginTab({this.onSubmitted, Key? key}) : super(key: key);
  @override
  State<LoginTab> createState() => _SimpleLoginScreenState();
}

class _SimpleLoginScreenState extends State<LoginTab> {
  late String email, password;
  String? emailError, passwordError;
  Function(String? email, String? password)? get onSubmitted =>
      widget.onSubmitted;

  @override
  void initState() {
    super.initState();
    email = '';
    password = '';

    emailError = null;
    passwordError = null;
  }

  void resetErrorText() {
    setState(() {
      emailError = null;
      passwordError = null;
    });
  }

  bool validate() {
    resetErrorText();

    RegExp emailExp = RegExp(
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

    bool isValid = true;
    if (email.isEmpty || !emailExp.hasMatch(email)) {
      setState(() {
        emailError = 'Email is invalid';
      });
      isValid = false;
    }

    if (password.isEmpty) {
      setState(() {
        passwordError = 'Please enter a password';
      });
      isValid = false;
    }

    return isValid;
  }

  void submit() {
    if (validate()) {
      if (onSubmitted != null) {
        onSubmitted!(email, password);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        children: [
          SizedBox(height: screenHeight * .12),
          const Text(
            'Welcome,',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: screenHeight * .01),
          const Text(
            'Sign in to continue!',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: screenHeight * .12),
          InputField(
            onChanged: (value) {
              setState(() {
                email = value;
              });
            },
            labelText: 'Email',
            errorText: emailError,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            autoFocus: true,
          ),
          SizedBox(height: screenHeight * .025),
          InputField(
            onChanged: (value) {
              setState(() {
                password = value;
              });
            },
            onSubmitted: (val) => submit(),
            labelText: 'Password',
            errorText: passwordError,
            obscureText: true,
            textInputAction: TextInputAction.next,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text(
                'Forgot Password?',
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          SizedBox(
            height: screenHeight * .075,
          ),
          FormButton(
            text: 'Log In',
            onPressed: submit,
          ),
          SizedBox(
            height: screenHeight * .15,
          ),
          TextButton(
            onPressed: () {
              setState(() {
                Home.of(context)?.onItemTapped(3);
              });
            },
            child: RichText(
              text: const TextSpan(
                text: "I'm a new user, ",
                style: TextStyle(color: Colors.grey),
                children: [
                  TextSpan(
                    text: 'Sign Up',
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
