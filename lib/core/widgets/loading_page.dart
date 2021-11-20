import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pomar_app/core/widgets/gradient_container_body.dart';

class LoadingPage extends StatefulWidget {
  LoadingPage({Key? key}) : super(key: key);

  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  Widget build(BuildContext context) {
    return const GradientContainerBody(child: CircularProgressIndicator());
  }
}
