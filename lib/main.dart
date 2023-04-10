import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nutri_app/pages/add_public_page.dart';
import 'package:nutri_app/pages/fav_page.dart';
import 'package:nutri_app/pages/profile_page.dart';
import 'package:nutri_app/pages/search_page.dart';
import 'package:nutri_app/signPages/sign.dart';
import 'package:nutri_app/pages/home_page.dart';


import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //final tokenUsuario;
  var prueba = false;
  var respuestaAPI;
  var usuarioLogeado;

  @override
  void initState() {
    super.initState();
    //fetchData();
  }

  //Petición a la API
  // void fetchData() async {
  //   var client = http.Client();
  //   final response = await client.get(
  //     Uri.parse('/currentUser'),
  //     headers: {
  //       //HttpHeaders.authorizationHeader: tokenUsuario,
  //     },
  //   );

  //   if (response.statusCode == 200) {
  //     setState(() {
  //       respuestaAPI = jsonDecode(response.body);
  //       usuarioLogeado = true;
  //     });
  //   } else {
  //     print('Error de conexión con la API: ${response.statusCode}');
  //     usuarioLogeado = false;
  //   }
  // }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //No ha cargado todavía la petición a la API
    if (prueba == null) {
      return const Center(
        //Pondría un spinner o algo así de loading..
        child: CircularProgressIndicator(),
      );
    } //El usuario tiene la sesión iniciada
    else if (prueba) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "NutriApp",
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
        ),
        home: SafeArea(child: NavigationScreen()),
        //home: SignPage(),
      );
    } //El usuario no tiene sesión iniciada
    else {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "NutriApp",
        theme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
        ),
        home: SignPage(),
        //home: SafeArea(child: NavigationScreen())
      );
    }
  }
}

class NavigationScreen extends StatefulWidget {
  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  int currentTab = 0;
  final List<Widget> screens = [
    HomePage(),
    SearchPage(),
    FavPage(),
    ProfilePage(),
  ];
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = HomePage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   backgroundColor: Color.fromARGB(255, 23, 142, 56),
      //   foregroundColor: Colors.white,
      //   onPressed: () {
      //     Navigator.of(context).push(PageRouteBuilder(
      //       pageBuilder: (context, animation, _) {
      //         return AddPublicPage();
      //       },
      //       opaque: false,
      //     ));
      //   },
      // ),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 10.0,
        shape: CircularNotchedRectangle(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: [
            MaterialButton(
              minWidth: 40,
              onPressed: () {
                setState(() {
                  currentScreen = HomePage();
                  currentTab = 0;
                });
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.home,
                    color: currentTab == 0
                        ? Color.fromARGB(255, 23, 142, 56)
                        : Color.fromARGB(255, 115, 119, 144),
                  ),
                  Text(
                    'Home',
                    style: TextStyle(
                      color: currentTab == 0
                          ? Color.fromARGB(255, 23, 142, 56)
                          : Color.fromARGB(255, 115, 119, 144),
                    ),
                  ),
                ],
              ),
            ),
            MaterialButton(
              minWidth: 40,
              onPressed: () {
                setState(() {
                  currentScreen = SearchPage();
                  currentTab = 1;
                });
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.search,
                    color: currentTab == 1
                        ? Color.fromARGB(255, 23, 142, 56)
                        : Color.fromARGB(255, 115, 119, 144),
                  ),
                  Text(
                    'Search',
                    style: TextStyle(
                      color: currentTab == 1
                          ? Color.fromARGB(255, 23, 142, 56)
                          : Color.fromARGB(255, 115, 119, 144),
                    ),
                  ),
                ],
              ),
            ),
            MaterialButton(
              minWidth: 40,
              onPressed: () {
                setState(() {
                  currentScreen = FavPage();
                  currentTab = 2;
                });
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.favorite,
                    color: currentTab == 2
                        ? Color.fromARGB(255, 23, 142, 56)
                        : Color.fromARGB(255, 115, 119, 144),
                  ),
                  Text(
                    'Favorite',
                    style: TextStyle(
                      color: currentTab == 2
                          ? Color.fromARGB(255, 23, 142, 56)
                          : Color.fromARGB(255, 115, 119, 144),
                    ),
                  ),
                ],
              ),
            ),
            MaterialButton(
              minWidth: 40,
              onPressed: () {
                setState(() {
                  currentScreen = ProfilePage();
                  currentTab = 3;
                });
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.person,
                    color: currentTab == 3
                        ? Color.fromARGB(255, 23, 142, 56)
                        : Color.fromARGB(255, 115, 119, 144),
                  ),
                  Text(
                    'Profile',
                    style: TextStyle(
                      color: currentTab == 3
                          ? Color.fromARGB(255, 23, 142, 56)
                          : Color.fromARGB(255, 115, 119, 144),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
