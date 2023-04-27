import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

class FocusSubmittedTextField extends HookWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onSubmitted;

  // TextField mirrors
  final Color? cursorColor;
  final TextStyle? style;
  final InputDecoration? decoration;
  final int? maxLength;
  final TextInputType keyboardType;
  final bool enableSuggestions;
  final FocusNode? focusNode;
  final bool autofocus;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final TextInputAction textInputAction;
  final bool readOnly;

  const FocusSubmittedTextField({
    super.key,
    this.controller,
    this.onSubmitted,
    this.cursorColor,
    this.style,
    this.decoration,
    this.maxLength,
    this.keyboardType = TextInputType.visiblePassword,
    this.enableSuggestions = true,
    this.focusNode,
    this.autofocus = false,
    this.inputFormatters,
    this.onChanged,
    this.textInputAction = TextInputAction.go,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    final controller = this.controller ?? useTextEditingController(text: "");

    // Prevents double submission (https://github.com/gruvw/0byte/issues/4)
    final wasSubmitted = useState(false);

    void onSubmitted(value) {
      this.onSubmitted?.call(value);
      wasSubmitted.value = true;
    }

    return IntrinsicWidth(
      child: Focus(
        focusNode: focusNode,
        onFocusChange: (hasFocus) {
          if (hasFocus) {
            wasSubmitted.value = false;
          } else if (!wasSubmitted.value) {
            onSubmitted.call(controller.text);
          }
        },
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          cursorColor: cursorColor,
          style: style,
          decoration: decoration,
          maxLength: maxLength,
          keyboardType: keyboardType,
          enableSuggestions: enableSuggestions,
          autofocus: autofocus,
          inputFormatters: inputFormatters,
          textInputAction: textInputAction,
          readOnly: readOnly,
        ),
      ),
    );
  }
}
