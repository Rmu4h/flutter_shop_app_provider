import 'package:flutter/material.dart';
import 'package:flutter_shop_app_provider/screens/edit_product_screen.dart';
import 'package:flutter_shop_app_provider/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/user_product_item.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  const UserProductsScreen({Key? key}) : super(key: key);

  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your products'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Products>(
                      builder: (context, productsData, child) => Padding(
                        padding: const EdgeInsets.all(8),
                        child: ListView.builder(
                            itemCount: productsData.items.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  UserProductItem(
                                      productsData.items[index].id ?? '',
                                      productsData.items[index].title,
                                      productsData.items[index].imageUrl),
                                  const Divider()
                                ],
                              );
                            }),
                      ),
                    ),
                  ),
      ),
    );
  }
}
