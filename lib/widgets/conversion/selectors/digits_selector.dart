import 'package:flutter/material.dart';

import 'package:app_0byte/models/number_types.dart';

class DigitsSelector extends StatelessWidget {
  final Digits selected;
  final void Function(Digits selectedDigits)? onSelected;

  const DigitsSelector({
    super.key,
    required this.selected,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    // TODO 0
    return Container();
  }
}
