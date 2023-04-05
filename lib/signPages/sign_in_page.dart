import 'package:google_fonts/google_fonts.dart';
import 'package:nutri_app/widges/myTextField.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {

  bool isObscurePassword = true;
  TextEditingController date = TextEditingController();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 15, right:15),
        child: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children : [
                    Column(
                      children: [
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
                        SizedBox(height: 30),
                        buildTextField('Correo Electrónico', '', emailController, false),
                        SizedBox(height: 5),
                        buildTextField('Contraseña', '', passwordController, true),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  //logica de has olvidado la contraseña
                                },
                                child: Text('¿Has olvidado la contraseña?',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 30),
                        GestureDetector(
                          onTap: () {
                            //logica del boton SIGN IN
                          },
                          child: Container(
                            padding: EdgeInsets.all(14),
                            margin: EdgeInsets.symmetric(horizontal: 100),
                            decoration: BoxDecoration(
                              color: Color.fromARGB(255, 23, 142, 56),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                "Sign in",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                )
                              ),
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
                      ]
                    ),
                  ],
                ),    
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget buildTextField(String labelText, String placeholder, TextEditingController date, bool isPasswordTextField){
    return Padding(
      padding: EdgeInsets.only(bottom:30),
      child: TextField(
        obscureText: isPasswordTextField ? isObscurePassword: false,
        decoration: InputDecoration(
          suffixIcon: isPasswordTextField ? 
          IconButton(
            onPressed: (){
              setState((){
                isObscurePassword = !isObscurePassword;
              });
            },
            icon: Icon(Icons.remove_red_eye, color: Colors.grey),
            ): null,
          contentPadding:  EdgeInsets.only(bottom: 5),
          labelText: labelText,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: placeholder,
          hintStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey
          ),
        ),
        controller: date,
      ),
    );
  }
}