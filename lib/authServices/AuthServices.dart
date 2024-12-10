import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServices{
  //instance of auth
  final FirebaseAuth auth = FirebaseAuth.instance;
  //instance of firestore
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  //sign in
  Future<UserCredential>signInWithEmailPassword(String email, password)
  async {
    try{
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    }on FirebaseAuthException catch(e){
      throw Exception(e.code);
    }
  }
  //register account
  Future<UserCredential>signUpWithEmailPassword(String email, password) async{
    try{
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);


    return userCredential;
    }on FirebaseAuthException catch(e){
      throw Exception(e.code);

    }
  }
  // Sign in with Google
  Future<UserCredential> signInWithGoogle() async {
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

    // Save user info to Firestore
    await firestore.collection('users').doc(userCredential.user?.uid).set({
      'email': userCredential.user?.email,
      'username': googleUser.displayName,
    });

    return userCredential;
  }

  //sign out
Future<void> signOut() async{
    return await auth.signOut();
}

}