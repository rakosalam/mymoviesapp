import 'package:flutter/material.dart';

class AppRadius {
  AppRadius._();

  static const double sm = 4;
  static const double regular = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 24;
  static const double full = 9999;

  static BorderRadius get smBorder => BorderRadius.circular(sm);
  static BorderRadius get regularBorder => BorderRadius.circular(regular);
  static BorderRadius get mdBorder => BorderRadius.circular(md);
  static BorderRadius get lgBorder => BorderRadius.circular(lg);
  static BorderRadius get xlBorder => BorderRadius.circular(xl);
  static BorderRadius get fullBorder => BorderRadius.circular(full);
}
