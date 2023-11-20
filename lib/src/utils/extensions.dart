import 'package:flutter/material.dart';

extension DoubleExtension on double {
  String rounded() {
    RegExp regex = RegExp(r'([.]*0*)(?!.*\d)');
    String s = toStringAsFixed(3).replaceAll(regex, '');

    return s;
  }
}

extension StringExtension on String {
  List<Color> colorsFromCSS() {
    final colors = RegExp(r'^linear-gradient\((\d+)deg,\s*(.+)\)$')
        .firstMatch(this)
        ?.group(2)
        ?.replaceAll(RegExp(r'([0-9]+)%'), '')
        .split(RegExp(r',\s'))
        .map((e) => e.trim()._colorFromHex())
        .toList();

    if (colors != null) return colors;

    final isHex = RegExp(r'^#?([0-9a-fA-F]{6}|[0-9a-fA-F]{3})$').hasMatch(this);

    return isHex ? [_colorFromHex(), _colorFromHex()] : [];
  }

  Color _colorFromHex() {
    String hex = replaceAll('#', '').toUpperCase();
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }
}
