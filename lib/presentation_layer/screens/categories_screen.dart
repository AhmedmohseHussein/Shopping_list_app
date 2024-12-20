import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/data_layer/data/categories.dart';
import 'package:shopping_list/data_layer/models/category_model.dart';
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
  List<GroceryItem> _groceryItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGroceries();
    print('initstate');
  }

  void _loadGroceries() async {
    //feaching data
    final url = Uri.https(
        'my-backend-8b100-default-rtdb.europe-west1.firebasedatabase.app',
        'shopping-list.json');

    final response = await http.get(url);
    // print(response.body);

    //parsing data
    final Map<String, dynamic> parsedGroceryItemsData =
        json.decode(response.body);
    //maping data
    List<GroceryItem> loadedGroceryItems = [];

    for (final parsedItem in parsedGroceryItemsData.entries) {
      final Category category = categories.values.firstWhere(
        (category) => category.categoryTitle == parsedItem.value['category'],
      );

      loadedGroceryItems.add(GroceryItem(
          id: parsedItem.key,
          name: parsedItem.value['name'],
          quantity: parsedItem.value['quantity'],
          category: category));
    }
    setState(() {
      _groceryItems = loadedGroceryItems;
      _isLoading = false;
    });
  }

  void _addNewGrocery() async {
    final newGroceryItem = await Navigator.push<GroceryItem>(
      context,
      MaterialPageRoute(
        builder: (context) => const NewItem(),
      ),
    );

    if (newGroceryItem != null) {
      setState(() {
        _groceryItems.add(newGroceryItem);
      
      });
    }
  }

  Widget mainContent() {
      if (_groceryItems.isEmpty && !_isLoading) {
        //fallback content
        return const Center(
          child: Text('No grocery items found!...'),
        );
      } else 
      
      if (_isLoading) {
        return const Center(
          child: CircularProgressIndicator(),
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

  @override
  Widget build(BuildContext context) {
    print('build');
    

    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: _addNewGrocery,
              icon: const Icon(Icons.add),
            ),
          ],
          title: const Text('Your Groceries'),
          toolbarHeight: 85,
        ),
        body: mainContent());
  }
}
