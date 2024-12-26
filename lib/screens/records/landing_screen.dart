import 'package:flutter/material.dart';
import 'package:shop_record/screens/records/all_records.dart';
import 'package:shop_record/screens/records/category_screen.dart';
import 'package:shop_record/screens/records/expenses_screen.dart';
import 'package:shop_record/screens/records/income_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  int pageIndex = 0;
  List pages = [
    const CategoryScreen(),
    const AllRecordScreen(),
    const IncomeScreen(),
    const ExpensesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[pageIndex],
      bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          currentIndex: pageIndex,
          onTap: (value) {
            setState(() {
              pageIndex = value;
            });
          },
          items: [
            const BottomNavigationBarItem(
                icon: Icon(Icons.category), label: "Category"),
            const BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long), label: "All Records"),
            const BottomNavigationBarItem(
                icon: Icon(Icons.call_received), label: "Income"),
            const BottomNavigationBarItem(
                icon: Icon(Icons.call_made), label: "Expenses"),
          ]),
    );
  }
}
