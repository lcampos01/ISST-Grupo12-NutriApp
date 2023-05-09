import 'package:flutter/cupertino.dart';
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
    padding: EdgeInsets.symmetric(horizontal: 10.0),
    child: Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.visible,
                  ),
                  SizedBox(width: 10.0),
                  widget.imageUrl == 'NS/NC'
                    ? Container(
                      child: Image(
                        image: AssetImage('assets/No_Image_Available.jpg'),
                        width: 50,
                        height: 50,
                        fit: BoxFit.contain,
                      ),
                    )
                    : Container(
                      child: Image.network(
                        widget.imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 50.0,
              ),
              Icon(
                CupertinoIcons.chevron_right, 
                color: Colors.black,
                size: 20,
              ),
            ],
          ),
          Divider(
            height: 20,
            thickness: 1,
            color: Colors.grey.shade400,
            indent: 0,
            endIndent: 0,
          ),
        ],
      ),
    );
  }
}