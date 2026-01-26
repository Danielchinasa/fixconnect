import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ImageAssets {
  static String imageEndPoint = 'assets/images/';
  static String iconEndPoint = 'assets/icons/';

  static Image carouselFirst() =>
      Image.asset('${imageEndPoint}carousel_first.png', fit: BoxFit.cover);
  static Image carouselSecond() =>
      Image.asset('${imageEndPoint}carousel_second.png', fit: BoxFit.cover);
  static Image carouselThird() =>
      Image.asset('${imageEndPoint}carousel_third.png', fit: BoxFit.cover);

  static Widget google({double size = 24}) => SvgPicture.asset(
    '${iconEndPoint}google.svg',
    width: size,
    height: size,
    fit: BoxFit.contain,
  );
  static Widget facebook({double size = 24}) => SvgPicture.asset(
    '${iconEndPoint}facebook.svg',
    width: size,
    height: size,
    fit: BoxFit.contain,
  );
  static Widget apple({double size = 24}) => SvgPicture.asset(
    '${iconEndPoint}apple.svg',
    width: size,
    height: size,
    fit: BoxFit.contain,
  );
}
