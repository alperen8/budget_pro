import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'SideBar.dart';
import 'mainPage.dart';

class Friends extends StatefulWidget {
  const Friends({Key? key}) : super(key: key);

  @override
  _FriendsState createState() => _FriendsState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;

class _FriendsState extends State<Friends> {
  final List<ElevatedButton> buttonsList = [];

  _FriendsState() {
    print("FRİENDSSS");
    getFriendsAsButton();
  }

  addFriend() async {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Add Friend'),
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
                        hintText: "ID",
                        border: OutlineInputBorder(),
                        labelText: "edit description")),
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
              if (FirebaseFirestore.instance
                          .collection("users")
                          .doc(myController.text) !=
                      null &&
                  myController.text != _auth.currentUser.uid) {
                print("kişi bulundu");
                DocumentReference doc = FirebaseFirestore.instance
                    .collection('users')
                    .doc(myController.text);
                DocumentSnapshot docSnap = await doc.get();
                Map<String, dynamic> data = docSnap.data();
                String name1 = data['userName'];
                Map<String, dynamic> map =
                    Map<String, dynamic>.from(data['friends']);
                DocumentReference doc2 = FirebaseFirestore.instance
                    .collection('users')
                    .doc(_auth.currentUser.uid);
                DocumentSnapshot docSnap2 = await doc2.get();
                Map<String, dynamic> data2 = docSnap2.data();
                Map<String, dynamic> map2 =
                    Map<String, dynamic>.from(data2['friends']);
                String name2 = data2['userName'];
                map.putIfAbsent(_auth.currentUser.uid, () => name2);
                map2.putIfAbsent(myController.text, () => name1);
                print(map);
                print(map2);
                FirebaseFirestore.instance
                    .collection("users")
                    .doc(_auth.currentUser.uid)
                    .update({"friends": map2});
                FirebaseFirestore.instance
                    .collection("users")
                    .doc(myController.text)
                    .update({"friends": map});
              }
              Navigator.pop(context, 'OK');
              myController.text = '';
              getFriendsAsButton();
              Navigator.popUntil(context, ModalRoute.withName('/Main_Page'));
              // ignore: unnecessary_statements
              Navigator.pop;
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Main_Page()));
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Friends()));
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
          buttonsList.add(new ElevatedButton(
              onPressed: () => {removeFriend(value, key)}, child: Text(value)));
        });
      }
    });
  }

  final myController = TextEditingController();
  final myController2 = TextEditingController();

  Future<void> removeFriend(String _name, String value) async {
    String name = _name;
    DocumentReference doc = FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser.uid);
    DocumentSnapshot docSnap = await doc.get();
    Map<String, dynamic> data = docSnap.data();
    Map<String, dynamic> map = Map<String, dynamic>.from(data['friends']);

    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Remove Friend'),
        content: SizedBox(
          width: 150,
          height: 126,
          child: Column(
            children: [
              Text("Are you sure you want to remove $name from your friends?")
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
              map.remove(value);
              FirebaseFirestore.instance
                  .collection("users")
                  .doc(_auth.currentUser.uid)
                  .update({"friends": map});
              DocumentReference doc =
                  FirebaseFirestore.instance.collection('users').doc(value);
              DocumentSnapshot docSnap = await doc.get();
              Map<String, dynamic> data = docSnap.data();
              map = Map<String, dynamic>.from(data['friends']);
              map.remove(_auth.currentUser.uid);
              FirebaseFirestore.instance
                  .collection("users")
                  .doc(_auth.currentUser.uid)
                  .update({"friends": map});

              Navigator.pop(context, 'OK');
              myController.text = '';
              myController2.text = '';
              getFriendsAsButton();
              Navigator.popUntil(context, ModalRoute.withName('/Main_Page'));
              // ignore: unnecessary_statements
              Navigator.pop;
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Main_Page()));
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Friends()));
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
        title: Text("Friends"),
        actions: [
          ElevatedButton(onPressed: addFriend, child: Text("Add Friend"))
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
