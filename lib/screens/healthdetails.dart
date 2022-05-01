import 'package:flutter/material.dart';

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

  String username = '';
  String email = '';
  String password = '';
  late double height;
  late double weight;
  late int systolicBP;
  late int diastolicBP;
  late int heartRate;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Color.fromARGB(255, 211, 220, 219),
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
              setHeight(),
              const SizedBox(height: 16),
              setWeight(),
              const SizedBox(height: 32),
              setSBP(),
              const SizedBox(height: 32),
              setDBP(),
              const SizedBox(height: 32),
              setHeartRate(),
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
        onSaved: (value) => setState(() => height = value! as double),
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
        onSaved: (value) => setState(() => weight = value! as double),
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
        onSaved: (value) => setState(() => systolicBP = value! as int),
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
        onSaved: (value) => setState(() => diastolicBP = value! as int),
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
        onSaved: (value) => setState(() => heartRate = value! as int),
      );

  Widget buildSubmit() => Builder(
        builder: (context) => ElevatedButton(
          onPressed: () {
            final isValid = formKey.currentState?.validate();
            // FocusScope.of(context).unfocus();

            if (isValid!) {
              formKey.currentState!.save();

              final message =
                  'Username: $username\nPassword: $password\nEmail: $email';
              final snackBar = SnackBar(
                content: Text(
                  message,
                  style: const TextStyle(fontSize: 20),
                ),
                backgroundColor: Colors.green,
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
            minimumSize: Size(88, 36),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
          ),
        ),
      );
}
