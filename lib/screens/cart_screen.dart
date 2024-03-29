import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/Providers/cart.dart';

import '../Providers/orders.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart?>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Total",
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const Spacer(), //keeps widgets spaced
                  Chip(
                    label: Text(
                      '\$${cart!.totalAmount!.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: Theme.of(context)
                              .primaryTextTheme
                              .titleMedium!
                              .color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),

                  TextButton(
                      onPressed: () {
                        Provider.of<Orders?>(context, listen: false)!.addOrder(
                            cart.items!.values.toList(), cart.totalAmount);
                        cart.clear();
                      },
                      child: Text(
                        'Order Now',
                        style: TextStyle(color: Theme.of(context).primaryColor),
                      ))
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.items!.length,
              itemBuilder: (context, i) => ItemInCart(
                cart.items!.values.toList()[i]!.id!,
                cart.items!.values.toList()[i]!.price,
                cart.items!.values.toList()[i]!.quantity,
                cart.items!.keys.toList()[i],
                cart.items!.values.toList()[i]!.title,
              ),
            ),
          )
        ],
      ),
    );
  }
}
