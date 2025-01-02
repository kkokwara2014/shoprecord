import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_record/models/category_model.dart';
import 'package:shop_record/providers/shop_record_provider.dart';

class AddShopRecordScreen extends StatefulWidget {
  const AddShopRecordScreen({super.key, required this.categoryModel});
  final CategoryModel categoryModel;

  @override
  State<AddShopRecordScreen> createState() => _AddShopRecordScreenState();
}

class _AddShopRecordScreenState extends State<AddShopRecordScreen> {
  //getting input from a user
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _noteController = TextEditingController();
  bool _isIncome = true;

  //form key
  final _formKey = GlobalKey<FormState>();

//saving data to firebase
  void _saveData() {
    final name = _nameController.text.trim();
    final price = double.tryParse(_priceController.text.trim()) ?? 0;
    final note = _noteController.text.trim();

    if (name.isEmpty || price <= 0) return;
    Provider.of<ShopRecordProvider>(context, listen: false)
        .addShopRecord(widget.categoryModel.name, name, price, note, _isIncome);
    Provider.of<ShopRecordProvider>(context, listen: false).loadShopRecords();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Record to ${widget.categoryModel.name}"),
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Form(
          key: _formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            TextFormField(
              controller: _nameController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: "Name",
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Name required";
                } else {
                  return null;
                }
              },
            ),
            TextFormField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Amount",
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return "Amount required";
                } else {
                  return null;
                }
              },
            ),
            TextField(
              controller: _noteController,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                labelText: "Note",
              ),
              maxLines: 3,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Income",
                  style: TextStyle(
                    color: _isIncome ? Colors.green : Colors.black,
                    fontSize: 16,
                  ),
                ),
                Switch(
                    value: _isIncome,
                    onChanged: (val) {
                      setState(() {
                        _isIncome = val;
                      });
                    }),
                Text(
                  "Expense",
                  style: TextStyle(
                    color: !_isIncome ? Colors.red : Colors.black,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _saveData();
                  }
                },
                child: const Text("Add Record"),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
