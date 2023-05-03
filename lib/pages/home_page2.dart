import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../functions/scanBarcode.dart';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:nutri_app/variables/global.dart';


class HomePage2 extends StatefulWidget {
  const HomePage2({Key? key}) : super(key: key);

  @override
  _HomePage2State createState() => _HomePage2State();
}

bool _isFavorite = false;
bool _isRegistered = false;

class _HomePage2State extends State<HomePage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          flexibleSpace: ClipRRect(
            child: Container(
              margin: EdgeInsets.only(top: 60),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/eggs.jpeg'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          automaticallyImplyLeading: true,
          actions: [
            IconButton(
              icon: _isFavorite ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
              iconSize: 25,
              color: _isFavorite ? Colors.red : Colors.black,
              onPressed: () {
              },
            ),
              IconButton(
              icon: _isRegistered ? Icon(Icons.add_box_rounded) : Icon(Icons.add_box_outlined),
              iconSize: 25,
              color: _isRegistered ? Colors.green : Colors.black,
              onPressed: () async {
                final responseConsumo = await http.get(
                  Uri.parse('${globalVariables.ipVM}/consumo'),
                  headers: <String, String>{
                    'authorization': globalVariables.tokenUser,
                  },
                );
                var jsonDataConsumo;
                if (responseConsumo.statusCode == 200) {
                  final jsonDataConsumo = jsonDecode(responseConsumo.body);
                }
                else{
                  throw new Exception('Error al cargar productos consumidos');
                }

                _isRegistered = !_isRegistered;

                if (_isRegistered) {
            

                      List<Map<String, String>> alergenosMod = _selectedAllergens.map((alergeno) {
                        return {'nombre': alergeno};
                      }).toList();
                      


                  
                  List<Map<String, String>> consumoMod = jsonDataConsumo.add().toList();
                      



                  //la he añadido a favoritos -> post alimentos para meterla en favs
                  final responseadd = await http.post(
                    Uri.parse('${globalVariables.ipVM}/consumo'),
                    body: 

                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                      'authorization': globalVariables.tokenUser,
                    },
                  );
                  if(responseadd.statusCode == 200) {
                    print("Se ha añadido a favoritos");
                  } else {
                    print("Ha ocurrido un error");
                  }
                } else {
                  //la he borrado de favoritos -> delete alimentos para sacarla de favs
                  final responsedelete = await http.delete(
                    Uri.parse('${globalVariables.ipVM}/favoritos'),
                    body: jsonEncode({
                      "barcode": widget.barcode, 
                    }),
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                      'authorization': globalVariables.tokenUser,
                    },
                  );
                  if(responsedelete.statusCode == 200) {
                    print("Se ha borrado de favoritos");
                  } else {
                    print("Ha ocurrido un error");
                  }
                }
                setState(() {});
              },
              },
            ),

          ],
        ),
      ),

    );
  }
}
