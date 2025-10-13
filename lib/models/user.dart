class User {
  String? token;
  String? id;
  String? name;
  String? email;
  String? password;
  String? address;
  String? type;
  List<dynamic>? cart;
  User(
      {
     required this.token,
     required this.id,
     required this.name,
     required this.email,
     required this.password,
     required this.address,
     required this.type,
     required this.cart,
     });
 User copyWith({
    String? token,
    String? id,
    String? name,
    String? email,
    String? password,
    String? address,
    String? type,
    List<dynamic>? cart,

  }) {
    return User(
      token: token ?? this.token,
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      address: address ?? this.address,
      type: type ?? this.type,
      cart: cart ?? this.cart,
    );
  }
  User.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    id = json['_id'];
    name = json['name'];
    email = json['email'];
    password = json['password'];
    address = json['address'];
    type = json['type'];
   cart = json['cart'];
  }

  Map<String, dynamic> toJson( ) {
   final Map<String, dynamic> data = <String, dynamic>{};
    data['token'] = token;
    data['_id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['password'] = password;
    data['address'] = address;
    data['type'] = type;
    data['cart'] = cart;
    return data;
  }
}
