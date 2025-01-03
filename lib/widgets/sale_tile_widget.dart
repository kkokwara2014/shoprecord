import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_record/constants/colors.dart';
import 'package:shop_record/models/sales_model.dart';
import 'package:shop_record/providers/inventory_provider.dart';
import 'package:shop_record/providers/sales_provider.dart';

class SaleTileWidget extends StatelessWidget {
  const SaleTileWidget({
    super.key,
    required this.sale,
    required this.saleProvider,
    required this.inventoryProvider,
  });

  final SalesModel sale;
  final SalesProvider saleProvider;
  final InventoryProvider inventoryProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onLongPress: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("Delete ${sale.name}?"),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Do you want to delete ${sale.name}?"),
                  ],
                ),
                actions: [
                  MaterialButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("No"),
                  ),
                  MaterialButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await saleProvider.removeSales(sale.id!);
                      await saleProvider.loadSales();

                      Get.rawSnackbar(
                          message: "${sale.name} deleted successfully!");
                    },
                    child: const Text("Yes"),
                  ),
                ],
              ),
            );
          },
          title: Row(
            children: [
              Text(
                sale.name,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                width: 5,
              ),
              Text("(${sale.qty})"),
            ],
          ),
          subtitle:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(sale.category),
            Text(sale.created),
            const SizedBox(
              height: 2,
            ),
            const Text(
              "Long press to delete",
              style: TextStyle(fontSize: 12),
            )
          ]),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "\u20A6${sale.amount}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Cancel ${sale.name}?"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Do you want to cancel ${sale.name}?"),
                          const Text(
                            "The quantity of this product will be returned to the stock.",
                            style: TextStyle(
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      actions: [
                        MaterialButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("No"),
                        ),
                        MaterialButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            await saleProvider.returnQtyToInventory(
                                sale.inventoryid, sale.qty);
                            await saleProvider.removeSales(sale.id!);
                            await saleProvider.loadSales();

                            Get.rawSnackbar(
                                message:
                                    "${sale.name} sell cancelled successfully!");
                          },
                          child: const Text("Yes"),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text(
                  "Cancel",
                  style: TextStyle(
                    color: pkColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(
          thickness: 1,
        ),
      ],
    );
  }
}
