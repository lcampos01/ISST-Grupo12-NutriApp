import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;
import '../variables/global.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:nutri_app/pages/item_page.dart';

// class Product {
//   final String name;
//   final String imageUrl;

//   Product({required this.name, required this.imageUrl});

//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       name: json['product_name'],
//       imageUrl: json['image_small_url'],
//     );
//   }
// }

// class FoodLector extends StatefulWidget {
//   @override
//   _FoodLectorState createState() => _FoodLectorState();
// }

// class _FoodLectorState extends State<FoodLector> {
//   String _scanBarcode = 'Unknown';

//   @override
//   void initState() {
//     super.initState();
//   }

//   Future<Product?> fetchProduct(String barcode) async {
//     final response = await http.get(Uri.parse(
//         'https://world.openfoodfacts.org/api/v0/product/$barcode.json'));

//     if (response.statusCode == 200) {
//       final json = jsonDecode(response.body);

//       if (json['status'] == 1) {
//         return Product.fromJson(json['product']);
//       }
//     }

//     return null;
//   }

//   Future<void> scanBarcodeNormal() async {
//     String barcodeScanRes;
//     try {
//       barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
//           '#ff6666', 'Cancel', true, ScanMode.BARCODE);
//       print(barcodeScanRes);
//     } on PlatformException {
//       barcodeScanRes = 'Failed to get platform version.';
//     }

//     if (!mounted) return;

//     setState(() {
//       _scanBarcode = barcodeScanRes;
//     });

//     final product = await fetchProduct(barcodeScanRes);

//     if (product != null) {
//       showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text(product.name),
//               content: Image.network(product.imageUrl),
//             );
//           });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     // return IconButton(
//     //   icon: Icon(Icons.camera_alt_rounded),
//     //   color: Colors.green,
//     //   onPressed: () => scanBarcodeNormal(),
//     // );
//     return GestureDetector(
//       onTap: () => scanBarcodeNormal(),
//       child: BarcodeWidget(
//         data: 'Barcode',
//         barcode: Barcode.code128(),
//         width: 125,
//         height: 75,
//         color: Colors.black,
//         backgroundColor: Colors.transparent,
//         errorBuilder: (_context, _error) => SizedBox(
//           width: 100,
//           height: 50,
//         ),
//         drawText: true,
//       ),
//     );
//   }
// }

class FoodLector extends StatefulWidget {
  @override
  _FoodLectorState createState() => _FoodLectorState();
}

class _FoodLectorState extends State<FoodLector> {
  String _scanBarcode = 'Unknown';

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });

    final nombre = await fetchNombre(barcodeScanRes);

    if (nombre != null) {
      final imageUrls = await fetchItemImage(barcodeScanRes);
      final macros = await fetchItemMacros(barcodeScanRes);
      final grades = await fetchGrade(barcodeScanRes);
      final imageIngredientsUrls = await fetchItemImageIngredients(barcodeScanRes);
      final cantidades = await fetchCantidad(barcodeScanRes);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ItemPage(
            name: nombre,
            imageUrl: imageUrls,
            macros: [macros[0], macros[1], macros[2], macros[3]],
            imageNutriScore: grades,
            details: cantidades,
            imageIngredientes:imageIngredientsUrls,
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => scanBarcodeNormal(),
      child: BarcodeWidget(
        data: 'Barcode',
        barcode: Barcode.code128(),
        width: 125,
        height: 75,
        color: Colors.black,
        backgroundColor: Colors.transparent,
        errorBuilder: (_context, _error) => SizedBox(
          width: 100,
          height: 50,
        ),
        drawText: true,
      ),
    );
  }
  Future<String> fetchNombre(String barcode) async {
    final response = await http.get(
      Uri.parse('${globalVariables.ipVM}/search-product/scan/$barcode'),
      headers: <String, String>{
        'authorization': globalVariables.tokenUser,
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final product = jsonData['product'] as dynamic;
      final name = product['product_name'] as String;
      if (name != null) {
        return name;
      } else {
        return name;
      }
    } else {
      print(response.statusCode);
      throw Exception('Failed to fetch food list');
    }
  }

  Future<NetworkImage> fetchItemImage(String barcode) async {
    final response = await http.get(
      Uri.parse('${globalVariables.ipVM}/search-product/scan/$barcode'),
      headers: <String, String>{
        'authorization': globalVariables.tokenUser,
      },
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final product = jsonData['product'] as dynamic;
      final imagestr = product['image_front_url'] as String?;
      if (imagestr != null) {
        return NetworkImage(imagestr);
      } else {
        return NetworkImage('https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg');
      }
    } else {
      throw Exception('Failed to fetch food image');
    }
  }

    Future<NetworkImage> fetchItemImageIngredients(String barcode) async {
    final response = await http.get(
      Uri.parse('${globalVariables.ipVM}/search-product/scan/$barcode'),
      headers: <String, String>{
        'authorization': globalVariables.tokenUser,
      },
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final product = jsonData['product'] as dynamic;
      final imageIngredientsstr = product['image_ingredients_url'] as String?;
      if (imageIngredientsstr != null) {
        return NetworkImage(imageIngredientsstr);
      } else {
        return NetworkImage('https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg');
      }
    } else {
      throw Exception('Failed to fetch food image');
    }
  }

  Future<List<dynamic>> fetchItemMacros(String barcode) async {
    final response = await http.get(
      Uri.parse('${globalVariables.ipVM}/search-product/scan/$barcode'),
      headers: <String, String>{
        'authorization': globalVariables.tokenUser,
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final product = jsonData['product'] as dynamic;
      final nutriments = product['nutriments'] as Map<String, dynamic>;
      final calorias = nutriments['energy-kcal_100g'] as dynamic;
      final proteinas = nutriments['proteins_100g'] as dynamic;
      final carbohidratos = nutriments['carbohydrates_100g'] as dynamic;
      final grasas = nutriments['fat_100g'] as dynamic;

      final macros = [calorias, proteinas, carbohidratos, grasas];
      return macros;
    } else {
      print(response.statusCode);
      throw Exception('Failed to fetch food list');
    }
  }
  Future<String> fetchGrade(String barcode) async {
    final response = await http.get(
      Uri.parse('${globalVariables.ipVM}/search-product/scan/$barcode'),
      headers: <String, String>{
        'authorization': globalVariables.tokenUser,
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final product = jsonData['product'] as dynamic;
      final ecoscore = product['nutriscore_grade'] as String?;
      if (ecoscore != null) {
        return ecoscore;
      } else {
        return 'z';
      }
    } else {
      print(response.statusCode);
      throw Exception('Failed to fetch food list');
    }
  }

  Future<String> fetchCantidad(String barcode) async {
    final response = await http.get(
      Uri.parse('${globalVariables.ipVM}/search-product/scan/$barcode'),
      headers: <String, String>{
        'authorization': globalVariables.tokenUser,
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final product = jsonData['product'] as dynamic;
      final cantidad = product["quantity"] as String?;
      if (cantidad != null) {
        return cantidad;
      } else {
        return 'NS/NC';
      }
    } else {
      print(response.statusCode);
      throw Exception('Failed to fetch food list');
    }
  }
}

