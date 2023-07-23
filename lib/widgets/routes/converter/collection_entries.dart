import 'package:flutter/material.dart';

import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/dimensions.dart';
import 'package:app_0byte/models/collection.dart';
import 'package:app_0byte/models/number_conversion_entry.dart';
import 'package:app_0byte/utils/validation.dart';
import 'package:app_0byte/widgets/components/slidable_delete.dart';
import 'package:app_0byte/widgets/conversion/number_conversion_view.dart';

class CollectionEntries extends StatelessWidget {
  final Collection collection;

  const CollectionEntries({super.key, required this.collection});

  @override
  Widget build(BuildContext context) {
    final entries = collection.sortedEntries;

    return Theme(
      data: ThemeData(canvasColor: ColorTheme.background2),
      child: ReorderableListView.builder(
        buildDefaultDragHandles: false,
        onReorder: (oldIndex, newIndex) {
          if (oldIndex < newIndex) {
            newIndex -= 1;
          }
          entries[oldIndex].move(newIndex);
        },
        footer: const SizedBox(
          height: DimensionsTheme.converterPageEndScrollingSpacing,
        ),
        itemCount: entries.length,
        itemBuilder: (context, index) => _NumberEntry(
          key: ValueKey(index),
          index: index,
          entry: entries[index],
        ),
      ),
    );
  }
}

class _NumberEntry extends StatelessWidget {
  final int index;
  final NumberConversionEntry entry;

  const _NumberEntry({
    super.key,
    required this.entry,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return ReorderableDelayedDragStartListener(
      index: index,
      child: Column(
        children: [
          SlidableDelete(
            value: entry.hashCode,
            groupTag: entry.collection,
            onDelete: (_) => entry.delete(),
            child: Padding(
              padding: PaddingTheme.entry,
              child: NumberConversionEntryView(entryKey: Mutable(entry.key)),
            ),
          ),
          const Divider(
            height: DimensionsTheme.entryDividerHeight,
            thickness: DimensionsTheme.entryDividerThickness,
            color: ColorTheme.background2,
          ),
        ],
      ),
    );
  }
}
