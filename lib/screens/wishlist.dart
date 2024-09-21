import 'package:flutter/material.dart';
import 'package:meesho_dice/services/theme.dart';
import 'package:meesho_dice/utils/product_data.dart';
import 'package:meesho_dice/widgets/product_box.dart';

class Wishlist extends StatelessWidget {
  const Wishlist({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Wishlist",
            style: appBarTextStyle,
          ),
        ),
        body: Wishlistbody(wishlist: [1, 14, 11, 4, 6]));
  }
}

class Wishlistbody extends StatelessWidget {
  final List<int> wishlist;
  const Wishlistbody({super.key, required this.wishlist});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 320,
            mainAxisSpacing: 1.4,
            crossAxisSpacing: 1.4),
        itemCount: wishlist.length,
        itemBuilder: (context, index) {
          final productId = wishlist[index];
          final productDetails =
              productData.firstWhere((e) => e["id"] == productId);
          return ProductBox(
            details: productDetails,
          );
        });
  }
}
