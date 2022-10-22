import 'package:flutter/material.dart';

class ColumnPadding extends StatelessWidget {
  const ColumnPadding({Key? key, required this.child}) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 30.0)
          .add(const EdgeInsets.symmetric(horizontal: 32)),
      child: child,
    );
  }
}
