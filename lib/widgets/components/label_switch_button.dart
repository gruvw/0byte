import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/dimensions.dart';
import 'package:app_0byte/global/styles/texts.dart';
import 'package:flutter/material.dart';

class LabelSwitchButton extends StatelessWidget {
  final bool enabled;
  final String? label;

  final void Function(bool newEnabled)? onChanged;

  const LabelSwitchButton({
    super.key,
    required this.enabled,
    this.label,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final label = this.label;

    return Padding(
      padding: PaddingTheme.switchButton,
      child: Row(
        children: [
          Switch(
            value: enabled,
            onChanged: onChanged,
            activeColor: UIColors.accent,
            inactiveTrackColor: UIColors.background3,
          ),
          if (label != null)
            Padding(
              padding: PaddingTheme.switchText,
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      label,
                      overflow: TextOverflow.visible,
                      style: UITexts.sub,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
