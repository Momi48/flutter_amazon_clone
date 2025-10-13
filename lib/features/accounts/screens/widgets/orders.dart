import 'package:amazon_clone/common/widgets/loader.dart';
import 'package:amazon_clone/constant/global_variables.dart';
import 'package:amazon_clone/features/accounts/screens/services/account_services.dart';
import 'package:amazon_clone/features/accounts/screens/widgets/single_product.dart';
import 'package:amazon_clone/features/order_details/screens/order_details_screen.dart';
import 'package:amazon_clone/models/orders.dart';
import 'package:flutter/material.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List<Order>? orders;

  AccountServices accountServices = AccountServices();
  fetchAllOrder() async {
    orders = await accountServices.fetchAllOrders(context: context);

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    fetchAllOrder();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.only(left: 15),
              child: Text(
                'Your Orders',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            GestureDetector(
              onTap: () {
                fetchAllOrder();
              },
              child: Container(
                padding: EdgeInsets.only(right: 15),
                child: Text(
                  'See all',
                  style: TextStyle(color: GlobalVariables.selectedNavBarColor),
                ),
              ),
            ),
          ],
        ),
        Container(
          height: 170,
          padding: EdgeInsets.only(left: 10, top: 20, right: 0),
          child:
              orders == null
                  ? Loader()
                  : orders!.isEmpty
                  ? Text('No Order Has Been Placed')
                  : ListView.builder(
                    itemCount: orders!.length.compareTo(0),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            OrderDetailsScreen.routerName,
                            arguments: orders![index],

                          
                          
                          );
                        },
                        child: SingleProduct(
                          image:
                              orders![index].products![0].product!.images![0].toString(),
                        ),
                      );
                    },
                  ),
        ),
      ],
    );
  }
}
