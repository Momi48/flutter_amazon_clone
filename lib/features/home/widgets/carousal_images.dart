import 'package:amazon_clone/constant/global_variables.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarousalImages extends StatelessWidget {
  const CarousalImages({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(viewportFraction: 1,height: 200),
    items: GlobalVariables.carouselImages.map((i)  {
      return Builder(
     builder: (BuildContext context) {
      return Image.network(i,
      
      height: 200 ,
      fit: BoxFit.cover,);
     }
      );
    }
    ).toList()
    );
  }
}