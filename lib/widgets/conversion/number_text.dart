import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/fonts.dart';
import 'package:app_0byte/models/number_conversion_entry.dart';
import 'package:app_0byte/models/number_types.dart';
import 'package:app_0byte/models/settings.dart';
import 'package:app_0byte/state/hooks/listener.dart';
import 'package:app_0byte/state/providers/database.dart';
import 'package:app_0byte/state/providers/entry.dart';
import 'package:app_0byte/utils/input_transforms.dart';
import 'package:app_0byte/utils/validation.dart';
import 'package:app_0byte/widgets/components/focus_submitted_text_field.dart';
import 'package:app_0byte/widgets/utils/listenable_fields.dart';
import 'package:app_0byte/widgets/utils/number_input_formatter.dart';

class NumberTextView extends HookConsumerWidget {
  // TODO wrap number on new line (align with prefix); maybe on sigle line (number, converted) when very small ?

  static const _displayTitleStyle = TextStyle(
    fontFamily: FontTheme.firaCode,
    fontSize: FontTheme.numberSize,
    fontWeight: FontWeight.w500,
    color: ColorTheme.text1,
  );

  static TextStyle _styleFrom(Number? number) {
    return number == null
        ? _displayTitleStyle
        : _displayTitleStyle.apply(
            color: number.parsed() == null ? ColorTheme.danger : null,
          );
  }

  late final ListenableField<Number?> numberField;
  final PotentiallyMutableField<String> numberTextField;

  final ListenableField<ApplicationSettings> settings;

  NumberTextView({
    super.key,
    required PotentiallyMutable<Number?> number,
    required this.settings,
  }) : numberTextField = PotentiallyMutableField(
          applyNumberTextDisplay(number.object, settings.value),
          isMutable: number.isMutable,
          // Don't use applyObject here (uses NumberInputFormatter)
          onSubmitted: onSubmitNumber(number.object),
        ) {
    final numberObject = number.object;
    if (numberObject is NumberConversionEntry) {
      numberTextField
          .subscribeTo(ListenableField.familyProvided(numberObject, provider: entryTextProvider));
    }
    numberField = ListenableFieldTransform(
      numberTextField,
      transform: (text) => numberObject?.withText(text),
    );
  }

  NumberTextView.fromNumberField({
    super.key,
    required this.numberField,
    required this.settings,
  }) : numberTextField = ImmutableField(
          ListenableFieldTransform(
            numberField,
            transform: (input) => applyNumberTextDisplay(input, settings.value),
          ),
        );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final number = numberField.value;

    final controller = useTextEditingController(text: numberTextField.value);
    final focusNode = useFocusNode();
    final style = useState(_styleFrom(number));

    useListener(numberTextField.notifier, (newText) {
      if (!focusNode.hasFocus) {
        controller.text = newText;
      }
    });

    useListener(numberField.notifier, (newNumber) {
      style.value = _styleFrom(newNumber);
    });

    useListener(settings.notifier, (newSettings) {
      if (!focusNode.hasFocus) {
        controller.text = applyNumberTextDisplay(numberField.value, newSettings);
      }
    });

    void valueToClipboard() {
      FocusScope.of(context).unfocus();

      final number = numberField.value;
      if (number == null) {
        return;
      }

      String copy = number.export(ref.read(settingsProvider));
      Clipboard.setData(ClipboardData(text: copy)).then(
        (_) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: RichText(
            text: TextSpan(
              children: [
                const TextSpan(text: "Copied "),
                TextSpan(
                  text: copy,
                  style: const TextStyle(
                    fontFamily: FontTheme.firaCode,
                    color: ColorTheme.accent,
                  ),
                ),
                const TextSpan(text: " to clipboard."),
              ],
            ),
          ),
        )),
      );
    }

    if (number == null) {
      return const SizedBox();
    }

    // BUG long press temporarily focuses TextField
    return GestureDetector(
      onSecondaryTap: valueToClipboard,
      onLongPress: valueToClipboard,
      child: Row(
        children: [
          // Prefix
          Text(
            number.type.prefix,
            style: _displayTitleStyle.apply(color: ColorTheme.textPrefix),
          ),
          FocusSubmittedTextField(
            controller: controller,
            focusNode: focusNode,
            absorbing: !numberTextField.isMutable,
            readOnly: !numberTextField.isMutable,
            autofocus: number.text.isEmpty && numberTextField.isMutable,
            inputFormatters: [
              NumberInputFormatter(
                type: number.type,
                displaySeparator: settings.value.displaySeparators,
              )
            ],
            onChanged: numberTextField.set,
            onSubmitted: numberTextField.submit,
            cursorColor: ColorTheme.text1,
            style: style.value,
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }
}
