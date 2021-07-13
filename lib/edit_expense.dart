import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'SideBar.dart';

class EditExpense extends StatefulWidget {
  const EditExpense({Key? key}) : super(key: key);

  @override
  _EditIncomeState createState() => _EditIncomeState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;

class _EditIncomeState extends State<EditExpense> {
  final List<ElevatedButton> buttonsList = [];
  _EditIncomeState() {
    getExpenseAsButton();
  }

  Future<void> getExpenseAsButton() async {
    buttonsList.clear();
    DocumentReference doc = FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser.uid);
    DocumentSnapshot docSnap = await doc.get();
    Map<String, dynamic> data = docSnap.data();
    Map<String, dynamic> map = Map<String, dynamic>.from(data['expense']);
    double income = 0;

    map.forEach((key, value) {
      if (key.contains("Entry")) {
      } else {
        setState(() {
          buttonsList.add(new ElevatedButton(
              onPressed: () => {editExpense(key, value)},
              child: Text(key + " value: $value")));
        });
      }
    });
    print(income);
  }

  final myController = TextEditingController();
  final myController2 = TextEditingController();

  Future<void> editExpense(String a, double b) async {
    DocumentReference doc = FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser.uid);
    DocumentSnapshot docSnap = await doc.get();
    Map<String, dynamic> data = docSnap.data();
    Map<String, dynamic> map = Map<String, dynamic>.from(data['expense']);
    double expense = 0;

    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Edit Expense'),
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
              print("geldim");
              print(a);
              map.remove(a);
              map.putIfAbsent(
                  myController.text, () => double.parse(myController2.text));
              print(map);
              FirebaseFirestore.instance
                  .collection("users")
                  .doc(_auth.currentUser.uid)
                  .update({"expense": map});

              Navigator.pop(context, 'OK');
              myController.text = '';
              myController2.text = '';
              getExpenseAsButton();
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
        title: Text("Edit Expense"),
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
