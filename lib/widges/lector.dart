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
  // ignore: unused_field
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
    var t1 = DateTime.now().millisecondsSinceEpoch;
    final Data = await fetchData(barcodeScanRes);
    // print(Data);
    final jsonData = jsonDecode(Data)['product'];
    // print('--------------------------------------------');
    // print(jsonData.toString());
    final nombre = jsonData['product_name'];
    var t2 = DateTime.now().millisecondsSinceEpoch;
    if (nombre != null) {
      final imageUrls = await fetchItemImage(jsonData);
      final macros = await fetchItemMacros(jsonData);
      final grades = await fetchGrade(jsonData);
      final imageIngredientsUrls = await fetchItemImageIngredients(jsonData);
      final cantidades = await fetchCantidad(jsonData);
      var t3 = DateTime.now().millisecondsSinceEpoch;
      print('--------------------------------------------');
      print(t2 - t1);
      print(t3 - t2);
      print('--------------------------------------------');

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ItemPage(
            name: nombre,
            imageUrl: imageUrls,
            macros: [macros[0], macros[1], macros[2], macros[3]],
            imageNutriScore: grades,
            details: cantidades,
            imageIngredientes: imageIngredientsUrls,
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

  Future<String> fetchData(String barcode) async {
    print('${globalVariables.ipVM}/search-product/scan/$barcode');
    final response = await http.get(
      Uri.parse('${globalVariables.ipVM}/search-product/scan/$barcode'),
      headers: <String, String>{
        'authorization': globalVariables.tokenUser,
      },
    );

    if (response.statusCode == 200) {
      return response.body;
    } else {
      print(response.statusCode);
      throw Exception('Failed to fetch food list');
    }
  }

  Future<NetworkImage> fetchItemImage(Map<String, dynamic> jsonData) async {
    final imagestr = jsonData['image_front_url'] as String?;
    if (imagestr != null) {
      return NetworkImage(imagestr);
    } else {
      return NetworkImage(
          'https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg');
    }
  }

  Future<NetworkImage> fetchItemImageIngredients(
      Map<String, dynamic> jsonData) async {
    final imageIngredientsstr = jsonData['image_ingredients_url'] as String?;
    if (imageIngredientsstr != null) {
      return NetworkImage(imageIngredientsstr);
    } else {
      return NetworkImage(
          'https://upload.wikimedia.org/wikipedia/commons/1/14/No_Image_Available.jpg');
    }
  }

  Future<List<dynamic>> fetchItemMacros(Map<String, dynamic> jsonData) async {
    final nutriments = jsonData['nutriments'] as Map<String, dynamic>;
    final calorias = nutriments['energy-kcal_100g'] as dynamic;
    final proteinas = nutriments['proteins_100g'] as dynamic;
    final carbohidratos = nutriments['carbohydrates_100g'] as dynamic;
    final grasas = nutriments['fat_100g'] as dynamic;

    final macros = [calorias, proteinas, carbohidratos, grasas];
    return macros;
  }

  Future<String> fetchGrade(Map<String, dynamic> jsonData) async {
    final ecoscore = jsonData['nutriscore_grade'] as String?;
    if (ecoscore != null) {
      return ecoscore;
    } else {
      return 'z';
    }
  }

  Future<String> fetchCantidad(Map<String, dynamic> jsonData) async {
    final cantidad = jsonData["quantity"] as String?;
    if (cantidad != null) {
      return cantidad;
    } else {
      return 'NS/NC';
    }
  }
}
