/*
  Flutter UI
  ----------
  lib/screens/simple_login.dart
*/

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:locostall/screens/elements/input_field.dart';
import 'package:locostall/screens/elements/form_button.dart';
import 'package:locostall/screens/home.dart';

class RegisterTab extends StatefulWidget {
  /// Callback for when this form is submitted successfully. Parameters are (email, password)
  final Function(String? email, String? password)? onSubmitted;

  const RegisterTab({this.onSubmitted, Key? key}) : super(key: key);

  @override
  State<RegisterTab> createState() => _SimpleRegisterScreenState();
}

class _SimpleRegisterScreenState extends State<RegisterTab> {
  late String email, password, confirmPassword;
  String? emailError, passwordError;
  Function(String? email, String? password)? get onSubmitted =>
      widget.onSubmitted;

  @override
  void initState() {
    super.initState();
    email = '';
    password = '';
    confirmPassword = '';

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

    if (password.isEmpty || confirmPassword.isEmpty) {
      setState(() {
        passwordError = 'Please enter a password';
      });
      isValid = false;
    }
    if (password != confirmPassword) {
      setState(() {
        passwordError = 'Passwords do not match';
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
          Text(
            AppLocalizations.of(context)!.createaccount,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: screenHeight * .01),
          Text(
            AppLocalizations.of(context)!.signupcont,
            style: const TextStyle(
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
            labelText: 'Password',
            errorText: passwordError,
            obscureText: true,
            textInputAction: TextInputAction.next,
          ),
          SizedBox(height: screenHeight * .025),
          InputField(
            onChanged: (value) {
              setState(() {
                confirmPassword = value;
              });
            },
            onSubmitted: (value) => submit(),
            labelText: 'Confirm Password',
            errorText: passwordError,
            obscureText: true,
            textInputAction: TextInputAction.done,
          ),
          SizedBox(
            height: screenHeight * .075,
          ),
          FormButton(
            text: AppLocalizations.of(context)!.signup,
            onPressed: submit,
          ),
          SizedBox(
            height: screenHeight * .125,
          ),
          TextButton(
            onPressed: () {
              setState(() {
                Home.of(context)?.onItemTapped(2);
              });
            },
            child: RichText(
              text: TextSpan(
                text: "I'm already a member, ",
                style: const TextStyle(color: Colors.grey),
                children: [
                  TextSpan(
                    text: AppLocalizations.of(context)!.login,
                    style: const TextStyle(
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
