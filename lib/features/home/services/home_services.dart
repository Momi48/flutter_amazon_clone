import 'dart:convert';

import 'package:amazon_clone/constant/error_handling.dart';
import 'package:amazon_clone/constant/global_variables.dart';
import 'package:amazon_clone/constant/utils.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class HomeServices {
  Future<List<Product>> fetchCategoryProduct(context, String category) async {
    List<Product> productList = [];
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final res = await http.get(
        Uri.parse('$uri/api/products?category=$category'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token.toString(),
        },
      );
      final data = jsonDecode(res.body);

      httpErrorHandling(
        context: context,
        response: res,
        onSuccess: () {
          for (Map<String, dynamic> i in data) {
            productList.add(Product.fromJson(i));
          }
        },
      );
    } catch (e) {
      showSnackBar(context: context, text: e.toString());
    }
    return productList;
  }

  Future<Product> fetchDealOfTheDay({required BuildContext context}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    Product product = Product(
      name: '',
      description: '',
      quantity: 0,
      images: [],
      category: '',
      price: 0,
    );
    try {
      final response = await http.get(
        Uri.parse('$uri/api/deal-of-the-day'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token.toString(),
        },
      );
      final data = jsonDecode(response.body);

      httpErrorHandling(
        context: context,
        response: response,
        onSuccess: () {
          product = Product.fromJson(data);
        },
      );
    } catch (e) {
      showSnackBar(context: context, text: e.toString());
    }
    return product;
  }
}
