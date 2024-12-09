import 'package:flutter/material.dart';

enum Categories {
  dairy,
  fruit,
  meat,
  vegetables,
  carbs,
  sweets,
  spices,
  convenience,
  other,
  hygiene,
}

class Category {
  const Category(this.categoryTitle, this.categoryColor);
  final String categoryTitle;
  final Color categoryColor;
}
