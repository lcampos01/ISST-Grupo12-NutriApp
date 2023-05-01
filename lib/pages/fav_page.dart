import 'package:flutter/material.dart';
import 'package:nutri_app/widges/listFav.dart';

class FavPage extends StatefulWidget {
  const FavPage({Key? key}) : super(key: key);

  @override
  _FavPageState createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> {

  // late ScrollController _scrollController;

  // @override
  // void initState() {
  //   super.initState();
  //   _scrollController = ScrollController();
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     _scrollController.animateTo(
  //       _scrollController.position.maxScrollExtent,
  //       duration: const Duration(milliseconds: 300),
  //       curve: Curves.easeOut,
  //     );
  //   });
  // }

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
            // controller: _scrollController,
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
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(12, 8, 12, 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 8, 0, 0),
                              child: Text(
                                'Comidas favoritas',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 30.0,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 8, 0, 8),
                          child: SizedBox(
                            height: 50,
                            child: TextField(
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.grey[300],
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide.none,
                                    ),
                                    prefixIcon: Icon(Icons.search),
                                    prefixIconColor: Colors.black,
                                    hintText:
                                        "Busca entre tus alimentos favoritos")),
                          ),
                        ),
                        //aqui debemos llamar a ListFav tantas veces como elementos haya en el get de favoritos del usuario
                        //se puede hacer con un for y hay que poner en name: nombre del producto y en imageUrl la imagen url del producto
                        //es como en widges/lector.dart o en widges/searcher.dart
                        //pero con la peticion get a /favoritos -> devuelve un conjunto de urls de los alimentos
                        SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ListFav(
                                name: 'Huevos', 
                                imageUrl: AssetImage('assets/eggs.jpeg'),
                              ),
                              ListFav(
                                name: 'Kiwi',
                                imageUrl: AssetImage('assets/kiwi.jpg'),
                              ),
                              ListFav(
                                name: 'Leche',
                                imageUrl: AssetImage('assets/leche.jpg'),
                              ),
                              ListFav(
                                name: 'Tomate',
                                imageUrl: AssetImage('assets/tomatos.jpg'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
