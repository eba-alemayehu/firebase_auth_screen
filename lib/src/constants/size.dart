import 'package:flutter/material.dart';

class SizeConfig {
  static MediaQueryData? _mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;
  static double? defaultSize;
  static Orientation? orientation;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData!.size.width;
    screenHeight = _mediaQueryData!.size.height;
    orientation = _mediaQueryData!.orientation;
  }
}

// Get the proportionate height as per screen size
double getProportionateScreenHeight(double inputHeight) {
  double? screenHeight = SizeConfig.screenHeight;
  // 812 is the layout height that designer use
  return (inputHeight / 812.0) * screenHeight!;
}

// Get the proportionate height as per screen size
double getProportionateScreenWidth(double inputWidth) {
  double? screenWidth = SizeConfig.screenWidth;
  // 375 is the layout width that designer use
  return (inputWidth / 375.0) * screenWidth!;
}

const VERTICAL_MARGIN_1 = SizedBox(
  height: 4.0,
);

const VERTICAL_MARGIN_2 = SizedBox(
  height: 8.0,
);

const VERTICAL_MARGIN_3 = SizedBox(
  height: 16.0,
);

const VERTICAL_MARGIN_4 = SizedBox(
  height: 20.0,
);

const VERTICAL_MARGIN_5 = SizedBox(
  height: 24.0,
);

const VERTICAL_MARGIN_6 = SizedBox(
  height: 28.0,
);

const VERTICAL_MARGIN_7 = SizedBox(
  height: 32.0,
);

const VERTICAL_MARGIN_8 = SizedBox(
  height: 36.0,
);
const HORIZONTAL_MARGIN_1 = SizedBox(
  width: 4.0,
);

const HORIZONTAL_MARGIN_2 = SizedBox(
  width: 8.0,
);

const HORIZONTAL_MARGIN_3 = SizedBox(
  width: 16.0,
);

const HORIZONTAL_MARGIN_4 = SizedBox(
  width: 20.0,
);

const HORIZONTAL_MARGIN_5 = SizedBox(
  width: 24.0,
);

const HORIZONTAL_MARGIN_6 = SizedBox(
  width: 28.0,
);

const HORIZONTAL_MARGIN_7 = SizedBox(
  width: 32.0,
);

const HORIZONTAL_MARGIN_8 = SizedBox(
  width: 36.0,
);