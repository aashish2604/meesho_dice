import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meesho_dice/repository/firebase.dart';
import 'package:meesho_dice/screens/cart.dart';
import 'package:meesho_dice/screens/social/games.dart';
import 'package:meesho_dice/screens/social/group_cart.dart';
import 'package:meesho_dice/services/theme.dart';
import 'package:meesho_dice/widgets/message.dart';

class SocialArea extends StatefulWidget {
  final Map<String, dynamic> groupSummary;
  final String groupId;
  const SocialArea(
      {super.key, required this.groupId, required this.groupSummary});

  @override
  State<SocialArea> createState() => _SocialAreaState();
}

class _SocialAreaState extends State<SocialArea> {
  String? message;
  final _controller = TextEditingController();

  void sendMessage() async {
    FocusScope.of(context).unfocus();
    await FirebaseServices.uploadMessage(
        FirebaseServices.getUserId(), _controller.text, widget.groupId, "text");
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            CircleAvatar(
              radius: 20.0,
              child: CachedNetworkImage(imageUrl: widget.groupSummary["image"]),
            ),
            SizedBox(
              width: 12.0,
            ),
            Text(
              widget.groupSummary["name"],
              style: appBarTextStyle,
            )
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const GamesScreen()));
              },
              icon: const Icon(
                Icons.videogame_asset_outlined,
                color: Colors.green,
                size: 30,
              )),
          IconButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => GroupShoppingCart(
                          groupId: widget.groupId,
                        )));
              },
              icon: const Icon(
                Icons.add_shopping_cart_sharp,
                color: kMeeshoPurple,
                size: 30.0,
              )),
          const SizedBox(
            width: 20.0,
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
              child: MessagePage(
                  groupId: widget.groupId,
                  senderUid: FirebaseServices.getUserId())),
          Container(
            decoration: const BoxDecoration(color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25)),
                        labelText: 'Type your message here..',
                      ),
                      onChanged: (val) {
                        setState(() {
                          message = val;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    height: 50,
                    child: FloatingActionButton(
                      backgroundColor: kMeeshoPurple,
                      onPressed: () {
                        if (message != null) {
                          sendMessage();
                        } else {
                          Fluttertoast.showToast(msg: "Type something...");
                        }
                      },
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
