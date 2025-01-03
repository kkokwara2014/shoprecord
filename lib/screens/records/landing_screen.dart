import 'package:flutter/material.dart';
import 'package:shop_record/screens/inventory/all_inventory_screen.dart';
import 'package:shop_record/screens/records/all_records.dart';
import 'package:shop_record/screens/records/category_screen.dart';
import 'package:shop_record/screens/sales/all_sales_screen.dart';

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  int pageIndex = 0;
  late List pages;

  @override
  void initState() {
    super.initState();
    pages = [
      const CategoryScreen(),
      const AllInventoryScreen(),
      const AllSalesScreen(),
      const AllRecordScreen(),
      // const IncomeScreen(),
      // const ExpensesScreen(),
    ];
  }

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
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.category), label: "Category"),

            BottomNavigationBarItem(
                icon: Icon(Icons.assignment_outlined),
                label: "All Inventories"),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_checkout), label: "All Sales"),
            BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long), label: "All Records"),
            // BottomNavigationBarItem(
            //     icon: Icon(Icons.call_received), label: "Income"),
            // BottomNavigationBarItem(
            //     icon: Icon(Icons.call_made), label: "Expenses"),
          ]),
    );
  }
}
