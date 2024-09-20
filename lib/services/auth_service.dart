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
      String email, String password, String name, double phoneNumber) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
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
