import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meesho_dice/repository/firebase.dart';
import 'package:meesho_dice/services/theme.dart';
import 'package:meesho_dice/widgets/loading.dart';

class InviteNotificationPage extends StatefulWidget {
  final RemoteMessage message;
  const InviteNotificationPage({
    super.key,
    required this.message,
  });

  @override
  State<InviteNotificationPage> createState() => _InviteNotificationPageState();
}

class _InviteNotificationPageState extends State<InviteNotificationPage> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Group Invite",
            style: appBarTextStyle,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: !isLoading
                    ? Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: CachedNetworkImageProvider(
                                widget.message.data['group_icon']),
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          Text(
                            widget.message.data['group_name'],
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                              '${widget.message.data['sender_name']} has inviited you to join this group'),
                          const SizedBox(
                            height: 16.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Decline',
                                    style: TextStyle(color: Colors.red),
                                  )),
                              const SizedBox(
                                width: 16,
                              ),
                              TextButton(
                                  onPressed: () {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    final firebaseServices = FirebaseServices();
                                    firebaseServices.acceptInvite(
                                        widget.message.data['group_id'],
                                        widget.message.data['group_name'],
                                        widget.message.data['group_icon']);
                                    setState(() {
                                      isLoading = false;
                                    });
                                    Fluttertoast.showToast(
                                        msg: 'Added to group successfully');
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    'Accept',
                                    style: TextStyle(color: Colors.green),
                                  ))
                            ],
                          )
                        ],
                      )
                    : const Center(
                        child: LoadingWidget(),
                      ),
              ),
            ),
          ),
        ));
  }
}


//  Text(message.data.toString()),
//             Text(message.notification!.title!),
//             Text(message.notification!.body!)