import 'package:amazon_clone/features/cart/screens/services/cart_services.dart';
import 'package:amazon_clone/features/product_details/screens/services/product_details_services.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:amazon_clone/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartProduct extends StatefulWidget {
  final int index;
  const CartProduct({super.key, required this.index});

  @override
  State<CartProduct> createState() => _CartProductState();
}

class _CartProductState extends State<CartProduct> {
   ProductDetailsServices productDetailsServices = ProductDetailsServices();
   CartServices cartServices = CartServices();
  void increaseQuantity (Product product){
   productDetailsServices.addToCart(context: context, product: product);
  }
   void decreaseQuantity (Product product){
     cartServices.removeFromCart(context: context, product: product);
  }
  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user.cart![widget.index];
    final productCart =Product.fromJson(user['product']);
 return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Image.network(
                user['product']['images'][0],
                fit: BoxFit.contain,
                height: 135,
                width: 135,
              ),
              Expanded(
                child: Column(
                  children: [
                    Container(
                      width: 235,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        user['product']['name'],
                        style: const TextStyle(fontSize: 16),
                        maxLines: 2,
                      ),
                    ),
                
                    Container(
                      width: 235,
                      padding: const EdgeInsets.only(left: 10, top: 5),
                      child: Text(
                        "\$${user['product']['price']}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                      ),
                    ),
                    Container(
                      width: 235,
                      padding: const EdgeInsets.only(left: 10),
                      child:  Text('Eligible for free Shipping '),
                    ),
                    Container(
                      width: 235,
                      padding: const EdgeInsets.only(left: 10, top: 5),
                      child: const Text(
                        'In Stock',
                        style: TextStyle(color: Colors.teal),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
              
            ],
          ),
        ),
        Container(
                margin: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12, width: 1.5),
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.black12,
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              decreaseQuantity(productCart);
                            },
                            child: Container(
                              width: 35,
                              height: 32,
                              alignment: Alignment.center,
                              child: const Icon(Icons.remove, size: 18),
                            ),
                          ),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black12,
                                width: 1.5,
                              ),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(0),
                            ),
                            child: Container(
                              width: 35,
                              height: 32,
                              alignment: Alignment.center,
                              child: Text(user['quantity'].toString()),
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              increaseQuantity(productCart);
                              
                            },
                            child: Container(
                              width: 35,
                              height: 32,
                              alignment: Alignment.center,
                              child: const Icon(Icons.add, size: 18),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}
