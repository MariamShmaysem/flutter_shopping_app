import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopapp/Providers/product.dart';

class Products with ChangeNotifier {
  List<Product?>? _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  // var _showOnlyFavorites = false;
  List<Product?>? get favoriteItems {
    return _items!.where((element) => element!.isFavorite!).toList();
  }

  List<Product?>? get items {
    // if (_showOnlyFavorites) {
    //   return _items!.where((element) => element!.isFavorite!).toList();
    // }
    return [..._items!];
  }

  // void showFavoritesOnly() {
  //   _showOnlyFavorites = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showOnlyFavorites = false;
  //   notifyListeners();
  // }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.https(
        'shop-test-42501-default-rtdb.firebaseio.com', '/products.json');
    try {
      final res = await http.get(url);
      print(json.decode(res.body));
    } catch (e) {
      rethrow;
    }
  }

  Product? findById(String? id) {
    return _items!.firstWhere((element) => element!.id! == id!);
  }

  Future<void> addProduct(Product? product) async {
    final url = Uri.https(
        'shop-test-42501-default-rtdb.firebaseio.com', '/products.json');
    //print(url);
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': product!.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFavorite,
        }),
      );
      //We removed .then
      // print(response);
      // print(json.decode(response.body));
      final newProduct = Product(
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);
      _items!.add(newProduct);
      notifyListeners();
    } catch (error) {
      rethrow;
    }

    // .catchError((error) {
    //   print(error);
    //   throw error;
    // });
    // _items!.insert(0, newProduct); at the beginning of the list
  }

  void updateProduct(String? id, Product? updatedProd) {
    final prodIndex = _items!.indexWhere((element) => element!.id == id);
    if (prodIndex >= 0) {
      _items![prodIndex] = updatedProd;
      notifyListeners();
    } else {
      return;
    }
  }

  void deleteProduct(String? id) {
    _items!.removeWhere((element) => element!.id == id);
    notifyListeners();
  }
}
