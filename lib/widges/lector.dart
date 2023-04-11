import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/http.dart' as http;

import 'package:barcode_widget/barcode_widget.dart';

class Product {
  final String name;
  final String imageUrl;

  Product({required this.name, required this.imageUrl});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['product_name'],
      imageUrl: json['image_small_url'],
    );
  }
}

class FoodLector extends StatefulWidget {
  @override
  _FoodLectorState createState() => _FoodLectorState();
}

class _FoodLectorState extends State<FoodLector> {
  String _scanBarcode = 'Unknown';

  @override
  void initState() {
    super.initState();
  }

  Future<Product?> fetchProduct(String barcode) async {
    final response = await http.get(Uri.parse(
        'https://world.openfoodfacts.org/api/v0/product/$barcode.json'));

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);

      if (json['status'] == 1) {
        return Product.fromJson(json['product']);
      }
    }

    return null;
  }

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

    final product = await fetchProduct(barcodeScanRes);

    if (product != null) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(product.name),
              content: Image.network(product.imageUrl),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    // return IconButton(
    //   icon: Icon(Icons.camera_alt_rounded),
    //   color: Colors.green,
    //   onPressed: () => scanBarcodeNormal(),
    // );
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
}
