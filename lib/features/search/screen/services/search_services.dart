import 'dart:convert';

import 'package:amazon_clone/constant/error_handling.dart';
import 'package:amazon_clone/constant/global_variables.dart';
import 'package:amazon_clone/constant/utils.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/provider/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
class SearchServices {

Future<List<Product>>  fetchSearchCategory (context,String searchQuery)async {
    List<Product> product = [];
    final userProvider = Provider.of<UserProvider>(context,listen: false);
    try {
     final res = await http.get(Uri.parse('$uri/api/search-products?search=$searchQuery'),
     headers: {
                'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token.toString(),
     });
     final data = jsonDecode(res.body);
     print('data is $data');
     httpErrorHandling(context: context, response: res, 
     onSuccess: (){
         for(Map<String,dynamic> i in data){
           
          product.add(Product.fromJson(i));
         
         }
     });
    }catch(e){
      showSnackBar(context: context, text: e.toString());
    }
    return product;
  }
}