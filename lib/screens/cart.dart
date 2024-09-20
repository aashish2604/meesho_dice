import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meesho_dice/repository/firebase.dart';
import 'package:meesho_dice/services/theme.dart';
import 'package:meesho_dice/utils/product_data.dart';
import 'package:meesho_dice/widgets/cart_tile.dart';
import 'package:meesho_dice/widgets/loading.dart';

class ShoppingCart extends StatelessWidget {
  final bool isGroupCart;
  const ShoppingCart({super.key, required this.isGroupCart});

  List<int> getProductList(List<QueryDocumentSnapshot<Object?>> products) {
    List<int> response = [];
    for (var prod in products) {
      final prodInfo = prod.data() as Map<String, dynamic>;
      response.add(prodInfo["id"]);
    }
    return response;
  }

  int getAmount(List<int> products) {
    int totalAmount = 0;
    for (int i in products) {
      Map<String, dynamic> prod = productData.firstWhere((e) => e["id"] == i);
      int price = prod["price"];
      int discount = prod["discount"];
      int totalPrice = (price / (1 - 0.01 * discount)).ceil();
      totalAmount += totalPrice;
    }
    return totalAmount;
  }

  int getDiscount(List<int> products) {
    int totalDiscount = 0;
    for (int i in products) {
      Map<String, dynamic> prod = productData.firstWhere((e) => e["id"] == i);
      int price = prod["price"];
      int discount = prod["discount"];
      int totalPrice = (price / (1 - 0.01 * discount)).ceil();
      int discountAmount = totalPrice - price;
      totalDiscount += discountAmount;
    }
    return totalDiscount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(
          isGroupCart ? "Group Cart" : "Cart",
          style: appBarTextStyle,
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseServices.getUserId())
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
                              return CartTile(
                                isGroupCart: isGroupCart,
                                productId: data["id"],
                                productDocId: documents[index].id,
                              );
                            }),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          height: 60,
                          color: Colors.white,
                          child: Row(
                            children: [
                              Text(
                                "Wishlist",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              const Expanded(child: SizedBox()),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(Icons.arrow_forward_ios))
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CartPriceBox(products: getProductList(documents)),
                        SizedBox(
                          height: 80,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
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
                              "₹ ${getAmount(getProductList(documents)) - getDiscount(getProductList(documents)) + 24}",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            const Expanded(child: SizedBox()),
                            TextButton(
                                style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4)),
                                    backgroundColor: Colors.purple),
                                onPressed: () {},
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

class CartPriceBox extends StatelessWidget {
  final List<int> products;
  const CartPriceBox({super.key, required this.products});

  int getAmount() {
    int totalAmount = 0;
    for (int i in products) {
      Map<String, dynamic> prod = productData.firstWhere((e) => e["id"] == i);
      int price = prod["price"];
      int discount = prod["discount"];
      int totalPrice = (price / (1 - 0.01 * discount)).ceil();
      totalAmount += totalPrice;
    }
    return totalAmount;
  }

  int getDiscount() {
    int totalDiscount = 0;
    for (int i in products) {
      Map<String, dynamic> prod = productData.firstWhere((e) => e["id"] == i);
      int price = prod["price"];
      int discount = prod["discount"];
      int totalPrice = (price / (1 - 0.01 * discount)).ceil();
      int discountAmount = totalPrice - price;
      totalDiscount += discountAmount;
    }
    return totalDiscount;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            "Price Details (${products.length} Items)",
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          const SizedBox(
            height: 22.0,
          ),
          CartPriceDetailsRow(
              title: "Total Product Price",
              amount: getAmount().toString(),
              isDiscount: false),
          CartPriceDetailsRow(
              title: "Total Discounts",
              amount: getDiscount().toString(),
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
            amount: (getAmount() - getDiscount() + 24).toString(),
            isDiscount: false,
            isTotal: true,
          )
        ],
      ),
    );
  }
}

class CartPriceDetailsRow extends StatelessWidget {
  final String title;
  final String amount;
  final bool isDiscount;
  final bool isTotal;
  const CartPriceDetailsRow(
      {super.key,
      required this.title,
      required this.amount,
      required this.isDiscount,
      this.isTotal = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
                color: isDiscount ? Colors.green : Colors.black,
                fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
                fontSize: isTotal ? 18 : 14),
          ),
          const Expanded(child: SizedBox()),
          title == "Order Total"
              ? const SizedBox.shrink()
              : isDiscount
                  ? Icon(
                      Icons.remove,
                      size: 14,
                      color: Colors.green,
                    )
                  : Icon(Icons.add, size: 14),
          const SizedBox(
            width: 7,
          ),
          Text(
            "₹$amount",
            style: TextStyle(
                color: isDiscount ? Colors.green : Colors.black,
                fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
                fontSize: isTotal ? 18 : 14),
          ),
        ],
      ),
    );
  }
}
