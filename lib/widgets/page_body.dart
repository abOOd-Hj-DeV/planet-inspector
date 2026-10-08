import 'package:flutter/material.dart';

class PageBody extends StatelessWidget {
  const PageBody({super.key, required this.child, this.maxWidth = 600});
  final Widget child;
  final double maxWidth;
  @override
  Widget build(BuildContext context) => SafeArea(
    child: Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    ),
  );
}

class FlowerHeader extends StatelessWidget {
  const FlowerHeader({super.key, this.height = 220});
  final double height;
  @override
  Widget build(BuildContext context) =>
      Image.asset('img/flower.png', height: height, fit: BoxFit.contain);
}
