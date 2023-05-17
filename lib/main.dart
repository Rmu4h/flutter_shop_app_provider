import 'package:flutter/material.dart';
import 'package:flutter_shop_app_provider/providers/cart.dart';
import 'package:flutter_shop_app_provider/providers/orders.dart';
import 'package:flutter_shop_app_provider/providers/products.dart';
import 'package:flutter_shop_app_provider/screens/auth_screen.dart';
import 'package:flutter_shop_app_provider/screens/cart_screen.dart';
import 'package:flutter_shop_app_provider/screens/edit_product_screen.dart';
import 'package:flutter_shop_app_provider/screens/product_detail_screen.dart';
import 'package:flutter_shop_app_provider/screens/products_overview_screen.dart';
import 'package:flutter_shop_app_provider/screens/user_products_screen.dart';
import 'package:provider/provider.dart';
import './screens/orders_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          //всі інстанси дітей будуть мати можливість слухати цей продактс. Але при цьому не перебудовувати весь MaterialApp
          create: (ctx) => Products(),
        ),
        ChangeNotifierProvider(
          //всі інстанси дітей будуть мати можливість слухати цей продактс. Але при цьому не перебудовувати весь MaterialApp
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProvider(
          //всі інстанси дітей будуть мати можливість слухати цей продактс. Але при цьому не перебудовувати весь MaterialApp
          create: (ctx) => Orders(),
        ),
      ],
      child: MaterialApp(
        title: 'My shop',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: Colors.purple,
            // secondary: const Color(0xFF0A2A3F),
            secondary: Colors.deepOrange,
          ),
          // buttonTheme: ButtonThemeData(
          //   buttonColor: const Color(0xffff914d), // Background color (orange in my case).
          //   textTheme: ButtonTextTheme.accent,
          //   ),
          fontFamily: 'Lato',
        ),
        // home: ProductsOverviewScreen(),
        home: const AuthScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
          CartScreen.routeName: (ctx) => const CartScreen(),
          OrdersScreen.routeName: (ctx) => const OrdersScreen(),
          UserProductsScreen.routeName: (ctx) => const UserProductsScreen(),
          EditProductScreen.routeName: (ctx) => const EditProductScreen(),
        },
      ),
    );
  }
}
