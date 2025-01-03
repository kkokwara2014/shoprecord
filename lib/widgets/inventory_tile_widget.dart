import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_record/constants/colors.dart';
import 'package:shop_record/models/inventory_model.dart';
import 'package:shop_record/screens/sales/sale_item.dart';

class InventoryTileWidget extends StatelessWidget {
  const InventoryTileWidget({
    super.key,
    required this.inventory,
  });

  final InventoryModel inventory;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          onTap: () {
            Get.to(() => SaleItemScreen(
                  inventory: inventory,
                ));
          },
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                inventory.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                "(${inventory.qty})",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                inventory.category,
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "\u20A6${inventory.costprice.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "\u20A6${inventory.sellingprice.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Text(inventory.created),
              const SizedBox(
                height: 5,
              ),
              const Text(
                "Tap to sell this item.",
                style: TextStyle(
                  fontSize: 13,
                ),
              )
            ],
          ),
          trailing: const Icon(
            Icons.shopping_cart_checkout,
            color: incomeColor,
          ),
        ),
        const Divider(
          thickness: 1,
        ),
      ],
    );
  }
}
