import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meesho_dice/repository/firebase.dart';
import 'package:meesho_dice/utils/product_data.dart';

class CartTile extends StatelessWidget {
  final bool isGroupCart;
  final int productId;
  final String productDocId;
  final int? numberOfLikes;
  const CartTile(
      {super.key,
      this.numberOfLikes,
      required this.isGroupCart,
      required this.productId,
      required this.productDocId});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> details =
        productData.firstWhere((element) => element["id"] == productId);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ImageContainer(
                  imageUrl: details["images"][0],
                ),
                const SizedBox(
                  width: 16.0,
                ),
                Expanded(
                  child: CartProductDetails(
                    details: details,
                    isGroupCart: isGroupCart,
                    productDocId: productDocId,
                  ),
                ),
              ],
            ),
          ),
          Divider(
            thickness: 1.7,
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  "Sold by: ${details["seller_details"]["name"]}",
                  style: const TextStyle(color: Colors.black54),
                ),
                const Expanded(
                  child: SizedBox(),
                ),
                const Text("Free Delivery",
                    style: TextStyle(color: Colors.black54))
              ],
            ),
          ),
          const SizedBox(
            height: 14.0,
          )
        ],
      ),
    );
  }
}

class ImageContainer extends StatelessWidget {
  final String imageUrl;
  const ImageContainer({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          image: DecorationImage(
              fit: BoxFit.fill, image: CachedNetworkImageProvider(imageUrl))),
    );
  }
}

class CartProductDetails extends StatelessWidget {
  final Map<String, dynamic> details;
  final bool isGroupCart;
  final String productDocId;
  const CartProductDetails(
      {super.key,
      required this.details,
      required this.isGroupCart,
      required this.productDocId});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          details["title_name"],
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w900),
        ),
        Row(
          children: [
            Text(
              "₹ ${details["price"]}",
              style:
                  const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              width: 4.0,
            ),
            Text(
              "${(details["price"] / (1 - 0.01 * details["discount"])).ceil()}",
              style: const TextStyle(
                  decoration: TextDecoration.lineThrough,
                  fontSize: 12.0,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              width: 4.0,
            ),
            Text(
              "${details["discount"].toString()}% off",
              style: const TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54),
            ),
          ],
        ),
        Text("Easy Returns"),
        TextButton.icon(
            onPressed: () async {
              await FirebaseServices().removeProductFromCart(productDocId);
            },
            icon: Icon(
              Icons.close,
              color: Colors.black.withOpacity(0.7),
              size: 18,
            ),
            label: Text(
              "Remove",
              style: TextStyle(
                  fontSize: 13,
                  color: Colors.black.withOpacity(0.7),
                  fontWeight: FontWeight.bold),
            ))
      ],
    );
  }
}
