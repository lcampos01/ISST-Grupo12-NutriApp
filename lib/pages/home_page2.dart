import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import '../functions/scanBarcode.dart';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:nutri_app/variables/global.dart';


import 'package:nutri_app/main.dart';

import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import 'package:nutri_app/signPages/sign.dart';



class HomePage2 extends StatefulWidget {
  HomePage2(
    {Key? key,
    this.momentoDia = 0,
    this.cantidad = 0,
    });

final momentoDia;
final cantidad;

  @override
  _HomePage2State createState() => _HomePage2State();
}


  int momento(String act) {
    if (act == 'Desayuno') {
      return 0;
    } else if (act == 'Almuerzo') {
      return 1;
    } else if (act == 'Comida') {
      return 2;

    }else if (act == 'Merienda') {
      return 3;
    } else {

      return 4;
    }
  }

bool _isFavorite = false;
bool _isRegistered = false;
String? _selectedMomento = 'Comida';
TextEditingController cantidadController = TextEditingController();

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
              onPressed: () {
                // final responseConsumo = await http.get(
                //   Uri.parse('${globalVariables.ipVM}/consumo'),
                //   headers: <String, String>{
                //     'authorization': globalVariables.tokenUser,
                //   },
                // );
                // var jsonDataConsumo;
                // if (responseConsumo.statusCode == 200) {
                //   final jsonDataConsumo = jsonDecode(responseConsumo.body);
                // }
                // else{
                //   throw new Exception('Error al cargar productos consumidos');
                // }

                 _isRegistered = !_isRegistered;
                String hintText = 'Seleccionar Momento del Día';
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Seleccionar Momento del Día'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          buildNumericField("Cantidad aproximada en gramos", widget.cantidad!.toString(), cantidadController),
                          SizedBox(height: 10),


                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Momento del Día',
                              border: OutlineInputBorder(),
                            ),
                            value: widget.momentoDia! == '0'
                                ? 'Desayuno'
                                : (widget.momentoDia! == 1 ? 'Almuerzo' :
                                (widget.momentoDia! == 2 ? 'Comida' :
                                (widget.momentoDia! == 3 ? 'Merienda' : 'Cena'))),
                            onChanged: (String? newValue) {
                              setState(() {
                                _selectedMomento = newValue;
                              });
                            },
                            items: [
                              DropdownMenuItem(
                                child: Text('Desayuno'),
                                value: 'Desayuno',
                              ),
                              DropdownMenuItem(
                                child: Text('Almuerzo'),
                                value: 'Almuerzo',
                              ),
                              DropdownMenuItem(
                                child: Text('Comida'),
                                value: 'Comida',
                              ),
                              DropdownMenuItem(
                                child: Text('Merienda'),
                                value: 'Merienda',
                              ),
                              DropdownMenuItem(
                                child: Text('Cena'),
                                value: 'Cena',
                              ),
                            ],
                             hint: Text(hintText) ,
                          ),
                          // DropdownButton<String>(

                          //   onChanged: (value) {
                          //     // Aquí puede guardar la selección del usuario en una variable
                          //     momento= value;
                          //     setState(() {
                          //       hintText = 'Momento del día: $momento';
                          //       print(value);
                          //       print(hintText);
                          //       print(momento);
                          //     });
                          //   },






                          // ),
                        ],
                      ),
                      actions: [
                        TextButton(
                          child: Text('Cancelar'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('Guardar'),
                          onPressed: () async{


                            // var cantidadMod = int.tryParse(cantidadController.text) ?? widget.cantidad;
                            // var momentoDiaMod = momento(_selectedMomento.toString());
                            // var esteDia = DateTime.now().toString().split(" ")[0];
                            // var grasaMod = cantidadMod * grasas /100;
                            // var carbohidratosMod = cantidadMod * carbohidratos /100;
                            // var proteinasMod = cantidadMod * proteinas /100;
                            // var caloriasMod = cantidadMod * calorias /100;
                            // var nombreMod = nombre;


                            print(cantidadMod);
                            print(_selectedMomento);
                            print(momentoDiaMod);


                              //la he añadido a favoritos -> post alimentos para meterla en favs
                              // final responseconsumo = await http.post(
                              //   Uri.parse('${globalVariables.ipVM}/consumo'),
                              //   body: jsonEncode({
                              //       'dia': esteDia,
                              //       'grasas': grasaMod,
                              //       'carbohidratos': carbohidratosMod,
                              //       'proteinas': proteinasMod,
                              //       'calorias': caloriasMod,
                              //       'momento': momentoDiaMod,
                              //       'alimento' nombreMod,
                              //       'cantidad' cantidadMod
                              //     }),
                              //   headers: <String, String>{
                              //       'Content-Type': 'application/json; charset=UTF-8',
                              //       'authorization': globalVariables.tokenUser,
                              //     },
                              //   );

                            // Aquí puede guardar la cantidad y la selección del usuario en su base de datos
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  },
                );





                //   print( DateTime.now());
                //   if(responseadd.statusCode == 200) {
                //     print("Se ha añadido a favoritos");
                //   } else {
                //     print("Ha ocurrido un error");
                //   }
                // } else {
                //   //la he borrado de favoritos -> delete alimentos para sacarla de favs
                //   final responsedelete = await http.delete(
                //     Uri.parse('${globalVariables.ipVM}/favoritos'),
                //     body: jsonEncode({
                //       "barcode": widget.barcode,
                //     }),
                //     headers: <String, String>{
                //       'Content-Type': 'application/json; charset=UTF-8',
                //       'authorization': globalVariables.tokenUser,
                //     },
                //   );
                //   if(responsedelete.statusCode == 200) {
                //     print("Se ha borrado de favoritos");
                //   } else {
                //     print("Ha ocurrido un error");
                //   }
                // }
              setState(() {});
              },

            ),

          ],
        ),
      ),

    );
  }
  Widget buildNumericField(
      String labelText, String placeholder, TextEditingController controller) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: TextField(
        keyboardType: TextInputType.numberWithOptions(decimal: false),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 5),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
        controller: controller,
      ),
    );
  }
}
