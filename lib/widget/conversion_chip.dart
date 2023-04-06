import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/fonts.dart';
import 'package:app_0byte/models/conversion_types.dart';
import 'package:flutter/material.dart';

class ConversionChip extends StatelessWidget {
  final ConversionType inputType;
  final ConversionType outputType;
  final int digits;

  final VoidCallback? onPressed;

  const ConversionChip({
    required this.inputType,
    required this.outputType,
    required this.digits,
    this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(ColorTheme.accent),
          foregroundColor: MaterialStateProperty.all(ColorTheme.background3),
          padding: MaterialStateProperty.all(
              const EdgeInsets.symmetric(vertical: 0, horizontal: 6)),
          shape: MaterialStateProperty.all(
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
          ),
        ),
        child: Text(
          "${inputType.prefix} -> ${outputType.prefix} $digits",
          style: const TextStyle(
            fontFamily: FontTheme.firaCode,
            fontWeight: FontWeight.bold,
            fontSize: FontTheme.numberLabelSize,
          ),
        ));
  }
}
