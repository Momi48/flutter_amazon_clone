import 'dart:convert';

import 'package:amazon_clone/constant/error_handling.dart';
import 'package:amazon_clone/constant/global_variables.dart';
import 'package:amazon_clone/constant/utils.dart';
import 'package:amazon_clone/features/auth/screens/auth_screen.dart';
import 'package:amazon_clone/models/orders.dart';
import 'package:amazon_clone/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountServices {
  Future<List<Order>> fetchAllOrders({required BuildContext context}) async {
    List<Order> order = [];
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final res = await http.get(
        Uri.parse("$uri/api/fetch-all-orders"),
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
            order.add(Order.fromJson(i));
          }
        },
      );
    } catch (e) {
      showSnackBar(context: context, text: e.toString());
      return [];
    }
    return order;
  }
  static  logOut({required BuildContext context})async {
    try {
     final pref = await SharedPreferences.getInstance();
      pref.setString('x-auth-token', '');
       Navigator.pushNamedAndRemoveUntil(
        context,
        AuthScreen.routerName,
        (route) => false,
      );
    } 
    catch(e){
      showSnackBar(context: context, text: e.toString());
    }
  }
}
