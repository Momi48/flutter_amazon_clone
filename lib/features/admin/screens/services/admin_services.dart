import 'dart:convert';
import 'dart:io';

import 'package:amazon_clone/constant/error_handling.dart';
import 'package:amazon_clone/constant/global_variables.dart';
import 'package:amazon_clone/constant/utils.dart';
import 'package:amazon_clone/features/admin/model/sales.dart';
import 'package:amazon_clone/features/admin/screens/admin_screen.dart';
import 'package:amazon_clone/models/orders.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/provider/user_provider.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AdminServices {
  void sellProducts({
    required BuildContext context,
    required String name,
    required String description,
    required String category,
    required int price,
    required int quantity,
    required List<File> images,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final cloudinary = CloudinaryPublic('dynwq1ziw', 'vision');
      List<String> imagesUrl = [];
      for (int i = 0; i < images.length; i++) {
        //this is for uploading images in cloudinary, u can use firebase or supabase
        CloudinaryResponse response = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(
            images[i].path,
            resourceType: CloudinaryResourceType.Image,
            folder: name,
          ),
        );
        //we will sotre these url of images in mongoose
        imagesUrl.add(response.secureUrl);
      }
      final product = Product(
        name: name,
        description: description,
        quantity: quantity,
        images: imagesUrl,
        category: category,
        price: price,
      );
      final res = await http.post(
        Uri.parse('$uri/api/add-products'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token.toString(),
        },
        body: jsonEncode(product),
      );
      httpErrorHandling(
        context: context,
        response: res,
        onSuccess: () {
          showSnackBar(context: context, text: "Product Added Successfully");
          Navigator.pushNamedAndRemoveUntil(
            context,
            AdminScreen.routeName,
            (route) => false,
          );
          //Navigator.pop(context);
        },
      );
    } catch (e) {
      print(e.toString());
      showSnackBar(context: context, text: e.toString());
    }
  }

  //
  Future<List<Product>> fetchAllProduct(context) async {
    List<Product> product = [];
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    print('Wait ');
    try {
      final response = await http.get(
        Uri.parse('$uri/admin/get-products'),
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
          for (Map<String, dynamic> i in data) {
            product.add(Product.fromJson(i));
          }
        },
      );
    } catch (e) {
      showSnackBar(context: context, text: e.toString());
    }
    return product;
  }

  Future<List<Order>> fetchAllOrder({required BuildContext context}) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Order> order = [];

    try {
      final response = await http.get(
        Uri.parse('$uri/admin/fetch-orders'),
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
          for (Map<String, dynamic> i in data) {
            order.add(Order.fromJson(i));
          }
        },
      );
    } catch (e) {
      showSnackBar(context: context, text: e.toString());
    }
    return order;
  }

  deleteProduct({
    required BuildContext context,
    required Product product,
    required VoidCallback onSucces,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final res = await http.delete(
        Uri.parse('$uri/admin/delete-products'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token.toString(),
        },
        body: jsonEncode({"id": product.id}),
      );
      final data = jsonDecode(res.body);
      print("data $data");
      httpErrorHandling(
        context: context,
        response: res,
        onSuccess: () {
          showSnackBar(context: context, text: jsonDecode(res.body)['message']);
          onSucces();
        },
      );
    } catch (e) {
      showSnackBar(context: context, text: e.toString());
    }
  }

  changeOrderStatus({
    required BuildContext context,
    required Order order,
    required int status,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      final res = await http.post(
        Uri.parse('$uri/admin/update-status-orders'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token.toString(),
        },
        body: jsonEncode({"id": order.sId, 'status': status}),
      );
      final data = jsonDecode(res.body);

      httpErrorHandling(
        context: context,
        response: res,
        onSuccess: () {
          order = order.copywith(status: data['status']);
          print('Status in API ${data['status']}');
        },
      );
    } catch (e) {
      showSnackBar(context: context, text: e.toString());
    }
  }

  Future<Map<String, dynamic>> getEarnings({
    required BuildContext context,
  }) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      int totalEarnings = 0;
      List<Sales> sales = [];
      final res = await http.get(
        Uri.parse("$uri/admin/analytics"),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token.toString(),
        },
      );
      final data = jsonDecode(res.body);
      print("Data is $data");
      httpErrorHandling(
        context: context,
        response: res,
        onSuccess: () {
          totalEarnings = data['totalEarnings'];
          sales = [
            Sales(label: "Mobiles", earnings: data['mobileEarnings']),
            Sales(label: "Appliances", earnings: data['appliancesEarnings']),
            Sales(label: "Essentials", earnings: data['essentialEarnings']),
            Sales(label: "Books", earnings: data['booksEarnings']),
            Sales(label: "Fashion", earnings: data['fashionEarnings']),
          ];
          print(
            jsonEncode({
              'totalEarning': totalEarnings,
              'sales':
                  sales
                      .map((e) => {'label': e.label, 'earnings': e.earnings})
                      .toList(),
            }),
          );
          print('Sale of Essential ${sales[2].earnings} ${sales[2].label}');
        },
      );
      return {'totalEarning': totalEarnings, 'sales': sales};
    } catch (e) {
      showSnackBar(context: context, text: e.toString());
      return {};
    }
  }

}
