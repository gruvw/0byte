import 'package:app_0byte/models/conversion_types.dart';
import 'package:app_0byte/styles/colors.dart';
import 'package:flutter/material.dart';

class ConversionTitleWidget extends StatelessWidget {
  static const _targetTextStyle = TextStyle(
    color: ColorTheme.accent,
    fontWeight: FontWeight.w600,
    fontSize: 23,
  );
  static const _titleStyle = TextStyle(fontSize: 23);

  final ConversionType targetType;
  final int n;

  const ConversionTitleWidget({
    required this.targetType,
    required this.n,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorTheme.background2,
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Input", style: _titleStyle),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Target:", style: _titleStyle),
              SizedBox(width: 10),
              Text(targetType.label, style: _targetTextStyle),
              if (n != targetType.defaultN)
                Row(
                  children: [
                    SizedBox(width: 4),
                    Text(
                      n.toString(),
                      style: _targetTextStyle,
                    ),
                  ],
                ),
              IconButton(
                onPressed: () {},
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                icon: const Icon(
                  Icons.expand_more,
                  size: 30,
                  color: ColorTheme.accent,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
