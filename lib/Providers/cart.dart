import 'package:flutter/cupertino.dart';

class CartItem {
  final String? id;
  final String? title;
  final int? quantity;
  final double? price;

  const CartItem(this.id, this.title, this.quantity, this.price);
}

class Cart with ChangeNotifier {
  Map<String?, CartItem?>? _items = {}; //must be initialized

  Map<String?, CartItem?>? get items {
    return {..._items!};
  }

  int? get itemCount {
    //return _items == null ? 0 :  Not needed if initialized
    return _items!.length;
  }

  void addItem(String? productId, double? price, String? title) {
    if (_items!.containsKey(productId)) {
      //change quantity
      _items!.update(
          productId,
          (existing) => CartItem(existing!.id, existing.title,
              existing.quantity! + 1, existing.price));
    } else {
      _items!
          .putIfAbsent(productId, () => CartItem(productId, title, 1, price));
    }
    notifyListeners();
  }

  double? get totalAmount {
    var total = 0.0;
    _items!.forEach((key, cartItem) {
      total += cartItem!.price! + cartItem.quantity!;
    });
    return total;
  }

  void removeItem(String? prodId) {
    _items!.remove(prodId);
    notifyListeners();
  }

  void removeSingleItem(String? prodId) {
    if (!_items!.containsKey(prodId)) {
      return;
    }
    if (_items![prodId]!.quantity! > 1) {
      _items!.update(
          prodId,
          (existing) => CartItem(existing!.id, existing.title,
              existing.quantity! - 1, existing.price));
    } else {
      _items!.remove(prodId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
