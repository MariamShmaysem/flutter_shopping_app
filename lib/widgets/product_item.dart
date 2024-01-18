import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/Providers/cart.dart';
import 'package:shopapp/Providers/product.dart';
import 'package:shopapp/screens/product_detail_screen.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({super.key});

  // final String? id;
  // final String? title;
  // final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final produit = Provider.of<Product?>(context, listen: false);
    final chariot = Provider.of<Cart?>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          title: Text(
            produit!.title!,
            textAlign: TextAlign.center,
          ),
          leading: Consumer<Product?>(
            builder: (context, produit, child) => IconButton(
              onPressed: () {
                produit.toggleFavoriteStatus();
              },
              icon: Icon(
                  produit!.isFavorite! ? Icons.favorite : Icons.favorite_border,
                  color: Colors.deepOrange),
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          trailing: IconButton(
            onPressed: () {
              chariot!.addItem(produit.id, produit.price, produit.title);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text('Added items to cart'),
                duration: const Duration(seconds: 2),
                action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      chariot.removeSingleItem(produit.id);
                    }),
              ));
            },
            icon: const Icon(Icons.shopping_cart),
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
        child: GestureDetector(
          onTap: () => Navigator.of(context)
              .pushNamed(ProductDetailScreen.routeName, arguments: produit.id!),
          child: Image.network(
            produit.imageUrl!,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
