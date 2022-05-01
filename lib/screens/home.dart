import 'package:flutter/material.dart';
import './login.dart';
import './register.dart';
import './healthdetails.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 175, 211, 243),
      appBar: AppBar(
        title: Text('Welcome'),
        backgroundColor: Color.fromARGB(255, 99, 172, 236),
      ),
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset('images/welcome.png'),
            const Text(
              'Swasthshala',
              style: TextStyle(
                color: Color.fromARGB(255, 1, 96, 87),
                fontSize: 70,
                fontFamily: 'Cursive',
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(
              height: 60,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LogIn(title: 'Log In')),
                  );
                },
                child: const Text(
                  "LogIn",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.black87,
                  primary: Color.fromARGB(255, 99, 172, 236),
                  minimumSize: Size(88, 36),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 8),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                )),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SignIn(title: 'Sign In')),
                  );
                },
                child: const Text(
                  "Register",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.black87,
                  primary: Color.fromARGB(255, 99, 172, 236),
                  minimumSize: Size(88, 36),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 8),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                  ),
                )),
            //ElevatedButton(onPressed: () {}, child: const Text("Register"))
          ],
        ),
      ),
    );
  }
}
