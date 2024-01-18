import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/Providers/cart.dart';
import 'package:shopapp/Providers/orders.dart';
import 'package:shopapp/Providers/products.dart';
import 'package:shopapp/screens/cart_screen.dart';
import 'package:shopapp/screens/edit_product_screen.dart';
import 'package:shopapp/screens/orders_screen.dart';
import 'package:shopapp/screens/product_detail_screen.dart';
import 'package:shopapp/screens/product_overview_screen.dart';
import 'package:shopapp/screens/user_products_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Products(), ),
         ChangeNotifierProvider(create: (context) => Cart(), ),
           ChangeNotifierProvider(create: (context) => Orders(), ),
      ],
      
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Shop App',
        theme: ThemeData(
          primaryColor: Colors.purple,
          primarySwatch: Colors.purple, 
          colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.deepOrange),
          fontFamily: 'Lato',
          
        ),
        home: const ProductOverviewScreen(),
        routes: {
      ProductDetailScreen.routeName: (ctx) =>const ProductDetailScreen(),
      CartScreen.routeName: (ctx) =>const CartScreen(),
      OrdersScreen.routeName: (ctx) =>const OrdersScreen(),
      UserProductsScreen.routeName: (ctx) =>const UserProductsScreen(),
      EditProductScreen.routeName: (ctx) =>const EditProductScreen(),
        },
      ),
    );
  }
}
