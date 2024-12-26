// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class ShopRecordModel {
  final String? id;
  final String category;
  final String name;
  final double price;
  final String? note;
  final bool isIncome;
  final String created;

  ShopRecordModel(
      {this.id,
      required this.category,
      required this.name,
      required this.price,
      this.note,
      required this.isIncome,
      required this.created});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'category': category,
      'name': name,
      'price': price,
      'note': note,
      'isIncome': isIncome,
      'created': created,
    };
  }

  factory ShopRecordModel.fromMap(Map<String, dynamic> map) {
    return ShopRecordModel(
      id: map['id'] as String,
      category: map['category'] as String,
      name: map['name'] as String,
      price: map['price'] as double,
      note: map['note'] != null ? map['note'] as String : null,
      isIncome: map['isIncome'] as bool,
      created: map['created'] as String,
    );
  }
  factory ShopRecordModel.fromFirestore(DocumentSnapshot map) {
    return ShopRecordModel(
      id: map.id,
      category: map['category'] as String,
      name: map['name'] as String,
      price: map['price'] as double,
      note: map['note'] != null ? map['note'] as String : null,
      isIncome: map['isIncome'] as bool,
      created: map['created'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory ShopRecordModel.fromJson(String source) =>
      ShopRecordModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
