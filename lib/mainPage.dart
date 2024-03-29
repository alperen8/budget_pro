import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'SideBar.dart';
import 'package:charts_flutter/flutter.dart' as charts;

//14.07.21

//addIncome ve AddExpense çalışmadığında AlertDialog kapanmasın
//UI
//detailed report
//friends
//shared payments

class Main_Page extends StatefulWidget {
  const Main_Page({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<Main_Page> {
  final myController = TextEditingController();
  final myController2 = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  int totalExpense = 0;
  int totalIncome = 0;
  int money = 0;
  double piggyMoney = 0;
  bool showMoney = false;
  var user;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  _MainPageState() {
    refresh();
  }

  void change() {
    setState(() {});
  }

  void refresh() {
    addExpense("Entry", 0);
    addIncome("Entry", 0);
    getMoney();
    getPiggy();
    calculateTotalExpense();
    calculateTotalIncome();
    getUserName();
  }

  VerticalBarLabelChart createChart() {
    return VerticalBarLabelChart(
        VerticalBarLabelChart._createSampleData(totalIncome, totalExpense),
        totalIncome,
        totalExpense,
        true);
  }

  printIncome() async {
    DocumentReference doc = FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser.uid);
    DocumentSnapshot docSnap = await doc.get();
    Map<String, dynamic> data = docSnap.data();
    print(data['income']);
  }

  Future<void> addIncome(String name, double data1) async {
    if (data1 > 0) {
      DocumentReference doc = FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser.uid);
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      DocumentSnapshot docSnap = await doc.get();
      Map<String, dynamic> data = docSnap.data();
      Map<String, dynamic> map = Map<String, dynamic>.from(data['income']);
      map.putIfAbsent(name, () => data1);

      return users
          .doc(_auth.currentUser.uid)
          .update({'income': map})
          .then((value) => print("User Updated"))
          .catchError((error) => print("Failed to update Income: $error"));
    }
  }

  Future<void> getMoney() async {
    DocumentReference doc = FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser.uid);
    DocumentSnapshot docSnap = await doc.get();
    Map<String, dynamic> data = docSnap.data();
    setState(() {
      money = data['money'];
      showMoney = true;
    });
  }

  Future<void> calculateMoney() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser.uid)
        .update({'money': money + totalIncome - totalExpense});
    setState(() {
      money = money + (totalIncome - totalExpense);
      showMoney = true;
    });
  }

  Future<void> addPiggy(double data1) async {
    setState(() {
      piggyMoney = piggyMoney + data1;
      money = (money - data1).toInt();
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser.uid)
        .update({'piggyBank': piggyMoney});
    FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser.uid)
        .update({'money': money});
  }

  Future<void> breakPiggy() async {
    setState(() {
      money = (money + piggyMoney).toInt();
      piggyMoney = 0;
    });
    FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser.uid)
        .update({'piggyBank': 0});
    FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser.uid)
        .update({'money': money});
  }

  Future<void> getPiggy() async {
    DocumentReference doc = FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser.uid);
    DocumentSnapshot docSnap = await doc.get();
    Map<String, dynamic> data = docSnap.data();
    setState(() {
      piggyMoney = data["piggyBank"];
    });
  }

  Future<void> addExpense(String name, double data1) async {
    if (data1 > 0) {
      DocumentReference doc = FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser.uid);
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');
      DocumentSnapshot docSnap = await doc.get();
      Map<String, dynamic> data = docSnap.data();
      Map<String, dynamic> map = Map<String, dynamic>.from(data['expense']);
      map.putIfAbsent(name, () => data1);
      return users
          .doc(_auth.currentUser.uid)
          .update({'expense': map})
          .then((value) => print("User Updated"))
          .catchError((error) => print("Failed to update expense: $error"));
    }
  }

  Future<String> getUserName() async {
    DocumentReference doc = FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser.uid);
    DocumentSnapshot docSnap = await doc.get();
    Map<String, dynamic> data = docSnap.data();
    String name = data["userName"];
    return name;
  }

  Future<void> calculateTotalIncome() async {
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
      totalIncome = income.toInt();
    });

    return users
        .doc(_auth.currentUser.uid)
        .update({'totalIncome': income})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update Income: $error"));
  }

  Future<void> calculateTotalExpense() async {
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
    DocumentReference doc1 = FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser.uid);
    CollectionReference users1 = FirebaseFirestore.instance.collection('users');
    DocumentSnapshot docSnap1 = await doc1.get();
    Map<String, dynamic> data1 = docSnap1.data();
    Map<String, dynamic> map1 =
        Map<String, dynamic>.from(data1['sharedPayments']);
    map1.forEach((key, value) {
      expense = expense + value;
    });
    print(expense);
    setState(() {
      totalExpense = expense.toInt();
    });

    return users
        .doc(_auth.currentUser.uid)
        .update({'totalExpense': expense})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update Income: $error"));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.blue,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Bookkeeper"),
          ],
        ),
      ),
      drawer: SideBar(),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: size.height,
              child: Stack(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.only(top: size.height * 0.4),
                    padding: EdgeInsets.only(top: size.height * 0.10),
                    height: 600,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20))),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 30,
                        ),
                        FloatingActionButton(
                            onPressed: () => showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: Text('Piggy Bank',
                                        textAlign: TextAlign.center),
                                    content: SizedBox(
                                      width: 150,
                                      height: 140,
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: TextField(
                                              textAlign: TextAlign.center,
                                              controller: myController2,
                                              decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: "saved amount"),
                                              keyboardType:
                                                  TextInputType.number,
                                            ),
                                          ),
                                          Text("piggy bank value: $piggyMoney"),
                                          TextButton(
                                              onPressed: () => {
                                                    breakPiggy(),
                                                    Navigator.pop(context)
                                                  },
                                              child: Text("BRAKE THE PIGGY"))
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'Cancel'),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          await addPiggy(
                                              double.parse(myController2.text));
                                          Navigator.pop(context, 'OK');
                                          calculateTotalExpense();
                                          getMoney();

                                          myController.text = '';
                                          myController2.text = '';
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                ),
                            child: Text("piggy bank",
                                textAlign: TextAlign.center)),
                        SizedBox(height: 80),
                        Row(
                          children: [
                            SizedBox(
                              width: 90,
                            ),
                            FloatingActionButton(
                              onPressed: () => showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Add Income'),
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
                                                  border: OutlineInputBorder(),
                                                  labelText:
                                                      "income description")),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: TextField(
                                            controller: myController2,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: "income amount"),
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Cancel'),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await addIncome(myController.text,
                                            double.parse(myController2.text));
                                        calculateTotalIncome();
                                        getMoney();

                                        Navigator.pop(context, 'OK');
                                        calculateTotalIncome();
                                        getMoney();

                                        myController.text = '';
                                        myController2.text = '';
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              ),
                              heroTag: "incomeButton",
                              tooltip: 'decrement',
                              child: Icon(Icons.add),
                            ),
                            SizedBox(
                              width: 100,
                            ),
                            FloatingActionButton(
                              heroTag: "expenseButton",
                              onPressed: () => showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Add Expense'),
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
                                                  border: OutlineInputBorder(),
                                                  labelText:
                                                      "Expense description")),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: TextField(
                                            controller: myController2,
                                            decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: "Expense amount"),
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Cancel'),
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await addExpense(myController.text,
                                            double.parse(myController2.text));
                                        Navigator.pop(context, 'OK');
                                        calculateTotalExpense();
                                        getMoney();

                                        myController.text = '';
                                        myController2.text = '';
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                ),
                              ),
                              tooltip: 'decrement',
                              child: Icon(Icons.remove),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Column(
                              children: [
                                SizedBox(
                                  width: 160,
                                  child: RichText(
                                      text: TextSpan(children: [
                                    TextSpan(
                                        text: 'Your balance is',
                                        style: TextStyle(fontSize: 20)),
                                  ])),
                                ),
                                SizedBox(
                                  width: 160,
                                  child: RichText(
                                      text: TextSpan(children: [
                                    TextSpan(
                                        text: '₺',
                                        style: TextStyle(fontSize: 27)),
                                    TextSpan(text: '$money')
                                  ])),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                SizedBox(
                                    width: 200,
                                    height: 350,
                                    child: createChart()),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class VerticalBarLabelChart extends StatefulWidget {
  final List<charts.Series<OrdinalSales, String>> seriesList;
  final bool animate;
  final int a;
  final int b;

  VerticalBarLabelChart(this.seriesList, this.a, this.b, this.animate) {
    _createSampleData(a, b);
  }

  /// Creates a [BarChart] with sample data and no transition.
  ///
/*
  VerticalBarLabelChart() {
    return new VerticalBarLabelChart(
      _createSampleData(a, b),
      a, b,
      // Disable animations for image tests.
      animate: false,
    );
  }
  */

  // [BarLabelDecorator] will automatically position the label
  // inside the bar if the label will fit. If the label will not fit,
  // it will draw outside of the bar.
  // Labels can always display inside or outside using [LabelPosition].
  //
  // Text style for inside / outside can be controlled independently by setting
  // [insideLabelStyleSpec] and [outsideLabelStyleSpec].
  @override
  _VerticalBarLabelChartState createState() => _VerticalBarLabelChartState();

  /// Create one series with sample hard coded data.
  static List<charts.Series<OrdinalSales, String>> _createSampleData(
      num a, num b) {
    int intIncome = a.toInt();
    int intExpense = b.toInt();

    final data = [
      new OrdinalSales(
          'Income', intIncome, charts.ColorUtil.fromDartColor(Colors.green)),
      new OrdinalSales(
          'Expense', intExpense, charts.ColorUtil.fromDartColor(Colors.red)),
    ];

    return [
      new charts.Series<OrdinalSales, String>(
          id: 'Sales',
          domainFn: (OrdinalSales sales, _) => sales.year,
          measureFn: (OrdinalSales sales, _) => sales.sales,
          colorFn: (OrdinalSales sales, _) => sales.barColor,
          data: data,
          // Set a label accessor to control the text of the bar label.
          labelAccessorFn: (OrdinalSales sales, _) =>
              '\₺${sales.sales.toString()}')
    ];
  }
}

class _VerticalBarLabelChartState extends State<VerticalBarLabelChart> {
  @override
  Widget build(BuildContext context) {
    return new charts.BarChart(
      widget.seriesList,
      animate: widget.animate,
      // Set a bar label decorator.
      // Example configuring different styles for inside/outside:
      //       barRendererDecorator: new charts.BarLabelDecorator(
      //          insideLabelStyleSpec: new charts.TextStyleSpec(...),
      //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),
      barRendererDecorator: new charts.BarLabelDecorator<String>(),
      domainAxis: new charts.OrdinalAxisSpec(),
    );
  }
}

class OrdinalSales {
  final charts.Color barColor;
  final String year;
  final int sales;
  OrdinalSales(this.year, this.sales, this.barColor);
}

/*
DocumentReference doc= FirebaseFirestore.instance.Collection('users').doc('');
DocumentSnapshot docSnap= await doc.get();
Map<String,dynamic>data=docSnap.data();
print(data['name']);
*/
/*
  Future<void> addExpense(double expense1) async {
    DocumentReference doc = FirebaseFirestore.instance
        .collection('users')
        .doc('2ky2fBFlkeRkJskOi3bI');
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    DocumentSnapshot docSnap = await doc.get();
    Map<String, dynamic> data = docSnap.data();
    return users
        .doc('2ky2fBFlkeRkJskOi3bI')
        .update({'expense': data['expense'] + expense1})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update Expense: $error"));
  }
*/
/*
  Future<void> addIncome(double income1) async {
    DocumentReference doc = FirebaseFirestore.instance
        .collection('users')
        .doc('2ky2fBFlkeRkJskOi3bI');
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    DocumentSnapshot docSnap = await doc.get();
    Map<String, dynamic> data = docSnap.data();
    return users
        .doc('2ky2fBFlkeRkJskOi3bI')
        .update({'expense': data['expense'] + income1})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update Income: $error"));
  }
  */
/*                              //showdialog



  TextEditingController controller = TextEditingController();
  Future<void> _showMyDialog() async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('AlertDialog Title'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('This is a demo alert dialog.'),
              Text('Would you like to approve of this message?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Approve'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
*/
