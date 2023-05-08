import 'package:flutter/material.dart';
import 'package:nutri_app/pages/item_page.dart';
import 'package:nutri_app/variables/global.dart';
import 'package:nutri_app/widges/listFav.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/cupertino.dart';

class FavPage extends StatefulWidget {
  const FavPage({Key? key}) : super(key: key);

  @override
  _FavPageState createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> {
  int numFavs = 0;
  dynamic jsonData;
  List<dynamic> barcodes = [];
  List<dynamic> nombres = [];
  List<dynamic> imageUrls = [];
  List<dynamic> imageNutriScores = [];
  List<dynamic> cantidadess = [];
  List<dynamic> imageIngredientess = [];
  List<dynamic> caloriass = [];
  List<dynamic> proteinass = [];
  List<dynamic> grasass = [];
  List<dynamic> carbohidratoss = [];

  TextEditingController searchController = TextEditingController();
  List<dynamic> filteredNombres = [];

  @override
  void initState() {
    super.initState();
    favoritosLista();
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
            toolbarHeight: 100,
            title: Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                'Alimentos favoritos',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            floating: true,
            expandedHeight: 150,
            flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.only(top: 50, bottom: 15),
                centerTitle: true,
                title: Padding(
                  padding: EdgeInsets.fromLTRB(9.0, 24.0, 9.0, 6.0),
                  child: Container(
                    padding: EdgeInsets.only(bottom: 2),
                    constraints: BoxConstraints(minHeight: 30, maxHeight: 30),
                    width: 220,
                    child: CupertinoTextField(
                      controller: searchController,
                      onChanged: (filtro) {
                        setState(() {
                          filteredNombres = nombres.where((element) => element
                            .toString()
                            .toLowerCase()
                            .contains(filtro.toLowerCase())).toList();
                        });
                      },
                      keyboardType: TextInputType.text,
                      placeholder: "Search..",
                      placeholderStyle: TextStyle(
                        color: Color(0xffC4C6CC),
                        fontSize: 14.0,
                      ),
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
                    ),

                  ),
                )),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
            sliver: numFavs > 0
                ? SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      return InkWell(
                        child: ListFav(
                          name: filteredNombres[index],
                          imageUrl: imageUrls[index],
                        ),
                        onTap: () {
                            print(nombres[index]);
                            print(barcodes[index]);
                            print(imageUrls[index]);
                            print(imageNutriScores[index]);
                            print(cantidadess[index]);
                            print(imageIngredientess[index]);
                            print(caloriass[index]);
                            print(proteinass[index]);
                            print(carbohidratoss[index]);
                            print(grasass[index]);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ItemPage(
                                  name: nombres[index],
                                  barcode: barcodes[index],
                                  imageUrl: NetworkImage(imageUrls[index]),
                                  imageNutriScore: imageNutriScores[index],
                                  details: cantidadess[index],
                                  imageIngredientes:
                                      NetworkImage(imageIngredientess[index]),
                                  macros: [
                                    caloriass[index],
                                    proteinass[index],
                                    carbohidratoss[index],
                                    grasass[index],
                                  ],
                                  isFavorite: true,
                                  
                                ),
                              ),
                            );
                          },
                        );
                    },
                    childCount: filteredNombres.length,
                  )
                ): SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                        'Aún no tienes alimentos favoritos',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> favoritosLista() async {
    final response = await http.get(
      Uri.parse('${globalVariables.ipVM}/favoritos'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': globalVariables.tokenUser,
      },
    );
    if (response.statusCode == 200) {
      jsonData = jsonDecode(response.body);
      print(jsonData);
      print(jsonData.length);
      if (jsonData.length == 0) {
        return;
      } else {
        for (var data in jsonData) {
          final barcode = data["barcode"] as String?;
          final nombre = data["nombre"] as String?;
          final imageUrl = data["imageUrl"] as String?;
          final imageNutriScore = data["imageNutriScore"] as String?;
          final cantidades = data["cantidades"] as String?;
          final imageIngredientes = data["imageIngredientes"] as String?;
          final calorias = data["calorias"] as String?;
          final proteinas = data["proteinas"] as String?;
          final grasas = data["grasas"] as String?;
          final carbohidratos = data["carbohidratos"] as String?;

          if (barcode != null) {
            barcodes.add(barcode);
          } else {
            barcodes.add('NS/NC');
          }
          if (nombre != null) {
            nombres.add(nombre);
          } else {
            nombres.add('NS/NC');
          }
          if (imageUrl != null) {
            imageUrls.add(imageUrl);
          } else {
            imageUrls.add('NS/NC');
          }
          if (imageNutriScore != null) {
            imageNutriScores.add(imageNutriScore);
          } else {
            imageNutriScores.add('NS/NC');
          }
          if (cantidades != null) {
            cantidadess.add(cantidades);
          } else {
            cantidadess.add('NS/NC');
          }
          if (imageIngredientes != null) {
            imageIngredientess.add(imageIngredientes);
          } else {
            imageIngredientess.add('NS/NC');
          }
          if (calorias != null) {
            caloriass.add(double.tryParse(calorias));
          } else {
            caloriass.add('NS/NC');
          }
          if (proteinas != null) {
            proteinass.add(double.tryParse(proteinas));
          } else {
            proteinass.add('NS/NC');
          }
          if (grasas != null) {
            grasass.add(double.tryParse(grasas));
          } else {
            grasass.add('NS/NC');
          }
          if (carbohidratos != null) {
            carbohidratoss.add(double.tryParse(carbohidratos));
          } else {
            carbohidratoss.add('NS/NC');
          }
        }
      }
      filteredNombres = List.from(nombres);
      setState(() {
        numFavs = jsonData.length;
      });
    } else {
      throw Exception('Failed to fetch favorites');
    }
  }
}
