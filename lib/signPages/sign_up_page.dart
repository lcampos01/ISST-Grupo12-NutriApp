import 'package:google_fonts/google_fonts.dart';
import 'package:nutri_app/widges/myTextField.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({Key? key}) : super(key: key);

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 15),
              DefaultTextStyle(
                style: GoogleFonts.openSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
                child: Text(
                  "Bienvenido/a de nuevo. ¡NUTRI rindas!",
                ),
              ),
              SizedBox(height: 15),
              MyTextField(
                controller: usernameController, 
                hintText: 'Email', 
                obscureText: false,
              ),
              SizedBox(height: 5),
              MyTextField(
                controller: passwordController, 
                hintText: 'Password', 
                obscureText: true,
              ),
              SizedBox(height: 5),
              MyTextField(
                controller: passwordController, 
                hintText: 'Repeate your password', 
                obscureText: true,
              ),
              SizedBox(height: 35),
              Container(
                padding: EdgeInsets.all(14),
                margin: EdgeInsets.symmetric(horizontal: 100),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 23, 142, 56),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    "Sign up",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    )
                  ),
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }
}