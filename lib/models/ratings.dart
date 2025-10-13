class Ratings {
  String? userId;
  double? rating;

  Ratings({this.userId, this.rating});

  Ratings.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
   rating = json['rating'] ?? 0.0; 
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['rating'] = rating;
    
    return data;
  }
}