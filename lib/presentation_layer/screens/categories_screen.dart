import 'package:flutter/material.dart';
import 'package:shopping_list/data_layer/data/dummy_items.dart';
import 'package:shopping_list/presentation_layer/widgets/new_item.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() {
    return _CategoriesScreenState();
  }
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  void _addItem() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NewItem(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: _addItem,
              icon: const Icon(Icons.add),
            ),
          ],
          title: const Text('Your Groceries'),
          toolbarHeight: 85,
        ),
        body: ListView.builder(
          itemCount: groceryItems.length,
          itemBuilder: (context, index) {
            return ListTile(
              subtitle: const Divider(
                color: Colors.grey,
              ),
              leading: Container(
                width: 20,
                height: 20,
                color: groceryItems[index].category.categoryColor,
              ),
              title: Text(groceryItems[index].name),
              trailing: Text(
                groceryItems[index].quantity.toString(),
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            );
          },
        ));
  }
}
