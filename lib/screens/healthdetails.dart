import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './camera.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart';
import './new_student.dart';

class HealthInfo extends StatefulWidget {
  final String title;

  // ignore: use_key_in_widget_constructors
  const HealthInfo({
    required this.title,
  });

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<HealthInfo> {
  final formKey = GlobalKey<FormState>();
  //String now = DateFormat("yyyy-MM-dd").format(DateTime.now());

  int? studentId;
  String firstName = '';
  String lastName = '';
  String school = '';

  late double height;
  late double weight;
  late int systolicBP;
  late int diastolicBP;
  late int heartRate;
  late int temp;

  @override
  Widget build(BuildContext context) {
    if (studentId == null) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 211, 220, 219),
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Colors.teal,
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NewStudent(),
                  ),
                );
              },
              child: const Center(child: Text("Add Student")),
              style: TextButton.styleFrom(primary: Colors.black),
            )
          ],
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: chooseStudentImage,
            child: const Text("take image"),
          ),
        ),
      );
    }

    return Scaffold(
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
            studentData(),
            const SizedBox(height: 16),
            setHeight(),
            const SizedBox(height: 16),
            setWeight(),
            const SizedBox(height: 16),
            setTemp(),
            // const SizedBox(height: 32),
            // setSBP(),
            // const SizedBox(height: 32),
            // setDBP(),
            // const SizedBox(height: 32),
            // setHeartRate(),
            const SizedBox(height: 32),
            buildSubmit(),
            Image.asset(
              'images/x.png',
              height: 200,
            ),
          ],
        ),
      ),
    );
  }

  Widget studentData() => Builder(
      builder: (context) => Column(
            children: [
              Text("student id $studentId"),
              Text(firstName),
              Text(lastName),
              Text(school),
            ],
          ));

  Future<void> chooseStudentImage() async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    File? f = await getFromCamera();
    if (f == null) return;
    var url =
        Uri.parse("http://btp.southindia.cloudapp.azure.com/auth/face_auth/");
    var request = http.MultipartRequest('POST', url);
    Map<String, String> headers = {"authorization": "token $token"};
    request.files.add(http.MultipartFile(
      'image',
      f.readAsBytes().asStream(),
      f.lengthSync(),
      filename: basename(f.path),
      contentType: MediaType("image", extension(f.path)),
    ));
    request.headers.addAll(headers);
    if (kDebugMode) {
      print("request sent");
    }
    var res = await request.send() /*.timeout(const Duration(minutes: 2))*/;
    var resp = await http.Response.fromStream(res);

    var dat = jsonDecode(resp.body);
    setState(() {
      studentId = dat['id'];
      lastName = dat['last_name'];
      firstName = dat['first_name'];
      school = dat['school'];
    });

    if (kDebugMode) {
      print(res.statusCode);
      print(resp.body);
    }
  }

  Widget setHeight() => TextFormField(
        decoration: const InputDecoration(
          labelText: 'Height (in cm)',
          border: OutlineInputBorder(),
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Reuired Field.';
          } else {
            return null;
          }
        },
        onSaved: (value) => setState(() => height = double.parse(value!)),
      );

  Widget setWeight() => TextFormField(
        decoration: const InputDecoration(
          labelText: 'Weight (in kg)',
          border: OutlineInputBorder(),
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Reuired Field.';
          } else {
            return null;
          }
        },
        onSaved: (value) => setState(() => weight = double.parse(value!)),
      );

  Widget setTemp() => TextFormField(
        decoration: const InputDecoration(
          labelText: 'temp (in F)',
          border: OutlineInputBorder(),
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Reuired Field.';
          } else {
            return null;
          }
        },
        onSaved: (value) => setState(() => temp = int.parse(value!)),
      );

  Widget setSBP() => TextFormField(
        decoration: const InputDecoration(
          labelText: 'Systolic Blood Pressure (in mmHg)',
          border: OutlineInputBorder(),
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Reuired Field.';
          } else {
            return null;
          }
        },
        onSaved: (value) => setState(() => systolicBP = int.parse(value!)),
      );

  Widget setDBP() => TextFormField(
        decoration: const InputDecoration(
          labelText: 'Diastolic Blood Pressure (in mmHg)',
          border: OutlineInputBorder(),
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Reuired Field.';
          } else {
            return null;
          }
        },
        onSaved: (value) => setState(() => diastolicBP = int.parse(value!)),
      );

  Widget setHeartRate() => TextFormField(
        decoration: const InputDecoration(
          labelText: 'Heart Rate (in BPM)',
          border: OutlineInputBorder(),
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Reuired Field.';
          } else {
            return null;
          }
        },
        onSaved: (value) => setState(() => heartRate = int.parse(value!)),
      );

  Widget buildSubmit() => Builder(
        builder: (context) => ElevatedButton(
          onPressed: () {
            final isValid = formKey.currentState?.validate();
            // FocusScope.of(context).unfocus();

            if (isValid!) {
              formKey.currentState!.save();
              submitData(context);
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

  Future submitData(context) async {
    var prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    var url = Uri.parse(
        "http://btp.southindia.cloudapp.azure.com/health_data/create/");
    var resp = await http.post(
      url,
      headers: {"authorization": "token $token"},
      body: {
        'height': height.toString(),
        'weight': weight.toString(),
        'temperature': temp.toString(),
        'student': studentId.toString(),
      },
    );
    if (kDebugMode) {
      print(resp.statusCode);
      print(resp.body);
    }
    if (resp.statusCode == 201) {
      setState(() {
        studentId = null;
        lastName = '';
        firstName = '';
        school = '';
      });
    }
  }
}
