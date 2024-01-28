import 'package:app_0byte/global/styles/colors.dart';
import 'package:flutter/material.dart';

import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:app_0byte/global/styles/dimensions.dart';

class SlidableDelete extends StatelessWidget {
  final dynamic
      value; // used in ValueKey (otherwise glitches the slide animation on next row)
  final Object? groupTag;
  final SlidableActionCallback onDelete;
  final Widget child;

  const SlidableDelete({
    super.key,
    required this.value,
    required this.groupTag,
    required this.onDelete,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(value),
      groupTag: groupTag,
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        extentRatio: DimensionsTheme
            .slidableExtendRatio, // FIXME too long on wide screens
        children: [
          SlidableAction(
            icon: Icons.delete,
            backgroundColor: UIColors.danger,
            onPressed: onDelete,
          )
        ],
      ),
      child: child,
    );
  }
}
