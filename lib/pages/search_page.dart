import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutri_app/widges/lector.dart';
import 'package:nutri_app/widges/searcher.dart';
import 'package:percent_indicator/percent_indicator.dart';
//import 'package:provider/provider.dart';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import '../functions/scanBarcode.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Container(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.all(24.0),
                  child: Container(
                    padding: EdgeInsets.only(left: 15, top: 20, right: 15),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.8,
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
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            showSearch(
                                context: context,
                                delegate: FoodSearcher(queryHint: ''));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Buscar',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 20.0,
                                ),
                              ),
                            ],
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.5),
                          child: Text(
                            "Búsqueda por código de barras",
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.05),
                          child: Material(
                              child: FoodLector(), color: Colors.transparent),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
