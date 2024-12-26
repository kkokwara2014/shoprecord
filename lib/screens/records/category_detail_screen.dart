import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_paginate_firestore/bloc/pagination_listeners.dart';
import 'package:flutterflow_paginate_firestore/paginate_firestore.dart';
import 'package:get/get.dart';
import 'package:shop_record/constants/colors.dart';
import 'package:shop_record/models/category_model.dart';
import 'package:shop_record/models/shop_record_model.dart';
import 'package:shop_record/screens/records/add_shop_record.dart';

class CategoryDetailScreen extends StatefulWidget {
  const CategoryDetailScreen({super.key, required this.categoryModel});
  final CategoryModel categoryModel;

  @override
  State<CategoryDetailScreen> createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  final CollectionReference shopRecordRef =
      FirebaseFirestore.instance.collection("shoprecords");
  Query get shopRecordQuery => shopRecordRef
      .where("category", isEqualTo: widget.categoryModel.name)
      .orderBy("created", descending: true);

  PaginateRefreshedChangeListener refreshChangeListener =
      PaginateRefreshedChangeListener();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.categoryModel.name} details"),
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
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
            onEmpty: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("No Records available on"),
                  Text(widget.categoryModel.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      )),
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

              return ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      shoprec.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Icon(
                      shoprec.isIncome ? Icons.call_received : Icons.call_made,
                      color: shoprec.isIncome ? incomeColor : expensesColor,
                      size: 16,
                    ),
                  ],
                ),
                subtitle: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(shoprec.created),
                    ]),
                trailing: Text(
                  "\u20A6${shoprec.price.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: shoprec.isIncome ? incomeColor : expensesColor,
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddShopRecordScreen(
                categoryModel: widget.categoryModel,
              ));
          // showModalBottomSheet(
          //     isScrollControlled: true,
          //     context: context,
          //     builder: (context) => Padding(
          //           padding: MediaQuery.of(context).viewInsets,
          //           child: Container(
          //             padding: const EdgeInsets.symmetric(
          //                 horizontal: 8, vertical: 8),
          //             height: MediaQuery.of(context).size.height * .50,
          //             child: Column(
          //               children: [
          //                 Row(
          //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                   children: [
          //                     const Text(
          //                       "Add Record",
          //                       style: TextStyle(
          //                         fontWeight: FontWeight.w500,
          //                       ),
          //                     ),
          //                     IconButton(
          //                       onPressed: () {
          //                         Navigator.pop(context);
          //                       },
          //                       icon: const Icon(
          //                         Icons.close,
          //                         color: pkColor,
          //                       ),
          //                     )
          //                   ],
          //                 ),
          //                 const Divider(
          //                   thickness: 1,
          //                 ),
          //               ],
          //             ),
          //           ),
          //         ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
