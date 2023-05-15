import 'package:flutter/material.dart';
import 'package:flutter_shop_app_provider/models/http_exception.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> fetchAndSetProducts() async {
    final url = Uri.parse(
        'https://flutter-shop-app-provider-default-rtdb.europe-west1.firebasedatabase.app/products.json');
    try {
      final response = await http.get(url);
      print(json.decode(response.body));
      final List<Product> loadedProducts = [];

      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      extractedData.forEach((prodId, prodData) {
        print('this is prodId - ${prodId}');
        print('this is prodId - ${prodData}');
        loadedProducts.add(Product(
            id: prodId,
            title: prodData['title'],
            description: prodData['description'],
            price: prodData['price'],
            imageUrl: prodData['imageUrl'],
            isFavorite: prodData['isFavourite'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse(
        'https://flutter-shop-app-provider-default-rtdb.europe-west1.firebasedatabase.app/products.json');

    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'isFavourite': product.isFavorite,
          }));
      final newProduct = Product(
          //юзаєм це іd щоб ідентифікувати потрібну нам "єчейку" на сервері і при необхідності видалити її
          id: json.decode(response.body)['name'],
          title: product.title,
          description: product.description,
          price: product.price,
          imageUrl: product.imageUrl);

      _items.add(newProduct);

      notifyListeners();
    } catch (error) {
      print('catch error work');
      //коли ми обробляємо помилки апка не крашиться
      print(error);
      //throw  створює еррор щоб його можна було обробляти далі
      throw error;
    }
  }

  Future<void> updateProduct(String? id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);

    if (prodIndex >= 0) {
      final url = Uri.parse(
          'https://flutter-shop-app-provider-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json');
      await http.patch(url, body: json.encode({
        'title': newProduct.title,
        'description': newProduct.description,
        'imageUrl': newProduct.imageUrl,
        'price': newProduct.price,
      }));

      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  // https://www.visitdubai.com/-/media/gathercontent/article/t/top-rides-at-img-worlds-of-adventure/media/top-rides-at-img-worlds-of-adventure-predator-5.jpg
  Future<void> deleteProduct(String id) async {
    final url = Uri.parse('https://flutter-shop-app-provider-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json');
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    Product? existingProduct = _items[existingProductIndex];

    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);

    if(response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct!);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }

    existingProduct = null;

    // http.delete(url).then((response) {
    //   if(response.statusCode >= 400){
    //     throw HttpException('Could not delete product.');
    //   }
    //   existingProduct = null;
    // }).catchError((_){
    //   print('catch error work');
    //
    // });

  }
}
