import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:nutri_app/main.dart';
import 'package:nutri_app/variables/global.dart';
import 'package:intl/intl.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:nutri_app/signPages/sign.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
// import 'package:path_provider/path_provider.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage(
      {Key? key,
      this.nombre,
      this.email,
      this.password,
      this.sexo,
      this.fecha_nacimiento,
      this.peso,
      this.altura,
      this.actividad_diaria,
      this.objetivo,
      this.kcalGoal,
      this.alergenos,
      this.fotoPerfil,
      });

  final nombre;
  final email;
  final password;
  final sexo;
  final fecha_nacimiento;
  final peso;
  final altura;
  final actividad_diaria;
  final objetivo;
  final kcalGoal;
  final alergenos;
  final fotoPerfil;

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isObscurePassword = true;

  TextEditingController nombreController = TextEditingController();

  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  TextEditingController fechaController = TextEditingController();

  TextEditingController pesoController = TextEditingController();

  TextEditingController alturaController = TextEditingController();

  TextEditingController goal = TextEditingController();

  String? _selectedActivity = 'moderado';

  String? _selectedGoal = 'deficitcalorico';

  String? _selectedSex = 'hombre';

  MemoryImage? _imageFile;


  List<MultiSelectItem<String>> _allergens = [
    'Lactosa',
    'Gluten',
    'Huevos',
    'Crustaceos',
    'Pescado',
    'Frutos Secos',
    'Soja',
  ].map((allergen) => MultiSelectItem<String>(allergen, allergen)).toList();

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

  List<String> _selectedAllergens = [];

  double tbm = 0;
  double kcal = 0;
  double kcalGoal = 0;

  String actBBDD = '';

  String formatDate(String date) {
    if(date.contains('-')) {
      List<String> partes = date.split('-');
      return '${partes[2]}-${partes[1]}-${partes[0]}';
    } else {
      return date;
    }
  }

  double getTbm(String? sex, String? birth, String? weight, String? height, double defecto) {
    double tbm = 0;
    if(sex == null || birth == '' || weight == '' || height == '') {
      return tbm = defecto;
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

  double getKcal(String? sex, String? birth, String? weight, String? height, String? act, double defecto) {
    double tbm = getTbm(sex, birth, weight, height, defecto);
    double kcal = defecto;
    if(sex == null || birth == '' || weight == '' || height == '') {
      return tbm = defecto;
    } else {
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
  }

  double getKcalGoal(String? sex, String? birth, String? weight, String? height, String? act, String? goalStr, String? goal, double defecto) {
    double kcal = getKcal(sex, birth, weight, height, act, defecto);
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
      return kcalGoal = defecto;
    }
  }
  
  Future<MemoryImage?> _initializeImage() async {
    if (widget.fotoPerfil != null) {
      final fotoPerfilBytes = base64.decode(widget.fotoPerfil);
      return MemoryImage(fotoPerfilBytes);
    } else {
      return null;
    }
  }


  @override
  void initState() {
    super.initState();
    _selectedAllergens = widget.alergenos;
    widget.actividad_diaria == 0 ? actBBDD = 'sedentario'
      : (widget.actividad_diaria == 1 ? actBBDD == 'moderado' : actBBDD = 'activo');
    _selectedActivity = actBBDD;
    _selectedGoal = widget.objetivo;
    _selectedSex = widget.sexo;
    _initializeImage().then((file) {
      setState(() {
        _imageFile = file;
      });
    });
    print(actBBDD);
    print(widget.objetivo);
    print(widget.kcalGoal);
    // print(_imageFile);
    tbm = getTbm(widget.sexo, widget.fecha_nacimiento, widget.peso.toString(), widget.altura.toString(), 0);
    kcal = getKcal(widget.sexo, widget.fecha_nacimiento, widget.peso.toString(), widget.altura.toString(), actBBDD, 0);
    kcalGoal = getKcalGoal(widget.sexo, widget.fecha_nacimiento, widget.peso.toString(), widget.altura.toString(), actBBDD, widget.objetivo, widget.kcalGoal.toString(), 0);
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
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        border: Border.all(width: 4, color: Colors.white),
                        boxShadow: [
                          BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.1)),
                        ],
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: _imageFile == null
                            ? const AssetImage('assets/usuario_foto.png') 
                            : Image(image:_imageFile!).image,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          _selectImage(context);
                        },
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(width: 4, color: Colors.green),
                            color: Colors.white),
                          child: Icon(
                            Icons.edit,
                            color: Colors.green,
                          )
                        )
                      )
                    )
                  ],
                ),
              ),
              SizedBox(height: 30),
              Text(
                widget.email,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20),
              buildTextField(
                  "Nombre Completo", widget.nombre!, nombreController, false),
              // buildTextField(
              //     "Correo Electrónico", widget.email!, emailController, false),
              // buildTextField(
              //     "Contraseña", '********', passwordController, true),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Sexo',
                    border: OutlineInputBorder(),
                  ),
                  value: widget.sexo!,
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
                  controller: fechaController,
                  decoration: InputDecoration(
                    hintText: widget.fecha_nacimiento,
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
                            fechaController.text =
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
              buildNumericField("Peso aproximado en Kg",
                  widget.peso!.toString(), pesoController),
              buildNumericField(
                  "Altura en cm", widget.altura!.toString(), alturaController),

              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Text(
                  'Tu Tasa de Metabolismo Basal (TMB) (Fórmula Mifflin-St. Jeor) es ${getTbm(_selectedSex, fechaController.text, pesoController.text, alturaController.text, tbm).toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.visible,
                ),
              ),
              //Actividad Física
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Actividad física',
                    border: OutlineInputBorder(),
                  ),
                  value: widget.actividad_diaria! == 0
                      ? 'sedentario'
                      : (widget.actividad_diaria! == 1 ? 'moderado' : 'activo'),
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
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Text(
                  'Dependiendo del tipo de actividad física que realices, la cantidad mínima de energía variará: ${getKcal(_selectedSex, fechaController.text, pesoController.text, alturaController.text, _selectedActivity, kcal).toStringAsFixed(2)} Kcal',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.visible,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Objetivo',
                    border: OutlineInputBorder(),
                  ),
                  value: widget.objetivo!,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedGoal = newValue;
                    });
                  },
                  items: [
                    DropdownMenuItem<String>(
                      value: 'deficitcalorico',
                      child: Text('Déficit Calórico'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'caloriastbm',
                      child: Text('Calorias TBM'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'superavitcalorico',
                      child: Text('Superávit Calórico'),
                    ),
                    DropdownMenuItem<String>(
                      value: 'alimentacionhiperproteica',
                      child: Text('Alimentación Hiperproteica'),
                    ),
                  ],
                ),
              ),
              (_selectedGoal == 'deficitcalorico' || _selectedGoal == 'superavitcalorico')
                ? buildNumericField("Ajusta las Kcal", widget.kcalGoal!.toString(), goal)
                : _selectedGoal == 'alimentacionhiperproteica'
                  ? buildNumericField("Ajusta los g/peso", widget.kcalGoal!.toString(), goal)
                  : Container(),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  _selectedGoal == 'alimentacionhiperproteica' 
                  ? 'El objetivo establecido es: ${getKcalGoal(_selectedSex, fechaController.text, pesoController.text, alturaController.text, _selectedActivity, _selectedGoal, goal.text, kcalGoal).toStringAsFixed(2)} g proteinas'
                    : 'El objetivo establecido es: ${getKcalGoal(_selectedSex, fechaController.text, pesoController.text, alturaController.text, _selectedActivity, _selectedGoal, goal.text, kcalGoal).toStringAsFixed(2)} kcal',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.visible,
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
                        Text("Seleccionar alérgenos"),
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
                      print(
                          "Se ha cerrado sesión ${globalVariables.tokenUser}");
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
                    onPressed: () async {
                      // var emailMod = emailController.toString(); segun el metodo put modify-user no se puede modificar
                      // var passwordMod = passwordController.toString(); segun el método put modify-user no se puede modificar
                      var usernameMod = nombreController.text.isNotEmpty ? nombreController.text : widget.nombre;
                      var sexoMod = _selectedSex.toString();
                      var fechaNacimientoMod = fechaController.text.isNotEmpty ? fechaController.text : widget.fecha_nacimiento;
                      var pesoMod = int.tryParse(pesoController.text) ?? widget.peso;
                      var alturaMod = int.tryParse(alturaController.text) ?? widget.altura;
                      var actividadFisicaMod =
                          actividad(_selectedActivity.toString());
                      var objetivoMod = _selectedGoal.toString();
                      var objetivonumMod = double.tryParse(goal.text) ?? widget.kcalGoal;
                      var base64Image;
                      _imageFile != null
                        ? base64Image = base64Encode(_imageFile!.bytes)
                        : base64Image = null;
                      print(_imageFile);
                      List<Map<String, String>> alergenosMod = _selectedAllergens.map((alergeno) {
                        return {'nombre': alergeno};
                      }).toList();
                      
                      print(usernameMod);
                      print(sexoMod);
                      print(fechaNacimientoMod);
                      print(pesoMod);
                      print(alturaMod);
                      print(actividadFisicaMod);
                      print(alergenosMod);
                      print(objetivoMod);
                      print(objetivonumMod);
                      final response = await http.put(
                        Uri.parse('${globalVariables.ipVM}/modify-user'),
                        body: jsonEncode({
                          // 'email': emailMod,  
                          // 'password': passwordMod, no estan en el metodo put de modify-user
                          'nombre': usernameMod,
                          'altura': alturaMod,
                          'peso': pesoMod,
                          'sexo': sexoMod,
                          'fecha_nacimiento': fechaNacimientoMod,
                          'actividad_diaria': actividadFisicaMod,
                          'objetivo': objetivoMod,
                          'num_objetivo': objetivonumMod,
                          'imagenPerfil': base64Image,
                        }),
                        headers: <String, String>{
                          'Content-Type': 'application/json; charset=UTF-8',
                          'authorization': globalVariables.tokenUser,
                        },
                      );
                      final responseAlergenos = await http.post(
                        Uri.parse('${globalVariables.ipVM}/alergenos'),
                        body: jsonEncode(alergenosMod),
                        headers: <String, String>{
                          'Content-Type': 'application/json; charset=UTF-8',
                          'authorization': globalVariables.tokenUser,
                        },
                      );
                      print(response.statusCode);
                      print(responseAlergenos.statusCode);
                      if (response.statusCode == 200 && responseAlergenos.statusCode == 200) {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title:
                                      Text('Cambios guardados correctamente'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  SafeArea(child: NavigationScreen(page: screens[0])),
                                            ),
                                          );
                                        },
                                        child: Text('OK'))
                                  ],
                                ));
                      }
                    },
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

  Widget buildTextField(String labelText, String placeholder,
      TextEditingController date, bool isPasswordTextField) {
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
  Future<void> _selectImage(BuildContext context) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await showModalBottomSheet<XFile?>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Galería'),
                onTap: () async {
                  Navigator.pop(context, await _picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 50
                  ));
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Cámara'),
                onTap: () async {
                  Navigator.pop(context, await _picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 50
                  ));
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Eliminar foto de perfil'),
                onTap: () {
                  setState(() {
                    _imageFile = null;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      }
    );

    if (image != null) {
      // Actualiza la imagen de perfil con la imagen seleccionada
      setState(() {
        _imageFile = null;
      });

      final file = File(image.path);
      final bytes = await file.readAsBytes();
      final memoryImage = MemoryImage(bytes);

      setState(() {
        _imageFile = memoryImage;
      });
    }
  }
}
