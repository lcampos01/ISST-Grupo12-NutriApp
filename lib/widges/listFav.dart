import 'package:flutter/material.dart';

class ListFav extends StatefulWidget {
  const ListFav({Key? key, this.name, this.imageUrl}) : super(key: key);

  final name;
  final imageUrl; 

  @override
  _ListFavState createState() => _ListFavState();
}

class _ListFavState extends State<ListFav> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.name,
          ),
          Image(
            image: widget.imageUrl,
            width: 50,
            height: 50,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}