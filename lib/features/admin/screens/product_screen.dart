import 'package:amazon_clone/common/widgets/loader.dart';
import 'package:amazon_clone/features/accounts/screens/widgets/single_product.dart';
import 'package:amazon_clone/features/admin/screens/add_product_screen.dart';
import 'package:amazon_clone/features/admin/screens/services/admin_services.dart';
import 'package:amazon_clone/features/product_details/screens/product_details_screen.dart';
import 'package:amazon_clone/models/product.dart';
import 'package:flutter/material.dart';

class ProductScreen extends StatefulWidget {
  static const routeName = '/product-screen';
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  AdminServices adminServices = AdminServices();
  List<Product>? productList;
  @override
  void initState() {
    super.initState();
    fetchAllProduct();
  }

  void fetchAllProduct() async {
    productList = await adminServices.fetchAllProduct(context);
    setState(() {});
  }

  void deleteProduct(int index) {
    adminServices.deleteProduct(
      context: context,
      product: productList![index],
      onSucces: () {
        productList!.removeAt(index);
        setState(() {});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return productList == null
        ? Loader()
        : Scaffold(
          body: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: productList!.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  SizedBox(
                    height: 120,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          ProductDetailScreen.routeName,
                          arguments: productList![index],
                          
                        );
                      },
                      child: SingleProduct(
                        image: productList![index].images![0],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Text(
                          productList![index].name.toString(),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          deleteProduct(index);

                          // for (var i in productList!) {
                          //   print(
                          //     'Product in After Deleting ${i.id} ${i.description} ${i.images} ${i.quantity} ${i.price} ${i.category} ',
                          //   );
                          // }
                        },
                        icon: Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                AddProductScreen.routeName,
                (route) => false,
              );
            },
            tooltip: 'Add a Product',
            child: Icon(Icons.add),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
  }
}
