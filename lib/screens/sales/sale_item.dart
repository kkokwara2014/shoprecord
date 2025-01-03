import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shop_record/constants/colors.dart';
import 'package:shop_record/models/inventory_model.dart';
import 'package:shop_record/providers/inventory_provider.dart';
import 'package:shop_record/providers/sales_provider.dart';
import 'package:shop_record/widgets/my_button.dart';

class SaleItemScreen extends StatefulWidget {
  const SaleItemScreen({super.key, required this.inventory});
  final InventoryModel inventory;

  @override
  State<SaleItemScreen> createState() => _SaleItemScreenState();
}

class _SaleItemScreenState extends State<SaleItemScreen> {
  double amountToBePaid = 0.0;
  //for amount to be paid text input
  final amountToBePaidController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    amountToBePaidController.dispose();
  }

  @override
  void initState() {
    super.initState();
    amountToBePaid = widget.inventory.sellingprice;
    amountToBePaidController.text = amountToBePaid.toString();
  }

  @override
  Widget build(BuildContext context) {
    final sellProvider = Provider.of<SalesProvider>(context, listen: false);
    final inventoryProvider =
        Provider.of<InventoryProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text("Sell ${widget.inventory.name}"),
      ),
      body: Container(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Category: ${widget.inventory.category}"),
            Text(
                "Selling price: \u20A6${widget.inventory.sellingprice.toStringAsFixed(2)}"),
            Text("Available Quantity: ${widget.inventory.qty}"),
            Padding(
              padding: const EdgeInsets.all(45.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      sellProvider.decrementQty();
                      if (sellProvider.qtytosell > 1) {
                        setState(() {
                          amountToBePaid =
                              amountToBePaid - widget.inventory.sellingprice;
                          amountToBePaidController.text =
                              amountToBePaid.toString();
                        });
                      } else if (sellProvider.qtytosell == 1) {
                        setState(() {
                          amountToBePaid = widget.inventory.sellingprice;
                          amountToBePaidController.text =
                              amountToBePaid.toString();
                        });
                      }
                    },
                    icon: const Icon(
                      Icons.remove_circle_outline,
                      size: 35,
                      color: pkColor,
                    ),
                  ),
                  Consumer<SalesProvider>(
                    builder: (context, provider, child) => Text(
                      "${provider.qtytosell}",
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (widget.inventory.qty > sellProvider.qtytosell) {
                        sellProvider.incrementQty();
                        setState(() {
                          amountToBePaid = widget.inventory.sellingprice *
                              sellProvider.qtytosell;
                          amountToBePaidController.text =
                              amountToBePaid.toString();
                        });
                      } else {
                        Get.rawSnackbar(
                            message: "There is insufficient quantity!");
                      }
                    },
                    icon: const Icon(
                      Icons.add_circle_outline,
                      size: 35,
                      color: incomeColor,
                    ),
                  ),
                ],
              ),
            ),
            TextFormField(
              controller: amountToBePaidController,
              decoration: const InputDecoration(
                hintText: "Selling price",
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(17),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Selling price required";
                } else {
                  return null;
                }
              },
              keyboardType: TextInputType.number,
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Column(
                children: [
                  const Text("Amount Payable"),
                  Text(
                    "\u20A6${amountToBePaidController.text}",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            MyButton(
              text: "Sell",
              onPressed: () async {
                Navigator.pop(context);
                sellProvider.addSales(
                    widget.inventory.id!,
                    widget.inventory.category,
                    widget.inventory.name,
                    sellProvider.qtytosell,
                    amountToBePaid);
                //remove the quantity to the inventory
                await FirebaseFirestore.instance
                    .collection("inventories")
                    .doc(widget.inventory.id)
                    .update({
                  "qty": FieldValue.increment(-sellProvider.qtytosell),
                });
                //reloading the quantity of item

                await sellProvider.loadSales();
                await inventoryProvider.loadInventory();
                sellProvider.reloadQty();
                Get.rawSnackbar(
                    message: "${widget.inventory.name} sold successfully");
              },
            ),
          ],
        ),
      ),
    );
  }
}
