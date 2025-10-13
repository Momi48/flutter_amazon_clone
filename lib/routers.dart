import 'package:amazon_clone/common/widgets/bottom_bar.dart';
import 'package:amazon_clone/features/address/screens/address_screen.dart';
import 'package:amazon_clone/features/admin/screens/add_product_screen.dart';
import 'package:amazon_clone/features/admin/screens/admin_screen.dart';
import 'package:amazon_clone/features/auth/screens/auth_screen.dart';
import 'package:amazon_clone/features/home/screens/category_deals_screen.dart';
import 'package:amazon_clone/features/home/screens/home_screen.dart';
import 'package:amazon_clone/features/order_details/screens/order_details_screen.dart';
import 'package:amazon_clone/features/product_details/screens/product_details_screen.dart';
import 'package:amazon_clone/features/search/screen/search_screen.dart';
import 'package:amazon_clone/models/orders.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:flutter/material.dart';

Route<dynamic> generateRouter(RouteSettings routeSetting) {
  switch (routeSetting.name) {
    case AuthScreen.routerName:
      return MaterialPageRoute(
        settings: routeSetting,
        builder: (_) => AuthScreen(),
      );
    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSetting,
        builder: (_) => HomeScreen(),
      );
    //routeName
    case BottomBar.routeName:
      return MaterialPageRoute(
        settings: routeSetting,
        builder: (_) => BottomBar(),
      );
    case CategoryDealsScreen.routeName:
      var category = routeSetting.arguments.toString();
      return MaterialPageRoute(
        builder: (_) => CategoryDealsScreen(category: category),
      );
    case AdminScreen.routeName:
      return MaterialPageRoute(
        settings: routeSetting,
        builder: (_) => AdminScreen(),
      );
    //ProductDetailScreen
    case ProductDetailScreen.routeName:
      var product = routeSetting.arguments as Product;
      return MaterialPageRoute(
        settings: routeSetting,
        builder: (_) => ProductDetailScreen(product: product),
      );
    case AddressScreen.routeName:
      var totalAmount = routeSetting.arguments as String;
      return MaterialPageRoute(
        builder:
            (_) => AddressScreen(totalAmount: totalAmount),
        settings: routeSetting,
      );
    case AddProductScreen.routeName:
      return MaterialPageRoute(
        settings: routeSetting,
        builder: (_) => AddProductScreen(),
      );
    case SearchScreen.routeName:
      var query = routeSetting.arguments.toString();
      return MaterialPageRoute(
        settings: routeSetting,
        builder: (_) => SearchScreen(searchQuery: query),
      );
      case OrderDetailsScreen.routerName:
      var order = routeSetting.arguments as Order;
      return MaterialPageRoute(
        settings: routeSetting,
        builder: (_) => OrderDetailsScreen(order: order,)
      );
    default:
      return MaterialPageRoute(
        settings: routeSetting,
        builder: (_) => Scaffold(body: Center(child: Text('No Page Found'))),
      );
  }
}
