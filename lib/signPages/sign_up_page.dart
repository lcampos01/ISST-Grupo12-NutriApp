import 'package:google_fonts/google_fonts.dart';
import 'package:nutri_app/widges/myTextField.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../functions/validaciones.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  bool isObscurePassword = true;

  TextEditingController date = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 15, right: 15),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(children: [
            Center(
              child: Stack(
                children: [
                  Column(
                    children: [
                      DefaultTextStyle(
                        style: GoogleFonts.openSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                        child: Text(
                          "Bienvenido/a a NutriApp",
                        ),
                      ),
                      SizedBox(height: 30),
                      buildTextField(
                          'Correo Electrónico', '', emailController, false),
                      SizedBox(height: 5),
                      buildTextField(
                          'Contraseña', '', passwordController, true),
                      GestureDetector(
                        onTap: () async {
                          String email = emailController.text.trim();
                          String password = passwordController.text.trim();

                          final emailBool = validateEmail(email);
                          final passBool = validatePassword(password);

                          if (emailBool && passBool) {
                            final response = await http.post(
                              Uri.parse('http://www.google.com'),
                              body: {
                                'email': email,
                                'password': password,
                              },
                            );
                            if (response.statusCode == 200) {
                              final tokenUser =
                                  response.headers['Authentication'];
                            }
                          } else if (!emailBool) {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text('Email no válido'),
                                      content: Text(
                                          'Debe ser una dirección de correo existente'),
                                      actions: [
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text('OK'))
                                      ],
                                    ));
                          } else if (!passBool) {
                            showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                      title: Text('Contraseña no válida'),
                                      content: Text(
                                          'La contraseña debe tener al menos 8 carácteres, incluyendo una mayúscula y un número'),
                                      actions: [
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            child: Text('OK'))
                                      ],
                                    ));
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(14),
                          margin: EdgeInsets.symmetric(horizontal: 100),
                          decoration: BoxDecoration(
                            color: Color.fromARGB(255, 23, 142, 56),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text("Sign up",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                )),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Or continue with',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        padding: EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black,
                          ),
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.grey.shade200,
                        ),
                        child: Image.asset(
                          'assets/google.png',
                          height: 40,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, String placeholder,
      TextEditingController date, bool isPasswordTextField) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: TextField(
        obscureText: isPasswordTextField ? isObscurePassword : false,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        isObscurePassword = !isObscurePassword;
                      });
                    },
                    icon: Icon(Icons.remove_red_eye, color: Colors.grey),
                  )
                : null,
            contentPadding: EdgeInsets.only(bottom: 5),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
        controller: date,
      ),
    );
  }
}
