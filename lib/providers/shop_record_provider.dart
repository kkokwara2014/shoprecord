import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_record/models/shop_record_model.dart';

class ShopRecordProvider extends ChangeNotifier {
  ShopRecordProvider() {
    loadShopRecords();
  }
  //creating instance of cloud firestore
  final _shopRecordRef = FirebaseFirestore.instance.collection("shoprecords");

  //getting all the records in shop records collection
  List<ShopRecordModel> _shopRecordList = [];
  List<ShopRecordModel> get shopRecordList => _shopRecordList;

  Future<void> loadShopRecords() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection("shoprecords").get();
      _shopRecordList =
          snapshot.docs.map((e) => ShopRecordModel.fromFirestore(e)).toList();
    } catch (e) {}
    notifyListeners();
  }

  //calculcating incomes
  double get totalIncome => _shopRecordList
      .where((rec) => rec.isIncome)
      .fold(0, (initval, element) => (initval + element.price));
  //calculcating expenses
  double get totalExpenses => _shopRecordList
      .where((rec) => !rec.isIncome)
      .fold(0, (initval, element) => (initval + element.price));

  //calculate remaining balance
  double get remainingBalance => totalIncome - totalExpenses;

  //method for adding new record
  Future<void> addShopRecord(String category, String name, double price,
      String note, bool isIncome) async {
    final newShopRecord = ShopRecordModel(
        category: category,
        name: name,
        price: price,
        note: note,
        isIncome: isIncome,
        created: DateTime.now().toString());
    if (name.isNotEmpty && price > 0) {
      await _shopRecordRef.add(newShopRecord.toMap());
    }
    notifyListeners();
  }

  int totalTransaction() {
    return _shopRecordList.length;
  }
}
