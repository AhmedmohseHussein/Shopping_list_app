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

  String? _error;

  @override
  void initState() {
    super.initState();
   _loadGroceries();
  }

void _loadGroceries() async {
    //feaching data
    final url = Uri.https(
        'my-backend-8b100-default-rtdb.europe-west1.firebasedatabase.app',
        'shopping-list.json');

    try {
      final response = await http.get(url);
      if (response.statusCode >= 400) {
        throw Exception('Failed to fetch data. Please try again later.');
        // setState(() {
        //   _error = 'Failed to fetch data. Please try again later.';
        // });
      }
//No Data state Check
      if (response.body == 'null') {
        setState(() {
          _isLoading = false;
        });
        return;
      }

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
     
    } catch (error) {
      setState(() {
        _error = 'Something went rong. Please try again later.';
      });
    }
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

  void _removeGrocery(int index, List<GroceryItem> groceryItems) async {
    //udate my local state

    setState(() {
      groceryItems.remove(groceryItems[index]);
    });
    final url = Uri.https(
        'my-backend-8b100-default-rtdb.europe-west1.firebasedatabase.app',
        'shopping-list/${groceryItems[index].id}.json');
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error'),
            duration: Duration(seconds: 1),
          ),
        );
      }
      setState(() {
        groceryItems.insert(index, groceryItems[index]);
      });
    }
  }


  Widget get mainContent{
    //Loading state
            if (_isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            //Error state in case of the future function go throw exception
          else if (_error !=null) {
              return Center(
                child: Text(
                  _error!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              );
            }
            //has Data but empty state
            else if (_groceryItems.isEmpty) {
              //fallback content
              return const Center(
                child: Text('No grocery items found!...'),
              );
            }

            //has Data but not empty State
            else //if (snapshot.data!.isNotEmpty)

            {
        
              return ListView.builder(
                itemCount: _groceryItems.length,
                itemBuilder: (context, index) => Dismissible(
                  background: Container(
                    color: Colors.redAccent,
                  ),
                  key: ValueKey(_groceryItems[index].id),
                  onDismissed: (direction) {
                    _removeGrocery(index, _groceryItems);
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
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: _addNewGrocery,
              icon: const Icon(Icons.add),
            ),
          ],
          title: const Text('Your Groceries'),
          
        ),
        body: mainContent
            
    );}
}