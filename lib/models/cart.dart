import 'package:flutter/foundation.dart';

class Cart extends ChangeNotifier {
  int _itemCount = 0;

  int get itemCount => _itemCount;

  void addToCart() {
    _itemCount++;
    notifyListeners(); // Notify listeners to update UI
  }

  void removeFromCart() {
    if (_itemCount > 0) {
      _itemCount--;
      notifyListeners(); // Notify listeners to update UI
    }
  }
}
