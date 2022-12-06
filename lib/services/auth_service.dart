// ignore_for_file: unnecessary_null_comparison

import 'package:chatapp/helper/HelperFunction.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'database_services.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  // Login
  Future loginUser(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        // call our database service to update the user data.
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Register
  Future registerUser(String fullName, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        // call our database service to update the user data.
        await DatabaseService(uid: user.uid).saveUserData(fullName, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // Sign out
  Future signOut() async {
    try {
      await HelperFunction.saveUserLoggedInKey(false);
      await HelperFunction.saveUserEmailKey("");
      await HelperFunction.saveUserNameKey("");
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}
