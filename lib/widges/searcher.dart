import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../variables/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:nutri_app/pages/item_page.dart';
import 'package:nutri_app/pages/search_page.dart';

class FoodSearcher extends SearchDelegate<String> {
  final String? queryHint;

  FoodSearcher({this.queryHint}) : super();

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: fetchFoodList(query),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data![index]),
                onTap: () async {
                  List<NetworkImage> imageUrls = await fetchItemImage(query);
                  List<List<dynamic>> macros = await fetchItemMacros(query);
                  List<String> grades = await fetchGrade(query);
                  List<NetworkImage> imageIngredientsUrls = await fetchItemImageIngredients(query);
                  List<String> cantidades = await fetchCantidad(query);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ItemPage(
                        name: snapshot.data![index],
                        imageUrl: imageUrls[index],
                        macros: [macros[0][index], macros[1][index], macros[2][index], macros[3][index]],
                        imageNutriScore: grades[index],
                        details: cantidades[index],
                        imageIngredientes:imageIngredientsUrls[index],
                      ),
                    ),
                  );
                },
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }









  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: const Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => SearchPage(),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: query != '' ? fetchFoodList(query) : null,
      builder: (context, snapshot) {
        if (query.isEmpty) {
          return Container();
        } else if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data![index]),
                onTap: () async {
                  List<NetworkImage> imageUrls = await fetchItemImage(query);
                  List<List<dynamic>> macros = await fetchItemMacros(query);
                  List<String> grades = await fetchGrade(query);
                  List<NetworkImage> imageIngredientsUrls = await fetchItemImageIngredients(query);
                  List<String> cantidades = await fetchCantidad(query);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ItemPage(
                        name: snapshot.data![index],
                        imageUrl: imageUrls[index],
                        macros: [macros[0][index], macros[1][index], macros[2][index], macros[3][index]],
                        imageNutriScore: grades[index],
                        details: cantidades[index],
                        imageIngredientes:imageIngredientsUrls[index],
                      ),
                    ),
                  );
                },
              );
            },
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Future<List<String>> fetchFoodList(String query) async {
    // final response = await http.get(Uri.parse(
    //     'https://world.openfoodfacts.org/cgi/search.pl?search_terms=$query&search_simple=1&action=process&json=1'));
      final response = await http.get(
        Uri.parse('${globalVariables.ipVM}/search-product/search/$query'),
        headers: <String, String>{
          'authorization': globalVariables.tokenUser,
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final products = jsonData['products'] as List<dynamic>;
        final names = <String>[];
        for (var product in products) {
          //final imageurl = product["image_front_url"] as String?;
          final name = product['product_name'] as String?;
          if (name != null) {
            names.add(name);
          }
        }
        return names;
      } else {
        print(response.statusCode);
        throw Exception('Failed to fetch food list');
      }
  }

  Future<List<NetworkImage>> fetchItemImage(String query) async {
    final response = await http.get(
      Uri.parse('${globalVariables.ipVM}/search-product/search/$query'),
      headers: <String, String>{
        'authorization': globalVariables.tokenUser,
      },
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final products = jsonData['products'] as List<dynamic>;
      final imageurls = <NetworkImage>[];
      for (var product in products) {
        final imagestr = product['image_front_url'] as String?;
        if (imagestr != null) {
          final imageurl = NetworkImage(imagestr);
          imageurls.add(imageurl);
        } else {
         final imageurl = NetworkImage('https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg');
         imageurls.add(imageurl);
        }
      }
      return imageurls;
    } else {
      throw Exception('Failed to fetch food image');
    }
  }

    Future<List<NetworkImage>> fetchItemImageIngredients(String query) async {
    final response = await http.get(
      Uri.parse('${globalVariables.ipVM}/search-product/search/$query'),
      headers: <String, String>{
        'authorization': globalVariables.tokenUser,
      },
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final products = jsonData['products'] as List<dynamic>;
      final imageurls = <NetworkImage>[];
      for (var product in products) {
        final imageIngredientsstr = product['image_ingredients_url'] as String?;
        if (imageIngredientsstr != null) {
          final imageIngredientsurl = NetworkImage(imageIngredientsstr);
          imageurls.add(imageIngredientsurl);
        } else {
         final imageIngredientsurl = NetworkImage('https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg');
         imageurls.add(imageIngredientsurl);
        }
      }
      return imageurls;
    } else {
      throw Exception('Failed to fetch food image');
    }
  }

  Future<List<List<dynamic>>> fetchItemMacros(String query) async {
    final response = await http.get(
      Uri.parse('${globalVariables.ipVM}/search-product/search/$query'),
      headers: <String, String>{
        'authorization': globalVariables.tokenUser,
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final products = jsonData['products'] as List<dynamic>;
      final caloriasLista = <dynamic>[];
      final proteinasLista = <dynamic>[];
      final carbohidratosLista = <dynamic>[];
      final grasasLista = <dynamic>[];

      for (var product in products) {
        final nutriments = product['nutriments'] as Map<String, dynamic>;
        final calorias = nutriments['energy-kcal_100g'] as dynamic;
        final proteinas = nutriments['proteins_100g'] as dynamic;
        final carbohidratos = nutriments['carbohydrates_100g'] as dynamic;
        final grasas = nutriments['fat_100g'] as dynamic;

        caloriasLista.add(calorias);
        proteinasLista.add(proteinas);
        carbohidratosLista.add(carbohidratos);
        grasasLista.add(grasas);
      }
      final macros = [caloriasLista, proteinasLista, carbohidratosLista, grasasLista];
      return macros;
    } else {
      print(response.statusCode);
      throw Exception('Failed to fetch food list');
    }
  }
  Future<List<String>> fetchGrade(String query) async {
    final response = await http.get(
      Uri.parse('${globalVariables.ipVM}/search-product/search/$query'),
      headers: <String, String>{
        'authorization': globalVariables.tokenUser,
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final products = jsonData['products'] as List<dynamic>;
      final grades = <String>[];
      for (var product in products) {
        final ecoscore = product['nutriscore_grade'] as String?;
        if (ecoscore != null) {
          grades.add(ecoscore);
        } else {
          grades.add('a');
        }
      }
      return grades;
    } else {
      print(response.statusCode);
      throw Exception('Failed to fetch food list');
    }
  }
  Future<List<String>> fetchCantidad(String query) async {
    final response = await http.get(
      Uri.parse('${globalVariables.ipVM}/search-product/search/$query'),
      headers: <String, String>{
        'authorization': globalVariables.tokenUser,
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final products = jsonData['products'] as List<dynamic>;
      final cantidades = <String>[];
      for (var product in products) {
        final cantidad = product["quantity"] as String?;
        if (cantidad != null) {
          cantidades.add(cantidad);
        } else {
          cantidades.add('NS/NC');
        }
      }
      return cantidades;
    } else {
      print(response.statusCode);
      throw Exception('Failed to fetch food list');
    }
  }
}
