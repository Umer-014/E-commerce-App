import 'package:flutter/material.dart';
import 'package:application/models/product.dart';

class CartProvider extends ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items => _items;

  void addToCart(Product product) {
    _items.add(product);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _items.remove(product);
    notifyListeners();
  }

  int get itemCount => _items.length;

  double get totalPrice {
    return _items.fold(0, (total, current) => total + current.price);
  }
}
