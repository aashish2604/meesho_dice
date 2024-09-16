import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meesho_dice/repository/firebase.dart';
import 'package:meesho_dice/screens/games.dart';
import 'package:meesho_dice/services/theme.dart';
import 'package:meesho_dice/widgets/message.dart';

class SocialArea extends StatefulWidget {
  const SocialArea({super.key});

  @override
  State<SocialArea> createState() => _SocialAreaState();
}

class _SocialAreaState extends State<SocialArea> {
  String? message;
  final _controller = TextEditingController();

  void sendMessage() async {
    FocusScope.of(context).unfocus();
    await FirebaseServices.uploadMessage("fbSH5sqoREa1ZdpK0ShRUUct0mh2",
        _controller.text, "yT2Q2ospLIF09ggC0O74", "text");
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            CircleAvatar(
              radius: 20.0,
            ),
            SizedBox(
              width: 12.0,
            ),
            Text(
              "code_squad",
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
              icon: Icon(
                Icons.videogame_asset_outlined,
                color: Colors.green,
                size: 30,
              )),
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.add_shopping_cart_sharp,
                color: Colors.purple,
                size: 30.0,
              )),
          const SizedBox(
            width: 20.0,
          )
        ],
      ),
      body: Column(
        children: [
          const Expanded(
              child: MessagePage(
                  groupId: "yT2Q2ospLIF09ggC0O74",
                  senderUid: "fbSH5sqoREa1ZdpK0ShRUUct0mh2")),
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
                      backgroundColor: Colors.purple,
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
