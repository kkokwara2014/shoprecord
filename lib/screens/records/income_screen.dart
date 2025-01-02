import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_paginate_firestore/bloc/pagination_listeners.dart';
import 'package:flutterflow_paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';
import 'package:shop_record/models/shop_record_model.dart';
import 'package:shop_record/providers/shop_record_provider.dart';
import 'package:shop_record/widgets/income_expenses_widget.dart';

class IncomeScreen extends StatefulWidget {
  const IncomeScreen({super.key});

  @override
  State<IncomeScreen> createState() => _IncomeScreenState();
}

class _IncomeScreenState extends State<IncomeScreen> {
  final CollectionReference shopRecordRef =
      FirebaseFirestore.instance.collection("shoprecords");
  Query get shopRecordQuery => shopRecordRef
      .where("isIncome", isEqualTo: true)
      .orderBy("created", descending: true);

  PaginateRefreshedChangeListener refreshChangeListener =
      PaginateRefreshedChangeListener();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Incomes"),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer<ShopRecordProvider>(
              builder: (context, provider, child) => Text(
                "Total Income: \u20A6${provider.totalIncome.toStringAsFixed(2)}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
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
                        Text("No Income Records"),
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
