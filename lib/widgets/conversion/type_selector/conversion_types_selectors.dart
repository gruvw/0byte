import 'package:flutter/material.dart';

import 'package:app_0byte/models/number_types.dart';
import 'package:app_0byte/widgets/conversion/type_selector/conversion_type_selector.dart';

class ConversionTypesSelectors extends StatelessWidget {
  final ConversionType? selected;
  final void Function(ConversionType selectedType)? onSelected;

  const ConversionTypesSelectors({
    this.selected,
    this.onSelected,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Wrap(
        spacing: 15,
        runSpacing: 15,
        alignment: WrapAlignment.start,
        children: [
          for (final type in ConversionType.values)
            ConversionTypeSelector(
              type: type,
              isSelected: type == selected,
              onSelected: () => onSelected?.call(type),
            )
        ],
      ),
    );
  }
}
