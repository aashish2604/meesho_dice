import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meesho_dice/screens/category_page.dart';

class CategoryBox extends StatelessWidget {
  final String image;
  final String title;
  final String category;
  const CategoryBox(
      {super.key,
      required this.image,
      required this.title,
      required this.category});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                CategoryPage(category: category, title: title)));
      },
      child: Container(
        width: 80.0,
        color: Colors.white,
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 28.0,
              backgroundImage: CachedNetworkImageProvider(image),
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
      ),
    );
  }
}
