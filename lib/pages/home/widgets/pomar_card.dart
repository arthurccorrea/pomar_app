import 'package:flutter/material.dart';
import 'package:pomar_app/model/pomar.dart';

class PomarCard extends StatefulWidget {
  final Pomar pomar;
  const PomarCard({required this.pomar, Key? key}) : super(key: key);

  @override
  _PomarCardState createState() => _PomarCardState();
}

class _PomarCardState extends State<PomarCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(widget.pomar.descricao),
        ],
      ),
    );
  }
}
