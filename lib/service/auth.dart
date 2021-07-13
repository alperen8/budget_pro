import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User> signIn(String email, String password) async {
    var user = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    return user.user;
  }

  signOut() async {
    return await _auth.signOut();
  }

  Future<User> createPerson(String name, String email, String password) async {
    var user = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    DocumentReference doc =
        FirebaseFirestore.instance.collection('users').doc("userCount");
    DocumentSnapshot docSnap = await doc.get();
    Map<String, dynamic> data = docSnap.data();
    int value = data['value'];
    await _firestore
        .collection("users")
        .doc("userCount")
        .update({'value': value + 1});
    await _firestore.collection("users").doc(user.user.uid).set({
      'userName': name,
      'email': email,
      'expense': {},
      'income': {},
      'money': 0,
      'piggyBank': 0,
      'totalExpense': 0,
      'totalIncome': 0,
      'userID': 100 + 5 * value,
      'friends': {},
    });

    return user.user;
  }
}
