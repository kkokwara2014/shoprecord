import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_paginate_firestore/bloc/pagination_listeners.dart';
import 'package:flutterflow_paginate_firestore/paginate_firestore.dart';
import 'package:provider/provider.dart';
import 'package:shop_record/constants/colors.dart';
import 'package:shop_record/models/inventory_model.dart';
import 'package:shop_record/providers/inventory_provider.dart';
import 'package:shop_record/widgets/inventory_tile_widget.dart';

class AllInventoryScreen extends StatefulWidget {
  const AllInventoryScreen({super.key});

  @override
  State<AllInventoryScreen> createState() => _AllInventoryScreenState();
}

class _AllInventoryScreenState extends State<AllInventoryScreen> {
  final CollectionReference inventoryRef =
      FirebaseFirestore.instance.collection("inventories");
  Query get inventories => inventoryRef.orderBy("created", descending: true);

  PaginateRefreshedChangeListener refreshChangeListener =
      PaginateRefreshedChangeListener();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Inventories"),
      ),
      body: Container(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Card(
              child: Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.all(8),
                width: double.infinity,
                child: Consumer<InventoryProvider>(
                  builder: (context, provider, child) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                          text: TextSpan(children: [
                        const TextSpan(
                            text: "Quantity: ",
                            style: TextStyle(
                              color: blackColor,
                            )),
                        TextSpan(
                            text: "${provider.totalQuantity}",
                            style: const TextStyle(
                              fontSize: 18,
                              color: blackColor,
                              fontWeight: FontWeight.w600,
                            )),
                      ])),
                      RichText(
                          text: TextSpan(children: [
                        const TextSpan(
                            text: "Worth: ",
                            style: TextStyle(
                              color: blackColor,
                            )),
                        TextSpan(
                            text:
                                "\u20A6${provider.shopWorthBasedOnCostPrice.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 18,
                              color: blackColor,
                              fontWeight: FontWeight.w600,
                            )),
                      ])),
                      RichText(
                          text: TextSpan(children: [
                        const TextSpan(
                            text: "Expected Worth: ",
                            style: TextStyle(
                              color: blackColor,
                            )),
                        TextSpan(
                            text:
                                "\u20A6${provider.expectedShopWorth.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 18,
                              color: blackColor,
                              fontWeight: FontWeight.w600,
                            )),
                      ])),
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
                  query: inventories,
                  itemBuilderType: PaginateBuilderType.listView,
                  itemsPerPage: 15,
                  isLive: true,
                  initialLoader:
                      const Center(child: CircularProgressIndicator.adaptive()),
                  onEmpty: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("No Inventory record available"),
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
                    List<InventoryModel> inventoryLists = snapshot
                        .map((e) => InventoryModel.fromFirestore(e))
                        .toList();

                    final inventory = inventoryLists[index];

                    return InventoryTileWidget(inventory: inventory);
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
