import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meesho_dice/services/notification_services.dart';

class FirebaseServices {
  Future? uploadMessage(
      String senderUid, String message, String groupId, String type) async {
    try {
      CollectionReference messages = FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .collection("chats");
      final userDetails = await getUserDetails();
      print(userDetails);
      await messages.add({
        'sender_image_url': userDetails!['image'],
        'type': type,
        'sender_uid': senderUid,
        'message': message,
        'sending_time': DateTime.now(),
      });
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  Future? uploadProductToChat(
      int productId, String senderId, String type, String groupId) async {
    try {
      CollectionReference messages = FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .collection("chats");
      final userDetails = await getUserDetails();
      await messages.add({
        'sender_image_url': userDetails!['image'],
        'type': type,
        'sender_uid': senderId,
        'product_id': productId,
        'sending_time': DateTime.now(),
      });
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  Future<Map<String, dynamic>?> getUserDetails() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    final userData =
        await FirebaseFirestore.instance.collection("users").doc(userId).get();
    return userData.data();
  }

  static String getUserId() {
    return FirebaseAuth.instance.currentUser!.uid;
  }

  Future removeProductFromCart(String docId) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(getUserId())
        .collection("cart")
        .doc(docId)
        .delete();
  }

  Future removeProductFromGroupCart(String groupId, String docId) async {
    await FirebaseFirestore.instance
        .collection("groups")
        .doc(groupId)
        .collection("cart")
        .doc(docId)
        .delete();
  }

  Future addProductToCart(int productId) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(getUserId())
        .collection("cart")
        .add({"id": productId});
  }

  Future addProductToGroupCart(
      int productId, String adderId, String groupId, int noOfLikes) async {
    final userDetails = await getUserDetails();
    await FirebaseFirestore.instance
        .collection("groups")
        .doc(groupId)
        .collection("cart")
        .add({
      "id": productId,
      "adder_id": adderId,
      "adder_name": userDetails!["username"],
      "no_of_likes": noOfLikes
    });
    print("something");
  }

  Future toggleLikeStatus(
      bool currentStatus, String groupId, String chatId) async {
    if (currentStatus) {
      await FirebaseFirestore.instance
          .collection("groups")
          .doc(groupId)
          .collection("chats")
          .doc(chatId)
          .collection("likes")
          .doc(getUserId())
          .delete();
    } else {
      await FirebaseFirestore.instance
          .collection("groups")
          .doc(groupId)
          .collection("chats")
          .doc(chatId)
          .collection("likes")
          .doc(getUserId())
          .set({});
    }
  }

  Future addSingleItemToOrders(int productId, bool isGroupCartOrder) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(getUserId())
        .collection("orders")
        .add({
      "timestamp": DateTime.now(),
      "product_id": productId,
      "is_group_cart_order": isGroupCartOrder
    });
  }

  Future placeOrderFromGroupCart(
      List<QueryDocumentSnapshot<Object?>> documents, String groupId) async {
    for (var doc in documents) {
      final docData = doc.data() as Map<String, dynamic>;
      if (getUserId() == docData["adder_id"]) {
        await addSingleItemToOrders(docData["id"], true);
        await removeProductFromGroupCart(groupId, doc.id);
      }
    }
  }

  Future placeOrderFromCart(
      List<QueryDocumentSnapshot<Object?>> documents) async {
    for (var doc in documents) {
      final docData = doc.data() as Map<String, dynamic>;
      await addSingleItemToOrders(docData["id"], false);
      await removeProductFromCart(doc.id);
    }
  }

  Future updateDeviceTokenForUser(String token) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseServices.getUserId())
        .update({"device_token": token});
  }

  Future<String> createNewGroup(String groupName, String groupIconUrl) async {
    final response = await FirebaseFirestore.instance
        .collection('groups')
        .add({'image': groupIconUrl, 'name': groupName});
    final docId = response.id;
    final currentUserDetails = await getUserDetails();
    await FirebaseFirestore.instance
        .collection('groups')
        .doc(docId)
        .collection('members')
        .add({
      'is_admin': true,
      'image_url': currentUserDetails!['image'],
      'name': currentUserDetails['username'],
      'uid': getUserId(),
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(getUserId())
        .collection('groups')
        .doc(docId)
        .set({'image': groupIconUrl, 'name': groupName});
    return docId;
  }

  Future sendInvites(List<String> deviceTokens, String groupName,
      String groupId, String groupIcon, String senderName) async {
    for (var deviceToken in deviceTokens) {
      await NotificationServices().sendTokenNotification(deviceToken,
          "Group Invite for $groupName", "Click to perform action", {
        'group_id': groupId,
        'group_name': groupName,
        'group_icon': groupIcon,
        'sender_name': senderName,
      });
    }
  }

  Future<String> uploadFile({required File parcel}) async {
    try {
      final fileName = parcel.path.split('/').last;
      Reference destination =
          FirebaseStorage.instance.ref().child('group_icons/$fileName');
      await destination.putFile(parcel);
      return await destination.getDownloadURL();
    } on FirebaseException catch (e) {
      Fluttertoast.showToast(msg: e.toString());
      return '';
    }
  }

  Future acceptInvite(
      String groupId, String groupName, String groupIcon) async {
    final userDetails = await getUserDetails();
    await FirebaseFirestore.instance
        .collection('groups')
        .doc(groupId)
        .collection('members')
        .add({
      'is_admin': false,
      'image_url': userDetails!['image'],
      'name': userDetails['username'],
      'uid': getUserId(),
    });
    await FirebaseFirestore.instance
        .collection('users')
        .doc(getUserId())
        .collection('groups')
        .doc(groupId)
        .set({'image': groupIcon, 'name': groupName});
  }
}
