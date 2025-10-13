import 'package:amazon_clone/models/product.dart';

// class Order {
//   String? sId;
//   List<Product>? products;
//   int? totalPrice;
//   String? address;
//   String? userId;
//   int? orderedAt;
//   int? status;

//   Order(
//       {this.sId,
//       this.products,
//       this.totalPrice,
//       this.address,
//       this.userId,
//       this.orderedAt,
//       this.status});

//   Order.fromJson(Map<String, dynamic> json) {
//     sId = json['_id'];
//       if (json['products'] != null) {
//       final List<Product> productList = [];
//       for (var item in json['products']) {
//         final productData = item['product'];
//         if (productData != null) {
//           productList.add(Product.fromJson(productData));
//         }
//       }
//       products = productList;
//     }
//     // if (json['products'] != null) {
//     //   products = <Product>[];
//     //   json['products'].forEach((v) {
//     //     products!.add( Product.fromJson(v));
//     //   });
//     // }
//     totalPrice = json['totalPrice'];
//     address = json['address'];
//     userId = json['userId'];
//     orderedAt = json['orderedAt'];
//     status = json['status'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data =  <String, dynamic>{};
//     data['_id'] = sId;
//     if (products != null) {
//       data['products'] = products!.map((v) => v.toJson()).toList();
//     }
//     data['totalPrice'] = totalPrice;
//     data['address'] = address;
//     data['userId'] = userId;
//     data['orderedAt'] = orderedAt;
//     data['status'] = status;
//     return data;
//   }
// }
class Order {
  List<Products>? products;
  int? totalPrice;
  String? address;
  String? userId;
  int? orderedAt;
  int? status;
  String? sId;

  Order({
    this.products,
    this.totalPrice,
    this.address,
    this.userId,
    this.orderedAt,
    this.status,
    this.sId,
  });

  Order.fromJson(Map<String, dynamic> json) {
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(Products.fromJson(v));
      });
    }
    totalPrice = json['totalPrice'];
    address = json['address'];
    userId = json['userId'];
    orderedAt = json['orderedAt'];
    status = json['status'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    data['totalPrice'] = totalPrice;
    data['address'] = address;
    data['userId'] = userId;
    data['orderedAt'] = orderedAt;
    data['status'] = status;
    data['_id'] = sId;
    return data;
  }

  Order copywith({
    List<Products>? products,
    int? totalPrice,
    String? address,
    String? userId,
    int? orderedAt,
    int? status,
    String? sId,
  }) {
    return Order(
      products: products ?? this.products,
      totalPrice: totalPrice ?? this.totalPrice,
      address: address ?? this.address,
      userId: userId ?? this.userId,
      orderedAt: orderedAt ?? this.orderedAt,
      status: status ?? this.status,
      sId: sId ?? this.sId,
    );
  }
}

class Products {
  Product? product;
  int? quantity;
  String? sId;

  Products({this.product, this.quantity, this.sId});

  Products.fromJson(Map<String, dynamic> json) {
    product =
        json['product'] != null ? Product.fromJson(json['product']) : null;
    quantity = json['quantity'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (product != null) {
      data['product'] = product!.toJson();
    }
    data['quantity'] = quantity;
    data['_id'] = sId;
    return data;
  }
}
