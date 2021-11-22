import 'package:flutter/material.dart';
import 'package:pomar_app/core/util/page_util.dart';
import 'package:pomar_app/dao/pomar_dao.dart';
import 'package:pomar_app/model/pomar.dart';
import 'package:pomar_app/pages/pomar/cadastro_pomar.dart';

class PomarCard extends StatefulWidget {
  final Pomar pomar;
  const PomarCard({required this.pomar, Key? key}) : super(key: key);

  @override
  _PomarCardState createState() => _PomarCardState();
}

class _PomarCardState extends State<PomarCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        PomarDao pomarDao = PomarDao();
        Pomar pomar = await pomarDao.findByCodigo(widget.pomar.codigo!);
        PageUtil.navigate(CadastroPomar(pomar: pomar), context);
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.white,
            image: DecorationImage(
                image: AssetImage("images/tree.png"),
                colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.2), BlendMode.dstATop))),
        child: Center(
          child: Text(widget.pomar.nome, style: TextStyle(color: Colors.black),),
        ),
      ),
    );
  }
}
