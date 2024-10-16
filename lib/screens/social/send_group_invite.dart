import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meesho_dice/repository/firebase.dart';
import 'package:meesho_dice/services/theme.dart';
import 'package:meesho_dice/widgets/loading.dart';

class SendGroupInvite extends StatelessWidget {
  final String groupName;
  final String groupDescription;
  final String groupIconUrl;
  const SendGroupInvite(
      {super.key,
      required this.groupName,
      required this.groupDescription,
      required this.groupIconUrl});

  @override
  Widget build(BuildContext context) {
    List<String> getDeviceTokens(List<QueryDocumentSnapshot<Object?>> documents,
        List<bool> userSelectionStatus) {
      List<String> deviceTokens = [];
      for (int i = 0; i < documents.length; i++) {
        if (userSelectionStatus[i]) {
          final userDetails = documents[i].data() as Map<String, dynamic>;
          deviceTokens.add(userDetails['device_token']);
        }
      }
      return deviceTokens;
    }

    bool isLoading = false;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Send Invites",
          style: appBarTextStyle,
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
              String senderName = '';
              final documents = snapshot.data!.docs;
              final userTiles = <bool>[];
              for (var doc in documents) {
                userTiles.add(false);
              }
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                child:
                    StatefulBuilder(builder: (context, StateSetter setState) {
                  if (isLoading == true) {
                    return const LoadingWidget();
                  }
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      ListView.builder(
                          itemCount: documents.length,
                          itemBuilder: (context, index) {
                            var data =
                                documents[index].data() as Map<String, dynamic>;
                            if (documents[index].id ==
                                FirebaseServices.getUserId()) {
                              senderName = data['username'];
                              return const SizedBox.shrink();
                            }
                            return Card(
                                child: CheckboxListTile(
                              value: userTiles[index],
                              selected: userTiles[index],
                              onChanged: (val) {
                                setState(() {
                                  userTiles[index] = val!;
                                });
                              },
                              title: Text(data['username']),
                              subtitle: Text(data['email']),
                              secondary: CircleAvatar(
                                radius: 20.0,
                                backgroundImage:
                                    CachedNetworkImageProvider(data["image"]),
                              ),
                            ));
                          }),
                      Positioned(
                          bottom: 20,
                          child: TextButton(
                              onPressed: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                final firebaseServices = FirebaseServices();
                                final groupId = await firebaseServices
                                    .createNewGroup(groupName, groupIconUrl);
                                FirebaseServices().sendInvites(
                                    getDeviceTokens(documents, userTiles),
                                    groupName,
                                    groupId,
                                    groupIconUrl,
                                    senderName);
                                setState(() {
                                  isLoading = false;
                                });
                                if (!context.mounted) return;
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                              style: TextButton.styleFrom(
                                  backgroundColor: Colors.purple),
                              child: const Text(
                                "Create Group",
                                style: TextStyle(color: Colors.white),
                              )))
                    ],
                  );
                }),
              );
            }
            return const Center(child: Text('No documents found'));
          }),
    );
  }
}
