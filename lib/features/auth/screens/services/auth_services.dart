import 'dart:convert';

import 'package:amazon_clone/constant/error_handling.dart';
import 'package:amazon_clone/constant/global_variables.dart';
import 'package:amazon_clone/constant/utils.dart';
import 'package:amazon_clone/features/home/screens/home_screen.dart';
import 'package:amazon_clone/models/user.dart';
import 'package:amazon_clone/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthServices {
  void signUp({
    required String name,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      User user = User(
        id: '',
        name: name,
        email: email,
        password: password,
        token: '',
        type: '',
        address: '',
        cart:[]
      );

      final response = await http.post(
        Uri.parse('$uri/api/sign-up'),
        body: jsonEncode(user.toJson()),
        headers:{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      
      );
      httpErrorHandling(
        context: context,
        response: response,
        onSuccess: () {
          showSnackBar(
            context: context,
            text: "Account Created Please Login in with Same Credential",
          );
        },
      );
    } catch (e) {
      showSnackBar(context: context, text: e.toString());
    }
  }

  void signIn({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      Map<String, String> headers = {
        'Content-Type': 'application/json; charset=UTF-8',
      };
     
      final response = await http.post(
        Uri.parse('$uri/api/sign-in'),
        body: jsonEncode({'email': email, 'password': password}),
        headers: headers,
      );

      final data = jsonDecode(response.body);
      httpErrorHandling(
        context: context,
        response: response,
        //data['token']
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          Provider.of<UserProvider>(context, listen: false).setUser(data);
          await prefs.setString('x-auth-token', data['token']);
          Navigator.pushNamedAndRemoveUntil(
            context,
            HomeScreen.routeName,
            (route) => false,
          );
          showSnackBar(context: context, text: "Logged In Successfully");
        },
      );
    } catch (e) {
      showSnackBar(context: context, text: e.toString());
    }
  }

  void getUserData(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      
      String? token = prefs.getString('x-auth-token');
      //await prefs.clear();
      if (token == null) {
        
        prefs.setString('x-auth-token', '');
      }
      final tokenResponse = await http.post(
        Uri.parse("$uri/api/tokenIsValid"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
      );
      final response = jsonDecode(tokenResponse.body);
      print('response $response');
      if (response == true) {
        http.Response userRes = await http.get(
          Uri.parse('$uri/api/getUserData'),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token':token,
                
          },
        );
      
        Provider.of<UserProvider>(
          context,
          listen: false,
        ).setUser(jsonDecode(userRes.body));
      }
    } catch (e) {
      // showSnackBar(context: context, text: e.toString());
    }
  }
}
