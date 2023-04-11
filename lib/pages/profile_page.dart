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


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, this.nombre, this.email, this.password, this.sexo, this.fecha_nacimiento, this.peso, this.altura, this.actividad_diaria});

  final nombre;
  final email;
  final password;
  final sexo;
  final fecha_nacimiento;
  final peso;
  final altura;
  final actividad_diaria;
  //final alergenos;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {



  bool isObscurePassword = true;

  TextEditingController nombreController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController _date = TextEditingController();

  TextEditingController pesoController = TextEditingController();

  TextEditingController alturaController = TextEditingController();
  
  String? _selectedActivity = 'moderado';
  
  String? _selectedSex = 'hombre';  

  List<MultiSelectItem<String>> _allergens = [
    'Lactosa',
    'Gluten',
    'Huevos',
    'Crustáceos',
    'Pescado',
    'Frutos Secos',
    'Soja',
  ].map((allergen) => MultiSelectItem<String>(allergen, allergen)).toList();

  List<String> _selectedAllergens = globalVariables.alergenos;
  
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
              // Center(
              //   child: Stack(
              //     children: [
              //       Container(
              //         width: 130,
              //         height: 130,
              //         decoration: BoxDecoration(
              //           border: Border.all(width: 4, color: Colors.white),
              //           boxShadow: [
              //             BoxShadow(
              //                 spreadRadius: 2,
              //                 blurRadius: 10,
              //                 color: Colors.black.withOpacity(0.1)),
              //           ],
              //           shape: BoxShape.circle,
              //           image: DecorationImage(
              //               fit: BoxFit.cover,
              //               image: NetworkImage(
              //                   'https://images.genius.com/a9306e944a04741a70c74429fb6b2b5e.1000x1000x1.jpg'))),
              //       ),
              //       Positioned(
              //         bottom: 0,
              //         right: 0,
              //         child: Container(
              //           height: 40,
              //           width: 40,
              //           decoration: BoxDecoration(
              //               shape: BoxShape.circle,
              //               border:
              //                   Border.all(width: 4, color: Colors.green),
              //               color: Colors.white),
              //           child: Icon(
              //             Icons.edit,
              //             color: Colors.green,
              //           )))
              //     ],
              //   ),
              // ),
              Center(
                child: DefaultTextStyle(
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ), 
                  child: Text('Editar datos'),
                ),
              ),
              SizedBox(height: 30),
              buildTextField("Nombre Completo", widget.nombre!, nombreController, false),
              buildTextField("Correo Electrónico", widget.email!, emailController, false),
              buildTextField("Contraseña", '********', passwordController, true),
              Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Sexo',
                        border: OutlineInputBorder(),
                      ),
                      value: widget.sexo,
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
                    hintText: globalVariables.fechaNacimiento,
                    contentPadding: EdgeInsets.only(bottom: 5),
                    labelText: "Fecha de Nacimiento",
                    floatingLabelBehavior: FloatingLabelBehavior.always,
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
                  ),
                ),
              ),

              //Cuadros Peso y Altura
              buildNumericField("Peso aproximado en Kg", widget.peso!.toString(), pesoController),
              buildNumericField("Altura en cm", widget.altura!.toString(), alturaController),

              //Actividad Física

              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Actividad física',
                    border: OutlineInputBorder(),
                  ),
                  value: widget.actividad_diaria! == 0 ? 'sedentario' 
                                  : (widget.actividad_diaria! == 1 ? 'moderado'
                                  : 'activo'),
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

              //Botones

              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        CupertinoPageRoute(
                          builder: (BuildContext context) => SignPage(),
                          fullscreenDialog: true,
                          maintainState: true,
                        ),
                        (route) => false,
                      );
                      //aqui tambien hacer que el token de la variable global se borre a null o ""..
                      globalVariables.tokenUser = '';
                      print("Se ha cerrado sesión ${globalVariables.tokenUser}");
                    },
                    child: Text("Cerrar Sesión",
                        style: TextStyle(
                            fontSize: 12,
                            letterSpacing: 2,
                            color: Colors.black)),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: Text("Guardar Cambios",
                        style: TextStyle(
                          fontSize: 12,
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

              SizedBox(height: 50),
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