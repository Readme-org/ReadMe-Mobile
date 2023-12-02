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
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color.fromARGB(78, 147, 205, 232), colorTween.value ?? Color.fromARGB(255, 3, 142, 255)],
            ),
          ),
          child: child,
        );
      },
      child: child,
    );
  }
}
