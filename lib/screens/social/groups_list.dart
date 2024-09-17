import 'package:flutter/material.dart';
import 'package:meesho_dice/screens/social/social_area.dart';
import 'package:meesho_dice/services/theme.dart';

class SocialGroupList extends StatelessWidget {
  const SocialGroupList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Groups",
          style: appBarTextStyle,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: ListView(
          children: [
            Card(
                child: ListTile(
              onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SocialArea())),
              title: Row(
                children: [
                  CircleAvatar(
                    radius: 20.0,
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Text("code_squad"),
                ],
              ),
            )),
            Card(
                child: ListTile(
              title: Row(
                children: [
                  CircleAvatar(
                    radius: 20.0,
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Text("Chillers"),
                ],
              ),
            )),
            Card(
                child: ListTile(
              title: Row(
                children: [
                  CircleAvatar(
                    radius: 20.0,
                  ),
                  const SizedBox(
                    width: 8.0,
                  ),
                  Text("Sneakerheads"),
                ],
              ),
            )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}
