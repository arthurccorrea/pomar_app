import 'package:flutter/material.dart';

class GradientContainerBody extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const GradientContainerBody({required this.child, this.padding, Key? key})
      : super(key: key);

  @override
  _GradientContainerBodyState createState() => _GradientContainerBodyState();
}

class _GradientContainerBodyState extends State<GradientContainerBody> {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        padding: widget.padding,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.green, Colors.green.shade200]),
        ),
        child: widget.child);
  }
}
