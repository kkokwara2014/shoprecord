import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_paginate_firestore/bloc/pagination_listeners.dart';
import 'package:flutterflow_paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';
import 'package:shop_record/constants/colors.dart';
import 'package:shop_record/models/sales_model.dart';
import 'package:shop_record/providers/inventory_provider.dart';
import 'package:shop_record/providers/sales_provider.dart';
import 'package:shop_record/widgets/sale_tile_widget.dart';

class AllSalesScreen extends StatefulWidget {
  const AllSalesScreen({super.key});

  @override
  State<AllSalesScreen> createState() => _AllSalesScreenState();
}

class _AllSalesScreenState extends State<AllSalesScreen> {
  final CollectionReference inventoryRef =
      FirebaseFirestore.instance.collection("sales");
  Query get sales => inventoryRef.orderBy("created", descending: true);

  PaginateRefreshedChangeListener refreshChangeListener =
      PaginateRefreshedChangeListener();

  @override
  Widget build(BuildContext context) {
    final saleProvider = Provider.of<SalesProvider>(context, listen: false);
    final inventoryProvider =
        Provider.of<InventoryProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Sales"),
      ),
      body: Container(
        padding: const EdgeInsets.all(5),
        child: Consumer<SalesProvider>(
          builder: (context, provider, child) => Column(
            children: [
              provider.totalSales > 0
                  ? Card(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.all(8),
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                                text: TextSpan(children: [
                              const TextSpan(
                                  text: "All Sales: ",
                                  style: TextStyle(
                                    color: blackColor,
                                  )),
                              TextSpan(
                                  text:
                                      "\u20A6${provider.totalSales.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: blackColor,
                                    fontWeight: FontWeight.w600,
                                  )),
                            ])),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox(),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    refreshChangeListener.refreshed = true;
                  },
                  child: PaginateFirestore(
                    query: sales,
                    itemBuilderType: PaginateBuilderType.listView,
                    itemsPerPage: 15,
                    isLive: true,
                    initialLoader: const Center(
                        child: CircularProgressIndicator.adaptive()),
                    onEmpty: const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("No Sales record available"),
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
                      List<SalesModel> salesLists = snapshot
                          .map((e) => SalesModel.fromFirestore(e))
                          .toList();

                      final sale = salesLists[index];

                      return SaleTileWidget(
                        sale: sale,
                        saleProvider: saleProvider,
                        inventoryProvider: inventoryProvider,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
