import 'package:flutter/material.dart';

class ImageAssets {
  static String imageEndPoint = 'assets/images/';

  static Image carouselFirst() =>
      Image.asset('${imageEndPoint}carousel_first.png', fit: BoxFit.cover);
}
