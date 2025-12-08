import 'dart:ui';
import 'package:flutter/material.dart';

class FrostedContainer extends StatelessWidget {
  final Widget child;
  final double blur;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;

  const FrostedContainer({
    Key? key,
    required this.child,
    this.blur = 10.0,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: borderRadius,
            border: Border.all(color: Colors.white24, width: 1),
          ),
          child: child,
        ),
      ),
    );
  }
}
