import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shopapp/Providers/products.dart';
import 'package:shopapp/widgets/product_item.dart';

class PruductsGrid extends StatelessWidget {
  final bool? showFaves;
  const PruductsGrid(this.showFaves, {super.key});

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products?>(context);
  
    final products =
        showFaves! ? productsData!.favoriteItems : productsData!.items!;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15),
      itemBuilder: ((context, index) => ChangeNotifierProvider.value(
            value: products[index],
            child: const ProductItem(
                // products[index]!.id!,
                //   products[index]!.title!, products[index]!.imageUrl!
                ),
          )),
      itemCount: products!.length,
    );
  }
}
