import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/texts.dart';
import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';

import 'package:app_0byte/global/styles/dimensions.dart';

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

    // TODO 2 LayoutBuilder
    final double width = MediaQuery.of(context).size.width *
        DimensionsTheme.formDialogWidthRatio;

    return AlertDialog(
      backgroundColor: UIColors.background1,
      title: Text(
        title,
        style: const TextStyle(
          color: UIColors.text1,
        ),
      ),
      content: ConstrainedBox(
        constraints: BoxConstraints(minWidth: width, maxWidth: width),
        child: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
          cursorColor: UIColors.text1,
          style: const TextStyle(
            color: UIColors.text1,
          ),
          decoration: const InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: UIColors.textPrefix,
              ),
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: () {
            callback(controller.text.isEmpty ? initialText : controller.text);
            Navigator.pop(context);
          },
          child: Text(
            "OK",
            style: UITexts.number.copyWith(
              color: UIColors.textPrefix,
            ),
          ),
        ),
      ],
    );
  }
}
