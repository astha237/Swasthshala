import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LogIn extends StatefulWidget {
  final String title;

  // ignore: use_key_in_widget_constructors
  const LogIn({
    required this.title,
  });

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final formKey = GlobalKey<FormState>();
  String username = '';
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color.fromARGB(255, 211, 220, 219),
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Colors.teal,
        ),
        body: Form(
          key: formKey,
          //autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(height: 16),
              buildUsername(),
              // const SizedBox(height: 16),
              // buildEmail(),
              const SizedBox(height: 32),
              buildPassword(),
              const SizedBox(height: 32),
              buildSubmit(),
            ],
          ),
        ),
      );

  Widget buildUsername() => TextFormField(
        decoration: const InputDecoration(
          labelText: 'Full Name',
          border: OutlineInputBorder(),
          // errorBorder:
          //     OutlineInputBorder(borderSide: BorderSide(color: Colors.purple)),
          // focusedErrorBorder:
          //     OutlineInputBorder(borderSide: BorderSide(color: Colors.purple)),
          // errorStyle: TextStyle(color: Colors.purple),
        ),
        validator: (value) {
          if (value!.length < 4) {
            return 'Enter at least 4 characters';
          } else {
            return null;
          }
        },
        maxLength: 30,
        onSaved: (value) => setState(() => username = value!),
      );

  Widget buildEmail() => TextFormField(
        decoration: const InputDecoration(
          labelText: 'Email',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          const pattern = r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
          final regExp = RegExp(pattern);

          if (value!.isEmpty) {
            return 'Enter an email';
          } else if (!regExp.hasMatch(value)) {
            return 'Enter a valid email';
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.emailAddress,
        onSaved: (value) => setState(() => email = value!),
      );

  Widget buildPassword() => TextFormField(
        decoration: const InputDecoration(
          labelText: 'Password',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value!.length < 7) {
            return 'Password must be at least 7 characters long';
          } else {
            return null;
          }
        },
        onSaved: (value) => setState(() => password = value!),
        keyboardType: TextInputType.visiblePassword,
        obscureText: true,
      );

  Widget buildSubmit() => Builder(
        builder: (context) => ElevatedButton(
          onPressed: () {
            final isValid = formKey.currentState?.validate();
            // FocusScope.of(context).unfocus();

            if (isValid!) {
              formKey.currentState!.save();
              signInUser();

              // final message =
              //     'Username: $username\nPassword: $password\nEmail: $email';
              // final snackBar = SnackBar(
              //   content: Text(
              //     message,
              //     style: const TextStyle(fontSize: 20),
              //   ),
              //   backgroundColor: Colors.green,
              // );
              // ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          },
          child: const Text(
            'Submit',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: ElevatedButton.styleFrom(
            onPrimary: Colors.white,
            primary: Colors.teal,
            minimumSize: const Size(88, 36),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
          ),
        ),
      );
  Future signInUser() async {
    var url = Uri.parse("http://btp.southindia.cloudapp.azure.com/auth/login/");
    var resp = await http.post(
      url,
      body: {
        'username': username,
        'password': password,
      },
    );
    if (kDebugMode) {
      print(resp.statusCode);
      print(resp.body);
    }
    if (resp.statusCode == 200) {
      Map data = jsonDecode(resp.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", data["token"]);
      Navigator.of(context).popAndPushNamed("main_app");
    }
  }
}
