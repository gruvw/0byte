import 'package:flutter/material.dart';

import 'package:app_0byte/styles/settings.dart';

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
      title: Text(title),
      content: ConstrainedBox(
        constraints: BoxConstraints(minWidth: width, maxWidth: width),
        child: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.sentences,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            callback(controller.text.isEmpty ? initialText : controller.text);
            Navigator.pop(context);
          },
          child: const Text("OK"),
        ),
      ],
    );
  }
}
