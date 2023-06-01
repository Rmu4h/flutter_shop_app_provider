import 'dart:convert';

import 'package:flutter_shop_app_provider/models/http_exception.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

class Auth with ChangeNotifier {
  //security mechanism
  String? _token ;
  DateTime? _expiryDate;
  String? _userId;

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if(_expiryDate != null && (_expiryDate?.isAfter(DateTime.now()) ?? false)  && _token != null){
      return _token;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  Future<void> _authenticate(String email, String password, String urlSegment) async {
    final Uri url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyDOBa15pWoEyG-D2BqxggFoi6HmYMBL6o4');

    try{
      final response = await http.post(url,
          body: json.encode(
              {'email': email, 'password': password, 'returnSecureToken': true}));

      final responseDate = json.decode(response.body);

      if(responseDate['error'] != null){
        throw HttpException(responseDate['error']['message']);
      }

      _token = responseDate['idToken'];
      _userId = responseDate['localId'];
      _expiryDate = DateTime.now().add(Duration(seconds: int.parse(responseDate['expiresIn'])));
      notifyListeners();
    } catch(error){
      throw error;
    }
  }

  Future<void> signup(String email, String password) async {
    print('signup work');
    // final Uri url = Uri.parse(
    //     'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyDOBa15pWoEyG-D2BqxggFoi6HmYMBL6o4');
    //
    // final response = await http.post(url,
    //     body: json.encode(
    //         {'email': email, 'password': password, 'returnSecureToken': true}));
    // print(json.decode(response.body));
    return _authenticate(email, password, 'signUp');
  }

  Future<void> login(String email, String password) async {
    print('login work');

    return _authenticate(email, password, 'signInWithPassword');
    //
    // final Uri url = Uri.parse(
    //     'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyDOBa15pWoEyG-D2BqxggFoi6HmYMBL6o4');
    //
    // final response = await http.post(url,
    //     body: json.encode(
    //         {'email': email, 'password': password, 'returnSecureToken': true}));
    // print(json.decode(response.body));
  }
}
