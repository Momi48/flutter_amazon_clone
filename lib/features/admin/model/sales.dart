class Sales {
  final String? label;
  final int? earnings;
  Sales({required this.label,required this.earnings});
}

// class Sales {
//   int? totalEarning;
//   int? mobileEarnings;
//   int? essentialEarnings;
//   int? appliancesEarnings;
//   int? booksEarnings;
//   int? fashionEarnings;

//   Sales(
//       {this.totalEarning,
//       this.mobileEarnings,
//       this.essentialEarnings,
//       this.appliancesEarnings,
//       this.booksEarnings,
//       this.fashionEarnings});

//   Sales.fromJson(Map<String, dynamic> json) {
//     totalEarning = json['totalEarning'];
//     mobileEarnings = json['mobileEarnings'];
//     essentialEarnings = json['essentialEarnings'];
//     appliancesEarnings = json['appliancesEarnings'];
//     booksEarnings = json['booksEarnings'];
//     fashionEarnings = json['fashionEarnings'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['totalEarning'] = this.totalEarning;
//     data['mobileEarnings'] = this.mobileEarnings;
//     data['essentialEarnings'] = this.essentialEarnings;
//     data['appliancesEarnings'] = this.appliancesEarnings;
//     data['booksEarnings'] = this.booksEarnings;
//     data['fashionEarnings'] = this.fashionEarnings;
//     return data;
//   }
// }
