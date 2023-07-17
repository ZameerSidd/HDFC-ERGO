import 'package:flutter/material.dart';

extension SymmetricPadding on Widget {
  symmetric({double? horizontal, double? vertical}) => Padding(
        padding: EdgeInsets.symmetric(
            horizontal: horizontal ?? 0, vertical: vertical ?? 0),
        child: this,
      );
}
