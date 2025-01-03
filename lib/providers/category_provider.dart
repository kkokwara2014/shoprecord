import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shop_record/models/category_model.dart';
import 'package:shop_record/models/inventory_model.dart';

class CategoryProvider extends ChangeNotifier {
  //getting the instance of firestore
  final _firestore = FirebaseFirestore.instance;
  //for getting category name from the user
  final nameController = TextEditingController();
  //getting the category collection from firebase
  final _categoryCollection =
      FirebaseFirestore.instance.collection("categories");

  //method for adding new category
  Future<void> addCategory() async {
    if (nameController.text.isNotEmpty) {
      await _categoryCollection.add({
        "name": nameController.text.trim(),
      });
      nameController.clear();
    }
    notifyListeners();
  }

  //method for editing category
  Future<void> updateCategory(String catId) async {
    await _categoryCollection.doc(catId).update({
      "name": nameController.text.trim(),
    });
    nameController.clear();
    notifyListeners();
  }

  //method for editing category
  Future<void> deleteCategory(String catId) async {
    //getting records of categories
    QuerySnapshot catSnapshots =
        await _firestore.collection("categories").get();
    final categoryLists =
        catSnapshots.docs.map((e) => CategoryModel.fromFirestore(e)).toList();

    for (var category in categoryLists) {
      final inventoryBelongingToCategory = await _firestore
          .collection("inventories")
          .where("category", isEqualTo: category.name)
          .get();
      if (inventoryBelongingToCategory.docs.isNotEmpty) {
        for (var ibCategory in inventoryBelongingToCategory.docs) {
          await _firestore
              .collection("inventories")
              .doc(ibCategory.id)
              .delete();
        }
      }
    }

    //getting inventory records
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
    await _categoryCollection.doc(catId).delete();
    notifyListeners();
  }
}
