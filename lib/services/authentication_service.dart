import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get onAuthStateChanged {
    return _auth.authStateChanges();
  }

  Future<String?> signInWithEmail(String email, String password) async {
    try {
      print("entered");
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid_email':
          {
            return "Input email address is invalid";
          }
        case 'user-disabled':
          {
            return "Disabled account";
          }
        case 'wrong-password':
          {
            return "Incorrect password";
          }
        case 'user-not-found':
          {
            return "You are not registered. Please sign up first.";
          }
      }
    }
    return null;
  }

  Future<String?> signUpWithEmail(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          {
            return "User already registered";
          }
        case 'invalid-email':
          {
            return "Invalid email address";
          }
        case 'weak-password':
          {
            return "Weak password";
          }
      }
    }
    return null;
  }
}
