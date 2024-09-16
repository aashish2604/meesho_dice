import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meesho_dice/screens/games.dart';

class SocialArea extends StatelessWidget {
  const SocialArea({super.key});

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
            const SizedBox(
              width: 12.0,
            ),
            Text(
              "group_name",
              style: TextStyle(fontSize: 16, overflow: TextOverflow.ellipsis),
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
        children: [Text("something")],
      ),
    );
  }
}
