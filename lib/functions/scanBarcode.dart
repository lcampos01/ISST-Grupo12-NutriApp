import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

Future<String> scanBarcode() async {
  String barcode = "";
  try {
    barcode = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancelar", true, ScanMode.BARCODE);
  } catch (e) {
    print(e.toString());
  }
  return barcode;
}
