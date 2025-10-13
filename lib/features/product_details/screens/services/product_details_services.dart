import 'dart:convert';

import 'package:amazon_clone/constant/error_handling.dart';
import 'package:amazon_clone/constant/global_variables.dart';
import 'package:amazon_clone/constant/utils.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/models/user.dart';
import 'package:amazon_clone/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ProductDetailsServices {
  void addToCart({
    required BuildContext context,
    required Product product,
  }) async  {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final res = await http.post(
        Uri.parse('$uri/api/add-to-cart'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token.toString(),
        },
        body: jsonEncode({'id': product.id}),
      );
      httpErrorHandling(context: context, response: res, onSuccess: () {
      User user =  userProvider.user.copyWith(cart: jsonDecode(res.body)['cart']); 
      user.cart!.map((e) => {
        print('all user data is $e')
      });
     userProvider.setUserFromModel(user);
       
      });
    } catch (e) {
      print('error ${e.toString()}');
      showSnackBar(context: context, text: e.toString());
    }
  }

  void ratingProduct({
    required BuildContext context,
    required double? rating,
    required Product product,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final res = await http.post(
        Uri.parse('$uri/api/rate-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token.toString(),
        },
        body: jsonEncode({'id': product.id, 'rating': rating}),
      );
      httpErrorHandling(context: context, response: res, onSuccess: () {});
    } catch (e) {
      print('error ${e.toString()}');
      showSnackBar(context: context, text: e.toString());
    }
  }
}
