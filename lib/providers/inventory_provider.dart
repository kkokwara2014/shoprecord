import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_record/models/inventory_model.dart';

class InventoryProvider extends ChangeNotifier {
  List<InventoryModel> _inventoryLists = [];
  List<InventoryModel> get inventoryLists => _inventoryLists;

  final _firestore = FirebaseFirestore.instance;

  //loading the inventory in the constructor
  InventoryProvider() {
    loadInventory();
  }

  //loading the inventories
  Future<void> loadInventory() async {
    try {
      final snapshot = await _firestore.collection("inventories").get();
      _inventoryLists =
          snapshot.docs.map((e) => InventoryModel.fromFirestore(e)).toList();
    } catch (e) {}

//calling the total qty, shop worth, expected shop worth and product worth
    totalQuantity;
    shopWorthBasedOnCostPrice;
    expectedShopWorth;
    productWorth;
    notifyListeners();
  }

//add new inventory
  Future<void> addInventory(String category, String name, int qty,
      double costprice, double sellingprice) async {
    final newInventory = InventoryModel(
        category: category,
        name: name,
        qty: qty,
        costprice: costprice,
        sellingprice: sellingprice,
        created: DateTime.now().toString().split(" ")[0]);
    await _firestore.collection("inventories").add(newInventory.toMap());
    notifyListeners();
  }

  //remove inventory
  Future<void> removeInventory(String invId) async {
    QuerySnapshot invSnapshots =
        await _firestore.collection("inventories").get();
    final inventoryLists =
        invSnapshots.docs.map((e) => InventoryModel.fromFirestore(e)).toList();
    for (var inventory in inventoryLists) {
      final salesBelongingToInventory = await _firestore
          .collection("sales")
          .where("inventoryid", isEqualTo: inventory.id!)
          .get();
      if (salesBelongingToInventory.docs.isNotEmpty) {
        for (var sbInventory in salesBelongingToInventory.docs) {
          await _firestore.collection("sales").doc(sbInventory.id).delete();
        }
      }
    }
    await _firestore.collection("inventories").doc(invId).delete();
    notifyListeners();
  }

  //getting the total quantity in the inventory
  int get totalQuantity =>
      _inventoryLists.fold(0, (initval, inven) => (initval + inven.qty));

  //getting shop worth based on qty and cost price
  double get shopWorthBasedOnCostPrice => _inventoryLists.fold(
      0, (initval, element) => (totalQuantity * element.costprice));
  //getting shop worth based on qty and selling price
  double get expectedShopWorth => _inventoryLists.fold(
      0, (initval, element) => (totalQuantity * element.sellingprice));
  //getting the worth of each product
  double get productWorth => _inventoryLists.fold(
      0, (initval, element) => (element.qty * element.costprice));
}
