import 'package:flutter/material.dart';
import 'package:se380final/edit_expense.dart';
import 'package:se380final/edit_income.dart';

class SideBar extends StatelessWidget {
  const SideBar({
    Key? key,
  }) : super(key: key);

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
              'Extra Options',
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
