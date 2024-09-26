import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meesho_dice/repository/firebase.dart';
import 'package:meesho_dice/screens/immersive/augmented_reality.dart';
import 'package:meesho_dice/screens/immersive/virtual_tryon_input.dart';
import 'package:meesho_dice/screens/model_3d_view.dart';
import 'package:meesho_dice/services/general_functions.dart';
import 'package:meesho_dice/services/theme.dart';
import 'package:meesho_dice/widgets/chatbot/chatbot_fab.dart';
import 'package:meesho_dice/widgets/circular_iconbutton.dart';
import 'package:meesho_dice/widgets/image_carousal.dart';
import 'package:meesho_dice/widgets/loading.dart';
import 'package:meesho_dice/widgets/product_box.dart';

class ProductDetails extends StatelessWidget {
  final Map<String, dynamic> details;
  const ProductDetails({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    void addProductToGroupChat() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return SocialGroupBottomsheet(details: details);
          });
    }

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
                    height: 20,
                  ),
                  Row(
                    children: [
                      VirtualStoreContainer(details: details),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
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
                                const SizedBox(
                                  width: 30.0,
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
                              height: 8.0,
                            ),
                            TextButton.icon(
                                style: TextButton.styleFrom(
                                    backgroundColor: Colors.purple,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(4))),
                                onPressed: () {
                                  addProductToGroupChat();
                                },
                                label: const Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.chat_outlined,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      width: 8.0,
                                    ),
                                    Text(
                                      "Add to group chat",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 10),
                                    )
                                  ],
                                ))
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 20,
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
                              "${(details["price"].toDouble() / (1 - 0.01 * (details["discount"].toDouble()))).ceil()}",
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
                        const SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
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
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    height: 12,
                    color: kCatsKillWhiteColor,
                  ),
                  SellerDetailsBox(
                    details: details,
                  ),
                  Container(
                    height: 12,
                    color: kCatsKillWhiteColor,
                  ),
                  DetailsBox(details: details),
                  const SizedBox(
                    height: 100,
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
              child: BottomButtonBox(
                details: details,
              ),
            ),
          )
        ],
      ),
      floatingActionButton: const Padding(
        padding: const EdgeInsets.only(bottom: 60),
        child: const ChatBotFab(
            initMessage:
                "Place order between 8PM to 11PM to get personalized discount on this product",
            containerLifeInSeconds: 10),
      ),
    );
  }
}

class VirtualStoreContainer extends StatelessWidget {
  final Map<String, dynamic> details;
  const VirtualStoreContainer({super.key, required this.details});

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
              "Immersive Zone",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            const SizedBox(
              height: 8.0,
            ),
            Wrap(
              children: [
                VirtualStoreElement(
                    borerColor: kMeeshoPurple,
                    backgroundColor: Colors.purple.shade100,
                    action: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AugmentedRealityView(
                                modelUrl: details["3d_model_url"],
                              )));
                    },
                    label: "AR View"),
                const SizedBox(
                  width: 10.0,
                ),
                VirtualStoreElement(
                    borerColor: Colors.black,
                    backgroundColor: Colors.white,
                    action: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Model3dViewer(
                              modelUrl: details["3d_model_url"],
                              modelTitle: details["descriptive_name"])));
                    },
                    label: "3D View"),
                details["tryon_image"] != null
                    ? const SizedBox(
                        width: 10.0,
                      )
                    : const SizedBox.shrink(),
                details["tryon_image"] != null
                    ? VirtualStoreElement(
                        borerColor: Color(0xff00317D),
                        backgroundColor: Colors.blue.shade100,
                        action: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => VirtualTryOnInput(
                                  tryOnCategory: details["tryon_category"],
                                  clothImage: details["tryon_image"])));
                        },
                        label: "Try-on")
                    : const SizedBox.shrink(),
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

  String getImagePath() {
    if (label == "3D View")
      return "assets/images/model_3d.png";
    else if (label == "AR View")
      return "assets/images/ar.png";
    else
      return "assets/images/virtual_tryon.png";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircularIconButton(
            borderColor: borerColor,
            backgroundColor: backgroundColor,
            action: action,
            imagePath: getImagePath()),
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
  final Map<String, dynamic> details;
  const BottomButtonBox({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
              onPressed: () async {
                await FirebaseServices().addProductToCart(details['id']);
                Fluttertoast.showToast(msg: "Product added to cart");
              },
              style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.purple),
                  shape: RoundedRectangleBorder(
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
              onPressed: () async {
                await FirebaseServices()
                    .addSingleItemToOrders(details['id'], false);
                Fluttertoast.showToast(msg: "Order Placed");
              },
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

class SocialGroupBottomsheet extends StatefulWidget {
  final Map<String, dynamic> details;
  const SocialGroupBottomsheet({super.key, required this.details});

  @override
  State<SocialGroupBottomsheet> createState() => _SocialGroupBottomsheetState();
}

class _SocialGroupBottomsheetState extends State<SocialGroupBottomsheet> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: isLoading
          ? LoadingWidget()
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(FirebaseServices.getUserId())
                  .collection("groups")
                  .snapshots(),
              builder: (context, snapshot) {
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
                  return ListView.builder(
                      itemCount: documents.length,
                      itemBuilder: (context, index) {
                        var data =
                            documents[index].data() as Map<String, dynamic>;
                        var groupId = documents[index].id;
                        return Card(
                            child: ListTile(
                          onTap: () async {
                            setState(() {
                              isLoading = true;
                            });
                            await FirebaseServices.uploadProductToChat(
                                widget.details["id"],
                                FirebaseServices.getUserId(),
                                "product",
                                groupId);
                            setState(() {
                              isLoading = false;
                            });
                            if (!mounted) return;
                            if (context.mounted) {
                              Navigator.of(context).pop();
                            }
                            Fluttertoast.showToast(
                                msg: "Product added to chat");
                          },
                          title: Row(
                            children: [
                              CircleAvatar(
                                radius: 20.0,
                                backgroundImage:
                                    CachedNetworkImageProvider(data["image"]),
                              ),
                              const SizedBox(
                                width: 8.0,
                              ),
                              Text(data["name"]),
                            ],
                          ),
                        ));
                      });
                }
                return const Center(child: Text('No documents found'));
                // return ListView(
                //   shrinkWrap: true,
                //   children: [
                //     Text(
                //       "Groups",
                //       style: TextStyle(
                //           fontSize: 20.0, fontWeight: FontWeight.bold),
                //     ),
                //     SizedBox(
                //       height: 16.0,
                //     ),
                //     Text(
                //       "Tap the group in which you wish to share this product",
                //       style: TextStyle(fontSize: 12.0),
                //     ),
                //     SizedBox(
                //       height: 20.0,
                //     ),
                //     Card(
                //       child: ListTile(
                //         onTap: () async {
                //           setState(() {
                //             isLoading = true;
                //           });
                //           await FirebaseServices.uploadProductToChat(
                //               widget.details["id"],
                //               "fbSH5sqoREa1ZdpK0ShRUUct0mh2",
                //               "product",
                //               "yT2Q2ospLIF09ggC0O74");
                //           setState(() {
                //             isLoading = false;
                //           });
                //           if (!mounted) return;
                //           Navigator.of(context).pop();
                //           Fluttertoast.showToast(msg: "Product added to chat");
                //         },
                //         title: Text("code_squad"),
                //       ),
                //     ),
                //     Card(
                //       child: ListTile(
                //         onTap: () async {
                //           Navigator.of(context).pop();
                //         },
                //         title: Text("Chillers"),
                //       ),
                //     ),
                //     Card(
                //       child: ListTile(
                //         onTap: () async {
                //           Navigator.of(context).pop();
                //         },
                //         title: Text("Sneakerheads"),
                //       ),
                //     ),
                //     const SizedBox(
                //       height: 10.0,
                //     )
                //   ],
                // );
              }),
    );
  }
}

class SellerDetailsBox extends StatelessWidget {
  final Map<String, dynamic> details;
  const SellerDetailsBox({super.key, required this.details});

  Widget getWidgets(Widget head, String subtitle) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        head,
        const SizedBox(
          height: 8.0,
        ),
        Text(
          subtitle,
          style: TextStyle(
              fontSize: 14, color: Colors.black45, fontWeight: FontWeight.w500),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            "Sold by",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),
          const SizedBox(
            height: 22.0,
          ),
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.lightBlue.shade200,
                backgroundImage: CachedNetworkImageProvider(
                    "https://firebasestorage.googleapis.com/v0/b/meesho-dice-9bfa9.appspot.com/o/app_assets%2Fstore.png?alt=media&token=c1187e3c-e656-4014-933d-fcd81ec72c27"),
              ),
              const SizedBox(
                width: 12.0,
              ),
              Text(
                details["seller_details"]["name"],
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(
            height: 20.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              getWidgets(
                  Text(
                    details["seller_details"]["followers"].toString(),
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  "Followers"),
              getWidgets(
                  Text(details["seller_details"]["products"].toString(),
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  "Products"),
              getWidgets(RatingBox(rating: details["seller_details"]["rating"]),
                  "12K ratings"),
            ],
          ),
          const SizedBox(
            height: 20.0,
          )
        ],
      ),
    );
  }
}

class DetailsBox extends StatelessWidget {
  final Map<String, dynamic> details;
  const DetailsBox({super.key, required this.details});

  Widget getKeyValueWidget(String key, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        children: [
          Text(
            "$key:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: 10,
          ),
          Text(value)
        ],
      ),
    );
  }

  List<Widget> getKeyValueList(
      Map<String, dynamic> data, BuildContext context) {
    List<Widget> response = [];
    data.forEach((key, value) {
      if (value is int) {
        value = value.toString();
      }
      response.add(getKeyValueWidget(key, value.toString(), context));
    });
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 10,
          ),
          Text(
            "Product Details",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),
          const SizedBox(
            height: 12.0,
          ),
          Divider(),
          const SizedBox(
            height: 4.0,
          ),
          Text("Highlights",
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
          const SizedBox(
            height: 16.0,
          ),
          Column(
              children:
                  getKeyValueList(details["product_highlights"], context)),
          const SizedBox(
            height: 16.0,
          ),
          Divider(),
          const SizedBox(
            height: 4.0,
          ),
          Text("Additional Details",
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16)),
          const SizedBox(
            height: 16.0,
          ),
          Column(
              children: getKeyValueList(details["additional_details"], context))
        ],
      ),
    );
  }
}
