import 'package:flutter/material.dart';
import 'package:flutter_shop_app_provider/screens/cart_screen.dart';
import 'package:flutter_shop_app_provider/widgets/app_drawer.dart';
import 'package:flutter_shop_app_provider/widgets/badge.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/product.dart';
import '../providers/products.dart';
import '../widgets/product_item.dart';
import '../widgets/products_grid.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  ProductsOverviewScreen({Key? key}) : super(key: key);

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var _showOnlyFavorites = false;
  var _isInit = true;
  var _isLoading = false;

  // @override
  // void initState() {
  //   print('init work');
  //   // TODO: implement initState
  //   Provider.of<Products>(context, listen: false).fetchAndSetProducts();
  //   super.initState();
  // }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      print('did work');

      //old way to fetch, better way use FutureBuilder as like in ordersScreen page because builder run only one time
      Provider.of<Products>(context).fetchAndSetProducts().then((value) {
        _isLoading = false;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print('build prod screen works');

    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: [
          PopupMenuButton(
              onSelected: (FilterOptions selectedValue) {
                setState(() {
                  if (selectedValue == FilterOptions.Favorites) {
                    _showOnlyFavorites = true;
                  } else {
                    _showOnlyFavorites = false;
                  }
                });
              },
              icon: const Icon(
                Icons.more_vert,
              ),
              itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: FilterOptions.Favorites,
                      child: Text('Only Favorites'),
                    ),
                    const PopupMenuItem(
                      value: FilterOptions.All,
                      child: Text('Show All'),
                    ),
                  ]),
          Consumer<Cart>(
            builder: (_, cart, child) =>
                BadgeItem(value: cart.itemCount.toString(), child: child!),
            child: IconButton(
              icon: const Icon(
                Icons.shopping_cart,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(_showOnlyFavorites),
    );
  }
}
