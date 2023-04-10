import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nutri_app/widges/lector.dart';
import 'package:nutri_app/widges/searcher.dart';
import 'package:percent_indicator/percent_indicator.dart';
//import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
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
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        showSearch(context: context, delegate: FoodSearcher(queryHint: ''));
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
                          Material(child: FoodLector(), color: Colors.transparent)
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                    
                  ],
                ),
            ),



            ],
          ),
        ),
      ),



    );
  }
}