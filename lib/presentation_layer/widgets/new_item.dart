import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_list/data_layer/data/categories.dart';
import 'package:shopping_list/data_layer/models/category_model.dart';
import 'package:http/http.dart' as http;

extension ContextExtension on BuildContext {
  double get height => MediaQuery.sizeOf(this).height;
  double get width => MediaQuery.sizeOf(this).width;
}

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  

  @override
  State<NewItem> createState() {
    return _NewItemState();
  }
}

class _NewItemState extends State<NewItem> {
  final TextEditingController titleController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _enterdTitle = '';
  int _enterdQuantity = 1;
  Category _selectedCategory = categories[Categories.vegetables]!;

  void _saveItem() async {
    final bool isValid = _formKey.currentState!.validate();
    if (isValid) {
      _formKey.currentState!.save();
      final url = Uri.https(
          'my-backend-8b100-default-rtdb.europe-west1.firebasedatabase.app',
          'shopping-list.json');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': _enterdTitle,
          'quantity': _enterdQuantity,
          'category': _selectedCategory.categoryTitle,
        }),
      );
      print(response.statusCode);
      print(response.body);
      if (context.mounted) {
       Navigator.of(context).pop();
      } 
    }
  }


  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Title'),
                ),
                controller: titleController,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'must be between 1 and 50 characters';
                  }
                  return null;
                },
                onSaved: (newValue) {
                  _enterdTitle = newValue!;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: context.width * 0.25,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        label: Text('Quantity'),
                      ),
                      initialValue: _enterdQuantity.toString(),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value) == null ||
                            int.tryParse(value)! <= 0) {
                          return 'must be a valid positive number';
                        }
                        return null;
                      },
                      onSaved: (newValue) {
                        _enterdQuantity = int.parse(newValue!);
                      },
                    ),
                  ),
                  SizedBox(
                    width: context.width * 0.5,
                    child: DropdownButtonFormField(
                        value: _selectedCategory,
                        items: [
                          for (final category in categories.entries)
                            DropdownMenuItem(
                              value: category.value,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 18,
                                    height: 18,
                                    color: category.value.categoryColor,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    category.value.categoryTitle,
                                  ),
                                ],
                              ),
                            ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value!;
                          });
                        }),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () {
                        _formKey.currentState!.reset();
                      },
                      child: const Text('Reset')),
                  ElevatedButton(
                    onPressed: _saveItem,
                    child: const Text('Submit'),
                  ),
                  
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
