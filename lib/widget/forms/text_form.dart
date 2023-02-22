import 'package:flutter/material.dart';

import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/fonts.dart';
import 'package:app_0byte/global/styles/settings.dart';

class TextForm extends StatelessWidget {
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
    final controller = TextEditingController(text: initialText);

    final double width =
        MediaQuery.of(context).size.width * SettingsTheme.formDialogWidthRatio;

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
              fontSize: FontTheme.fontSize6,
              fontFamily: FontTheme.fontFamily2,
              color: ColorTheme.textPrefix,
            ),
          ),
        ),
      ],
    );
  }
}
