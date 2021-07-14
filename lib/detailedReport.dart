import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'SideBar.dart';
import 'edit_expense.dart';
import 'edit_income.dart';
import 'mainPage.dart';
import 'package:pie_chart/pie_chart.dart';

class DetailedReport extends StatefulWidget {
  const DetailedReport({Key? key}) : super(key: key);

  @override
  _DetailedReportState createState() => _DetailedReportState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;

class _DetailedReportState extends State<DetailedReport> {
  Map<String, double> dataMap = {};

  final List<ElevatedButton> expenseButtonsList = [];
  final List<ElevatedButton> incomeButtonsList = [];
  double totalIncome = 100;
  double totalExpense = 344;

  final myController = TextEditingController();
  final myController2 = TextEditingController();
  _DetailedReportState() {
    getExpenseAsButton();
    getIncomesAsButton();
    calculateTotalExpense();
    calculateTotalIncome();
  }

  Future<void> getExpenseAsButton() async {
    expenseButtonsList.clear();
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
          expenseButtonsList.add(new ElevatedButton(
              onPressed: () => {editExpense(key, value)},
              child: Text(key + "  : $value")));
        });
      }
    });
    print(income);
  }

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
              Navigator.popUntil(context, ModalRoute.withName('/MainPage'));
              // ignore: unnecessary_statements
              Navigator.pop;
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Main_Page()));
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DetailedReport()));
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> getIncomesAsButton() async {
    incomeButtonsList.clear();
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
          incomeButtonsList.add(new ElevatedButton(
              onPressed: () => {editIncomes(key, value)},
              child: Text(key + "  : $value")));
        });
      }
    });
    print(income);
  }

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
                  MaterialPageRoute(builder: (context) => DetailedReport()));
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  calculateTotalIncome() async {
    DocumentReference doc = FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser.uid);
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    DocumentSnapshot docSnap = await doc.get();
    Map<String, dynamic> data = docSnap.data();
    Map<String, dynamic> map = Map<String, dynamic>.from(data['income']);
    double income = 0;

    map.forEach((key, value) {
      income = income + value;
    });
    print(income);
    setState(() {
      totalIncome = income.toDouble();
      dataMap['incomes'] = totalIncome;
    });
  }

  calculateTotalExpense() async {
    DocumentReference doc = FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser.uid);
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    DocumentSnapshot docSnap = await doc.get();
    Map<String, dynamic> data = docSnap.data();
    Map<String, dynamic> map = Map<String, dynamic>.from(data['expense']);
    double expense = 0;

    map.forEach((key, value) {
      expense = expense + value;
    });
    print(expense);
    setState(() {
      totalExpense = expense.toDouble();
      dataMap['expenses'] = totalExpense;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    calculateTotalExpense();
    calculateTotalIncome();
    dataMap = {
      "incomes": totalIncome,
      "expenses": totalExpense,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Detailed Report'),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Center(
              child: SizedBox(
                height: 300,
                width: 300,
                child: PieChart(dataMap: dataMap),
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 25,
                ),
                Column(
                  children: [
                    SizedBox(
                        width: 175, child: Wrap(children: incomeButtonsList)),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                        width: 175, child: Wrap(children: expenseButtonsList)),
                  ],
                )
              ],
            ),
          ]),
        ));
  }
}
