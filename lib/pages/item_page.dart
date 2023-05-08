import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:nutri_app/variables/global.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({Key? key, this.name, this.imageUrl, this.macros, this.imageNutriScore, this.details, this.imageIngredientes, this.barcode, this.isFavorite, this.alergenos, this.misAlergenos}) : super(key: key);
  
  final name;
  final imageUrl; 
  final macros; 
  final imageNutriScore;
  final details;
  final imageIngredientes;
  final barcode;
  
  final isFavorite;
  final alergenos;
  final misAlergenos;

  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {

  bool _isFavorite = false;
  
  String momentoDia= 'Comida';
  int cantidad= 0;
  double cantidadCalculadora= 100;

  String? _selectedMomento = 'Comida';
  TextEditingController cantidadController = TextEditingController();
  TextEditingController cantidadCalculadoraController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
    
    if(widget.alergenos.contains(',')) {
      alergenos = (widget.alergenos).split(", ");
    } else if(widget.alergenos.length == 0) {
      alergenos = [];
    } else {
      alergenos.add(widget.alergenos);
    }
    for(String alergeno in alergenos) {
      switch(alergeno) {
        case 'en:crustaceans':
          if(widget.misAlergenos.contains('Crustaceos')) {
            alertaAler = true;
            alerSi.add('Crustaceos');
          }
          break;
        case 'en:peanuts':
          if(widget.misAlergenos.contains('Cacahuetes')) {
            alertaAler = true;
            alerSi.add('Cacahuetes');
          }
          break;
        case 'en:nuts':
          if(widget.misAlergenos.contains('Nueces')) {
            alertaAler = true;
            alerSi.add('Nueces');
          }
          break;
        case 'en:mustard':
          if(widget.misAlergenos.contains('Mostaza')) {
            alertaAler = true;
            alerSi.add('Mostaza');
          }
          break;
        case 'en:lupin':
          if(widget.misAlergenos.contains('Altramuces')) {
            alertaAler = true;
            alerSi.add('Altramuces');
          }
          break;
        case 'en:gluten':
          if(widget.misAlergenos.contains('Gluten')) {
            alertaAler = true;
            alerSi.add('Gluten');
          }
          break;
        case 'en:soybeans':
          if(widget.misAlergenos.contains('Soja')) {
            alertaAler = true;
            alerSi.add('Soja');
          }
          break;
        case 'en:celery':
          if(widget.misAlergenos.contains('Apio')) {
            alertaAler = true;
            alerSi.add('Apio');
          }
          break;
        case 'en:sulphur-dioxide-and-sulphites':
          if(widget.misAlergenos.contains('Dioxido de azufre y sulfitos')) {
            alertaAler = true;
            alerSi.add('Dioxido de azufre y sulfitos');
          }
          break;
        case 'en:fish':
          if(widget.misAlergenos.contains('Pescado')) {
            alertaAler = true;
            alerSi.add('Pescado');
          }
          break;
        case 'en:mollusc':
          if(widget.misAlergenos.contains('Moluscos')) {
            alertaAler = true;
            alerSi.add('Moluscos');
          }
          break;
        case 'en:milk':
          if(widget.misAlergenos.contains('Leche')) {
            alertaAler = true;
            alerSi.add('Leche');
          }
          break;
        case 'en:eggs':
          if(widget.misAlergenos.contains('Huevos')) {
            alertaAler = true;
            alerSi.add('Huevos');
          }
          break;
        case 'en:sesame-seeds':
          if(widget.misAlergenos.contains('Sesamo')) {
            alertaAler = true;
            alerSi.add('Sesamo');
          }
          break;
        default: 
          break;
      }
    }
    if(alertaAler) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
      _showAlertDialog();
    });
    }
  }

  List<String> alergenos = [];
  List<String> alerSi = [];

  bool alertaAler = false;

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
                  image: widget.imageUrl,
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
              onPressed: () async {
                _isFavorite = !_isFavorite;
                final barcode = widget.barcode;
                final nombre = widget.name;
                final imageUrlNetwork = widget.imageUrl.toString();
                final imageUrl = RegExp(r'"([^"]*)"').firstMatch(imageUrlNetwork)!.group(1);
                final imageNutriScore = widget.imageNutriScore;
                final cantidades = widget.details;
                final imageIngredientesNetwork = widget.imageIngredientes.toString();
                final imageIngredientes = RegExp(r'"([^"]*)"').firstMatch(imageIngredientesNetwork)!.group(1);
                final calorias = widget.macros[0];
                final proteinas = widget.macros[1];
                final carbohidratos = widget.macros[2];
                final grasas = widget.macros[3];
                print(barcode);
                print(nombre);
                print(imageUrlNetwork);
                print(imageUrl);
                print(imageNutriScore);
                print(cantidades);
                print(imageIngredientesNetwork);
                print(calorias);
                print(proteinas);
                print(carbohidratos);
                print(grasas);
                if (_isFavorite) {
                  //la he añadido a favoritos -> post alimentos para meterla en favs
                  final responseadd = await http.post(
                    Uri.parse('${globalVariables.ipVM}/favoritos'),
                    body: jsonEncode({
                      "barcode": barcode,
                      "nombre": nombre,
                      "imageUrl": imageUrl,
                      "imageNutriScore": imageNutriScore,
                      "cantidades": cantidades,
                      "imageIngredientes": imageIngredientes,
                      "calorias": calorias,
                      "proteinas": proteinas,
                      "carbohidratos": carbohidratos,
                      "grasas": grasas
                    }),
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
            ),
          IconButton(

              icon: Icon(Icons.add_box_outlined) ,
              iconSize: 25,
              color: Colors.black,
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

                String hintText = 'Seleccionar Momento del Día';
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Seleccionar Momento del Día'),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          buildNumericField("Cantidad aproximada en gramos", cantidad.toString(), cantidadController),
                          SizedBox(height: 10),


                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Momento del Día',
                              border: OutlineInputBorder(),
                            ),
                            value: momentoDia == '0'
                                ? 'Desayuno'
                                : (momentoDia == 1 ? 'Almuerzo' :
                                (momentoDia == 2 ? 'Comida' :
                                (momentoDia == 3 ? 'Merienda' : 'Cena'))),
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
//                            _isRegistered=true;

                            double cantidadMod = double.tryParse(cantidadController.text) ?? 0;
                            String momentoDiaMod = _selectedMomento.toString();
                            String esteDia = DateTime.now().toString().split(" ")[0];
                            double grasaMod = (cantidadMod * widget.macros[3] /100);
                            double carbohidratosMod = (cantidadMod * widget.macros[2] /100);
                            double proteinasMod = (cantidadMod * widget.macros[1] /100);
                            double caloriasMod = (cantidadMod * widget.macros[0] /100);
                            String nombreMod = widget.name;


                            print(cantidadMod);
                            print(_selectedMomento);
                            print(momentoDiaMod);


                            final responseconsumo = await http.post(
                              Uri.parse('${globalVariables.ipVM}/consumo'),
                              body: jsonEncode({
                                'dia': esteDia,
                                'grasas': grasaMod,
                                'carbohidratos': carbohidratosMod,
                                'proteinas': proteinasMod,
                                'calorias': caloriasMod,
                                'momento': momentoDiaMod,
                                'alimento': nombreMod,
                                'cantidad': cantidadMod,
                            }),
                              headers: <String, String>{
                                  'Content-Type': 'application/json; charset=UTF-8',
                                  'authorization': globalVariables.tokenUser,
                                },
                              );
                              bool correcto = true;
                              if (responseconsumo.statusCode == 200){
                                print("Se ha registrado correctamente");


                              }else{
                                print("No se ha registrado correctamente");
                                correcto = false;
                              }
                          

                            // Aquí puede guardar la cantidad y la selección del usuario en su base de datos
                            Navigator.of(context).pop();
                            if (correcto){
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Se ha registrado correctamente'),
                                    );
                                  }

                                );
                                }else{
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Hubo un error al registrar el producto'),
                                      );
                                    }

                                );
                                }



                          },
                        ),
                      ],
                    );
                  },
                );


              setState(() {});
              },

            ),
          ],
        ),
      ),
      body: CustomScrollView(
        slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Producto',
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.visible,
                ),
                SizedBox(height: 5),
                Text(
                  widget.name,
                  style: TextStyle(
                    fontSize: 22,
                  ),
                ),
                SizedBox(height: 25),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Column(
                //       children: [
                //         Text('Calorías'),
                //         SizedBox(height: 10),
                //         //Text('$calorias [Kcal]'), para cuando se cree el array de macros
                //         widget.macros[0] == null ? Text(
                //           'NS/NC',
                //           style: TextStyle(
                //             fontSize: 13,
                //             fontWeight: FontWeight.bold,
                //           ),
                //         ) 
                //         : Text(
                //           '${double.parse(double.parse((widget.macros[0]).toString()).toStringAsFixed(3))} [Kcal]', 
                //           style: TextStyle(
                //             fontSize: 13,
                //             fontWeight: FontWeight.bold,
                //           ),
                //         ),
                //       ],
                //     ),
                //     Column(
                //       children: [
                //         Text('Proteínas'),
                //         SizedBox(height: 10),
                //         //Text('$proteinas [g]'), para cuando se cree el array de macros
                //         widget.macros[1] == null ? Text(
                //           'NS/NC',
                //           style: TextStyle(
                //             fontSize: 13,
                //             fontWeight: FontWeight.bold,
                //           ),
                //         ) 
                //         : Text(
                //           '${double.parse(double.parse((widget.macros[1]).toString()).toStringAsFixed(3))} [g]',
                //           style: TextStyle(
                //             fontSize: 13,
                //             fontWeight: FontWeight.bold,
                //           ),
                //         ),
                //       ],
                //     ),
                //     Column(
                //       children: [
                //         Text('Carbohidratos'),
                //         SizedBox(height: 10),
                //         //Text('$carbohidratos [g]'), para cuando se cree el array de macros
                //         widget.macros[2] == null ? Text(
                //           'NS/NC',
                //           style: TextStyle(
                //             fontSize: 13,
                //             fontWeight: FontWeight.bold,
                //           ),
                //         ) 
                //         : Text(
                //           '${double.parse(double.parse((widget.macros[2]).toString()).toStringAsFixed(3))} [g]',
                //           style: TextStyle(
                //             fontSize: 13,
                //             fontWeight: FontWeight.bold,
                //           ),
                //         ),
                //       ],
                //     ),
                //     Column(
                //       children: [
                //         Text('Grasas'),
                //         SizedBox(height: 10),
                //         //Text('$grasas [g]'), para cuando se cree el array de macros
                //         widget.macros[3] == null ? Text(
                //           'NS/NC',
                //           style: TextStyle(
                //             fontSize: 13,
                //             fontWeight: FontWeight.bold,
                //           ),
                //         ) 
                //         : Text(
                //           '${double.parse(double.parse((widget.macros[3]).toString()).toStringAsFixed(3))} [g]',
                //           style: TextStyle(
                //             fontSize: 13,
                //             fontWeight: FontWeight.bold,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ],
                // ),
              
              
              
              
                // SizedBox(height: 25),
                Text(
                  'Calculadora de macros',
                  style: TextStyle(
                    fontSize: 20,
                    color: const Color.fromARGB(255, 0, 104, 3),
                  ),
                  overflow: TextOverflow.visible,
                ),
                SizedBox(height: 5),
              
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: buildNumericField("Cantidad aproximada en gramos", cantidadCalculadora.toString(), cantidadCalculadoraController),
                      ),
                      SizedBox(width: 10),
                      TextButton(
                        child: Text('Calcular'),
                        onPressed: () async {
                          setState(() {
                            cantidadCalculadora = double.tryParse(cantidadCalculadoraController.text) ?? 0;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              
                Row(
              
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Text('Calorías'),
                        SizedBox(height: 10),
              
                        //Text('$calorias [Kcal]'), para cuando se cree el array de macros
                        widget.macros[0] == null ? Text(
                          'NS/NC',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ) 
                        : Text(
                            '${(widget.macros[0] * (double.tryParse(cantidadCalculadoraController.text) ?? 0) / 100).toStringAsFixed(2)} [Kcal]',
                            style: TextStyle(
                            fontSize: 13,
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
                        widget.macros[1] == null ? Text(
                          'NS/NC',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ) 
                        : Text(
                          '${(widget.macros[1] * (double.tryParse(cantidadCalculadoraController.text) ?? 0) / 100).toStringAsFixed(2)} [g]',
                          style: TextStyle(
                            fontSize: 13,
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
                        widget.macros[2] == null ? Text(
                          'NS/NC',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ) 
                        : Text(
                          '${(widget.macros[2] * (double.tryParse(cantidadCalculadoraController.text) ?? 0) / 100).toStringAsFixed(2)} [g]',
                          style: TextStyle(
                            fontSize: 13,
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
                        widget.macros[3] == null ? Text(
                          'NS/NC',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ) 
                        : Text(
                          '${(widget.macros[3] * (double.tryParse(cantidadCalculadoraController.text) ?? 0) / 100).toStringAsFixed(2)} [g]',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              
              
                SizedBox(height: 25),
                GestureDetector(
                  onTap: () {
                    //logica del boton Ver detalles
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Center(
                          child: Text(
                            'Detalles',
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ), 
                        content: Container(
                          height: 600,
                          child: Center(
                            child: Column(
                              children: [
                                widget.details == '' ? Text(
                                    'Cantidad de producto: NS/NC',
                                    style: TextStyle(
                                      fontSize: 24,
                                    ),
                                  ) 
                                  : Text(
                                      'Cantidad de producto: ${widget.details}',
                                      style: TextStyle(
                                        fontSize: 24,
                                      ),
                                    ),   //cambiar
                                SizedBox(height: 55),
                                Text(
                                  'Ingredientes:',
                                  style: TextStyle(
                                    fontSize: 24,
                                  ),
                                ),
                                ClipRRect(
                                  child: Container(
                                    width: 300,
                                    height: 300,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: widget.imageIngredientes,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'OK'),
                            child: const Text('OK'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.symmetric(horizontal: 110),
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
                SizedBox(height: 25),
                Center(
                  child: Text(
                    widget.imageNutriScore.toString() == 'a' ? 'Calidad nutricional muy buena'
                                    : (widget.imageNutriScore.toString() == 'b' ? 'Calidad nutricional buena'
                                    : (widget.imageNutriScore.toString() == 'c' ? 'Calidad nutricional media'
                                    : (widget.imageNutriScore.toString() == 'd' ? 'Calidad nutricional baja'
                                    : (widget.imageNutriScore.toString() == 'e' ? 'Calidad nutricional mala'
                                    : 'Calidad nutricional (?)')))),
                    style: TextStyle(
                      color: Color.fromARGB(255, 23, 142, 56),
                      fontWeight: FontWeight.bold,
                      fontSize: 21,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Center(
                  child: ClipRRect(
                    child: Container(
                      width: 170,
                      height: 90,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: widget.imageNutriScore.toString() == 'a' ? AssetImage('assets/nutriscore-a.png') 
                                            : (widget.imageNutriScore.toString() == 'b' ? AssetImage('assets/nutriscore-b.png')
                                            : (widget.imageNutriScore.toString() == 'c' ? AssetImage('assets/nutriscore-c.png')
                                            : (widget.imageNutriScore.toString() == 'd' ? AssetImage('assets/nutriscore-d.png')
                                            : (widget.imageNutriScore.toString() == 'e' ? AssetImage('assets/nutriscore-e.png')
                                            : AssetImage('assets/No_Image_Available.jpg'))))),
                          fit: BoxFit.fill
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        ],
      ),
    );
  }
  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("¡ATENCIÓN!"),
          content: Text(
            "Este alimento contiene alérgenos para ti: ${alerSi.join(", ")}"
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, 'OK'),
              child: const Text('OK'),
            ),
          ],
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
}
  