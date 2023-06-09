import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../screens/edit_product_screen.dart';

class UserProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;

  const UserProductItem(this.id, this.title, this.imageUrl, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: SizedBox(
        width: 100,
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName, arguments: id);
              },
              icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.secondary,),
            ),
            IconButton(
                onPressed: () async {
                  try{
                    await Provider.of<Products>(context, listen: false).deleteProduct(id);
                  } catch(error){
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Deleting failed')));
                  }
                },
                icon: const Icon(Icons.delete),
                color: Theme.of(context).colorScheme.error),
          ],
        ),
      ),
    );
  }
}
