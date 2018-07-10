import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = new GoogleSignIn();

Future<bool> signOut() async {
  await _auth.signOut();
  return true;
}

Future<Null> ensureLoggedIn() async {
  FirebaseUser firebaseUser = await _auth.currentUser();
  assert(firebaseUser != null);
  assert(firebaseUser.isAnonymous == false);
  print('We are logged into Firebase');
}

Future<bool> signInGoogle() async {
  GoogleSignInAccount googleUser = await _googleSignIn.signIn();
  GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  final FirebaseUser user = await _auth.signInWithGoogle(idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

  if(user != null && user.isAnonymous == false) {
    return true;
  }

  return false;
}

Future<String> username() async {
  await ensureLoggedIn();
  FirebaseUser firebaseuser = await _auth.currentUser();
  return firebaseuser.uid;
}