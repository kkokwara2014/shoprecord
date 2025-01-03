// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryModel {
  final String? id;
  final String category;
  final String name;
  final int qty;
  final double costprice;
  final double sellingprice;
  final String created;

  InventoryModel(
      {this.id,
      required this.category,
      required this.name,
      required this.qty,
      required this.costprice,
      required this.sellingprice,
      required this.created});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'category': category,
      'name': name,
      'qty': qty,
      'costprice': costprice,
      'sellingprice': sellingprice,
      'created': created,
    };
  }

  factory InventoryModel.fromMap(Map<String, dynamic> map) {
    return InventoryModel(
      id: map['id'] != null ? map['id'] as String : null,
      category: map['category'] as String,
      name: map['name'] as String,
      qty: map['qty'] as int,
      costprice: map['costprice'] as double,
      sellingprice: map['sellingprice'] as double,
      created: map['created'] as String,
    );
  }
  factory InventoryModel.fromFirestore(DocumentSnapshot map) {
    return InventoryModel(
      id: map.id,
      category: map['category'] as String,
      name: map['name'] as String,
      qty: map['qty'] as int,
      costprice: map['costprice'] as double,
      sellingprice: map['sellingprice'] as double,
      created: map['created'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory InventoryModel.fromJson(String source) =>
      InventoryModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
