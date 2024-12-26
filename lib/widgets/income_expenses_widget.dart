import 'package:flutter/material.dart';
import 'package:shop_record/constants/colors.dart';
import 'package:shop_record/models/shop_record_model.dart';

class IncomeExpensesWidget extends StatelessWidget {
  const IncomeExpensesWidget({
    super.key,
    required this.shoprec,
  });

  final ShopRecordModel shoprec;

  @override
  Widget build(BuildContext context) {
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
      subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(shoprec.category),
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
  }
}
