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

       body: Center(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                showSearch(context: context, delegate: FoodSearcher(queryHint: ''));
              },
              child: Text('Buscar'),
            ),
            Material(child: FoodLector()),
          ],
        ),
      ),


    );
  }
}