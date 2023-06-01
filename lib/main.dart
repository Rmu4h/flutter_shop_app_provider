import 'package:flutter/material.dart';
import 'package:flutter_shop_app_provider/providers/auth.dart';
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
        ChangeNotifierProvider.value(
            value: Auth(),
        ),
        //provider Products rebuild if provider Auth change
        ChangeNotifierProxyProvider<Auth, Products>(
          // builder: (ctx, auth, previousProducts) => Products(
          //   auth.token,
          //   auth.userId,
          //   previousProducts == null ? [] : previousProducts.items),
            create: (context) => Products('','', []),
            update: (context, auth, previousProducts) => Products(
                auth.token,
                auth.userId,
                previousProducts == null ? [] : previousProducts.items)
        ),
        ChangeNotifierProvider(
          //всі інстанси дітей будуть мати можливість слухати цей продактс. Але при цьому не перебудовувати весь MaterialApp
          create:(context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (context) => Orders('', []),
          //всі інстанси дітей будуть мати можливість слухати цей продактс. Але при цьому не перебудовувати весь MaterialApp
          update: (context, auth, previousOrders) => Orders(auth.token, previousOrders == null ? [] : previousOrders.orders),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
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
          home: auth.isAuth ? ProductsOverviewScreen() : const AuthScreen(),
          // home: EditProductScreen(),
          routes: {
            ProductDetailScreen.routeName: (ctx) => const ProductDetailScreen(),
            CartScreen.routeName: (ctx) => const CartScreen(),
            OrdersScreen.routeName: (ctx) => const OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => const UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => const EditProductScreen(),
          },
        ),
      ),
    );
  }
}
