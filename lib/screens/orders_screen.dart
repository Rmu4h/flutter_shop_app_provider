import 'package:flutter/material.dart';
import 'package:flutter_shop_app_provider/widgets/app_drawer.dart';
import 'package:flutter_shop_app_provider/widgets/order_item.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late final Future _ordersListFuture;

  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
  }

  @override
  void initState() {
    // TODO: implement initState
    _ordersListFuture = _obtainOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('building works');

    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Your Orders'),
        ),
        drawer: const AppDrawer(),
        body: FutureBuilder(
          future: _ordersListFuture,
          builder: (context, dataSnapshot) {
            // Widget ordersList;
            //
            // if(dataSnapshot.connectionState == ConnectionState.done) {
            //   ordersList =  ListView.builder(
            //       itemCount: orderData.orders.length,
            //       itemBuilder: (context, index) {
            //         return OrderItem(orderData.orders[index]);
            //       });
            // } else if (dataSnapshot.hasError){
            //   ordersList = Center(child: Text('Error: ${dataSnapshot.error}'),);
            // } else {
            //   ordersList = const CircularProgressIndicator();
            // }

            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else {
              if (dataSnapshot.hasError) {
                return Center(
                  child: Text('Error: ${dataSnapshot.error}'),
                );
              } else {
                return Consumer<Orders>(
                  builder: (context, orderData, child) => ListView.builder(
                    itemCount: orderData.orders.length,
                    itemBuilder: (context, index) {
                      return OrderItem(orderData.orders[index]);
                    }),);
              }
            }
          },
        ));
  }
}
