import 'package:flutter/material.dart';
import 'package:flutter1/DataModels/Basket_Item.dart';

class BasketModel extends ChangeNotifier{
  final List<BasketItem> _items =[];

  void addToBasket(BasketItem item){
    _items.add(item);
    notifyListeners();
  }
  void removeItem(String name) {
    _items.removeWhere((item) => item.name == name);
    notifyListeners();
  }

  bool containsItem(String name) {
    return _items.any((element) => element.name == name);
  }

  List<BasketItem> get items => _items;
}