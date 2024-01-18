import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/Providers/orders.dart';
import 'package:shopapp/widgets/app_drawer.dart';

import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});
  static const routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    final orderat = Provider.of<Orders?>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: const AppDrawer(),
      body: ListView.builder(
        itemBuilder: ((context, index) => OrderWidget(orderat.orders![index])),
        itemCount: orderat!.orders!.length,
      ),
    );
  }
}
