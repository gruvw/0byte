import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/texts.dart';
import 'package:app_0byte/global/values.dart';
import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:app_0byte/global/styles/dimensions.dart';
import 'package:app_0byte/models/number_types.dart';
import 'package:app_0byte/state/hooks/listener.dart';
import 'package:app_0byte/widgets/components/focus_submitted_text_field.dart';
import 'package:app_0byte/widgets/utils/listenable_fields.dart';

class DigitsSelector extends HookWidget {
  static final _displayDigitsStyle = UITexts.number.copyWith(
    fontWeight: FontWeight.w500,
    color: UIColors.accent,
  );

  static TextStyle _styleFrom(String digitsText) {
    return _displayDigitsStyle.apply(
      color: Digits.fromString(digitsText) == null ? UIColors.danger : null,
    );
  }

  final ListenableField<Digits> digitsField;
  final void Function(Digits selectedDigits)? onSelected;

  const DigitsSelector({
    super.key,
    required this.digitsField,
    this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final digits = digitsField.value;
    final controller = useTextEditingController(text: digits.toString());
    final focusNode = useFocusNode();
    final style = useState(_styleFrom(digits.toString()));

    useListener(digitsField.notifier, (newDigits) {
      if (!focusNode.hasFocus) {
        final text = newDigits.toString();
        controller.text = text;
        style.value = _styleFrom(text);
      }
    });

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          UIValues.digitsSelectorLabel,
          style: UITexts.large,
        ),
        const SizedBox(width: DimensionsTheme.digitsSelectorHorizontalSpacing),
        FocusSubmittedTextField(
          controller: controller,
          focusNode: focusNode,
          cursorColor: UIColors.accent,
          keyboardType: TextInputType.number,
          style: style.value,
          maxLength: Digits.MAX_AMOUNT.toString().length,
          onChanged: (newDigitsText) {
            style.value = _styleFrom(newDigitsText);
          },
          onSubmitted: (newDigitsText) {
            final newDigits = Digits.fromString(newDigitsText) ?? digits;
            onSelected?.call(newDigits);
          },
        ),
      ],
    );
  }
}
