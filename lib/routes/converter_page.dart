import 'package:app_0byte/models/conversion_types.dart';
import 'package:app_0byte/styles/colors.dart';
import 'package:app_0byte/widget/conversion_entry_widget.dart';
import 'package:app_0byte/widget/conversion_title_widget.dart';
import 'package:flutter/material.dart';

class ConverterPage extends StatelessWidget {
  const ConverterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final int n = ConversionType.hexadecimal.defaultTargetSize;

    return Scaffold(
      backgroundColor: ColorTheme.background1,
      appBar: AppBar(
        backgroundColor: ColorTheme.background3,
        leading: const Icon(
          Icons.menu,
          color: ColorTheme.text1,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.bookmark_border,
              color: ColorTheme.text1,
            ),
          )
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const ConversionTitleWidget(),
          Column(
            // scrollDirection: Axis.vertical,
            // shrinkWrap: true,
            children: [
              ConversionEntryWidget(
                input: "invalid number",
              ),
              ConversionEntryWidget(
                input: "0s-10",
                label: "Negative test",
              ),
              ConversionEntryWidget(
                input: "0s-1",
                label: "Negative test",
              ),
              ConversionEntryWidget(
                input: "0s37",
                label: "Negative test",
              ),
              ConversionEntryWidget(
                input: "0s-37",
                label: "Negative test",
              ),
              ConversionEntryWidget(
                input: "0d37",
                label: "Negative test",
              ),
              ConversionEntryWidget(
                input: "0s9999999999",
                label: "Negative test",
              ),
              ConversionEntryWidget(
                input: "0s01",
                label: "Negative test",
              ),
              ConversionEntryWidget(
                input: "0s9",
                label: "Negative test",
              ),
              ConversionEntryWidget(
                input: "0d9",
                label: "Negative test",
              ),
              ConversionEntryWidget(
                input: "0s-7",
                label: "Negative test",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
