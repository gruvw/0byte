import 'package:app_0byte/models/conversion_types.dart';
import 'package:app_0byte/providers/providers.dart';
import 'package:app_0byte/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ConversionTitleWidget extends StatelessWidget {
  static const _targetTextStyle = TextStyle(
    color: ColorTheme.accent,
    fontWeight: FontWeight.w600,
    fontSize: 23,
  );
  static const _titleStyle = TextStyle(fontSize: 23);

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
            children: [
              const Text("Target:", style: _titleStyle),
              const SizedBox(width: 10),
              HookConsumer(
                // FIXME extract widget (local?)
                builder: (context, ref, child) {
                  final targetType = ref.watch(targetConversionTypeProvider);
                  final targetSize = ref.watch(targetSizeProvider);

                  final nTextController =
                      TextEditingController(text: targetSize.toString());

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (targetSize != targetType.defaultTargetSize)
                        Row(
                          children: [
                            Text(
                              targetSize.toString(),
                              style: _targetTextStyle,
                            ),
                            const SizedBox(width: 10),
                          ],
                        ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 2),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            dropdownColor: ColorTheme.background2,
                            elevation: 0,
                            icon: const Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Icon(
                                Icons.expand_more,
                                size: 32,
                                color: ColorTheme.accent,
                              ),
                            ),
                            style: _targetTextStyle,
                            value: targetType,
                            onChanged: (value) {
                              ref
                                  .read(targetConversionTypeProvider.notifier)
                                  .state = value!;
                              ref.read(targetSizeProvider.notifier).state =
                                  value.defaultTargetSize;
                            },
                            items: [
                              for (final conversionType
                                  in ConversionType.values)
                                DropdownMenuItem(
                                  value: conversionType,
                                  child: Text(
                                    conversionType.label,
                                    style: _targetTextStyle,
                                  ),
                                ),
                              DropdownMenuItem(
                                enabled: false,
                                child: Row(
                                  children: [
                                    const Text(
                                      "N: ",
                                      style: _targetTextStyle,
                                    ),
                                    IntrinsicWidth(
                                      child: TextField(
                                        controller: nTextController,
                                        cursorColor: ColorTheme.accent,
                                        decoration: const InputDecoration(
                                          counterText: "",
                                          border: InputBorder.none,
                                        ),
                                        style: _targetTextStyle,
                                        maxLength: 2,
                                        keyboardType: TextInputType.number,
                                        enableSuggestions: false,
                                        onSubmitted: (value) {
                                          int newValue =
                                              int.tryParse(value) ?? targetSize;
                                          newValue = newValue != 0
                                              ? newValue
                                              : targetSize;
                                          ref
                                              .read(targetSizeProvider.notifier)
                                              .state = newValue;
                                          nTextController.text =
                                              newValue.toString();
                                          Navigator.pop(context);
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              )
            ],
          )
        ],
      ),
    );
  }
}
