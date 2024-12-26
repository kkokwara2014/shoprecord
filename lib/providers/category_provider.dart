import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryProvider extends ChangeNotifier {
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
    await _categoryCollection.doc(catId).delete();
    notifyListeners();
  }
}
