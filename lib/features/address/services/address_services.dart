import 'dart:convert';

import 'package:amazon_clone/constant/error_handling.dart';
import 'package:amazon_clone/constant/global_variables.dart';
import 'package:amazon_clone/constant/utils.dart';
import 'package:amazon_clone/models/user.dart';
import 'package:amazon_clone/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AddressServices {
  saveAddress({required BuildContext context, required String address}) async {
    final userAddress = context.watch<UserProvider>();
    try {
      final response = await http.post(
        Uri.parse("$uri/api/save-user-address"),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode({'address': address}),
      );
      final data = jsonDecode(response.body);

      httpErrorHandling(
        context: context,
        response: response,
        onSuccess: () {
          User user = userAddress.user.copyWith(address: data['address']);
          userAddress.setUserFromModel(user);
        },
      );
    } catch (e) {
      print('Address API ${e.toString()}');
      showSnackBar(context: context, text: e.toString());
    }
  }

   placeOrder({
    required BuildContext context,
    required String address,
    required double totalPrice,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final res = await http.post(
        Uri.parse("$uri/api/order"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token.toString(),
        },
        body: jsonEncode({
          'cart': userProvider.user.cart,
          'address': address,
          'totalPrice': totalPrice,
        }),
      );
      final data = jsonDecode(res.body);
      print("Sending cart: ${userProvider.user.cart}");
print("Address: $address");
print("Total price: $totalPrice");
      print('Data is ${userProvider.user.cart} and data $data');
      httpErrorHandling(
        context: context,
        response: res,
        onSuccess: () {
          showSnackBar(
            context: context,
            text: "Your Order Has Been Placed Successfully",
          );
          User user = userProvider.user.copyWith(cart: []);
          userProvider.setUserFromModel(user);
        },
      );
    } catch (e) {
      

      showSnackBar(context: context, text: e.toString());
    }
  }
}
