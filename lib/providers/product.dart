
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String? id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite ;

  Product(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.imageUrl,
      this.isFavorite = false});

  void _setFavouriteValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String? authToken, String? userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;

    notifyListeners();

    final url = Uri.parse(
        'https://flutter-shop-app-provider-default-rtdb.europe-west1.firebasedatabase.app/userFavorites/$userId/$id.json?auth=$authToken');
    try{
      final response = await http.put(url, body: json.encode(
        isFavorite,
      ));
      print('status code ${response.statusCode}');
      //check if error
      if(response.statusCode >= 400){
        _setFavouriteValue(oldStatus);
      }
    }catch(error){
      print('catch work');
      _setFavouriteValue(oldStatus);
    }
  }
}
