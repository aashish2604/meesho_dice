import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meesho_dice/repository/firebase.dart';
import 'package:meesho_dice/screens/product_details.dart';
import 'package:meesho_dice/services/general_functions.dart';
import 'package:meesho_dice/services/theme.dart';
import 'package:meesho_dice/utils/product_data.dart';
import 'package:meesho_dice/widgets/product_box.dart';

class MessagePage extends StatefulWidget {
  final String senderUid, groupId;

  const MessagePage(
      {super.key, required this.groupId, required this.senderUid});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  final chatMessages = FirebaseFirestore.instance.collection('groups');
  final String _currentUid = FirebaseServices.getUserId();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: chatMessages
            .doc(widget.groupId)
            .collection('chats')
            .orderBy('sending_time', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SizedBox(
                  height: 50,
                  width: 50,
                  child: const CircularProgressIndicator()),
            );
          }
          return snapshot.hasData && snapshot.data!.docs.isNotEmpty
              ? ListView(
                  reverse: true,
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot document) {
                    Map<String, dynamic> data =
                        document.data() as Map<String, dynamic>;
                    data.addAll({"doc_id": document.id});
                    bool isMe =
                        (_currentUid == data['sender_uid'] ? true : false);
                    bool isProduct = data['type'] == "product";
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: isMe
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        !isMe
                            ? Padding(
                                padding: EdgeInsets.only(left: 6, top: 10),
                                child: CircleAvatar(
                                  radius: 20.0,
                                  backgroundImage:
                                      NetworkImage(data["sender_image_url"]),
                                ),
                              )
                            : SizedBox(
                                height: 0,
                                width: 0,
                              ),
                        Container(
                          padding: isProduct ? null : const EdgeInsets.all(10),
                          margin: const EdgeInsets.all(8),
                          constraints: const BoxConstraints(maxWidth: 300),
                          decoration: BoxDecoration(
                            borderRadius: isMe
                                ? const BorderRadius.only(
                                    topLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                    bottomLeft: Radius.circular(15))
                                : const BorderRadius.only(
                                    bottomLeft: Radius.circular(15),
                                    topRight: Radius.circular(15),
                                    bottomRight: Radius.circular(15)),
                            color: isMe
                                ? kMeeshoPurple
                                : kMeeshoPurple.withOpacity(0.1),
                          ),
                          child: !isProduct
                              ? Text(
                                  data['message'],
                                  style: TextStyle(
                                      fontSize: 17,
                                      color:
                                          isMe ? Colors.white : Colors.black),
                                )
                              : isMe
                                  ? ProductMessageBoxMe(
                                      productId: data["product_id"],
                                      chatData: data,
                                      groupId: widget.groupId,
                                    )
                                  : ProductMessageBoxNotMe(
                                      productId: data['product_id'],
                                      chatData: data,
                                      groupId: widget.groupId,
                                    ),
                        )
                      ],
                    );
                  }).toList(),
                )
              : const Center(child: Text('Say Hi..'));
        });
  }
}

class ProductMessageBoxMe extends StatelessWidget {
  final int productId;
  final String groupId;
  final Map<String, dynamic> chatData;
  const ProductMessageBoxMe(
      {super.key,
      required this.productId,
      required this.groupId,
      required this.chatData});

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> details =
        productData.singleWhere((element) => element["id"] == productId);
    return Column(
      children: [
        Container(
          height: 210,
          width: 300,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: CachedNetworkImageProvider(
                                details["images"][0])),
                        borderRadius:
                            BorderRadius.only(topLeft: Radius.circular(15.0))),
                    height: 150,
                    width: 150,
                  ),
                  const SizedBox(
                    width: 12.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        details["title_name"],
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14,
                            // fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: [
                          Text(
                            "₹ ${details["price"]}, ",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "${details["discount"].toString()}% off",
                            style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                                color: Colors.white54),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 4.0,
                      ),
                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("groups")
                              .doc(groupId)
                              .collection("chats")
                              .doc(chatData["doc_id"])
                              .collection("likes")
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final data = snapshot.data!.docs;
                              bool isLikedByMe() {
                                for (var i in data) {
                                  if (i.id == FirebaseServices.getUserId()) {
                                    return true;
                                  }
                                }
                                return false;
                              }

                              return Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        FirebaseServices().toggleLikeStatus(
                                            isLikedByMe(),
                                            groupId,
                                            chatData["doc_id"]);
                                      },
                                      icon: isLikedByMe()
                                          ? const Icon(
                                              Icons.favorite,
                                              color: Colors.red,
                                            )
                                          : const Icon(
                                              Icons.favorite_border_outlined)),
                                  Text("${data.length}"),
                                ],
                              );
                            }
                            return const SizedBox(
                              height: 15.0,
                            );
                          }),
                      const SizedBox(
                        height: 4,
                      ),
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
                  )
                ],
              ),
              Container(
                width: 300,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    OutlinedButton(
                        onPressed: () async {
                          await FirebaseServices().addProductToGroupCart(
                              productId, FirebaseServices.getUserId(), groupId);
                          Fluttertoast.showToast(
                              msg: "Product added to group cart");
                        },
                        style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.white, width: 0.5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_shopping_cart,
                              color: Colors.white,
                              size: 20,
                            ),
                            Text(
                              "Add to cart",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            )
                          ],
                        )),
                    const SizedBox(
                      width: 10.0,
                    ),
                    TextButton.icon(
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4))),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetails(details: details)));
                        },
                        label: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.remove_red_eye_outlined,
                              color: kMeeshoPurple,
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Text(
                              "View Details",
                              style:
                                  TextStyle(color: kMeeshoPurple, fontSize: 12),
                            )
                          ],
                        ))
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}

class ProductMessageBoxNotMe extends StatelessWidget {
  final int productId;
  final String groupId;
  final Map<String, dynamic> chatData;
  const ProductMessageBoxNotMe({
    super.key,
    required this.productId,
    required this.groupId,
    required this.chatData,
  });

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> details =
        productData.singleWhere((element) => element["id"] == productId);
    return Column(
      children: [
        Container(
          height: 210,
          width: 300,
          child: Column(
            children: [
              Row(
                children: [
                  const SizedBox(
                    width: 20.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        details["title_name"],
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 14,
                            // fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        children: [
                          Text(
                            "₹ ${details["price"]}, ",
                            style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w600),
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
                      const SizedBox(
                        height: 0.0,
                      ),
                      StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("groups")
                              .doc(groupId)
                              .collection("chats")
                              .doc(chatData["doc_id"])
                              .collection("likes")
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final data = snapshot.data!.docs;
                              bool isLikedByMe() {
                                for (var i in data) {
                                  if (i.id == FirebaseServices.getUserId()) {
                                    return true;
                                  }
                                }
                                return false;
                              }

                              return Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        FirebaseServices().toggleLikeStatus(
                                            isLikedByMe(),
                                            groupId,
                                            chatData["doc_id"]);
                                      },
                                      icon: isLikedByMe()
                                          ? const Icon(
                                              Icons.favorite,
                                              color: Colors.red,
                                            )
                                          : const Icon(
                                              Icons.favorite_border_outlined)),
                                  Text("${data.length}"),
                                ],
                              );
                            }
                            return const SizedBox(
                              height: 15.0,
                            );
                          }),
                      const SizedBox(
                        height: 0,
                      ),
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
                  const Expanded(child: SizedBox()),
                  Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: CachedNetworkImageProvider(
                                details["images"][0])),
                        borderRadius:
                            BorderRadius.only(topRight: Radius.circular(15.0))),
                    height: 150,
                    width: 150,
                  ),
                ],
              ),
              Container(
                width: 300,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton.icon(
                        style: TextButton.styleFrom(
                            backgroundColor: kMeeshoPurple,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4))),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  ProductDetails(details: details)));
                        },
                        label: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.remove_red_eye_outlined,
                              color: Colors.white,
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Text(
                              "View Details",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12),
                            )
                          ],
                        )),
                    const SizedBox(
                      width: 10.0,
                    ),
                    OutlinedButton(
                        onPressed: () async {
                          await FirebaseServices().addProductToGroupCart(
                              productId, FirebaseServices.getUserId(), groupId);
                          Fluttertoast.showToast(
                              msg: "Product added to group cart");
                        },
                        style: OutlinedButton.styleFrom(
                            side: BorderSide(color: kMeeshoPurple, width: 0.5),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_shopping_cart,
                              color: kMeeshoPurple,
                              size: 20,
                            ),
                            Text(
                              "Add to cart",
                              style:
                                  TextStyle(color: kMeeshoPurple, fontSize: 12),
                            )
                          ],
                        )),
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
