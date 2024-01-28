import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:app_0byte/global/styles/colors.dart';

abstract class UITexts {
  static final TextStyle _sansBase = GoogleFonts.firaSans(
    color: UIColors.text1,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle _codeBase = GoogleFonts.firaCode(
    color: UIColors.text1,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle title = _sansBase.copyWith(
    fontSize: 24,
  );
  static final TextStyle large = _sansBase.copyWith(
    fontSize: 22,
  );
  static final TextStyle normal = _sansBase.copyWith(
    fontSize: 20,
  );
  static final TextStyle sub = _sansBase.copyWith(
    fontSize: 18,
  );

  static final TextStyle number = _codeBase.copyWith(
    fontSize: 25,
  );

  static final TextStyle numberNormal = _codeBase.copyWith(
    fontSize: 20,
  );
}
