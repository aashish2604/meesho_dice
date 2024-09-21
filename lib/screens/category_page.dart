import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meesho_dice/services/theme.dart';
import 'package:meesho_dice/utils/product_data.dart';
import 'package:meesho_dice/widgets/product_box.dart';

class CategoryPage extends StatelessWidget {
  final String category;
  final String title;
  const CategoryPage({super.key, required this.category, required this.title});

  @override
  Widget build(BuildContext context) {
    final products = productData.where((e) => e['category'] == category);
    return Scaffold(
      appBar: AppBar(
          title: Text(
        title,
        style: appBarTextStyle,
      )),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 320,
                mainAxisSpacing: 1.4,
                crossAxisSpacing: 1.4),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final data = products.elementAt(index);
              return ProductBox(
                details: data,
              );
            }),
      ),
    );
  }
}
