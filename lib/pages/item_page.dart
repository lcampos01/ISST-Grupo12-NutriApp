import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
//import 'package:provider/provider.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({Key? key, this.name, this.imageUrl, this.macros, this.imageNutriScore, this.details, this.imageIngredientes, this.isFavorite}) : super(key: key);
  
  final name;
  final imageUrl; 
  final macros; 
  final imageNutriScore;
  final details;
  final imageIngredientes;
  
  final isFavorite;

  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {

  bool _isFavorite = false;
  
  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(200),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          flexibleSpace: ClipRRect(
            child: Container(
              margin: EdgeInsets.only(top: 60),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: widget.imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          automaticallyImplyLeading: true,
          actions: [
            IconButton(
              icon: _isFavorite ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
              iconSize: 25,
              color: _isFavorite ? Colors.red : Colors.black,
              onPressed: () {
                setState(() {
                  _isFavorite = !_isFavorite;
                  if (_isFavorite) {
                    //la he añadido a favoritos -> post alimentos para meterla en favs
                  } else {
                    //la he borrado de favoritos -> delete alimentos para sacarla de favs
                  }
                });
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Product',
              style: TextStyle(
                fontSize: 16,
              ),
              overflow: TextOverflow.visible,
            ),
            SizedBox(height: 5),
            Text(
              widget.name,
              style: TextStyle(
                fontSize: 22,
              ),
            ),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text('Calorías'),
                    SizedBox(height: 10),
                    //Text('$calorias [Kcal]'), para cuando se cree el array de macros
                    widget.macros[0] == null ? Text(
                      'NS/NC',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ) 
                    : Text(
                      '${double.parse(double.parse((widget.macros[0]).toString()).toStringAsFixed(3))} [Kcal]', 
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('Proteínas'),
                    SizedBox(height: 10),
                    //Text('$proteinas [g]'), para cuando se cree el array de macros
                    widget.macros[1] == null ? Text(
                      'NS/NC',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ) 
                    : Text(
                      '${double.parse(double.parse((widget.macros[1]).toString()).toStringAsFixed(3))} [g]',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('Carbohidratos'),
                    SizedBox(height: 10),
                    //Text('$carbohidratos [g]'), para cuando se cree el array de macros
                    widget.macros[2] == null ? Text(
                      'NS/NC',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ) 
                    : Text(
                      '${double.parse(double.parse((widget.macros[2]).toString()).toStringAsFixed(3))} [g]',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text('Grasas'),
                    SizedBox(height: 10),
                    //Text('$grasas [g]'), para cuando se cree el array de macros
                    widget.macros[3] == null ? Text(
                      'NS/NC',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ) 
                    : Text(
                      '${double.parse(double.parse((widget.macros[3]).toString()).toStringAsFixed(3))} [g]',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: 25),
            GestureDetector(
              onTap: () {
                //logica del boton Ver detalles
                showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Center(
                      child: Text(
                        'Detalles',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ), 
                    content: Container(
                      height: 600,
                      child: Center(
                        child: Column(
                          children: [
                            widget.details == '' ? Text(
                                'Cantidad de producto: NS/NC',
                                style: TextStyle(
                                  fontSize: 24,
                                ),
                              ) 
                              : Text(
                                  'Cantidad de producto: ${widget.details}',
                                  style: TextStyle(
                                    fontSize: 24,
                                  ),
                                ),   //cambiar
                            SizedBox(height: 55),
                            Text(
                              'Ingredientes:',
                              style: TextStyle(
                                fontSize: 24,
                              ),
                            ),
                            ClipRRect(
                              child: Container(
                                width: 300,
                                height: 300,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: widget.imageIngredientes,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: Container(
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(horizontal: 110),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 23, 142, 56),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    "Ver detalles",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    )
                  ),
                ),
              ),
            ),
            SizedBox(height: 25),
            Center(
              child: Text(
                widget.imageNutriScore.toString() == 'a' ? 'Calidad nutricional muy buena'
                                : (widget.imageNutriScore.toString() == 'b' ? 'Calidad nutricional buena'
                                : (widget.imageNutriScore.toString() == 'c' ? 'Calidad nutricional media'
                                : (widget.imageNutriScore.toString() == 'd' ? 'Calidad nutricional baja'
                                : (widget.imageNutriScore.toString() == 'e' ? 'Calidad nutricional mala'
                                : 'Calidad nutricional (?)')))),
                style: TextStyle(
                  color: Color.fromARGB(255, 23, 142, 56),
                  fontWeight: FontWeight.bold,
                  fontSize: 21,
                ),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: ClipRRect(
                child: Container(
                  width: 170,
                  height: 90,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: widget.imageNutriScore.toString() == 'a' ? AssetImage('assets/nutriscore-a.png') 
                                        : (widget.imageNutriScore.toString() == 'b' ? AssetImage('assets/nutriscore-b.png')
                                        : (widget.imageNutriScore.toString() == 'c' ? AssetImage('assets/nutriscore-c.png')
                                        : (widget.imageNutriScore.toString() == 'd' ? AssetImage('assets/nutriscore-d.png')
                                        : (widget.imageNutriScore.toString() == 'e' ? AssetImage('assets/nutriscore-e.png')
                                        : AssetImage('assets/No_Image_Available.jpg'))))),
                      fit: BoxFit.fill
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
  