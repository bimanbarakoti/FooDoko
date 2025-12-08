// lib/app/config/app_fonts.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralized typography helpers for FooDoko
class AppFonts {
  AppFonts._();

  static TextStyle headlineXL([Color? color]) =>
      GoogleFonts.poppins(fontSize: 34, fontWeight: FontWeight.w700, color: color);

  static TextStyle headlineL([Color? color]) =>
      GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: color);

  static TextStyle bodyM([Color? color]) =>
      GoogleFonts.inter(fontSize: 16, color: color);

  static TextStyle bodyS([Color? color]) =>
      GoogleFonts.inter(fontSize: 14, color: color);

  // small helper for buttons
  static TextStyle button([Color? color]) =>
      GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: color);
}
