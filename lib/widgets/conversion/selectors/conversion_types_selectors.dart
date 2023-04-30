import 'package:app_0byte/global/styles/dimensions.dart';
import 'package:flutter/material.dart';

import 'package:app_0byte/models/number_types.dart';
import 'package:app_0byte/widgets/conversion/selectors/conversion_type_selector.dart';

class ConversionTypesSelectors extends StatelessWidget {
  final ConversionType? selected;
  final void Function(ConversionType selectedType)? onSelected;

  const ConversionTypesSelectors({
    super.key,
    this.selected,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: PaddingTheme.typesSelectors,
      child: Wrap(
        spacing: DimensionsTheme.typesSelectorsWrapSpacing,
        runSpacing: DimensionsTheme.typesSelectorsWrapSpacing,
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
