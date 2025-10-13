import 'dart:io';

import 'package:amazon_clone/common/widgets/loader.dart';
import 'package:amazon_clone/constant/global_variables.dart';
import 'package:amazon_clone/constant/utils.dart';
import 'package:amazon_clone/features/address/services/address_services.dart';
import 'package:amazon_clone/features/auth/screens/widgets/custom_textfield.dart';
import 'package:amazon_clone/provider/user_provider.dart';

import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:provider/provider.dart';

class AddressScreen extends StatefulWidget {
  static const String routeName = '/address';
  final String totalAmount;
  const AddressScreen({super.key, required this.totalAmount});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final TextEditingController flatBuildingController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController pincodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final _addressFormKey = GlobalKey<FormState>();
  List<PaymentItem> paymentItems = [];
  String addressToBeUsed = "";
  @override
  void initState() {
    super.initState();
    paymentItems.add(
      PaymentItem(
        label: 'Total Amount',
        amount: widget.totalAmount,
        status: PaymentItemStatus.final_price,
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    flatBuildingController.dispose();
    areaController.dispose();
    pincodeController.dispose();
    cityController.dispose();
  }

  onApplePayResult(res) {
    if (Provider.of<UserProvider>(
      context,
      listen: false,
    ).user.address!.isEmpty) {
      addressServices.saveAddress(context: context, address: addressToBeUsed);
    }

    addressServices.placeOrder(
      context: context,
      address: addressToBeUsed,
      totalPrice: double.parse(widget.totalAmount),
    );
  }

  onGooglePayResult(res) async {
    if (Provider.of<UserProvider>(
      context,
      listen: false,
    ).user.address!.isEmpty) {
      addressServices.saveAddress(context: context, address: addressToBeUsed);
    }
    print(
      "User cart Place ORder ${Provider.of<UserProvider>(context, listen: false).user.cart} ",
    );
   await addressServices.placeOrder(
      context: context,
      address: addressToBeUsed,
      totalPrice: double.parse(widget.totalAmount),
    );
    
  }

  void onPayPressed(String addressFromProvider) {
    bool isForm =
        flatBuildingController.text.isNotEmpty ||
        areaController.text.isNotEmpty ||
        pincodeController.text.isNotEmpty ||
        cityController.text.isNotEmpty;
    if (isForm) {
      if (_addressFormKey.currentState!.validate()) {
        addressToBeUsed =
            "${flatBuildingController.text} ${areaController.text} ${pincodeController.text} ${cityController.text}";
      } else {
        throw Exception("Please Fill All Field");
      }
    } else if (addressFromProvider.isNotEmpty) {
      addressToBeUsed = addressFromProvider;
    } else {
      showSnackBar(context: context, text: 'ERROR');
    }
  }

  final Future<PaymentConfiguration> googlePayConfigFuture =
      PaymentConfiguration.fromAsset('gpay.json');
  final Future<PaymentConfiguration> applePayConfigFuture =
      PaymentConfiguration.fromAsset('applepay.json');

  final AddressServices addressServices = AddressServices();
  @override
  Widget build(BuildContext context) {
    var address = context.watch<UserProvider>().user.address;
    print('Address $address');
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: GlobalVariables.appBarGradient),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Column(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        address.toString(),
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('OR', style: TextStyle(fontSize: 18)),
                  SizedBox(height: 20),
                ],
              ),
              Form(
                key: _addressFormKey,
                child: Column(
                  children: [
                    CustomTextField(
                      controller: flatBuildingController,
                      hintText: 'Flat, House no, Building',
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      controller: areaController,
                      hintText: 'Area, Street',
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      controller: pincodeController,
                      hintText: 'Pincode',
                    ),
                    SizedBox(height: 10),
                    CustomTextField(
                      controller: cityController,
                      hintText: 'Town/City',
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),

              SizedBox(height: 10),
              Platform.isAndroid
                  ? FutureBuilder<PaymentConfiguration>(
                    future: googlePayConfigFuture,
                    builder: (context, snapshot) {
                      print('Snasphot is ${snapshot.data}');

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Loader();
                      } else if (snapshot.hasData) {
                        return GooglePayButton(
                          width: double.infinity,
                          onPressed: () {
                            onPayPressed(address.toString());
                          },
                          paymentConfiguration: snapshot.data!,
                          onPaymentResult: onGooglePayResult,
                          paymentItems: paymentItems,
                          height: 50,

                          type: GooglePayButtonType.buy,
                          margin: EdgeInsets.only(top: 15),
                          loadingIndicator: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      } else {
                        return SizedBox.shrink();
                      }
                    },
                  )
                  : Platform.isIOS
                  ? FutureBuilder<PaymentConfiguration>(
                    future: applePayConfigFuture,
                    builder:
                        (context, snapshot) =>
                            snapshot.hasData
                                ? ApplePayButton(
                                  width: double.infinity,
                                  paymentConfiguration: snapshot.data!,
                                  paymentItems: paymentItems,
                                  style: ApplePayButtonStyle.black,
                                  type: ApplePayButtonType.buy,
                                  margin: EdgeInsets.only(top: 15.0),
                                  onPaymentResult: onApplePayResult,
                                  loadingIndicator: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                )
                                : SizedBox.shrink(),
                  )
                  : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }
}
