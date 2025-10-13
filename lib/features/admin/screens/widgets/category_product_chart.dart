import 'package:amazon_clone/features/admin/model/sales.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CategoryProductChart extends StatelessWidget {
  final List<Sales>? sales;
  const CategoryProductChart({super.key, required this.sales});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(
            labelIntersectAction: AxisLabelIntersectAction.rotate45,

        ),
        legend: Legend(isVisible: true),
        series: <ColumnSeries<Sales, String>>[
          ColumnSeries<Sales, String>(
            
            dataSource: sales!,
            xValueMapper: (Sales sales, _) => sales.label,
            yValueMapper: (Sales sales, _) => sales.earnings,
            dataLabelSettings: DataLabelSettings(isVisible: true),
            name: 'Earnings',
          ),
        ],
      ),
    );
  }
}
