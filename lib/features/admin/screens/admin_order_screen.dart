import 'package:amazon_clone/common/widgets/loader.dart';
import 'package:amazon_clone/features/accounts/screens/widgets/single_product.dart';
import 'package:amazon_clone/features/admin/screens/services/admin_services.dart';
import 'package:amazon_clone/features/order_details/screens/order_details_screen.dart';
import 'package:amazon_clone/models/orders.dart';
import 'package:flutter/material.dart';

class AdminOrderScreen extends StatefulWidget {
  const AdminOrderScreen({super.key});

  @override
  State<AdminOrderScreen> createState() => _AdminOrderScreenState();
}

class _AdminOrderScreenState extends State<AdminOrderScreen> {
  
  List<Order>? order;
  AdminServices adminServices = AdminServices();
  @override
  void initState() {
    super.initState();
    fetchAllOrder();

  }
  fetchAllOrder()async{
       order = await adminServices.fetchAllOrder(context: context);
  setState(() {
    
  });
  }

  @override
  Widget build(BuildContext context) {
    return order == null ? Loader() : GridView.builder(
      itemCount: order!.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), 
    itemBuilder: (context,index) {
     return SizedBox(height: 120,
     child: GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, OrderDetailsScreen.routerName,arguments: order![index]);
      },
       child: SingleProduct(
        image: order![index].products![0].product!.images![0].toString(),),
     ),
     );
    });
  }
}