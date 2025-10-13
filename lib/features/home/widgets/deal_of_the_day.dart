import 'package:amazon_clone/common/widgets/loader.dart';
import 'package:amazon_clone/features/home/services/home_services.dart';
import 'package:amazon_clone/features/product_details/screens/product_details_screen.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:flutter/material.dart';

class DealOfDay extends StatefulWidget {
  const DealOfDay({super.key});

  @override
  State<DealOfDay> createState() => _DealOfDayState();
}

class _DealOfDayState extends State<DealOfDay> {
  Product? product;
  HomeServices homeServices = HomeServices();
  @override
  void initState() {
    super.initState();
    fetchDealOfTheDay();
  }

  void fetchDealOfTheDay() async {
    product = await homeServices.fetchDealOfTheDay(context: context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return product == null
        ? Loader()
        : product!.name!.isEmpty ? SizedBox() : Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(left: 10, top: 15),
              child: Text('Deal of the day', style: TextStyle(fontSize: 20)),
            ),
            GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, ProductDetailScreen.routeName,arguments: product);
              },
              child: Image.network(
                product!.images![0].toString(),
                height: 235,
                fit: BoxFit.fitHeight,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 15),
              alignment: Alignment.topLeft,
              child: Text(
                '\$${product!.price}',
                style: TextStyle(fontSize: 18),
              ),
            ),
            Container(
              alignment: Alignment.topLeft,
              padding: EdgeInsets.only(left: 15, top: 5, right: 40),
              child: Text(
                'Muzzammil',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: product!.images!.map((e) => 
                   GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(context, ProductDetailScreen.routeName,arguments: product);
                    },
                     child: Image.network(
                       e.toString(),
                        fit: BoxFit.fitWidth,
                      width: 100,
                      height: 100,
                                       ),
                   ),
                ).toList() 
               
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 15,
              ).copyWith(left: 15),
              alignment: Alignment.topLeft,
              child: Text(
                'See all deals',
                style: TextStyle(color: Colors.cyan[800]),
              ),
            ),
          ],
        );
  }
}
