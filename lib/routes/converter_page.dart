import 'package:app_0byte/widget/utils/slidable_delete.dart';
import 'package:flutter/material.dart';

import 'package:app_0byte/providers/providers.dart';
import 'package:app_0byte/styles/colors.dart';
import 'package:app_0byte/widget/conversion_entry_widget.dart';
import 'package:app_0byte/widget/conversion_title_widget.dart';
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
    );
  }
}

class _NumberEntries extends ConsumerWidget {
  const _NumberEntries();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(entriesProvider);

    if (entries.isEmpty) {
      return TextButton(
          onPressed: (() =>
              database.createUserEntry(input: "0b11111", label: "value")),
          child: Text("click me to add entry"));
    }

    return Column(
      children: [
        for (final entry in entries)
          SlidableDelete(
            onDelete: (_) => entry.delete(),
            child: ConversionEntryWidget(entry: entry),
          ),
        TextButton(
          onPressed: () => database.createUserEntry(
            input: "0b010101",
            label: "another value",
          ),
          child: Text("click me to add another entry"),
        ),
      ],
    );
  }
}
