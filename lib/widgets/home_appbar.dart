import 'package:flutter/material.dart';
import 'package:meesho_dice/screens/social_area.dart';

class HomeAppbarLeading extends StatelessWidget {
  final String userName;
  const HomeAppbarLeading({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 26,
        ),
        const SizedBox(
          width: 8.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Hello",
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
  List<Widget> getAppBarActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const SocialArea()));
        },
        icon: const Icon(
          Icons.group,
          color: Colors.blue,
        ),
      ),
      IconButton(
        onPressed: () {},
        icon: const Icon(
          Icons.favorite,
          color: Colors.red,
        ),
      ),
      IconButton(
        onPressed: () {},
        icon: const Icon(
          Icons.shopping_cart,
          color: Colors.purple,
        ),
      ),
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
          decoration: InputDecoration(
            hintText: 'Search...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: BorderSide.none,
            ),
            fillColor: Colors.white,
            filled: true,
            prefixIcon: Icon(Icons.search),
          ),
        ));
  }
}
