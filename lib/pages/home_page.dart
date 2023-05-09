import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:nutri_app/pages/progress_page.dart';
import 'package:nutri_app/variables/global.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  dynamic jsonData;
  dynamic alimentosDiarios;
  dynamic alimentosDiariosDES;
  dynamic alimentosDiariosCOM;
  dynamic alimentosDiariosCENA;

  @override
  void initState() {
    super.initState();
    fetchConsumo();
  }

  Future<void> fetchConsumo() async {
    final response = await http.get(
      Uri.parse('${globalVariables.ipVM}/consumo'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': globalVariables.tokenUser,
      },
    );
    if (response.statusCode == 200) {
      jsonData = jsonDecode(response.body);
      //print(jsonData);
      if (jsonData.length != 0) {
        for (var data in jsonData) {
          if (data["dia"].contains(DateFormat.Md().format(DateTime.now()))) {
            alimentosDiarios.add(data);
            for (var data in alimentosDiarios) {
              final alimentoSTR = data["alimento"] as String?;

              if (data["momento"].contains("desayuno")) {
                alimentosDiariosDES.add(alimentoSTR);
              } else if (data["momento"].contains("comida")) {
                alimentosDiariosCOM.add(alimentoSTR);
              } else {
                alimentosDiariosCENA.add(alimentoSTR);
              }
            }
          }
        }
      }
    } else {
      throw Exception('Failed to connect to the server');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                        child: Column(children: [
                      Wrap(
                          spacing: 8, // ajusta el espacio entre las dos columnas
                          runSpacing: 0,
                          alignment: WrapAlignment.start,
                          crossAxisAlignment: WrapCrossAlignment.start,
                          direction: Axis.horizontal,
                          runAlignment: WrapAlignment.start,
                          verticalDirection: VerticalDirection.down,
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.40,
                                    height:
                                        MediaQuery.of(context).size.height * 0.51,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 4,
                                          color: Color(0x34090F13),
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          12, 8, 12, 8),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0, 4, 0, 4),
                                            child: Text(
                                              'Seguimiento diario',
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  EdgeInsetsDirectional.fromSTEB(
                                                      0, 5, 0, 0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Calorías',
                                                      ),
                                                      Expanded(
                                                        child:
                                                            CircularPercentIndicator(
                                                          percent: 0.4,
                                                          radius: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.065,
                                                          lineWidth: 6,
                                                          animation: true,
                                                          progressColor:
                                                              Color(0xFF046701),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text('(Kcal)'),
                                                  Divider(
                                                    // Agrega un Divider debajo de la fila
                                                    thickness: 2.0,
                                                    color: Colors.green[300],
                                                    height: 10.0,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  EdgeInsetsDirectional.fromSTEB(
                                                      0, 5, 0, 0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Proteinas',
                                                      ),
                                                      Expanded(
                                                        child:
                                                            CircularPercentIndicator(
                                                          percent: 0.8,
                                                          radius: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.065,
                                                          lineWidth: 6,
                                                          animation: true,
                                                          progressColor:
                                                              Color(0xFF046701),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text('(g)'),
                                                  Divider(
                                                    // Agrega un Divider debajo de la fila
                                                    thickness: 2.0,
                                                    color: Colors.green[300],
                                                    height: 10.0,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  EdgeInsetsDirectional.fromSTEB(
                                                      0, 5, 0, 0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Carbohidratos',
                                                      ),
                                                      Expanded(
                                                        child:
                                                            CircularPercentIndicator(
                                                          percent: 0.55,
                                                          radius: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.065,
                                                          lineWidth: 6,
                                                          animation: true,
                                                          progressColor:
                                                              Color(0xFF046701),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text('(g)'),
                                                  Divider(
                                                    // Agrega un Divider debajo de la fila
                                                    thickness: 2.0,
                                                    color: Colors.green[300],
                                                    height: 10.0,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding:
                                                  EdgeInsetsDirectional.fromSTEB(
                                                      0, 5, 0, 0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Grasas',
                                                      ),
                                                      Expanded(
                                                        child:
                                                            CircularPercentIndicator(
                                                          percent: 0.2,
                                                          radius: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.065,
                                                          lineWidth: 6,
                                                          animation: true,
                                                          progressColor:
                                                              Color(0xFF046701),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text('(g)'),
                                                  Divider(
                                                    // Agrega un Divider debajo de la fila
                                                    thickness: 2.0,
                                                    color: Colors.green[300],
                                                    height: 10.0,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.40,
                                    height:
                                        MediaQuery.of(context).size.height * 0.21,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 4,
                                          color: Color(0x34090F13),
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          12, 8, 12, 8),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(0, 8, 0, 8),
                                                child: Text(
                                                  'Sigue tu \nprogreso',
                                                  style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.insert_chart,
                                                  color: Color(0xFF272626),
                                                  size: 38,
                                                ),
                                                onPressed: () => {
                                                  Navigator.of(context).push(
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProgressPage(),
                                                    ),
                                                  )
                                                },
                                              ),
                                            ],
                                          ),
                                          Expanded(
                                            child: Image(
                                              image: AssetImage(
                                                  'assets/graficahidratos.jpg'),
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(12.0),
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.40,
                                    height:
                                        MediaQuery.of(context).size.height * 0.75,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      boxShadow: [
                                        BoxShadow(
                                          blurRadius: 4,
                                          color: Color(0x34090F13),
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          12, 8, 12, 8),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Row(
                                                
                                                children: [
                                                  Text(
                                                    'Total Calorías',
                                                    style: TextStyle(
                                                      color: Colors.green,
                                                      fontSize: 18.0,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(top: 4),
                                                child: TextFormField(
                                                  autofocus: true,
                                                  obscureText: false,
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor: Colors.grey[300],
                                                    hintText: '0 KCAL',
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8.0),
                                                      borderSide: BorderSide.none,
                                                    ),
                                                    suffixIcon: Icon(Icons
                                                        .energy_savings_leaf),
                                                    prefixIconColor: Colors.green,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Text(
                                                  'Comidas diarias',
                                                  style: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 18.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                ListView(
                                                  padding: EdgeInsets.zero,
                                                  shrinkWrap: true,
                                                  scrollDirection: Axis.vertical,
                                                  children: [
                                                    Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      0, 8, 0, 0),
                                                          child: Text(
                                                            'Desayuno',
                                                            style: TextStyle(
                                                              fontSize: 16.0,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                            ),
                                                          ),
                                                        ),
                                                        alimentosDiariosDES !=
                                                                null
                                                            ? ListView.builder(
                                                                shrinkWrap: true,
                                                                itemCount:
                                                                    alimentosDiariosDES
                                                                            .length ??
                                                                        0,
                                                                itemBuilder:
                                                                    (BuildContext
                                                                            context,
                                                                        int index) {
                                                                  return ListTile(
                                                                    title: Text(
                                                                        alimentosDiariosDES[
                                                                            index]),
                                                                  );
                                                                },
                                                              )
                                                            : Container(
                                                                child: Text(
                                                                    'No hay ningún alimento de desayuno registrado'),
                                                              )
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Text(
                                                          'Comida',
                                                          style: TextStyle(
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        alimentosDiariosCOM !=
                                                                null
                                                            ? ListView.builder(
                                                                shrinkWrap: true,
                                                                itemCount:
                                                                    alimentosDiariosCOM
                                                                            .length ??
                                                                        0,
                                                                itemBuilder:
                                                                    (BuildContext
                                                                            context,
                                                                        int index) {
                                                                  return ListTile(
                                                                    title: Text(
                                                                        alimentosDiariosCOM[
                                                                            index]),
                                                                  );
                                                                },
                                                              )
                                                            : Container(
                                                                child: Text(
                                                                    'No hay ningún alimento de comida registrado'),
                                                              )
                                                      ],
                                                    ),
                                                    Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Text(
                                                          'Cena',
                                                          style: TextStyle(
                                                            fontSize: 16.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        alimentosDiariosCENA !=
                                                                null
                                                            ? ListView.builder(
                                                                shrinkWrap: true,
                                                                itemCount:
                                                                    alimentosDiariosCENA
                                                                            .length ??
                                                                        0,
                                                                itemBuilder:
                                                                    (BuildContext
                                                                            context,
                                                                        int index) {
                                                                  return ListTile(
                                                                    title: Text(
                                                                        alimentosDiariosCENA[
                                                                            index]),
                                                                  );
                                                                },
                                                              )
                                                            : Container(
                                                                child: Text(
                                                                    'No hay ningún alimento de cena registrado'),
                                                              )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ])
                    ]))
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}