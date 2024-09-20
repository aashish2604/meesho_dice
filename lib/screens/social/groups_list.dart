import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:meesho_dice/repository/firebase.dart';
import 'package:meesho_dice/screens/social/social_area.dart';
import 'package:meesho_dice/services/theme.dart';
import 'package:meesho_dice/widgets/loading.dart';

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
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseServices.getUserId())
              .collection("groups")
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
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                child: ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      var data =
                          documents[index].data() as Map<String, dynamic>;
                      return Card(
                          child: ListTile(
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SocialArea(
                                      groupId: documents[index].id,
                                      groupSummary: data,
                                    ))),
                        title: Row(
                          children: [
                            CircleAvatar(
                              radius: 20.0,
                              child:
                                  CachedNetworkImage(imageUrl: data["image"]),
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            Text(data["name"]),
                          ],
                        ),
                      ));
                    }),
              );
            }
            return const Center(child: Text('No documents found'));
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }
}
