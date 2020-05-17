import 'package:flutter/material.dart';
import 'colorConst.dart';

TextStyle styleTextBold18 = TextStyle(
  fontSize: 18,
  fontFamily: 'Segoe',
  fontWeight: FontWeight.bold,
  color: FONT_COLOR,
);

TextStyle styleTextBold16 = TextStyle(
  color: FONT_COLOR,
  fontFamily: 'Segoe',
  fontWeight: FontWeight.bold,
  fontSize: 16,
);

TextStyle styleTextBold = TextStyle(
  fontWeight: FontWeight.bold,
  fontFamily: 'Segoe',
);

TextStyle styleTextBoldWhite = TextStyle(
  fontWeight: FontWeight.bold,
  fontFamily: 'Segoe',
  color: Colors.white,
);

TextStyle styleTextNormal14Grey = TextStyle(
  fontFamily: 'Segoe',
  fontWeight: FontWeight.normal,
  fontSize: 14.0,
  color: Colors.grey,
);

TextStyle styleTextNormal14Underline = TextStyle(
  color: FONT_COLOR,
  fontWeight: FontWeight.normal,
  fontFamily: 'Segoe',
  fontSize: 14.0,
  decoration: TextDecoration.underline,
);

TextStyle styleTextNormal14 = TextStyle(
  color: FONT_COLOR,
  fontWeight: FontWeight.normal,
  fontFamily: 'Segoe',
  fontSize: 14.0,
);

TextStyle styleTextNormal14White = TextStyle(
  color: Colors.white,
  fontWeight: FontWeight.normal,
  fontFamily: 'Segoe',
  fontSize: 14.0,
);

TextStyle progressIndicatorTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 13.0,
  fontWeight: FontWeight.w400,
  fontFamily: 'Segoe',
);

TextStyle progressMessageTextStyle = TextStyle(
  color: Colors.black,
  fontSize: 19.0,
  fontWeight: FontWeight.w600,
  fontFamily: 'Segoe',
);

TextStyle styleTextNormal16 = TextStyle(
  color: FONT_COLOR,
  fontWeight: FontWeight.normal,
  fontFamily: 'Segoe',
  fontSize: 16.0,
);

TextStyle styleTextNormal20 = TextStyle(
  color: FONT_COLOR,
  fontWeight: FontWeight.normal,
  fontFamily: 'Segoe',
  fontSize: 20.0,
);

TextStyle styleTextNormal14Validator(bool validator) {
  return TextStyle(
      fontFamily: 'Segoe',
      fontWeight: FontWeight.normal,
      fontSize: 14.0,
      color: validator ? FONT_COLOR : Colors.grey);
}

TextStyle styleTextNormal16Height = TextStyle(
  color: FONT_COLOR,
  fontWeight: FontWeight.normal,
  fontSize: 16,
  fontFamily: 'Segoe',
  height: 1.25,
);

TextStyle styleTextBold20 = TextStyle(
  fontSize: 20,
  fontFamily: 'Segoe',
  fontWeight: FontWeight.bold,
  color: FONT_COLOR,
);

TextStyle styleTextBold25 = TextStyle(
  fontSize: 25,
  fontFamily: 'Segoe',
  fontWeight: FontWeight.bold,
  color: FONT_COLOR,
);

TextStyle styleTextNormal25White = TextStyle(
  fontFamily: 'Segoe',
  color: Colors.white,
  fontSize: 25,
  fontWeight: FontWeight.normal,
);

TextStyle styleTextNormal25 = TextStyle(
  fontFamily: 'Segoe',
  color: FONT_COLOR,
  fontSize: 25,
  fontWeight: FontWeight.normal,
);

TextStyle styleTextNormal40 = TextStyle(
  fontFamily: 'Segoe',
  color: FONT_COLOR,
  fontSize: 40,
  fontWeight: FontWeight.bold,
);

TextStyle styleTextNormal16White = TextStyle(
  fontFamily: 'Segoe',
  color: Colors.white,
  fontSize: 16,
  fontWeight: FontWeight.normal,
);