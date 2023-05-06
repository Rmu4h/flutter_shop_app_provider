import 'package:flutter/material.dart';
import 'package:flutter_shop_app_provider/widgets/app_drawer.dart';
import 'package:flutter_shop_app_provider/widgets/order_item.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
          itemCount: orderData.orders.length,
          itemBuilder: (context, index) {
            return OrderItem(orderData.orders[index]);
          }),
    );
  }
}
