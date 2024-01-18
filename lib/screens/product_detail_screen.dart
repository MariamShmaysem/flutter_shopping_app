import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/Providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  // final String? title;
  const ProductDetailScreen({super.key});
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments! as String?;
    final loadedProducts =
        Provider.of<Products?>(context)!.findById(productId!);
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProducts!.title!),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Image.network(
                loadedProducts.imageUrl!,
                fit: BoxFit.cover,
              ),
            ),
              const SizedBox(height: 10,),
            Text(
              '\$${loadedProducts.price}',
              style: const TextStyle(color: Colors.grey, fontSize: 20),
            ),
              const SizedBox(height: 10,),
            Text(
              loadedProducts.description!,
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ],
        ),
      ),
    );
  }
}
