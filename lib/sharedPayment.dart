import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'SideBar.dart';
import 'mainPage.dart';

class SharedPayments extends StatefulWidget {
  const SharedPayments({Key? key}) : super(key: key);

  @override
  _SharedPaymentsState createState() => _SharedPaymentsState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;

class _SharedPaymentsState extends State<SharedPayments> {
  final List<ElevatedButton> buttonsList = [];
  final List<ElevatedButton> friendsButtonsList = [];
  String chosenFriend = "1";

  Map<String, dynamic> friendMap = {};

  _SharedPaymentsState() {
    getSharedPaymentsAsButton();
    getFriendsAsButton();
  }

  addSharedPayment() async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Add payment'),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SizedBox(
              width: 200,
              height: 175,
              child: Column(
                children: [
                  SizedBox(
                      width: 400, child: Wrap(children: friendsButtonsList)),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: TextField(
                        controller: myController,
                        decoration: InputDecoration(
                            hintText: "description",
                            border: OutlineInputBorder(),
                            labelText: "Description")),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: TextField(
                        controller: myController2,
                        decoration: InputDecoration(
                            hintText: "amount",
                            border: OutlineInputBorder(),
                            labelText: "Amount")),
                  ),
                ],
              ),
            );
          },
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              DocumentReference doc = FirebaseFirestore.instance
                  .collection('users')
                  .doc(_auth.currentUser.uid);
              DocumentSnapshot docSnap = await doc.get();
              Map<String, dynamic> data = docSnap.data();
              Map<String, dynamic> map =
                  Map<String, dynamic>.from(data['sharedPayments']);
              double amount = double.parse(myController2.text);
              map.putIfAbsent(myController.text, () => (amount / 2));

              DocumentReference doc2 = FirebaseFirestore.instance
                  .collection('users')
                  .doc(chosenFriend);
              DocumentSnapshot docSnap2 = await doc2.get();
              Map<String, dynamic> data2 = docSnap2.data();
              Map<String, dynamic> map2 =
                  Map<String, dynamic>.from(data2['sharedPayments']);
              map2.putIfAbsent(myController.text, () => (amount / 2));

              print(map2);
              FirebaseFirestore.instance
                  .collection("users")
                  .doc(_auth.currentUser.uid)
                  .update({"sharedPayments": map});
              FirebaseFirestore.instance
                  .collection("users")
                  .doc(chosenFriend)
                  .update({"sharedPayments": map2});

              Navigator.pop(context, 'OK');
              myController.text = '';
              myController2.text = '';
              getSharedPaymentsAsButton();
              Navigator.popUntil(context, ModalRoute.withName('/Main_Page'));
              // ignore: unnecessary_statements
              Navigator.pop;
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Main_Page()));
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SharedPayments()));
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> getFriendsAsButton() async {
    buttonsList.clear();
    DocumentReference doc = FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser.uid);
    DocumentSnapshot docSnap = await doc.get();
    Map<String, dynamic> data = docSnap.data();
    Map<String, dynamic> map = Map<String, dynamic>.from(data['friends']);
    print(map);

    map.forEach((key, value) {
      if (key.contains("Entry")) {
      } else {
        setState(() {
          friendsButtonsList.add(new ElevatedButton(
              onPressed: () => {getID(key)}, child: Text(value)));
        });
      }
    });
  }

  getID(String key) {
    setState(() {
      chosenFriend = key;
    });
  }

  Future<void> getSharedPaymentsAsButton() async {
    buttonsList.clear();
    DocumentReference doc = FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser.uid);
    DocumentSnapshot docSnap = await doc.get();
    Map<String, dynamic> data = docSnap.data();
    Map<String, dynamic> map =
        Map<String, dynamic>.from(data['sharedPayments']);
    print(map);

    map.forEach((key, value) {
      if (key.contains("Entry")) {
      } else {
        setState(() {
          buttonsList.add(new ElevatedButton(
              onPressed: () => {removeSharedPayments(key, value)},
              child: Text(key + ': ' + value.toString())));
        });
      }
    });
  }

  final myController = TextEditingController();
  final myController2 = TextEditingController();

  Future<void> removeSharedPayments(String key2, double value2) async {
    DocumentReference doc = FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser.uid);
    DocumentSnapshot docSnap = await doc.get();
    Map<String, dynamic> data = docSnap.data();
    Map<String, dynamic> map =
        Map<String, dynamic>.from(data['sharedPayments']);

    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Remove payment'),
        content: SizedBox(
          width: 150,
          height: 126,
          child: Column(
            children: [
              Text("Are you sure you want to remove this shared payment?")
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              map.remove(key2);
              FirebaseFirestore.instance
                  .collection("users")
                  .doc(_auth.currentUser.uid)
                  .update({"sharedPayments": map});
              DocumentReference doc = FirebaseFirestore.instance
                  .collection('users')
                  .doc(_auth.currentUser.uid);
              DocumentSnapshot docSnap = await doc.get();
              Map<String, dynamic> data = docSnap.data();
              map = Map<String, dynamic>.from(data['friends']);
              print("printing map!");
              print(map);
              map.forEach((key, value) async {
                DocumentReference doc3 =
                    FirebaseFirestore.instance.collection('users').doc(key);
                DocumentSnapshot docSnap3 = await doc3.get();
                Map<String, dynamic> data3 = docSnap3.data();
                Map<String, dynamic> map3 =
                    Map<String, dynamic>.from(data3['sharedPayments']);
                print("printing 2. map!");
                print(map3);
                map3.remove(key2);

                FirebaseFirestore.instance
                    .collection("users")
                    .doc(key)
                    .update({"sharedPayments": map3});
              });

              Navigator.pop(context, 'OK');
              myController.text = '';
              myController2.text = '';
              getFriendsAsButton();
              Navigator.popUntil(context, ModalRoute.withName('/Main_Page'));
              // ignore: unnecessary_statements
              Navigator.pop;
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Main_Page()));
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SharedPayments()));
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Shared Payments"),
        actions: [
          ElevatedButton(
              onPressed: addSharedPayment, child: Text("Add Payment"))
        ],
      ),
      drawer: SideBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 400, child: Wrap(children: buttonsList)),
          ],
        ),
      ),
    );
  }
}
