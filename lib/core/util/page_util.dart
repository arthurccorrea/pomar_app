import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pomar_app/core/constants.dart';
import 'package:pomar_app/core/widgets/default_message_dialog.dart';

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
      {Color color = Colors.brown, double? padding, double? paddingVertical}) {
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

  /// Retorna o AlertDialog de atenção, com um icone que indica atenção e um texto
  /// Neste método também é possível customizar o texto de confirmação e a função ao confirmar
  static void warningAlertDialog(String mensagem, context,
      {String confirmarText = "OK", Function()? okFunction}) {
    Widget alert = DefaultMessageDialog(
        mensagem: mensagem,
        icon: CupertinoIcons.exclamationmark_triangle,
        iconColor: const Color(0xFFebb734),
        context: context,
        okFunction: okFunction,
        confirmarText: confirmarText);

    showMessageDialog(alert, context);
  }

  /// Retorna o AlertDialog de atenção, com um icone que indica informação e um texto
  /// Neste método também é possível customizar o texto de confirmação e a função ao confirmar
  static void infoAlertDialog(String mensagem, context,
      {String confirmarText = "OK",
      Function()? okFunction}) {
    Widget alert = DefaultMessageDialog(
            mensagem: mensagem,
            icon: CupertinoIcons.info,
            iconColor: Colors.white,
            context: context,
            okFunction: okFunction,
            confirmarText: confirmarText);

    showMessageDialog(alert, context);
  }

  /// Retorna o AlertDialog de falha, com icone que indica falha e texto
  /// Neste método também é possível customizar o texto de confirmação e a função ao confirmar
  static void failureAlertDialog(String mensagem, context,
      {String confirmarText = "OK",
      Function()? okFunction}) {
    Widget alert = DefaultMessageDialog(
        mensagem: mensagem,
        icon: Icons.cancel_outlined,
        iconColor: Colors.red,
        context: context,
        okFunction: okFunction,
        confirmarText: confirmarText);

    showMessageDialog(alert, context);
  }

  /// Retorna o AlertDialog de sucesso, com icone que indica sucesso e texto
  /// Neste método também é possível customizar o texto de confirmação e a função ao confirmar
  static void successAlertDialog(String mensagem, context,
      {String confirmarText = "OK",
      Function()? okFunction}) {
        Widget alert = DefaultMessageDialog(
        mensagem: mensagem,
        icon: Icons.check_circle,
        iconColor: Colors.green,
        context: context,
        okFunction: okFunction,
        confirmarText: confirmarText);

    showMessageDialog(alert, context);
  }

  /// Mostra o messageDialog passado por parâmetro fazendo uma animação em que ele começa no topo da tela e vai até o centro
  static void showMessageDialog(Widget alert, context) {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
            child: Opacity(opacity: a1.value, child: alert),
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return Container();
        });
  }
}
