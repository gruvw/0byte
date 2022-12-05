import 'package:app_0byte/providers/providers.dart';
import 'package:app_0byte/styles/colors.dart';
import 'package:app_0byte/styles/fonts.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class CollectionsList extends HookConsumerWidget {
  const CollectionsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collections = ref.watch(collectionsProvider);

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      itemBuilder: (context, index) {
        if (index == collections.length) {
          return const ListTile(
            leading: Icon(
              Icons.add,
              color: ColorTheme.text2,
            ),
            title: Text(
              "New collection",
              style: TextStyle(
                fontFamily: FontTheme.fontFamily1,
                fontSize: FontTheme.fontSize4,
                color: ColorTheme.text2,
              ),
            ),
          );
        }
        return ListTile(
          title: Text(
            collections[index].label,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: FontTheme.fontFamily1,
              fontSize: FontTheme.fontSize4,
              color: ColorTheme.text1,
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(
        color: ColorTheme.text2,
      ),
      itemCount: collections.length + 1,
    );
  }
}
