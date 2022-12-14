import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:app_0byte/providers/update_riverpod.dart';
import 'package:app_0byte/providers/updaters.dart';
import 'package:app_0byte/widget/utils/focus_submitted_text_field.dart';
import 'package:app_0byte/models/conversion_types.dart';
import 'package:app_0byte/providers/providers.dart';
import 'package:app_0byte/styles/colors.dart';
import 'package:app_0byte/styles/fonts.dart';

class ConversionTitleWidget extends StatelessWidget {
  static const _titleStyle = TextStyle(
    fontSize: FontTheme.fontSize3,
    fontFamily: FontTheme.fontFamily2,
  );

  const ConversionTitleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorTheme.background2,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Input", style: _titleStyle),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text("Target:", style: _titleStyle),
              SizedBox(width: 10),
              _ConversionTypeSelector()
            ],
          )
        ],
      ),
    );
  }
}

class _ConversionTypeSelector extends ConsumerWidget {
  static const _targetTextStyle = TextStyle(
    color: ColorTheme.accent,
    fontWeight: FontWeight.w600,
    fontFamily: FontTheme.fontFamily2,
    fontSize: FontTheme.fontSize3,
  );

  const _ConversionTypeSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collection = ref.watch(selectedCollectionProvider);
    ref.subscribe(collectionEditionUpdater(collection));

    final nTextController =
        TextEditingController(text: collection.targetSize.toString());

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (collection.targetSize != collection.targetType.defaultTargetSize)
          Row(
            children: [
              Text(
                collection.targetSize.toString(),
                style: _targetTextStyle,
              ),
              const SizedBox(width: 10),
            ],
          ),
        DropdownButtonHideUnderline(
          // FIXME remove empty space (padding) caused by longest option
          child: DropdownButton(
            dropdownColor: ColorTheme.background2,
            focusColor: ColorTheme.background3,
            elevation: 0,
            icon: const Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 3),
              child: Icon(
                Icons.expand_more,
                size: 32,
                color: ColorTheme.accent,
              ),
            ),
            style: _targetTextStyle,
            value: collection.targetType,
            onChanged: (value) {
              collection.targetType = value!;
              collection.targetSize = value.defaultTargetSize;
            },
            items: [
              for (final conversionType in ConversionType.values)
                DropdownMenuItem(
                  value: conversionType,
                  child: Text(conversionType.label),
                ),
              DropdownMenuItem(
                enabled: false,
                child: Row(
                  children: [
                    const Text("N:", style: _targetTextStyle),
                    const SizedBox(width: 5),
                    FocusSubmittedTextField(
                      controller: nTextController,
                      onSubmitted: (String newN) {
                        int newValue =
                            int.tryParse(newN) ?? collection.targetSize;
                        newValue =
                            newValue != 0 ? newValue : collection.targetSize;
                        collection.targetSize = newValue;
                        nTextController.text = newValue.toString();
                      },
                      cursorColor: ColorTheme.accent,
                      decoration: const InputDecoration(
                        counterText: "",
                        border: InputBorder.none,
                      ),
                      style: _targetTextStyle,
                      maxLength: 2,
                      keyboardType: TextInputType.number,
                      enableSuggestions: false,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
