import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../RegisterPages/registerPage.dart';

class AuthServices {
  // Instance of FirebaseAuth
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Instance of FirebaseFirestore
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Sign in with email and password
  Future<UserCredential> signInWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Merge user info into Firestore to avoid overwriting existing fields
      await firestore.collection('users').doc(userCredential.user?.uid).set({
        'email': userCredential.user?.email,
      }, SetOptions(merge: true)); // Use merge to preserve existing fields

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Register account with email and password
  Future<UserCredential> signUpWithEmailPassword(String email, String password) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Save user info to Firestore with default username
      await firestore.collection('users').doc(userCredential.user?.uid).set({
        'email': userCredential.user?.email,
        'username': 'New User', // Default username for new users
      }, SetOptions(merge: true)); // Use merge to preserve existing fields

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  // Register with Google (Prevent login if user already exists)
  Future<UserCredential> registerWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      throw Exception('Google sign-in canceled');
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential = await auth.signInWithCredential(credential);

    // Check if user data already exists in Firestore
    final userDoc = firestore.collection('users').doc(userCredential.user?.uid);
    final docSnapshot = await userDoc.get();

    if (docSnapshot.exists) {
      // Stop the process and sign the user out
      await auth.signOut();
      await RegisterPage(onTap: () {},);
      throw Exception('User already exists. Please login instead.');
    }

    // Save user info to Firestore if it doesn't exist
    await userDoc.set({
      'email': userCredential.user?.email,
      'username': googleUser.displayName ?? 'Anonymous',
    }, SetOptions(merge: true)); // Use merge to preserve existing fields

    return userCredential;
  }

  // Login with Google (Do NOT Save Data to Firestore)
  Future<UserCredential> loginWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      throw Exception('Google sign-in canceled');
    }

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Authenticate the user without saving data
    UserCredential userCredential = await auth.signInWithCredential(credential);

    return userCredential;
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await auth.signOut();
      print('User logged out successfully');
    } catch (e) {
      throw Exception('Failed to log out: $e');
    }
  }

  // Get Current User
  User? getCurrentUser() {
    return auth.currentUser;
  }
}
