import 'package:shopping_list/data_layer/models/grocery_item_model.dart';
import 'package:shopping_list/data_layer/data/categories.dart';
import 'package:shopping_list/data_layer/models/category_model.dart';

final List<GroceryItem> groceryItems = [
  GroceryItem(
      id: 'a',
      name: 'Milk',
      quantity: 1,
      category: categories[Categories.dairy]!),
  GroceryItem(
      id: 'b',
      name: 'Bananas',
      quantity: 5,
      category: categories[Categories.fruit]!),
  GroceryItem(
      id: 'c',
      name: 'Beef Steak',
      quantity: 1,
      category: categories[Categories.meat]!),
];
