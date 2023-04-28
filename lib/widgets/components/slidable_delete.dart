import 'package:flutter/material.dart';

import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/dimensions.dart';

class SlidableDelete extends StatelessWidget {
  final Widget child;
  final SlidableActionCallback onDelete;
  final Object? groupTag;

  const SlidableDelete({
    super.key,
    required this.onDelete,
    required this.child,
    required this.groupTag,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      groupTag: groupTag,
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        extentRatio: DimensionsTheme.slidableExtendRatio,
        children: [
          SlidableAction(
            icon: Icons.delete,
            backgroundColor: ColorTheme.danger,
            onPressed: onDelete,
          )
        ],
      ),
      child: child,
    );
  }
}
