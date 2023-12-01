import 'package:flutter/material.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;
  final Animation<Color?> colorTween;

  const GradientBackground({
    Key? key,
    required this.child,
    required this.colorTween,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: colorTween,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, colorTween.value ?? Colors.blue],
            ),
          ),
          child: child,
        );
      },
      child: child,
    );
  }
}
