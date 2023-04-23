import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/dimensions.dart';
import 'package:app_0byte/global/styles/fonts.dart';

class TextForm extends HookWidget {
  final String title;
  final String initialText;
  final void Function(String) callback;

  const TextForm({
    super.key,
    required this.title,
    required this.initialText,
    required this.callback,
  });

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController(text: initialText);

    final double width = MediaQuery.of(context).size.width *
        DimensionsTheme.formDialogWidthRatio;

    return AlertDialog(
      backgroundColor: ColorTheme.background1,
      title: Text(
        title,
        style: const TextStyle(
          color: ColorTheme.text1,
        ),
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(minWidth: width, maxWidth: width),
        child: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          cursorColor: ColorTheme.text1,
          style: const TextStyle(
            color: ColorTheme.text1,
          ),
          decoration: const InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: ColorTheme.textPrefix,
              ),
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            callback(controller.text.isEmpty ? initialText : controller.text);
            Navigator.pop(context);
          },
          child: const Text(
            "OK",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: FontTheme.formSubmitSize,
              fontFamily: FontTheme.firaCode,
              color: ColorTheme.textPrefix,
            ),
          ),
        ),
      ],
    );
  }
}
