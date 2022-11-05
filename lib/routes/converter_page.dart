import 'package:app_0byte/models/conversion_types.dart';
import 'package:app_0byte/styles/fonts.dart';
import 'package:app_0byte/styles/settings.dart';
import 'package:flutter/material.dart';

import 'package:app_0byte/providers/providers.dart';
import 'package:app_0byte/styles/colors.dart';
import 'package:app_0byte/widget/conversion_entry_widget.dart';
import 'package:app_0byte/widget/utils/slidable_delete.dart';
import 'package:app_0byte/widget/conversion_title_widget.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ConverterPage extends StatelessWidget {
  const ConverterPage({super.key});

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
        children: const [
          ConversionTitleWidget(),
          Expanded(
            child: SingleChildScrollView(
              child: _NumberEntries(),
            ),
          ),
        ],
      ),
      floatingActionButton: SpeedDial(
        backgroundColor: ColorTheme.textPrefix,
        icon: Icons.add,
        activeIcon: Icons.close,
        foregroundColor: ColorTheme.text1,
        useRotationAnimation: false,
        renderOverlay: false,
        childrenButtonSize: const Size(
          SettingsTheme.floatingActionChildrenSize,
          SettingsTheme.floatingActionChildrenSize,
        ),
        spacing: 8,
        children: [
          for (final conversionType in ConversionType.values)
            SpeedDialChild(
              backgroundColor: ColorTheme.background2,
              labelBackgroundColor: ColorTheme.background2,
              labelShadow: [],
              labelStyle: const TextStyle(
                color: ColorTheme.text1,
              ),
              label: conversionType.label,
              child: Text(
                conversionType.prefix,
                style: const TextStyle(
                  color: ColorTheme.textPrefix,
                  fontFamily: FontTheme.fontFamily2,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
              onTap: () {
                final nbEntries = container.read(entriesProvider).length;

                database.createUserEntry(
                  type: conversionType,
                  input: "",
                  label: "Value ${nbEntries + 1}",
                );
              },
            ),
        ],
      ),
    );
  }
}

class _NumberEntries extends ConsumerWidget {
  const _NumberEntries();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(entriesProvider);

    return Column(
      children: [
        for (final entry in entries)
          SlidableDelete(
            onDelete: (_) => entry.delete(),
            child: ConversionEntryWidget(entry: entry),
          ),
      ],
    );
  }
}
