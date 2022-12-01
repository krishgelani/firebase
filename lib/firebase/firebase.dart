import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<String> signup(String e1, String p1) async {
  // FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  // firebaseAuth.createUserWithEmailAndPassword(email: e1, password: p1);

  try {
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: e1,
      password: p1,
    );
    return "Success";
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
      return "The password provided is too weak.";
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
      return 'The account already exists for that email.';
    }
  }
  return "";
}

Future<String> loginemailpass(String email, String password) async {
  // FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  // firebaseAuth.createUserWithEmailAndPassword(email: e1, password: p1);

  try {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return "Success";
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
      return "No user found for that email.";
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
      return "Wrong password provided for that user.";
    }
  }
  return "";
}

bool checkUser() {
  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    return true;
  }
  return false;
}

void logout() async {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  firebaseAuth.signOut();
  GoogleSignIn googleSignIn = GoogleSignIn();
  await googleSignIn.signOut();
}

Future<bool> googlelogin() async {
  GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  var credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  await firebaseAuth.signInWithCredential(credential);

  // Once signed in, return the UserCredential
  return checkUser();
}

Future<List<String?>> userprofile() async {
  User? user = await FirebaseAuth.instance.currentUser;
  return [
    user!.email,
    user.displayName,
    user.photoURL,
  ];
}

void insertdata(String id, String name, String mobile, String std) {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  CollectionReference collectionReference = firebaseFirestore.collection("Student");

  collectionReference.add({"id": "$id", "name": "$name", "mobile": "$mobile", "std": "$std",})
      .then((value) => print("success"))
      .catchError((error) => print("Error $error"));
}

Stream<QuerySnapshot<Map<String, dynamic>>> readdata() {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  return firebaseFirestore.collection("Student").snapshots();
}

void deleteData(String key){
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  firebaseFirestore.collection("Student").doc("$key").delete();
}


void updateData(String key,String id, String name, String mobile, String std){
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  firebaseFirestore.collection("Student").doc("$key").set({"id": "$id", "name": "$name", "mobile": "$mobile", "std": "$std",});
}