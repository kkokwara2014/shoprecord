// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class SalesModel {
  final String? id;
  final String inventoryid;
  final String category;
  final String name;
  final int qty;
  final double amount;
  final String created;

  SalesModel(
      {this.id,
      required this.inventoryid,
      required this.category,
      required this.name,
      required this.qty,
      required this.amount,
      required this.created});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'inventoryid': inventoryid,
      'category': category,
      'name': name,
      'qty': qty,
      'amount': amount,
      'created': created,
    };
  }

  factory SalesModel.fromMap(Map<String, dynamic> map) {
    return SalesModel(
      id: map['id'] != null ? map['id'] as String : null,
      inventoryid: map['inventoryid'] as String,
      category: map['category'] as String,
      name: map['name'] as String,
      qty: map['qty'] as int,
      amount: map['amount'] as double,
      created: map['created'] as String,
    );
  }
  factory SalesModel.fromFirestore(DocumentSnapshot map) {
    return SalesModel(
      id: map.id,
      inventoryid: map['inventoryid'] as String,
      category: map['category'] as String,
      name: map['name'] as String,
      qty: map['qty'] as int,
      amount: map['amount'] as double,
      created: map['created'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SalesModel.fromJson(String source) =>
      SalesModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
