import 'package:flutter/material.dart';

class ConditionalParentWidget extends StatelessWidget {
  const ConditionalParentWidget({
    super.key,
    required this.child,
    required this.parentBuilder,
    this.isIncluded = true,
  });

  final Widget child;
  final Widget Function(Widget child) parentBuilder;
  final bool isIncluded;

  @override
  Widget build(BuildContext context) {
    if (!isIncluded) return child;
    return parentBuilder(child);
  }
}
