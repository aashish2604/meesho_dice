import 'package:flutter/material.dart';
import 'package:meesho_dice/services/general_functions.dart';
import 'package:meesho_dice/widgets/circular_iconbutton.dart';
import 'package:meesho_dice/widgets/image_carousal.dart';
import 'package:meesho_dice/widgets/product_box.dart';

class ProductDetails extends StatelessWidget {
  final Map<String, dynamic> details;
  const ProductDetails({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Container(
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: screenHeight * 0.5,
                    child:
                        CarouselWithIndicatorDemo(imageUrls: details["images"]),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const VirtualStoreContainer(),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Icon(Icons.favorite_border_outlined),
                                    Text(
                                      "Wishlist",
                                      style: TextStyle(fontSize: 10.0),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Icon(Icons.share_outlined),
                                    Text(
                                      "Share",
                                      style: TextStyle(fontSize: 10.0),
                                    )
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                RatingBox(rating: details["rating"].toDouble()),
                                const SizedBox(
                                  width: 8.0,
                                ),
                                Text(
                                  "(${GeneralFunctions().formatIndianNumber(details["no_of_feedbacks"].toString())})",
                                  style: const TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 30,
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          details["descriptive_name"],
                          style: const TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.w400),
                        ),
                        const SizedBox(
                          height: 12.0,
                        ),
                        Row(
                          children: [
                            Text(
                              "₹ ${details["price"]}",
                              style: const TextStyle(
                                  fontSize: 26.0, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              width: 4.0,
                            ),
                            Text(
                              "${(details["price"] / (1 - 0.01 * details["discount"])).ceil()}",
                              style: const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  fontSize: 16.0,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              width: 4.0,
                            ),
                            Text(
                              "${details["discount"].toString()}% off",
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87),
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            const Text(
                              "onwards",
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 2.0,
                        ),
                        Text(
                          "Free Delivery",
                          style: TextStyle(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.black.withOpacity(0.6)),
                        ),
                        const SizedBox(
                          height: 3.0,
                        ),
                        Text(
                          "₹ ${details["special_offer_price"].toString()} with ${details["no_of_special_offers"].toString()} Special Offers",
                          style: TextStyle(
                              color: Colors.green.shade800,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(
                          height: 100,
                          width: 100,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              color: Colors.white,
              width: screenWidth,
              child: BottomButtonBox(),
            ),
          )
        ],
      ),
    );
  }
}

class VirtualStoreContainer extends StatelessWidget {
  const VirtualStoreContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(20.0)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Virtual Store",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Wrap(
              children: [
                VirtualStoreElement(
                    borerColor: Colors.green,
                    backgroundColor: Colors.lightGreen.shade100,
                    action: () {},
                    label: "3D View"),
                const SizedBox(
                  width: 10.0,
                ),
                VirtualStoreElement(
                    borerColor: Colors.blue.shade900,
                    backgroundColor: Colors.lightBlue.shade100,
                    action: () {},
                    label: "AR View"),
                const SizedBox(
                  width: 10.0,
                ),
                VirtualStoreElement(
                    borerColor: Colors.amber.shade800,
                    backgroundColor: Colors.yellow.shade100,
                    action: () {},
                    label: "Try-on"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class VirtualStoreElement extends StatelessWidget {
  final Color borerColor;
  final Color backgroundColor;
  final GestureTapCallback action;
  final String label;
  const VirtualStoreElement(
      {super.key,
      required this.borerColor,
      required this.backgroundColor,
      required this.action,
      required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircularIconButton(
            borderColor: borerColor,
            backgroundColor: backgroundColor,
            action: action),
        const SizedBox(
          height: 6.0,
        ),
        Text(
          label,
          style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.w500),
        )
      ],
    );
  }
}

class BottomButtonBox extends StatelessWidget {
  const BottomButtonBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.purple),
                      borderRadius: BorderRadius.circular(4))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart,
                    color: Colors.purple,
                  ),
                  Text(
                    "Add to Cart",
                    style: TextStyle(color: Colors.purple),
                  )
                ],
              )),
        ),
        const SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: TextButton.icon(
              style: TextButton.styleFrom(
                  backgroundColor: Colors.purple,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4))),
              onPressed: () {},
              label: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.fast_forward_rounded,
                    color: Colors.white,
                  ),
                  Text(
                    "Buy Now",
                    style: TextStyle(color: Colors.white),
                  )
                ],
              )),
        )
      ],
    );
  }
}
