import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:se380final/edit_expense.dart';
import 'package:se380final/edit_income.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
String name = "b";

class SideBar extends StatelessWidget {
  Future<String> getUserName() async {
    DocumentReference doc = FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser.uid);
    DocumentSnapshot docSnap = await doc.get();
    Map<String, dynamic> data = docSnap.data();
    String name = data["userName"];
    return name;
  }

  SideBar() {
    getUserName().then((String result) {
      name = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Welcome ' + name,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            title: Text('Edit Incomes'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditIncome()),
              );
            },
          ),
          ListTile(
            title: Text('Edit Expenses'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditExpense()),
              );
            },
          ),
          ListTile(
            title: Text('Detailed Report'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Shared payments'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('Friends'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
