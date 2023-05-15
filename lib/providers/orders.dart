import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import '../providers/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.amount,
    required this.products,
    required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(
        'https://flutter-shop-app-provider-default-rtdb.europe-west1.firebasedatabase.app/orders.json');
    final timesTamp = DateTime.now();

    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': timesTamp.toIso8601String(),
          'products': cartProducts
              .map((cardProduct) => {
                    'id': cardProduct.id,
                    'title': cardProduct.title,
                    'quantity': cardProduct.quantity,
                    'price': cardProduct.price,
                  })
              .toList(),
        }));

    _orders.insert(
        0,
        OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            dateTime: timesTamp,
            products: cartProducts));
    notifyListeners();
  }
}
