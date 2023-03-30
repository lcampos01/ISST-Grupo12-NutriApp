import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutri_app/signPages/sign_in_page.dart';
import 'package:nutri_app/signPages/sign_up_page.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/cupertino.dart';
//import 'package:provider/provider.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({Key? key, this.name, this.imageUrl, this.macros, this.calidad, this.imageNutriScore}) : super(key: key);
  
  final name; //pasar a ItemPage(name: //pasar nombre del alimento de la API buscado)
  final imageUrl; //pasar a ItemPage(imageUrl: //url de la imagen de la API del alimento buscado)
  final macros; //sera un array de double de calorias, proteinas, carbohidratos y grasas
  final calidad;  //string con buena, mala... (para calidad nutricional..)
  final imageNutriScore;
  
  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {

  //macros si puede ser será un array de double [calorias, proteinas, carbohidratos, grasas]
  //calorias = widget.macros[0];
  //proteinas = widget.macros[1];
  //carbohidratos = widget.macros[2];
  //grasas = widget.macros[3];
  //calidad = widget.calidad;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200),
        child: AppBar(
          centerTitle: true,
          flexibleSpace: ClipRRect(
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/eggs.jpeg'),  //sustituir por imageUrl
                  fit: BoxFit.fill
                ),
              ),
            ),
          ),
          elevation: 5,
          automaticallyImplyLeading: true,
          // leading: Container(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Product',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 5),
            Text(
              widget.name,
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text('Calorías'),
                    SizedBox(height: 10),
                    //Text('$calorias [Kcal]'), para cuando se cree el array de macros
                    Text(
                      '___ [Kcal]',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('Proteínas'),
                    SizedBox(height: 10),
                    //Text('$proteinas [g]'), para cuando se cree el array de macros
                    Text(
                      '___ [g]',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('Carbohidratos'),
                    SizedBox(height: 10),
                    //Text('$carbohidratos [g]'), para cuando se cree el array de macros
                    Text(
                      '___ [g]',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('Grasas'),
                    SizedBox(height: 10),
                    //Text('$grasas [g]'), para cuando se cree el array de macros
                    Text(
                      '___ [g]',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 40),
            GestureDetector(
              onTap: () {
                //logica del boton Ver detalles
              },
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(horizontal: 120),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 23, 142, 56),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    "Ver detalles",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    )
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            Center(
              child: Text(
                //'Calidad nutricional $calidad',
                'Calidad nutricional buena',
                style: TextStyle(
                  color: Color.fromARGB(255, 23, 142, 56),
                  fontWeight: FontWeight.bold,
                  fontSize: 21,
                ),
              ),
            ),
            SizedBox(height: 25),
            Center(
              child: ClipRRect(
                child: Container(
                  width: 200,
                  height: 50,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/logo.png'),  //sustituir por imageNutriScore
                      fit: BoxFit.fill
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
  