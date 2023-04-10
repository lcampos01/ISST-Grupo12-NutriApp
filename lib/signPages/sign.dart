import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutri_app/signPages/sign_in_page.dart';
import 'package:nutri_app/signPages/sign_up_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class SignPage extends StatefulWidget {
  const SignPage({Key? key}) : super(key: key);

  @override
  _SignPageState createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  bool signInActive = true;
  
    // DefaultTextStyle(
    //   style: GoogleFonts.openSans(
    //     fontSize: 22,
    //     fontWeight: FontWeight.w600,
    //     color: Color.fromARGB(255, 101, 8, 189),
    //   ),
    //   child: Text(
    //     "     SIGN IN     ",
    //   ),
    // ),
    // DefaultTextStyle(
    //   style: GoogleFonts.openSans(
    //     fontSize: 22,
    //     fontWeight: FontWeight.w600,
    //     color: Color.fromARGB(255, 101, 8, 189),
    //   ),
    //   child: Text(
    //     "     SIGN UP     ",
    //   ),
    // ),
    
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Container(
          padding: EdgeInsets.only(left: 15, top: 20, right: 15),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ListView(
              children: [
                Center(
                  child: Column(
                    children: [
                      Image(
                        image: AssetImage('assets/logo.png'),
                      ),
                      SizedBox(height: 20),
                      Container(
                      width: 250,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                signInActive = true;
                              });
                            },
                            child: Container(
                              width: 115,
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: signInActive ? Colors.white : Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  'SIGN IN',
                                  style: GoogleFonts.openSans(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromARGB(255, 101, 8, 189),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 2),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                signInActive = false;
                              });
                            },
                            child: Container(
                              width: 115,
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                color: signInActive ? Colors.grey.shade200 : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  'SIGN UP',
                                  style: GoogleFonts.openSans(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                    color: Color.fromARGB(255, 101, 8, 189),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ), 
                    ),
                    SizedBox(height: 50),
                    signInActive ? 
                    SignInPage()
                    :
                    SignUpPage(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}