import 'package:amazon_clone/constant/global_variables.dart';
import 'package:amazon_clone/features/address/screens/address_screen.dart';
import 'package:amazon_clone/features/auth/screens/widgets/custom_button.dart';
import 'package:amazon_clone/features/cart/screens/widgets/cart_product.dart';
import 'package:amazon_clone/features/cart/screens/widgets/cart_subtotal.dart';
import 'package:amazon_clone/features/home/widgets/address_box.dart';
import 'package:amazon_clone/features/search/screen/search_screen.dart';
import 'package:amazon_clone/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  
   
    void navigateToSearchScreen(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }
   void navigateToAddressScreen(int totalAmount) {
    Navigator.pushNamed(context, AddressScreen.routeName,arguments: totalAmount.toString());
  }
  
  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
     int totalAmount = 0;
      user.cart!
        .map((e) => totalAmount += e['quantity'] * e['product']['price'] as int)
        .toList();
       
    return Scaffold(
       appBar: PreferredSize(
        preferredSize:  Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration:  BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  margin:  EdgeInsets.only(left: 15),
                  child: Material(
                    borderRadius: BorderRadius.circular(7),
                    elevation: 1,
                    child: TextFormField(
                      onFieldSubmitted: navigateToSearchScreen,
                      decoration: InputDecoration(
                        prefixIcon: InkWell(
                          onTap: () {},
                          child: const Padding(
                            padding: EdgeInsets.only(
                              left: 6,
                            ),
                            child: Icon(
                              Icons.search,
                              color: Colors.black,
                              size: 23,
                            ),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding:  EdgeInsets.only(top: 10),
                        border:  OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder:  OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(7),
                          ),
                          borderSide: BorderSide(
                            color: Colors.black38,
                            width: 1,
                          ),
                        ),
                        hintText: 'Search Amazon.in',
                        hintStyle:  TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.transparent,
                height: 42,
                margin:  EdgeInsets.symmetric(horizontal: 10),
                child:  Icon(Icons.mic, color: Colors.black, size: 25),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
              AddressBox(),
             CartSubtotal(),
             Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButton(
                text: 'Proceed to Buy (${user.cart!.length} items)',
                onTap: () {
                 print('Cart ${ user.toJson()}');
                  navigateToAddressScreen(totalAmount);
                } ,
                color: Colors.yellow[600],
              ),
            ),
             SizedBox(height: 15),
            Container(
              color: Colors.black12.withValues(alpha: 0.08),
              height: 1,
            ),
             SizedBox(height: 5),
           user.cart!.isEmpty ? Center(child: Text('No Item Has Been Added To Cart'),) : ListView.builder(
              itemCount: user.cart!.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return CartProduct(
                  index: index,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}