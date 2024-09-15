import 'package:flutter/material.dart';

class CategoryBox extends StatelessWidget {
  final String image;
  final String title;
  const CategoryBox({super.key, required this.image, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80.0,
      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 28.0,
          ),
          const SizedBox(
            height: 8.0,
          ),
          Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 10.0),
          )
        ],
      ),
    );
  }
}
