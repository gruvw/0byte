import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/fonts.dart';
import 'package:app_0byte/global/styles/time.dart';
import 'package:app_0byte/global/values.dart';
import 'package:app_0byte/models/collection.dart';
import 'package:app_0byte/utils/import_export.dart';
import 'package:app_0byte/widgets/components/text_icon.dart';

class CollectionMenu extends StatelessWidget {
  static const _menuTextStyle = TextStyle(
    fontFamily: FontTheme.firaSans,
    fontSize: FontTheme.menuSize,
    color: ColorTheme.text1,
  );

  final Collection collection;

  const CollectionMenu({
    super.key,
    required this.collection,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      color: ColorTheme.background3,
      itemBuilder: (context) => [
        PopupMenuItem(
          child: const TextIcon(
            leading: Icon(
              Icons.file_upload,
              color: ColorTheme.text1,
            ),
            text: Text(
              ValuesTheme.exportCollectionButtonLabel,
              style: _menuTextStyle,
            ),
          ),
          onTap: () async {
            String? path = await exportCollection(collection);
            if (path == null) {
              return;
            }
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              duration: TimeTheme.exportMessageDuration,
              action: SnackBarAction(
                label: "Ok",
                onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
              ),
              content: Text("Exported collection: $path."),
            ));
          },
        ),
        PopupMenuItem(
          child: const TextIcon(
            leading: Icon(
              Icons.content_copy,
              color: ColorTheme.text1,
            ),
            text: Text(
              ValuesTheme.copyCollectionButtonLabel,
              style: _menuTextStyle,
            ),
          ),
          onTap: () {
            Clipboard.setData(ClipboardData(
                    // FIXME should display separator from settings
                    text: collection.display(true)))
                .then((_) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: RichText(
                        text: TextSpan(
                          children: [
                            const TextSpan(text: "Copied "),
                            TextSpan(
                              text: collection.label,
                              style: const TextStyle(
                                color: ColorTheme.textPrefix,
                              ),
                            ),
                            const TextSpan(text: " to clipboard."),
                          ],
                        ),
                      ),
                    )));
          },
        )
      ],
    );
  }
}
