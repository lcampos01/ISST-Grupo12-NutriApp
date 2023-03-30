import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutri_app/signPages/sign_in_page.dart';
import 'package:nutri_app/signPages/sign_up_page.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/cupertino.dart';
//import 'package:provider/provider.dart';

class SignPage extends StatefulWidget {
  const SignPage({Key? key}) : super(key: key);

  @override
  _SignPageState createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {

  int indexBarra = 0;
  final Map<int, Widget> barra = <int, Widget> {
    0: DefaultTextStyle(
      style: GoogleFonts.openSans(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Color.fromARGB(255, 101, 8, 189),
      ),
      child: Text(
        "     SIGN IN     ",
      ),
    ),
    1: DefaultTextStyle(
      style: GoogleFonts.openSans(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: Color.fromARGB(255, 101, 8, 189),
      ),
      child: Text(
        "     SIGN UP     ",
      ),
    ),
  };
  final List<Widget> screens = [
    SignInPage(),
    SignUpPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 150),

            //logo
            Center(
              child: Image(
                image: AssetImage('assets/logo.png'),
              ),
            ),
            
            SizedBox(height: 50),

            //Pantallas SIGN IN / SIGN UP
            Center(
              child: CupertinoSlidingSegmentedControl(
                groupValue: indexBarra,
                onValueChanged: (changeFromGroupValue){
                  setState(() {
                    indexBarra = changeFromGroupValue!;
                  });
                },
                children: barra,
              ),
            ),
            Expanded(
              child: IndexedStack(
                index: indexBarra,
                children: screens,
              ),
            ),
          ],
        ),
      ),
    );
  }
}