import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meesho_dice/repository/firebase.dart';
import 'package:meesho_dice/screens/cart.dart';
import 'package:meesho_dice/screens/wishlist.dart';
import 'package:meesho_dice/services/theme.dart';
import 'package:meesho_dice/utils/product_data.dart';
import 'package:meesho_dice/widgets/cart_tile.dart';
import 'package:meesho_dice/widgets/chatbot/chatbot_fab.dart';
import 'package:meesho_dice/widgets/loading.dart';

class GroupShoppingCart extends StatelessWidget {
  final String groupId;
  const GroupShoppingCart({super.key, required this.groupId});

  List<int> getProductList(List<QueryDocumentSnapshot<Object?>> products) {
    List<int> response = [];
    for (var prod in products) {
      final prodInfo = prod.data() as Map<String, dynamic>;
      response.add(prodInfo["id"]);
    }
    return response;
  }

  int getDiscount(List<QueryDocumentSnapshot<Object?>> products) {
    int totalDiscount = 0;
    for (var i in products) {
      final prodInfo = i.data() as Map<String, dynamic>;
      if (prodInfo["adder_id"] == FirebaseServices.getUserId()) {
        Map<String, dynamic> prodDetails =
            productData.firstWhere((e) => e["id"] == prodInfo["id"]);
        int price = prodDetails["price"];
        int discount = prodDetails["discount"];
        int totalPrice = (price / (1 - 0.01 * discount)).ceil();
        int discountAmount = totalPrice - price;
        totalDiscount += discountAmount;
      }
    }
    return totalDiscount;
  }

  int getAmount(List<QueryDocumentSnapshot<Object?>> products) {
    int totalAmount = 0;
    for (var i in products) {
      final prodInfo = i.data() as Map<String, dynamic>;
      if (prodInfo["adder_id"] == FirebaseServices.getUserId()) {
        Map<String, dynamic> prodDetails =
            productData.firstWhere((e) => e["id"] == prodInfo["id"]);
        int price = prodDetails["price"];
        int discount = prodDetails["discount"];
        int totalPrice = (price / (1 - 0.01 * discount)).ceil();
        totalAmount += totalPrice;
      }
    }
    return totalAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60),
        child: const ChatBotFab(
            initMessage:
                'You get an extra "Group Discount" if your item has more likes than 50% group strength',
            containerLifeInSeconds: 10),
      ),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text(
          "Group Cart",
          style: appBarTextStyle,
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("groups")
              .doc(groupId)
              .collection("cart")
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: LabeledLoadingWidget(
                    label: Text("Loading"), loaderColor: kMeeshoPurple),
              );
            }
            if (snapshot.hasData) {
              final documents = snapshot.data!.docs;
              if (documents.isEmpty) {
                return const Center(
                  child: Text("Your cart is empty"),
                );
              }
              return Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: documents.length,
                            itemBuilder: (context, index) {
                              var data = documents[index].data()
                                  as Map<String, dynamic>;
                              return GroupCartTile(
                                groupId: groupId,
                                productId: data["id"],
                                productDocId: documents[index].id,
                                productInteractionDetails: data,
                              );
                            }),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          height: 60,
                          color: Colors.white,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const Wishlist()));
                            },
                            child: Row(
                              children: [
                                Text(
                                  "Wishlist",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                                const Expanded(child: SizedBox()),
                                IconButton(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const Wishlist()));
                                    },
                                    icon: Icon(Icons.arrow_forward_ios))
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GroupCartPriceBox(
                          products: getProductList(documents),
                          responseData: documents,
                        ),
                        SizedBox(
                          height: 150,
                        )
                      ],
                    ),
                  ),
                  getAmount(documents) == 0
                      ? const SizedBox.shrink()
                      : Positioned(
                          bottom: 0,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 10.0),
                            color: Colors.white,
                            width: MediaQuery.of(context).size.width,
                            child: Container(
                              child: Row(
                                children: [
                                  Text(
                                    "₹ ${getAmount(documents) - getDiscount(documents) + 24}",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Expanded(child: SizedBox()),
                                  TextButton(
                                      style: TextButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          backgroundColor: Colors.purple),
                                      onPressed: () {
                                        FirebaseServices()
                                            .placeOrderFromGroupCart(
                                                documents, groupId);
                                      },
                                      child: const Text(
                                        "Buy Now",
                                        style: TextStyle(color: Colors.white),
                                      ))
                                ],
                              ),
                            ),
                          ),
                        )
                ],
              );
            }
            return const Center(child: Text('No documents found'));
          }),
    );
  }
}

class GroupCartPriceBox extends StatelessWidget {
  final List<int> products;
  final List<QueryDocumentSnapshot<Object?>> responseData;
  const GroupCartPriceBox(
      {super.key, required this.products, required this.responseData});

  int getDiscount(List<QueryDocumentSnapshot<Object?>> products) {
    int totalDiscount = 0;
    for (var i in products) {
      final prodInfo = i.data() as Map<String, dynamic>;
      if (prodInfo["adder_id"] == FirebaseServices.getUserId()) {
        Map<String, dynamic> prodDetails =
            productData.firstWhere((e) => e["id"] == prodInfo["id"]);
        int price = prodDetails["price"];
        int discount = prodDetails["discount"];
        int totalPrice = (price / (1 - 0.01 * discount)).ceil();
        int discountAmount = totalPrice - price;
        totalDiscount += discountAmount;
      }
    }
    return totalDiscount;
  }

  int getAmount(List<QueryDocumentSnapshot<Object?>> products) {
    int totalAmount = 0;
    for (var i in products) {
      final prodInfo = i.data() as Map<String, dynamic>;
      if (prodInfo["adder_id"] == FirebaseServices.getUserId()) {
        Map<String, dynamic> prodDetails =
            productData.firstWhere((e) => e["id"] == prodInfo["id"]);
        int price = prodDetails["price"];
        int discount = prodDetails["discount"];
        int totalPrice = (price / (1 - 0.01 * discount)).ceil();
        totalAmount += totalPrice;
      }
    }
    return totalAmount;
  }

  int getYourOrderCount(List<QueryDocumentSnapshot<Object?>> products) {
    int count = 0;
    for (var i in products) {
      final prodInfo = i.data() as Map<String, dynamic>;
      if (prodInfo["adder_id"] == FirebaseServices.getUserId()) {
        count++;
      }
    }
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return getYourOrderCount(responseData) == 0
        ? const SizedBox.shrink()
        : Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                Text(
                  "Price Details (${getYourOrderCount(responseData)} Items)",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
                const SizedBox(
                  height: 22.0,
                ),
                CartPriceDetailsRow(
                    title: "Total Product Price",
                    amount: getAmount(responseData).toString(),
                    isDiscount: false),
                CartPriceDetailsRow(
                    title: "Total Discounts",
                    amount: getDiscount(responseData).toString(),
                    isDiscount: true),
                const CartPriceDetailsRow(
                    title: "Additional Fees", amount: "24", isDiscount: false),
                const Divider(
                  thickness: 1.5,
                ),
                const SizedBox(
                  height: 10,
                ),
                CartPriceDetailsRow(
                  title: "Order Total",
                  amount:
                      (getAmount(responseData) - getDiscount(responseData) + 24)
                          .toString(),
                  isDiscount: false,
                  isTotal: true,
                )
              ],
            ),
          );
  }
}

class GroupCartTile extends StatelessWidget {
  final int productId;
  final String productDocId;
  final String groupId;
  final Map<String, dynamic> productInteractionDetails;
  const GroupCartTile(
      {super.key,
      required this.productId,
      required this.productDocId,
      required this.productInteractionDetails,
      required this.groupId});

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
                GroupCartImageContainer(
                  imageUrl: details["images"][0],
                ),
                const SizedBox(
                  width: 16.0,
                ),
                Expanded(
                  child: GroupCartProductDetails(
                    groupId: groupId,
                    details: details,
                    productDocId: productDocId,
                    productInteractionDetails: productInteractionDetails,
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

class GroupCartImageContainer extends StatelessWidget {
  final String imageUrl;
  const GroupCartImageContainer({super.key, required this.imageUrl});

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

class GroupCartProductDetails extends StatelessWidget {
  final Map<String, dynamic> productInteractionDetails;
  final Map<String, dynamic> details;
  final String productDocId;
  final String groupId;
  const GroupCartProductDetails(
      {super.key,
      required this.details,
      required this.productDocId,
      required this.productInteractionDetails,
      required this.groupId});
  @override
  Widget build(BuildContext context) {
    String userId = FirebaseServices.getUserId();
    bool isMyAddition = productInteractionDetails["adder_id"] == userId;
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
        Text(
          "Adder: ${productInteractionDetails["adder_name"]}",
          style: TextStyle(
              fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87),
        ),
        Text("Easy Returns"),
        const SizedBox(
          height: 10.0,
        ),
        Row(
          children: [
            Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            SizedBox(
              width: 4.0,
            ),
            Text("${productInteractionDetails["no_of_likes"]}"),
            const SizedBox(
              width: 20.0,
            ),
            GroupCartDiscountChip(
              groupId: groupId,
              numberOfLikes: productInteractionDetails["no_of_likes"],
            )
          ],
        ),
        !isMyAddition
            ? const SizedBox(
                height: 10.0,
              )
            : TextButton.icon(
                onPressed: () async {
                  await FirebaseServices()
                      .removeProductFromGroupCart(groupId, productDocId);
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

class GroupCartDiscountChip extends StatelessWidget {
  final String groupId;
  final int numberOfLikes;
  const GroupCartDiscountChip(
      {super.key, required this.groupId, required this.numberOfLikes});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("groups")
            .doc(groupId)
            .collection("members")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final docs = snapshot.data!.docs;
            int likesThreshold = (docs.length / 2).floor();
            if (numberOfLikes > likesThreshold) {
              return Container(
                padding: EdgeInsets.only(top: 2, bottom: 2, right: 10, left: 5),
                decoration: BoxDecoration(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(30.0)),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check,
                      size: 14,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(
                      "Group Discount",
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    )
                  ],
                ),
              );
            }
          }
          return const SizedBox.shrink();
        });
  }
}
