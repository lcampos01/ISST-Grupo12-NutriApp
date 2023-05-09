import 'package:flutter/material.dart';
import 'package:nutri_app/widges/bargraph.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:nutri_app/pages/progress_page.dart';
import 'package:nutri_app/variables/global.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class HomePage2 extends StatefulWidget {
  const HomePage2({Key? key}) : super(key: key);

  @override
  _HomePage2State createState() => _HomePage2State();
}

class _HomePage2State extends State<HomePage2> {
  dynamic jsonData;
  dynamic jsonDataUser;
  
  dynamic alimentosDiarios;
  dynamic alimentosDiariosDES = [];
  dynamic alimentosDiariosALM = [];
  dynamic alimentosDiariosCOM = [];
  dynamic alimentosDiariosMER = [];
  dynamic alimentosDiariosCENA = [];

  dynamic nombre;
  dynamic sexo;
  dynamic fecha_nacimiento;
  dynamic peso;
  dynamic altura;
  dynamic actividad_diaria;
  dynamic objetivo;
  dynamic num_objetivo;

  double tbm = 0;
  double kcal = 0;
  double kcalGoal = 0;

  double kcalConsumo = 0;
  double protConsumo = 0;
  double hidrConsumo = 0;
  double grasConsumo = 0;

  List<String> diasGrafica = ['a', 'b', '', '', '', '', ''];
  List<double> sumarioKcal = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];
  List<double> sumarioProt = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];

  String formatDate(String date) {
    if(date.contains('-')) {
      List<String> partes = date.split('-');
      return '${partes[2]}-${partes[1]}-${partes[0]}';
    } else {
      return date;
    }
  }

  double getTbm(String? sex, String? birth, String? weight, String? height) {
    double tbm = 0;
    if(sex == '' || birth == '' || weight == '' || height == '') {
      return tbm = 0;
    } else {
      DateTime fecha = DateTime.parse(formatDate(birth!));
      DateTime today = DateTime.now();
      int anoToday = today.year;
      int anoFecha = fecha.year;
      int edad = anoToday - anoFecha;
      double peso = double.tryParse(weight!) ?? 0;
      double altura = double.tryParse(height!) ?? 0;
      if (sex == 'hombre') {
        tbm = 10*peso + 6.25*altura - 5*edad + 5;
        return tbm;
      } else {
        tbm = 10*peso + 6.25*altura - 5*edad - 161;
        return tbm;
      }
    }
  }

  double getKcal(String? sex, String? birth, String? weight, String? height, String? act) {
    double tbm = getTbm(sex, birth, weight, height);
    double kcal = 0;
    if(act == 'activo') {
      kcal = tbm*1.8;
    } else if(act == 'moderado') {
      kcal = tbm*1.55;
    } else if(act == 'sedentario') {
      kcal = tbm*1.2;
    } else {
      kcal = 0;
    }
    return kcal;
  }
  double getKcalGoal(String? sex, String? birth, String? weight, String? height, String? act, String? goalStr, String? goal) {
    double kcal = getKcal(sex, birth, weight, height, act);
    if(goal != '') {
      if(goalStr == 'deficitcalorico') {
        if(kcal == 0) {
          return kcalGoal = 0;
        } else {
          return kcalGoal = kcal - (double.tryParse(goal!) ?? 0);
        }
      } else if(goalStr == 'superavitcalorico') {
        if(kcal == 0) {
          return kcalGoal = 0;
        } else {
          return kcalGoal = kcal + (double.tryParse(goal!) ?? 0);
        }
      } else if(goalStr == 'alimentacionhiperproteica') {
        if(weight == '') {
          return kcalGoal = 0;
        } else {
          return kcalGoal = (double.tryParse(weight!) ?? 0) * (double.tryParse(goal!) ?? 0);
        }
      } else if(goalStr == 'caloriastbm') {
        return kcalGoal = kcal;
      } else {
        return kcalGoal = 0;
      }
    } else {
      return kcalGoal = 0;
    }
  }
  @override
  void initState() {
    super.initState();
    fetchAlimentosDiarios().then((_) {
      setState(() {
        
      });
    });
    _initializeUser().then((_) {
      setState(() {
        
      });
    });
    _initializeGrafica().then((_) {
      setState(() {
        
      });
    });
  }

  void initializeData() {
    fetchAlimentosDiarios().then((_) {
      _initializeUser().then((_) {
        _initializeGrafica().then((_) {
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: 20,
            ),
          ),
          SliverAppBar(
            toolbarHeight: 80,
            title: Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                'Seguimiento diario',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          //hacer 2 opciones esta si objetivo calorias y otra si objetivo es proteico
          objetivo == 'alimentacionhiperproteica' 
          ? SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Container(
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 159, 221, 161),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tu objetivo de proteinas es: \n${kcalGoal.toStringAsFixed(2)} g', //objetivo del usuario.
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.visible,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                'HAS CONSUMIDO: \n${protConsumo.toStringAsFixed(2)} g', //proteinas sumadas consumidas por el usuario.
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                ),
                                overflow: TextOverflow.visible,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                kcalGoal<protConsumo ? 'Te has pasado: ${(protConsumo-kcalGoal).toStringAsFixed(2)} g' 
                                  : 'Te faltan: ${(kcalGoal-protConsumo).toStringAsFixed(2)} g',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                ),
                                overflow: TextOverflow.visible,
                              ),
                            ],
                          ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: CircularPercentIndicator(
                            percent: protConsumo/kcalGoal > 1 ? 1 : protConsumo/kcalGoal, //hacer ratio entre consumido/objetivo
                            radius: MediaQuery.of(context).size.width * 0.15,
                            lineWidth: 20,
                            animation: true,
                            progressColor: Color.fromARGB(255, 10, 60, 8),
                            backgroundColor: Color.fromARGB(255, 196, 221, 196),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
          : SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Container(
                  padding: EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 159, 221, 161),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        
                         Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Tu objetivo de calorías es: \n${kcalGoal.toStringAsFixed(2)} kcal', //objetivo del usuario.
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.visible,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                'HAS CONSUMIDO: \n${kcalConsumo.toStringAsFixed(2)} kcal', //calorias sumadas consumidas por el usuario.
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                ),
                                overflow: TextOverflow.visible,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                kcalGoal<kcalConsumo ? 'Te has pasado: ${(kcalConsumo-kcalGoal).toStringAsFixed(2)} g' 
                                  : 'Te faltan: ${(kcalGoal-kcalConsumo).toStringAsFixed(2)} g',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.visible,
                              ),
                            ],
                          ),
                        
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: CircularPercentIndicator(
                            percent: kcalConsumo/kcalGoal > 1 ? 1 : kcalConsumo/kcalGoal, //hacer ratio entre consumido/objetivo
                            radius: MediaQuery.of(context).size.width * 0.2,
                            lineWidth: 15,
                            animation: true,
                            progressColor: Color.fromARGB(255, 10, 60, 8),
                            backgroundColor: Color.fromARGB(255, 196, 221, 196),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          objetivo == 'alimentacionhiperproteica' 
          ? SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text( //si el objetivo es proteico cambiar por calorias
                        'CALORÍAS: ${kcalConsumo.toStringAsFixed(2)} kcal', //calorías sumadas consumidas por el usuario.
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.visible,
                      ),
                      Text( //si el objetivo es proteico cambiar por calorias
                        '${kcalConsumo.toStringAsFixed(2)} kcal', //calorías sumadas consumidas por el usuario.
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.visible,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'HIDRATOS:', //hidratos sumadas consumidas por el usuario.
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.visible,
                      ),
                      Text( //si el objetivo es proteico cambiar por calorias
                        '${hidrConsumo.toStringAsFixed(2)} g', //calorías sumadas consumidas por el usuario.
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.visible,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'GRASAS:', //grasas sumadas consumidas por el usuario.
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.visible,
                      ),
                      Text(
                        '${grasConsumo.toStringAsFixed(2)} g', //grasas sumadas consumidas por el usuario.
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.visible,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
          : SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text( //si el objetivo es proteico cambiar por calorias
                        'PROTEINAS:', //proteinas sumadas consumidas por el usuario.
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.visible,
                      ),
                      Text( //si el objetivo es proteico cambiar por calorias
                        '${protConsumo.toStringAsFixed(2)} g', //proteinas sumadas consumidas por el usuario.
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.visible,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'HIDRATOS:', //hidratos sumadas consumidas por el usuario.
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.visible,
                      ),
                      Text(
                        '${hidrConsumo.toStringAsFixed(2)} g', //hidratos sumadas consumidas por el usuario.
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.visible,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'GRASAS:', //grasas sumadas consumidas por el usuario.
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.visible,
                      ),
                      Text(
                        '${grasConsumo.toStringAsFixed(2)} g', //grasas sumadas consumidas por el usuario.
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.visible,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'DESAYUNO:', //calorias sumadas consumidas por el usuario.
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                    overflow: TextOverflow.visible,
                  ),
                  alimentosDiariosDES.isEmpty 
                  ? Text(
                    'No hay alimentos registrados', //calorias sumadas consumidas por el usuario.
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.visible,
                  )
                  : Text(
                    alimentosDiariosDES.join(', '),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.visible,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'ALMUERZO:', //calorias sumadas consumidas por el usuario.
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                    overflow: TextOverflow.visible,
                  ),
                  alimentosDiariosALM.isEmpty 
                  ? Text(
                    'No hay alimentos registrados', //calorias sumadas consumidas por el usuario.
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.visible,
                  )
                  : Text(
                    alimentosDiariosALM.join(', '),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.visible,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'COMIDA:', //calorias sumadas consumidas por el usuario.
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                    overflow: TextOverflow.visible,
                  ),
                  alimentosDiariosCOM.isEmpty 
                  ? Text(
                    'No hay alimentos registrados', //calorias sumadas consumidas por el usuario.
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.visible,
                  )
                  : Text(
                    alimentosDiariosCOM.join(', '),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.visible,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'MERIENDA:', //calorias sumadas consumidas por el usuario.
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                    overflow: TextOverflow.visible,
                  ),
                  alimentosDiariosMER.isEmpty 
                  ? Text(
                    'No hay alimentos registrados', //calorias sumadas consumidas por el usuario.
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.visible,
                  )
                  : Text(
                    alimentosDiariosMER.join(', '),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.visible,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'CENA:', //calorias sumadas consumidas por el usuario.
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                    overflow: TextOverflow.visible,
                  ),
                  alimentosDiariosCENA.isEmpty 
                  ? Text(
                    'No hay alimentos registrados', //calorias sumadas consumidas por el usuario.
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.visible,
                  )
                  : Text(
                    alimentosDiariosCENA.join(', '),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.visible,
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
          SliverAppBar(
            toolbarHeight: 50,
            title: Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                'Seguimiento semanal',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w600,
                ),
                overflow: TextOverflow.visible,
              ),
            ),
          ),
          objetivo == 'alimentacionhiperproteica'
          ? SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'g',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ),
          )
          : SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Kcal',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 20,
            ),
          ),
          objetivo == 'alimentacionhiperproteica'
          ? SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SizedBox(
                height: 600,
                child: MyBarGraph(
                  sumario1: sumarioProt,
                  objetivo: kcalGoal + 10,
                  tipo: objetivo,
                  dias: diasGrafica,
                ),
              ),
            ),
          )
          : SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SizedBox(
                height: 600,
                child: MyBarGraph(
                  sumario1: sumarioKcal,
                  objetivo: kcalGoal + 1000,
                  tipo: objetivo,
                  dias: diasGrafica,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 50,
            ),
          ),
        ]
      ),
    );
  }
  Future<List<Map<String, dynamic>>> fetchAlimentosDiarios() async {
    List<Map<String, dynamic>> alimentosDiarios = [];
    final response = await http.get(
      Uri.parse('${globalVariables.ipVM}/consumo'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': globalVariables.tokenUser,
      },
    );
    if (response.statusCode == 200) {
      jsonData = jsonDecode(response.body);
      print(jsonData);
      if (jsonData.length != 0) {
        for (var data in jsonData) {
          DateTime fecha = DateTime.now();
          String fechaFormateada = fecha.toString().split(" ")[0];
          if (data["dia"].contains(fechaFormateada)) {
            alimentosDiarios.add(data);
          }
        }
        print(alimentosDiarios);
        return alimentosDiarios;
      } else {
        return alimentosDiarios = [];
      }
    } else {
      throw Exception('Failed to connect to the server');
    }
  }
  
  Future<Map<String, dynamic>> fetchJsonUser() async {
    final response = await http.get(
      Uri.parse('${globalVariables.ipVM}/currentuser'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': globalVariables.tokenUser,
      },
    );
    if (response.statusCode == 200) {
      jsonDataUser = jsonDecode(response.body);
      print(jsonDataUser);
      return jsonDataUser;
    } else {
      throw Exception('Failed to connect to the server');
    }
  }
  Future<String> fetchNombre(Map<String, dynamic> json) async {
    return json['nombre'];
  }
  Future<String> fetchSexo(Map<String, dynamic> json) async {
    return json['sexo'];
  }
  Future<String> fetchFecha(Map<String, dynamic> json) async {
    return json['fecha_nacimiento'];
  }
  Future<int> fetchPeso(Map<String, dynamic> json) async {
    return json['peso'];
  }
  Future<int> fetchAltura(Map<String, dynamic> json) async {
    return json['altura'];
  }
  Future<int> fetchActividad(Map<String, dynamic> json) async {
    return json['actividad_diaria'];
  }
  Future<String> fetchObjetivo(Map<String, dynamic> json) async {
    return json['objetivo'];
  }
  Future<double> fetchNumObjetivo(Map<String, dynamic> json) async {
    return json['num_objetivo'];
  }

  Future<void> _initializeUser() async {
    final jsonUser = await fetchJsonUser();
    jsonDataUser = jsonUser;
    nombre = await fetchNombre(jsonUser);
    sexo = await fetchSexo(jsonUser);
    fecha_nacimiento = await fetchFecha(jsonUser);
    peso = await fetchPeso(jsonUser);
    altura = await fetchAltura(jsonUser);
    actividad_diaria = await fetchActividad(jsonUser);
    objetivo = await fetchObjetivo(jsonUser);
    num_objetivo = await fetchNumObjetivo(jsonUser);
    actividad_diaria == 0 ? actividad_diaria = 'sedentario'
      : (actividad_diaria == 1 ? actividad_diaria == 'moderado' : actividad_diaria = 'activo');
    tbm = getTbm(sexo, fecha_nacimiento, peso.toString(), altura.toString());
    kcal = getKcal(sexo, fecha_nacimiento, peso.toString(), altura.toString(), actividad_diaria);
    kcalGoal = getKcalGoal(sexo, fecha_nacimiento, peso.toString(), altura.toString(), actividad_diaria, objetivo, num_objetivo.toString());
    alimentosDiarios = await fetchAlimentosDiarios();
    print(alimentosDiarios);
    if(alimentosDiarios != null) {
      for (var data in alimentosDiarios) {
        final alimentoSTR = data["alimento"] as String?;
        kcalConsumo = kcalConsumo + data["calorias"];
        protConsumo = protConsumo + data["proteinas"];
        hidrConsumo = hidrConsumo + data["carbohidratos"];
        grasConsumo = grasConsumo + data["grasas"];
        if (data["momento"].contains("Desayuno")) {
          alimentosDiariosDES.add(alimentoSTR);
        } else if (data["momento"].contains("Almuerzo")) {
          alimentosDiariosALM.add(alimentoSTR);
        } else if (data["momento"].contains("Comida")) {
          alimentosDiariosCOM.add(alimentoSTR);
        } else if (data["momento"].contains("Merienda")) {
          alimentosDiariosMER.add(alimentoSTR);
        } else {
          alimentosDiariosCENA.add(alimentoSTR);
        }
        print(kcalConsumo);
        print(protConsumo);
        print(hidrConsumo);
        print(grasConsumo);
      }
    }
  }
  Future<void> _initializeGrafica() async {
    alimentosDiarios = await fetchAlimentosDiarios();
    diasGrafica = getDays(DateTime.now());
    sumarioKcal = getSumarioKcal(alimentosDiarios);
    sumarioProt = getSumarioProt(alimentosDiarios);
  }

  List<String> getDays(DateTime fechaHoy) {
    List<String> dias = [];
    for (int i = 0; i < 7; i++) {
      DateTime fecha = fechaHoy.subtract(Duration(days: i));
      String fechaFormateada = fecha.toString().split(" ")[0];
      dias.add(fechaFormateada);
    }
    dias.sort((a, b) => a.compareTo(b));
    return dias;
  }
  List<double> getSumarioKcal(List<Map<String, dynamic>> alimentosDiarios) {
    List<String> ultimos7Dias = getDays(DateTime.now());
    List<double> sumario = [];
    for (String dia in ultimos7Dias) {
      double sumaCalorias = 0.0;
      for (var alimento in alimentosDiarios) {
        if (alimento['dia'] == dia) {
          sumaCalorias += alimento['calorias'];
        }
      }
      sumario.add(sumaCalorias);
    }
    return sumario;
  }
  List<double> getSumarioProt(List<Map<String, dynamic>> alimentosDiarios) {
    List<String> ultimos7Dias = getDays(DateTime.now());
    List<double> sumario = [];
    for (String dia in ultimos7Dias) {
      double sumaProteinas = 0.0;
      for (var alimento in alimentosDiarios) {
        if (alimento['dia'] == dia) {
          sumaProteinas += alimento['proteinas'];
        }
      }
      sumario.add(sumaProteinas);
    }
    return sumario;
  }
}