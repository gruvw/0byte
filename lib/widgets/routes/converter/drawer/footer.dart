import 'package:app_0byte/global/styles/colors.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:app_0byte/global/styles/dimensions.dart';
import 'package:app_0byte/widgets/routes/route_generator.dart';

final Uri _repository = Uri.parse("https://github.com/gruvw/0byte");

class DrawerFooter extends StatelessWidget {
  const DrawerFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Ink(
      color: UIColors.background2,
      child: Padding(
        padding: PaddingTheme.drawerFooter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              style: IconButton.styleFrom(
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              padding: PaddingTheme.zero,
              onPressed: () => launchUrl(_repository),
              icon: const Icon(
                FontAwesomeIcons.github,
                color: UIColors.text1,
                size: DimensionsTheme.iconSize,
              ),
            ),
            Row(
              children: [
                IconButton(
                  style: IconButton.styleFrom(
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  padding: PaddingTheme.zero,
                  onPressed: () {}, // FIXME information page
                  icon: const Icon(
                    Icons.info_outline,
                    color: UIColors.text1,
                    size: DimensionsTheme.iconSize,
                  ),
                ),
                const SizedBox(width: DimensionsTheme.drawerIconsSpacing),
                IconButton(
                  padding: PaddingTheme.zero,
                  onPressed: () {
                    Navigator.pop(context); // closes drawer
                    Navigator.pushNamed(context, Routes.settings.name);
                  },
                  icon: const Icon(
                    Icons.settings,
                    color: UIColors.text1,
                    size: DimensionsTheme.iconSize,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
