import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pomar_app/core/constants.dart';

class PageUtil {
  /// Invoca o método push do [Navigator] para o Widget passado por parâmetro
  static void navigate(Widget page, BuildContext context) {
    Future.delayed(Duration.zero, () {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (BuildContext context) => page));
    });
  }

  /// Invoca o método pushReplacement do [Navigator] para o Widget passado por parâmetro
  static navigateReplacement(Widget page, BuildContext context) {
    Future.delayed(Duration.zero, () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => page));
    });
  }

  /// Invoca o método pushNamed do [Navigator] para o Widget passado por parâmetro
  static navigateToRoute(String route, BuildContext context) {
    Future.delayed(Duration.zero, () {
      Navigator.pushNamed(context, route);
    });
  }

  /// Invoca o método pushReplacementNamed do [Navigator] para o Widget passado por parâmetro
  static navigateToRouteReplacement(String route, BuildContext context) {
    Future.delayed(Duration.zero, () {
      Navigator.pushReplacementNamed(context, route);
    });
  }

  /// Faz fechar todos os contextos até chegar a primeira rota, que é a [HomePage]
  static popToHome(BuildContext context) {
    Future.delayed(Duration.zero, () {
      Navigator.of(context).popUntil((route) => route.isFirst);
    });
  }

  /// Retorna o divider padrão na cor [Colors.white] e com Padding de 40% da tela pra esquerda e pra direita
  /// Usado em diversas telas para separar informações e componentes
  static Padding divider(BuildContext context,
      {Color color = Colors.brown,
      double? padding,
      double? paddingVertical}) {
    double paddingPadrao = MediaQuery.of(context).size.width * 0.30;
    return Padding(
      padding: EdgeInsets.only(
          right: padding ?? paddingPadrao,
          left: padding ?? paddingPadrao,
          top: paddingVertical ?? defaultHorizontalPadding,
          bottom: paddingVertical ?? defaultHorizontalPadding),
      child: Divider(
        color: color,
        thickness: 2,
      ),
    );
  }
}
