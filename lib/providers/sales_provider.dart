import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_record/models/sales_model.dart';
import 'package:shop_record/providers/inventory_provider.dart';

class SalesProvider extends ChangeNotifier {
  //instantiate Inventory provider
  final InventoryProvider inventoryProvider = InventoryProvider();
  int _qty = 1;
  int get qtytosell => _qty;

//reloading quantity after sells
  reloadQty() {
    _qty = 1;
    notifyListeners();
  }

//add quantity
  incrementQty() {
    _qty++;
    notifyListeners();
  }

//remove quantity
  decrementQty() {
    if (_qty > 1) {
      _qty--;
    }
    notifyListeners();
  }

  //declaring firestore instance
  final _firestore = FirebaseFirestore.instance;

  //getting the list of sales
  List<SalesModel> _salesLists = [];
  List<SalesModel> get salesLists => _salesLists;

  SalesProvider() {
    loadSales();
  }

  //loading sales
  Future<void> loadSales() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection("sales").get();
      _salesLists =
          snapshot.docs.map((e) => SalesModel.fromFirestore(e)).toList();
    } catch (e) {}

    //get total sales
    totalSales;
    notifyListeners();
  }

  //add sales
  Future<void> addSales(
    String inventoryid,
    String category,
    String name,
    int qty,
    double amount,
  ) async {
    final newSales = SalesModel(
        inventoryid: inventoryid,
        category: category,
        name: name,
        qty: qty,
        amount: amount,
        created: DateTime.now().toString().split(" ")[0]);

    await _firestore.collection("sales").add(newSales.toMap());

    notifyListeners();
  }

  //remove sales
  Future<void> removeSales(String salesId) async {
    _firestore.collection("sales").doc(salesId).delete();
    notifyListeners();
  }

  //getting total sales
  double get totalSales =>
      _salesLists.fold(0, (initval, element) => (initval + element.amount));

  //return quantity sold to inventory
  Future<void> returnQtyToInventory(String saleInventoryId, int saleQty) async {
    await FirebaseFirestore.instance
        .collection("inventories")
        .doc(saleInventoryId)
        .update({
      "qty": FieldValue.increment(saleQty),
    });
    notifyListeners();
  }
}
