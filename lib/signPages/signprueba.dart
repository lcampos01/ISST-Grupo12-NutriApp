import 'package:google_fonts/google_fonts.dart';
import 'package:nutri_app/main.dart';
import 'package:nutri_app/signPages/data_sign.dart';
import 'package:nutri_app/widges/myTextField.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../functions/validaciones.dart';
import 'dart:convert';
import 'package:nutri_app/variables/global.dart';

class SignUpPruebaPage extends StatefulWidget {
  SignUpPruebaPage({Key? key}) : super(key: key);

  @override
  State<SignUpPruebaPage> createState() => _SignUpPruebaPageState();
}

class _SignUpPruebaPageState extends State<SignUpPruebaPage> {
  bool isObscurePassword = true;

  TextEditingController date = TextEditingController();

  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
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
              // final response = await http.post(
              //   Uri.parse('http://34.175.85.15:8080/signup'),
              //   body: jsonEncode(<String, String>{
              //     'email': email,
              //     'password': password,
              //   }),
              //   headers: <String, String>{
              //     'Content-Type': 'application/json; charset=UTF-8',
              //   },
              // );
              // if (response.statusCode == 200) {
              //   final tokenUser = response.headers['Authentication'];
                print("Se ha registrado correctamente");
                showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('¡¡BIENVENIDO/A A NUTRIAPP!!'),
                  content: Text(
                    'Solo falta completar unos cuantos datos.'),
                  actions: [
                    TextButton(
                      onPressed: () => {
                        Navigator.pushAndRemoveUntil(
                          context,
                          CupertinoPageRoute(
                            builder: (BuildContext context) => NavigationScreen(page: screens[0]),
                            fullscreenDialog: true,
                            maintainState: true,
                          ),
                          (route) => false,
                        )
                      },   
                      child: Text('OK'),
                    ),
                  ],
                ));
              // } else {
              //   print("No se ha registrado correctamente");
              //   showDialog(
              //   context: context,
              //   builder: (context) => AlertDialog(
              //     title: Text('Oh, oh... Ha habido un error con el servidor'),
              //     content: Text(
              //         'El registro no se ha producido correctamente.'),
              //     actions: [
              //       TextButton(
              //           onPressed: () =>
              //               Navigator.pop(context),
              //           child: Text('OK'))
              //     ],
              //   ));
              // }
            } else if (!emailBool) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Email no válido'),
                  content: Text(
                      'Debe haber una dirección de correo'),
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
                    'La contraseña debe tener al menos 8 carácteres, incluyendo una mayúscula y un número'
                  ),
                  actions: [
                    TextButton(
                      onPressed: () =>
                          Navigator.pop(context),
                      child: Text('OK')
                    ),
                  ],
                )
              );
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
    );
  }

  Widget buildTextField(String labelText, String placeholder,
      TextEditingController date, bool isPasswordTextField) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: TextField(
        maxLength: isPasswordTextField ? 20 : null,
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