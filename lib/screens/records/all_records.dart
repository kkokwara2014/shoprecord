import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_paginate_firestore/bloc/pagination_listeners.dart';
import 'package:flutterflow_paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';
import 'package:shop_record/constants/colors.dart';
import 'package:shop_record/models/shop_record_model.dart';
import 'package:shop_record/providers/shop_record_provider.dart';
import 'package:shop_record/widgets/income_expenses_widget.dart';

class AllRecordScreen extends StatefulWidget {
  const AllRecordScreen({super.key});

  @override
  State<AllRecordScreen> createState() => _AllRecordScreenState();
}

class _AllRecordScreenState extends State<AllRecordScreen> {
  final CollectionReference shopRecordRef =
      FirebaseFirestore.instance.collection("shoprecords");
  Query get shopRecordQuery =>
      shopRecordRef.orderBy("created", descending: true);

  PaginateRefreshedChangeListener refreshChangeListener =
      PaginateRefreshedChangeListener();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Records"),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Card(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Consumer<ShopRecordProvider>(
                  builder: (context, provider, child) => Column(
                    children: [
                      const Text(
                        "Transaction Summary",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Income",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.green,
                                  ),
                                ),
                                Text(
                                  "\u20A6${provider.totalIncome.toStringAsFixed(2)}",
                                  // "\u20A6${totalincome.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: incomeColor,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Expenses",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: expensesColor,
                                  ),
                                ),
                                Text(
                                  "\u20A6${provider.totalExpenses.toStringAsFixed(2)}",
                                  // "\u20A6${totalexpenses.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          ]),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Balance: \u20A6${provider.remainingBalance.toStringAsFixed(2)}",
                        // "Balance: \u20A6${rembalance.toStringAsFixed(2)}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  refreshChangeListener.refreshed = true;
                },
                child: PaginateFirestore(
                  query: shopRecordQuery,
                  itemBuilderType: PaginateBuilderType.listView,
                  itemsPerPage: 15,
                  isLive: true,
                  initialLoader:
                      const Center(child: CircularProgressIndicator.adaptive()),
                  onEmpty: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("No Records available"),
                      ],
                    ),
                  ),
                  onError: (e) => const Center(
                    child: Text("Error loading data"),
                  ),
                  bottomLoader: const Center(
                    child: CircularProgressIndicator(),
                  ),
                  itemBuilder: (context, snapshot, index) {
                    List<ShopRecordModel> shopRecordLists = snapshot
                        .map((e) => ShopRecordModel.fromFirestore(e))
                        .toList();

                    final shoprec = shopRecordLists[index];

                    return IncomeExpensesWidget(shoprec: shoprec);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
