import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

import './camera.dart';
import 'package:path/path.dart';
import 'package:http_parser/http_parser.dart';

class NewStudent extends StatefulWidget {
  const NewStudent({Key? key}) : super(key: key);

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<NewStudent> {
  final formKey = GlobalKey<FormState>();
  String firstName = '';
  String lastName = '';
  File? photo;
  String school = '';
  String city = '';
  int age = 0;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color.fromARGB(255, 211, 220, 219),
        appBar: AppBar(
          backgroundColor: Colors.teal,
        ),
        body: Form(
          key: formKey,
          //autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const SizedBox(height: 16),
              buildFirstName(),
              const SizedBox(height: 32),
              buildLastName(),
              const SizedBox(height: 16),
              buildAge(),
              const SizedBox(height: 16),
              buildCity(),
              const SizedBox(height: 16),
              buildSchool(),
              const SizedBox(height: 32),
              takePhoto(),
              const SizedBox(height: 32),
              buildSubmit(),
            ],
          ),
        ),
      );

  Widget buildFirstName() => TextFormField(
        decoration: const InputDecoration(
          labelText: 'First name',
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
        onSaved: (value) => setState(() => firstName = value!),
      );

  Widget buildLastName() => TextFormField(
        decoration: const InputDecoration(
          labelText: 'last name',
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
        onSaved: (value) => setState(() => lastName = value!),
      );

  Widget buildAge() => TextFormField(
        decoration: const InputDecoration(
          labelText: 'Age',
          border: OutlineInputBorder(),
          // errorBorder:
          //     OutlineInputBorder(borderSide: BorderSide(color: Colors.purple)),
          // focusedErrorBorder:
          //     OutlineInputBorder(borderSide: BorderSide(color: Colors.purple)),
          // errorStyle: TextStyle(color: Colors.purple),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Age is required.';
          } else {
            return null;
          }
        },
        //maxLength: 2,
        onSaved: (value) => setState(() => age = int.parse(value!)),
        keyboardType: TextInputType.number,
      );
  Widget buildCity() => TextFormField(
        decoration: const InputDecoration(
          labelText: 'City',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Required.';
          } else {
            return null;
          }
        },
        onSaved: (value) => setState(() => city = value!),
      );

  Widget buildSchool() => TextFormField(
        decoration: const InputDecoration(
          labelText: 'School',
          border: OutlineInputBorder(),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Required.';
          } else {
            return null;
          }
        },
        onSaved: (value) => setState(() => school = value!),
      );

  Widget buildSubmit() => Builder(
        builder: (context) => ElevatedButton(
          onPressed: () {
            final isValid = formKey.currentState?.validate();
            // FocusScope.of(context).unfocus();

            if (isValid!) {
              formKey.currentState!.save();
              if (kDebugMode) {
                print("submit called");
              }
              signUpUser(context);
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

  Widget takePhoto() => Builder(
        builder: (context) => ElevatedButton(
          onPressed: chooseStudentImage,
          child: const Text("take photo"),
        ),
      );

  Future<void> chooseStudentImage() async {
    File? f = await getFromCamera();
    if (f == null) return;
    photo = f;
  }

  Future signUpUser(context) async {
    var url =
        Uri.parse("http://btp.southindia.cloudapp.azure.com/auth/new_student/");
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");

    Map<String, String> body = {
      'first_name': firstName,
      'last_name': lastName,
      'school': school,
      'city': city,
      'age': age.toString(),
    };
    if (photo == null) return;

    var request = http.MultipartRequest('POST', url);
    Map<String, String> headers = {"authorization": "token $token"};
    request.headers.addAll(headers);
    request.files.add(http.MultipartFile(
      'photo',
      photo!.readAsBytes().asStream(),
      photo!.lengthSync(),
      filename: basename(photo!.path),
      contentType: MediaType("image", extension(photo!.path)),
    ));
    request.fields.addAll(body);

    var res = await request.send();
    if (kDebugMode) {
      print(res.statusCode);
      var response = await http.Response.fromStream(res);
      print(response.body);
    }
    Navigator.of(context).pop();
  }
}
