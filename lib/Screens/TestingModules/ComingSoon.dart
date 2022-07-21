import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:vivii/globals.dart' as global;

class ComingSoon extends StatefulWidget {
  const ComingSoon({Key? key}) : super(key: key);

  @override
  State<ComingSoon> createState() => _ComingSoonState();
}

class _ComingSoonState extends State<ComingSoon> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Coming soon!",
        style: GoogleFonts.nunito(
            fontWeight: FontWeight.bold,
            fontSize: 30,
            color: HexColor(global.primary_color)),
      ),
    );
  }
}
