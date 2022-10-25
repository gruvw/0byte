import 'package:app_0byte/models/conversion_types.dart';
import 'package:app_0byte/styles/colors.dart';
import 'package:app_0byte/widget/conversion_entry_widget.dart';
import 'package:app_0byte/widget/conversion_title_widget.dart';
import 'package:flutter/material.dart';

class ConverterPage extends StatelessWidget {
  const ConverterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final int n = ConversionType.hexadecimal.defaultN;

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
          ConversionTitleWidget(
            targetType: ConversionType.hexadecimal,
            n: n,
          ),
          ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: const [
              ConversionEntryWidget(
                input: "invalid number",
                targetType: ConversionType.hexadecimal,
              ),
              ConversionEntryWidget(
                input: "0d-10",
                targetType: ConversionType.hexadecimal,
                label: "Negative test",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
