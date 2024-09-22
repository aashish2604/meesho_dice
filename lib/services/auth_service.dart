import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //sign in email
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;
      print(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  //register with email
  Future registerWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      await FirebaseFirestore.instance.collection("users").doc(user!.uid).set({
        "coins": 0,
        "email": email,
        "image":
            "https://firebasestorage.googleapis.com/v0/b/meesho-dice-9bfa9.appspot.com/o/product_images%2Fprofile-removebg-preview.png?alt=media&token=cddd0fc1-a0d5-4e41-840a-85d595f09c85",
        "personalized_offers": [],
        "phone_number": "9876543210",
        "username": name
      });
      print(user!.uid);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password')
        print('Password is weak');
      else if (e.code == 'email-already-in-use')
        print('An account already exists for that email');
    } catch (e) {
      print(e);
    }
  }

  //sign out
  Future signOut() async {
    await _auth.signOut();
  }
}
