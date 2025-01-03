import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_paginate_firestore/bloc/pagination_listeners.dart';
import 'package:flutterflow_paginate_firestore/paginate_firestore.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shop_record/models/category_model.dart';
import 'package:shop_record/models/inventory_model.dart';
import 'package:shop_record/providers/inventory_provider.dart';
import 'package:shop_record/widgets/inventory_tile_widget.dart';
import 'package:shop_record/widgets/my_button.dart';
import 'package:shop_record/widgets/my_textinput.dart';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key, required this.categoryModel});
  final CategoryModel categoryModel;

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  final CollectionReference inventoryRef =
      FirebaseFirestore.instance.collection("inventories");
  Query get inventories => inventoryRef
      .where("category", isEqualTo: widget.categoryModel.name)
      .orderBy("created", descending: true);

  PaginateRefreshedChangeListener refreshChangeListener =
      PaginateRefreshedChangeListener();

  //getting inputs from user
  final nameController = TextEditingController();
  final qtyController = TextEditingController();
  final costPriceController = TextEditingController();
  final sellingPriceController = TextEditingController();

  //form key
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final inventoryProvider = Provider.of<InventoryProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.categoryModel.name} Inventory"),
      ),
      body: Container(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
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
                  onEmpty: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("No Inventory available on"),
                        Text(
                          widget.categoryModel.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
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
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addInventoryWidget(context, inventoryProvider);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<dynamic> addInventoryWidget(
      BuildContext context, InventoryProvider inventoryProvider) {
    return showModalBottomSheet(
        isScrollControlled: true,
        isDismissible: false,
        context: context,
        builder: (context) => Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                height: MediaQuery.of(context).size.height * .48,
                child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      Expanded(
                          child: ListView(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Add Inventory",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: const Icon(Icons.close),
                              )
                            ],
                          ),
                          const Divider(
                            thickness: 1,
                          ),
                          MyTextInput(
                              controller: nameController,
                              hintText: "Product Name",
                              textInputType: TextInputType.text),
                          const SizedBox(
                            height: 10,
                          ),
                          MyTextInput(
                              controller: qtyController,
                              hintText: "Quantity",
                              textInputType: TextInputType.number),
                          const SizedBox(
                            height: 10,
                          ),
                          MyTextInput(
                              controller: costPriceController,
                              hintText: "Cost Price",
                              textInputType: TextInputType.number),
                          const SizedBox(
                            height: 10,
                          ),
                          MyTextInput(
                              controller: sellingPriceController,
                              hintText: "Selling Price",
                              textInputType: TextInputType.number),
                          const SizedBox(
                            height: 15,
                          ),
                          MyButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  Navigator.pop(context);
                                  final costprice = double.tryParse(
                                          costPriceController.text.trim()) ??
                                      0;
                                  final sellingprice = double.tryParse(
                                          sellingPriceController.text.trim()) ??
                                      0;
                                  await inventoryProvider.addInventory(
                                      widget.categoryModel.name,
                                      nameController.text.trim(),
                                      int.parse(qtyController.text.trim()),
                                      costprice,
                                      sellingprice);
                                  await inventoryProvider.loadInventory();
                                  Get.rawSnackbar(
                                      message:
                                          "New inventory added to ${widget.categoryModel.name}");
                                }
                              },
                              text: "Save"),
                        ],
                      ))
                    ],
                  ),
                ),
              ),
            ));
  }
}
