import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../variables/global.dart';

class FoodSearcher extends SearchDelegate<String> {
  final String? queryHint;

  FoodSearcher({this.queryHint}) : super();

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
        close(context, '');
      },
    );
  }

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
                onTap: () {
                  close(context, snapshot.data![index]);
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
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: fetchFoodList(query),
      builder: (context, snapshot) {
        if (query.isEmpty) {
          return Container();
        } else if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data![index]),
                onTap: () {
                  close(context, snapshot.data![index]);
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
      Uri.parse('http://34.175.85.15:8080/search-product/search/$query'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': globalVariables.tokenUser,
      },
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final products = jsonData['products'] as List<dynamic>;
      final names = <String>[];
      for (var product in products) {
        final name = product['product_name'] as String?;
        if (name != null) {
          names.add(name);
        }
      }
      return names;
    } else {
      throw Exception('Failed to fetch food list');
    }
  }
}
