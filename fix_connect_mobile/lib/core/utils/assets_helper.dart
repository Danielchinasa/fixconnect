import 'package:flutter/material.dart';

class ImageAssets {
  static String imageEndPoint = 'assets/images/';

  static Image carouselFirst() =>
      Image.asset('${imageEndPoint}carousel_first.png', fit: BoxFit.cover);
  static Image carouselSecond() =>
      Image.asset('${imageEndPoint}carousel_second.png', fit: BoxFit.cover);
  static Image carouselThird() =>
      Image.asset('${imageEndPoint}carousel_third.png', fit: BoxFit.cover);
}
