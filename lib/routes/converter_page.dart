import 'package:app_0byte/models/conversion_types.dart';
import 'package:app_0byte/styles/colors.dart';
import 'package:app_0byte/widget/conversion_title_widget.dart';
import 'package:flutter/material.dart';

class ConverterPage extends StatelessWidget {
  const ConverterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            n: ConversionType.hexadecimal.defaultN,
          )
        ],
      ),
    );
  }
}
