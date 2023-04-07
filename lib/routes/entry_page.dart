import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:app_0byte/global/styles/colors.dart';
import 'package:app_0byte/global/styles/fonts.dart';
import 'package:app_0byte/models/number_entry.dart';
import 'package:app_0byte/utils/validation.dart';

class EntryPage extends StatelessWidget {
  final Mutable<NumberEntry> entry;
  final bool deleteOnCancel;

  const EntryPage({
    required this.entry,
    this.deleteOnCancel = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorTheme.background3,
        title: Text(
          entry.object.collection.label,
          style: GoogleFonts.getFont(FontTheme.firaSans),
        ),
      ),
    );
  }
}
