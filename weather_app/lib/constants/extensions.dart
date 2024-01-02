import 'package:flutter/material.dart';

extension SpacerExtensions on num {
  Widget verticalSpacer({double height = 0.0}) {
    return SizedBox(
      height: height > 0.0 ? height : toDouble(),
      width: double.infinity,
    );
  }

  Widget horizontalSpacer({double width = 0.0}) {
    return SizedBox(
      width: width > 0.0 ? width : toDouble(),
      height: double.infinity,
    );
  }
}
