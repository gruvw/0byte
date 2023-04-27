import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/dimensions.dart';
import 'package:app_0byte/global/styles/fonts.dart';
import 'package:app_0byte/global/styles/settings.dart';
import 'package:app_0byte/models/number_types.dart';
import 'package:app_0byte/widgets/components/focus_submitted_text_field.dart';
import 'package:app_0byte/widgets/utils/listenable_fields.dart';

class DigitsSelector extends HookWidget {
  static const _displayDigitsStyle = TextStyle(
    fontFamily: FontTheme.firaCode,
    fontSize: FontTheme.numberSize,
    fontWeight: FontWeight.w500,
    color: ColorTheme.accent,
  );

  static TextStyle _styleFrom(String digitsText) {
    return _displayDigitsStyle.apply(
      color: Digits.fromString(digitsText) == null ? ColorTheme.danger : null,
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
    final controller =
        useTextEditingController(text: digitsField.value.toString());
    final focusNode = useFocusNode();
    final style = useState(_styleFrom(digitsField.value.toString()));

    final digitsUpdate = useValueListenable(digitsField.notifier);
    useEffect(() {
      if (!focusNode.hasFocus) {
        final text = digitsUpdate.toString();
        controller.text = text;
        style.value = _styleFrom(text);
      }
      return null;
    }, [digitsUpdate]);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          SettingsTheme.digitsSelectorLabel,
          style: TextStyle(
              color: ColorTheme.text1,
              fontFamily: FontTheme.firaSans,
              fontSize: FontTheme.conversionSelectorSize),
        ),
        const SizedBox(width: DimensionsTheme.digitsSelectorHorizontalSpacing),
        FocusSubmittedTextField(
          controller: controller,
          focusNode: focusNode,
          cursorColor: ColorTheme.accent,
          keyboardType: TextInputType.number,
          style: style.value,
          maxLength: Digits.MAX_AMOUNT.toString().length,
          onChanged: (newDigitsText) {
            style.value = _styleFrom(newDigitsText);
          },
          onSubmitted: (newDigitsText) {
            final newDigits =
                Digits.fromString(newDigitsText) ?? digitsField.value;
            onSelected?.call(newDigits);
          },
        ),
      ],
    );
  }
}
