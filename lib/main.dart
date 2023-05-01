import 'package:flutter/material.dart';
import 'package:flutter_shop_app_provider/providers/products.dart';
import 'package:flutter_shop_app_provider/screens/product_detail_screen.dart';
import 'package:flutter_shop_app_provider/screens/products_overview_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      //всі інстанси дітей будуть мати можливість слухати цей продактс. Але при цьому не перебудовувати весь MaterialApp
      value: Products(),
      child: MaterialApp(
        title: 'My shop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          // accentColor: Colors.yellow,
          colorScheme: ColorScheme.fromSwatch()
              .copyWith(secondary: Colors.deepOrange),
          fontFamily: 'Lato',
        ),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
        },
      ),
    );
  }
}




