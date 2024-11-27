import 'package:firebase_auth/firebase_auth.dart';

class AuthServices{
  //instance of auth
  final FirebaseAuth auth = FirebaseAuth.instance;

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

  //sign out
Future<void> signOut() async{
    return await auth.signOut();
}

}