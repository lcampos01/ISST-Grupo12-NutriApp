import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutri_app/variables/global.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:nutri_app/signPages/sign.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//import 'package:provider/provider.dart';

class DataSignPage extends StatefulWidget {
  DataSignPage({Key? key}) : super(key: key);

  @override
  State<DataSignPage> createState() => _DataSignPageState();
}

class _DataSignPageState extends State<DataSignPage> {
  bool isObscurePassword = true;

  TextEditingController date = TextEditingController();

  TextEditingController _date = TextEditingController();

  TextEditingController peso = TextEditingController();

  TextEditingController altura = TextEditingController();
  
  String? _selectedActivity = "moderado";
  
  String? _selectedSex = "hombre";  

  List<MultiSelectItem<String>> _allergens = [
    'Lactosa',
    'Gluten',
    'Huevos',
    'Crustáceos',
    'Pescado',
    'Frutos Secos',
    'Soja',
  ].map((allergen) => MultiSelectItem<String>(allergen, allergen)).toList();

  List<String> _selectedAllergens = [];

  int actividad(String act) {
    if (act == 'sedentario') {
      return 0;
    } else if (act == 'moderado') {
      return 1;
    } else if (act == 'activo') {
      return 2;
    } else {
      return 3;
    }
  }

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
                child: DefaultTextStyle(
                  style: GoogleFonts.acme(
                    fontSize: 25,
                    color: Colors.black,
                  ),
                  child: Text('Rellene sus datos personales'),
                ),
              ),
              SizedBox(height: 30),
              buildTextField("Nombre Completo", "Nombre", date, false),
              Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Sexo',
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedSex,
                      onChanged: (String? newValue) {
                        setState(() {
                          _selectedSex = newValue;
                        });
                      },
                      items: [
                        DropdownMenuItem<String>(
                          value: 'hombre',
                          child: Text('Hombre'), 
                        ),
                        DropdownMenuItem<String>(
                          value: 'mujer',
                          child: Text('Mujer'),
                        ),
                        
                      ],
                    ),
                  ),
              //Fecha nacimiento
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: TextField(
                  controller: _date,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () async {
                        DateTime? pickeddate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1900),
                            lastDate: DateTime(2100));

                        if (pickeddate != null) {
                          setState(() {
                            _date.text =
                                DateFormat("dd-MM-yyyy").format(pickeddate);
                          });
                        }
                      },
                      icon: Icon(Icons.calendar_today_rounded),
                      color: Colors.grey,
                    ),
                    labelText: "Fecha de Nacimiento",
                  ),
                ),
              ),
              //Cuadros Peso y Altura
              buildNumericField("Peso aproximado en Kg", "81", peso),
              buildNumericField("Altura en cm", "192", altura),
              //Actividad Física
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Actividad física',
                    border: OutlineInputBorder(),
                  ),
                  value: _selectedActivity,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedActivity = newValue;
                    });
                  },
                  items: [
                    DropdownMenuItem<String>(
                      value: 'activo',
                      child: Text('Activo'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'moderado',
                      child: Text('Moderado'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'sedentario',
                      child: Text('Sedentario'),
                    ),
                  ],
                ),
              ),
              //Alergenos
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: "Intolerancias Alimenticias",
                  ),
                  child: InkWell(
                    onTap: () {
                      _showMultiSelect(
                          context); // Llama a la función de selección múltiple
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Seleccionar alergenos"),
                        Icon(Icons.add_circle_outline_outlined,
                            color: Colors.grey),
                      ],
                    ),
                  ),
                ),
              ),
              MultiSelectChipDisplay(
                items: _selectedAllergens
                    .map((e) => MultiSelectItem(e, e))
                    .toList(),
                //decoration: BoxDecoration(border: Border.all(width: 4, color: Colors.green)),
                onTap: (value) {
                  setState(() {
                    _selectedAllergens.remove(value);
                  });
                },
                chipColor: Colors.grey.shade200,
                textStyle: TextStyle(color: Colors.green),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  //  side: BorderSide(color: Colors.green, width: 4)
                ),
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                onPressed: () async {
                  //validacion: estan vacios nombre, fecha_nacimiento, peso y altura
                  var nombre = date.text;
                  var sexo = _selectedSex.toString();
                  var fecha_nacimiento = _date.text;
                  // var pesoint = int.parse(peso.text);
                  // var alturaint = int.parse(altura.text);
                  var pesostr = peso.text;
                  var alturastr = altura.text;
                  var actividad_diariaint = actividad(_selectedActivity.toString());
                  var actividad_diariastr = actividad((_selectedActivity.toString())).toString();
                  var alergenos = _selectedAllergens;
                  print(date.text);
                  print(_selectedSex.toString());
                  print(_date.text);
                  print(peso.text);
                  print(altura.text);
                  print(actividad((_selectedActivity.toString())).toString());
                  print(_selectedAllergens);
                  
                  final response = await http.post(
                    Uri.parse('http://34.175.225.29:8080/signup'),
                    body: jsonEncode(<String, String>{
                      'nombre': nombre,
                      'altura': alturastr,
                      'peso': pesostr,
                      'sexo': sexo,
                      'fecha_nacimiento': fecha_nacimiento,
                      'actividad_diaria': actividad_diariastr,
                    }),
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                  );
                  if (response.statusCode == 200) {
                    print("datos guardados correctamente en el servidor");
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Registro completado'),
                        content: Text(
                            'Inicie sesión en "Sign in"'),
                        actions: [
                          TextButton(
                              onPressed: () {
                                //aqui es cuando se manda al signpage
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (BuildContext context) => SignPage(),
                                    fullscreenDialog: true,
                                    maintainState: true,
                                  ),
                                  (route) => false,
                                );
                              },
                              child: Text('OK'))
                        ],
                      ));
                  } else {
                    print("no se han guardado los datos");
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Oh, oh... Ha habido un error con el servidor'),
                        content: Text(
                            'No se han guardado los datos correctamente.'),
                        actions: [
                          TextButton(
                              onPressed: () =>
                                  Navigator.pop(context),
                              child: Text('OK'))
                        ],
                      ));
                  }
                },
                child: Text("Aceptar y registrarse",
                    style: TextStyle(
                      fontSize: 16,
                      letterSpacing: 2,
                      color: Colors.white,
                    )),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String labelText, String placeholder, TextEditingController date, bool isPasswordTextField) {
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

  void _showMultiSelect(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (ctx) {
        return MultiSelectDialog(
          items: _allergens,
          initialValue: _selectedAllergens,
          onConfirm: (values) {
            setState(() {
              _selectedAllergens =
                  values; // Actualiza la lista de alergenos seleccionados
            });
          },
        );
      },
    );
  }

  Widget buildNumericField(String labelText, String placeholder, TextEditingController controller) {
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
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey
              )
          ),
          controller: controller,
      ),
    );
  }
}
              