import 'package:flutter/material.dart';
import 'package:shopping_list/data_layer/models/grocery_item_model.dart';
import 'package:shopping_list/presentation_layer/widgets/new_item.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() {
    return _CategoriesScreenState();
  }
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final List<GroceryItem> _groceryItems = [];
  void _addItem()  {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>const NewItem(
         
        ),
      ),
    );
   
  }


  @override
  Widget build(BuildContext context) {
    Widget mainContent() {
      if (_groceryItems.isEmpty) {
        //fallback content
        return const Center(
          child: Text('No grocery items found!...'),
        );
      } else {
        return ListView.builder(
          itemCount: _groceryItems.length,
          itemBuilder: (context, index) => Dismissible(
            background: Container(
              color: Colors.redAccent,
            ),
            key: ValueKey(_groceryItems[index].id),
            onDismissed: (direction) {
              setState(() {
                _groceryItems.removeAt(index);
              });
            },
            child: ListTile(
              subtitle: const Divider(
                color: Colors.grey,
              ),
              leading: Container(
                width: 20,
                height: 20,
                color: _groceryItems[index].category.categoryColor,
              ),
              title: Text(_groceryItems[index].name),
              trailing: Text(
                _groceryItems[index].quantity.toString(),
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ),
        );
      }
    }

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
        body: mainContent());
  }
}
