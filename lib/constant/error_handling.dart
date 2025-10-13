import 'dart:convert';

import 'package:amazon_clone/constant/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

void httpErrorHandling({
  required BuildContext context,
  required Response response,
  required VoidCallback onSuccess,
}) {
  switch (response.statusCode) {
    case 200:
      onSuccess();
      break;
    case 400:
   
      showSnackBar(context: context, text: jsonDecode(response.body)['msg']);
    case 500:
    
      showSnackBar(context: context, text: jsonDecode(response.body)['error']);
    default:
      showSnackBar(context: context, text: response.body);
  }
}
