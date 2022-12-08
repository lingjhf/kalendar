import 'package:flutter/material.dart';

import 'theme.dart';

class KalendarPickerContainer extends StatelessWidget {
  const KalendarPickerContainer({
    super.key,
    required this.width,
    required this.height,
    required this.style,
    required this.child,
    this.disable = false,
  });

  final double width;

  final double height;

  final bool disable;

  final KalendarStyle style;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(color: style.primaryColor),
      child: Container(
        padding: style.padding,
        decoration: BoxDecoration(
          color: style.backgroundColor,
          borderRadius: style.borderRadius,
        ),
        child: Stack(children: [
          SizedBox(width: width, height: height, child: child),
          if (disable)
            const Positioned.fill(
              child: MouseRegion(
                cursor: SystemMouseCursors.forbidden,
                child: SizedBox(),
              ),
            )
        ]),
      ),
    );
  }
}
