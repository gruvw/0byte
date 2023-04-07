import 'package:flutter/material.dart';

typedef ApplyStringInput = String Function(String input);
typedef StringCallback = void Function(String newText);

class PotentiallyModifiableStringField {
  late final ValueNotifier<String> textNotifier;

  final String initialText;

  // ignore: prefer_final_fields
  late String _text;
  String get text => _text;
  set text(String newText) {
    _text = applyInput?.call(newText) ?? newText;
    textNotifier.value = text;
  }

  final ApplyStringInput? applyInput;
  final StringCallback? onSubmitted;

  PotentiallyModifiableStringField({
    required this.initialText,
    this.applyInput,
    this.onSubmitted,
  }) {
    text = initialText;
    textNotifier = ValueNotifier(text);
  }

  void submit() {
    onSubmitted?.call(text);
  }
}
