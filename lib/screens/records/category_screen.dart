import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shop_record/models/category_model.dart';
import 'package:shop_record/providers/category_provider.dart';
import 'package:shop_record/screens/records/category_detail_screen.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final CollectionReference categoryRef =
      FirebaseFirestore.instance.collection("categories");
  Query get categories => categoryRef.orderBy("name", descending: false);
  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Category"),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              addCategoryWidget(context, categoryProvider);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: SafeArea(
        child:
            Container(padding: const EdgeInsets.all(8), child: categoryList()),
      ),
    );
  }

  Future<dynamic> addCategoryWidget(
      BuildContext context, CategoryProvider categoryProvider) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Category"),
        content: TextField(
          controller: categoryProvider.nameController,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(17),
            hintText: "Name",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          MaterialButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          MaterialButton(
            onPressed: () async {
              await categoryProvider.addCategory();
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  StreamBuilder<QuerySnapshot<Object?>> categoryList() {
    return StreamBuilder<QuerySnapshot>(
        stream: categories.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              final List<CategoryModel> catList = snapshot.data!.docs
                  .map((e) => CategoryModel.fromFirestore(e))
                  .toList();

              return ListView.separated(
                  // itemCount: snapshot.data!.docs.length,
                  itemCount: catList.length,
                  separatorBuilder: (context, index) => const Divider(
                        thickness: 1,
                      ),
                  itemBuilder: (context, index) {
                    // final category = snapshot.data!.docs[index];
                    final category = catList[index];
                    return ListTile(
                      onTap: () {
                        Get.to(() => CategoryDetailScreen(
                              categoryModel: category,
                            ));
                      },
                      onLongPress: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Delete ${category.name}?"),
                            content: const Text("Are you sure?"),
                            actions: [
                              MaterialButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text("No"),
                              ),
                              MaterialButton(
                                  onPressed: () {
                                    context
                                        .read<CategoryProvider>()
                                        .deleteCategory(category.id);
                                    Navigator.pop(context);
                                  },
                                  child: const Text("Yes"))
                            ],
                          ),
                        );
                      },
                      title: Text(
                        category.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_circle_right_outlined,
                        color: Colors.red,
                      ),
                    );
                  });
            } else {
              return const Center(
                child: Text("No Category yet!"),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
