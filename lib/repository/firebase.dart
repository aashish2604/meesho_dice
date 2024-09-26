import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServices {
  static Future? uploadMessage(
      String senderUid, String message, String groupId, String type) async {
    try {
      CollectionReference messages = FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .collection("chats");
      await messages.add({
        'sender_image_url':
            "https://firebasestorage.googleapis.com/v0/b/meesho-dice-9bfa9.appspot.com/o/product_images%2Fprofile-removebg-preview.png?alt=media&token=cddd0fc1-a0d5-4e41-840a-85d595f09c85",
        'type': type,
        'sender_uid': senderUid,
        'message': message,
        'sending_time': DateTime.now(),
      });
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  static Future? uploadProductToChat(
      int productId, String senderId, String type, String groupId) async {
    try {
      CollectionReference messages = FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .collection("chats");
      await messages.add({
        'sender_image_url':
            "https://firebasestorage.googleapis.com/v0/b/meesho-dice-9bfa9.appspot.com/o/product_images%2Fprofile-removebg-preview.png?alt=media&token=cddd0fc1-a0d5-4e41-840a-85d595f09c85",
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
}
