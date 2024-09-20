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
            "https://images.unsplash.com/photo-1557862921-37829c790f19?q=80&w=871&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
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
            "https://images.unsplash.com/photo-1557862921-37829c790f19?q=80&w=871&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
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

  Future addProductToCart(int productId) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(getUserId())
        .collection("cart")
        .add({"id": productId});
  }
}
