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

class CartServices {

  void removeFromCart({
  required BuildContext context , 
  required Product product,
  })
  async {
    final userProvider = Provider.of<UserProvider>( context, listen: false,);
   try {
    final res = await http.delete(Uri.parse("$uri/api/remove-from-cart/${product.id}",),
    headers: {
     'Content-Type': 'application/json; charset=UTF-8',
     'x-auth-token' : userProvider.user.token.toString(),
    });
    httpErrorHandling(context: context, response: res, onSuccess: (){
     User user = userProvider.user.copyWith(cart: jsonDecode(res.body)['cart']);
     userProvider.setUserFromModel(user);
    });
   } 
   catch(e) {
    showSnackBar(context: context, text: e.toString());
   }
  }

 
}