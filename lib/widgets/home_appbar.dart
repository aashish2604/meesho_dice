import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meesho_dice/repository/firebase.dart';
import 'package:meesho_dice/screens/cart.dart';
import 'package:meesho_dice/screens/social/groups_list.dart';
import 'package:meesho_dice/screens/social/social_area.dart';
import 'package:meesho_dice/screens/wishlist.dart';
import 'package:meesho_dice/services/theme.dart';

class HomeAppbarLeading extends StatelessWidget {
  final String userName;
  final String userImage;
  const HomeAppbarLeading(
      {super.key, required this.userName, required this.userImage});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 26,
          backgroundImage:
              userImage == "" ? null : CachedNetworkImageProvider(userImage),
        ),
        const SizedBox(
          width: 8.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello,",
              style: TextStyle(fontSize: 16.0),
            ),
            Text(
              userName,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0),
            )
          ],
        )
      ],
    );
  }
}

class HomeAppbarTrailing {
  Widget getDialogTitle(int noOfCoins) {
    if (noOfCoins == 0)
      return const Text("Hmm...no Meesho Coins",
          textAlign: TextAlign.center, style: TextStyle(fontSize: 20.0));
    return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: [
          TextSpan(
              text: "You have ",
              style: TextStyle(fontSize: 20.0, color: Colors.black)),
          TextSpan(
              text: noOfCoins.toString(),
              style: TextStyle(fontSize: 20.0, color: Colors.orange)),
          TextSpan(
              text: " Meesho Coins",
              style: TextStyle(fontSize: 20.0, color: Colors.black))
        ]));
  }

  Widget getDialogContent(int noOfCoins) {
    if (noOfCoins == 0)
      return const Text(
          "No need to worry! Simply make purchases and engage in activities to rack up coins, unlocking exclusive rewards just for you! 🛒💸 The more you participate, the more you win! 🎁✨");
    return const Text(
        "Awesome so far! 🎉 Keep exploring the app and make more purchases to boost your coin count! 🛍️ The more you engage, the faster your rewards grow! 🚀🌟");
  }

  List<Widget> getAppBarActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const SocialGroupList()));
        },
        icon: Image.asset(height: 34, "assets/images/icons8-users-94.png"),
      ),
      IconButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => const Wishlist()));
        },
        icon: const Icon(
          Icons.favorite,
          color: Colors.red,
        ),
      ),
      IconButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const ShoppingCart(
                    isGroupCart: false,
                  )));
        },
        icon: const Icon(
          Icons.shopping_cart,
          color: Colors.purple,
        ),
      ),
      StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseServices.getUserId())
              .snapshots(),
          builder: (context, snapshot) {
            return Stack(
              children: [
                IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            backgroundColor: Colors.white,
                            icon: Image.asset(
                                height: 100, "assets/images/coin.png"),
                            title: snapshot.hasData
                                ? getDialogTitle((snapshot.data!.data()
                                    as Map<String, dynamic>)["coins"])
                                : const Text("Some error occured !!!"),
                            content: getDialogContent((snapshot.data!.data()
                                as Map<String, dynamic>)["coins"]),
                          );
                        });
                  },
                  icon: Image.asset(height: 26, "assets/images/coin.png"),
                ),
                Positioned(
                    right: 3,
                    top: 0,
                    child: CircleAvatar(
                      radius: 10,
                      backgroundColor: Colors.yellow,
                      child: Text(
                        snapshot.hasData
                            ? ((snapshot.data!.data()
                                    as Map<String, dynamic>)["coins"]
                                .toString())
                            : "0",
                        style: TextStyle(fontSize: 10),
                      ),
                    ))
              ],
            );
          }),
      const SizedBox(
        width: 12.0,
      )
    ];
  }
}

class HomeAppbarSearch extends StatelessWidget {
  const HomeAppbarSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          readOnly: true,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(0),
            hintText: 'Search...',
            hintStyle:
                TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
            fillColor: Colors.white,
            filled: true,
            prefixIcon: Icon(
              Icons.search,
              color: Colors.grey,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(16.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
        ));
  }
}
