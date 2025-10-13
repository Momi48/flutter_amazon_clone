import 'package:amazon_clone/common/widgets/loader.dart';
import 'package:amazon_clone/features/admin/model/sales.dart';
import 'package:amazon_clone/features/admin/screens/services/admin_services.dart';
import 'package:amazon_clone/features/admin/screens/widgets/category_product_chart.dart';
import 'package:flutter/material.dart';

class AnalyticScreen extends StatefulWidget {
  const AnalyticScreen({super.key});

  @override
  State<AnalyticScreen> createState() => _AnalyticScreenState();
}

class _AnalyticScreenState extends State<AnalyticScreen> {
  int? totalEarnings;
  List<Sales>? sales;
  AdminServices adminServices = AdminServices();
  getEarnings() async {
  var earningData = await adminServices.getEarnings(context: context);
  totalEarnings = earningData['totalEarning'];
  sales = earningData['sales'];
  
  setState(() {
    
  });
  
  }

  @override
  void initState() {
    super.initState();
    getEarnings(); 
  }

  @override
  Widget build(BuildContext context) {
    return totalEarnings == null || sales == null 
        ? Loader()
        : Column(
          children: [
            Text(
              'Total Price $totalEarnings',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            CategoryProductChart(sales: sales,)
          ],
        );
  }
}
