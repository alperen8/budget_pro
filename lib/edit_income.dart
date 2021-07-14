import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'SideBar.dart';
import 'mainPage.dart';

class EditIncome extends StatefulWidget {
  const EditIncome({Key? key}) : super(key: key);

  @override
  _EditIncomeState createState() => _EditIncomeState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;

class _EditIncomeState extends State<EditIncome> {
  final List<ElevatedButton> buttonsList = [];
  _EditIncomeState() {
    getIncomesAsButton();
  }

  Future<void> getIncomesAsButton() async {
    buttonsList.clear();
    DocumentReference doc = FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser.uid);
    DocumentSnapshot docSnap = await doc.get();
    Map<String, dynamic> data = docSnap.data();
    Map<String, dynamic> map = Map<String, dynamic>.from(data['income']);
    double income = 0;

    map.forEach((key, value) {
      if (key.contains("Entry")) {
      } else {
        setState(() {
          buttonsList.add(new ElevatedButton(
              onPressed: () => {editIncomes(key, value)},
              child: Text(key + " value: $value")));
        });
      }
    });
    print(income);
  }

  final myController = TextEditingController();
  final myController2 = TextEditingController();

  Future<void> editIncomes(String a, double b) async {
    DocumentReference doc = FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser.uid);
    DocumentSnapshot docSnap = await doc.get();
    Map<String, dynamic> data = docSnap.data();
    Map<String, dynamic> map = Map<String, dynamic>.from(data['income']);
    double income = 0;

    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Edit Income'),
        content: SizedBox(
          width: 150,
          height: 126,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: TextField(
                    controller: myController,
                    decoration: InputDecoration(
                        hintText: a,
                        border: OutlineInputBorder(),
                        labelText: "edit description")),
              ),
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: TextField(
                  controller: myController2,
                  decoration: InputDecoration(
                      hintText: b.toString(),
                      border: OutlineInputBorder(),
                      labelText: "edit amount"),
                  keyboardType: TextInputType.number,
                ),
              ),
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
              map.remove(a);
              map.putIfAbsent(
                  myController.text, () => double.parse(myController2.text));
              print(map);
              FirebaseFirestore.instance
                  .collection("users")
                  .doc(_auth.currentUser.uid)
                  .update({"income": map});

              Navigator.pop(context, 'OK');
              myController.text = '';
              myController2.text = '';
              getIncomesAsButton();
              Navigator.popUntil(context, ModalRoute.withName('/MainPage'));
              // ignore: unnecessary_statements
              Navigator.pop;
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Main_Page()));
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EditIncome()));
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
        title: Text("Edit Incomes"),
      ),
      drawer: SideBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: 200, child: Wrap(children: buttonsList)),
          ],
        ),
      ),
    );
  }
}

/*
    return users
        .doc('2ky2fBFlkeRkJskOi3bI')
        .update({'totalIncome': income})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update Income: $error"));
        */
