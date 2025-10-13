import 'package:amazon_clone/models/ratings.dart';

class Product {
  String? name;
   String? description;
   int? quantity;
   List<String>? images;
   String? category;
   int? price;
   String? id;
   String? userId;
  List<Ratings>? ratings;
  Product(
    {
    required this.name,
    required this.description,
    required this.quantity,
    required this.images,
    required this.category,
    required this.price,
    this.id, 
    this.userId,
    this.ratings,
  });

Product.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    description = json['description'];
    quantity = json['quantity'];
    images =  List<String>.from(json["images"]);
    category = json['category'];
    price = json['price'];
    id = json['_id'];
    ratings =  json['ratings'] != null
          ? List<Ratings>.from(
              json['ratings']?.map(
                (x) => Ratings.fromJson(x),
              ),
            ) : null;
          
  }

 Map<String, dynamic> toJson( ) {
   final Map<String, dynamic> data = <String, dynamic>{};
   data['name'] = name ?? '' ;
   data['description'] =  description ?? '' ;
    data['quantity'] =quantity ?? 0 ;
    data['images'] =images ?? '' ;
    data['category'] =category ?? '' ;
     data['price'] =price?.toDouble() ?? 0;
    data['_id']= id;
    data['ratings'] = ratings;
    print('Dattaa $data');
    return data;
  }  
  }