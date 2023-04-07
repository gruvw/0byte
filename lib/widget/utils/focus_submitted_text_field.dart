import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FocusSubmittedTextField extends StatelessWidget {
  final TextEditingController? controller;
  final ValueChanged<String>? onSubmitted;

  final Color? cursorColor;
  final TextStyle? style;
  final InputDecoration? decoration;
  final int? maxLength;
  final TextInputType keyboardType;
  final bool enableSuggestions;
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
    this.autofocus = false,
    this.inputFormatters,
    this.onChanged,
    this.textInputAction = TextInputAction.go,
    this.readOnly = true,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController controller =
        this.controller ?? TextEditingController(text: "");

    return IntrinsicWidth(
      child: Focus(
        onFocusChange: (hasFocus) {
          if (!hasFocus && onSubmitted != null) {
            onSubmitted!(controller.text);
          }
        },
        child: TextField(
          controller: controller,
          onSubmitted: onSubmitted,
          cursorColor: cursorColor,
          style: style,
          decoration: decoration,
          maxLength: maxLength,
          keyboardType: keyboardType,
          enableSuggestions: enableSuggestions,
          autofocus: autofocus,
          inputFormatters: inputFormatters,
          onChanged: onChanged,
          textInputAction: textInputAction,
          readOnly: readOnly,
        ),
      ),
    );
  }
}
