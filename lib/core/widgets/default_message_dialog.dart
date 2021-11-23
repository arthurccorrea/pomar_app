import 'package:flutter/material.dart';

class DefaultMessageDialog extends AlertDialog {
  final String mensagem;
  final IconData icon;
  final Color iconColor;
  final BuildContext context;
  final Color textColor;
  final String confirmarText;
  final Function()? okFunction;

  const DefaultMessageDialog(
      {Key? key, required this.mensagem,
      required this.icon,
      required this.iconColor,
      required this.context,
      this.textColor = Colors.white,
      this.confirmarText = "OK",
      backgroundColor = Colors.brown,
      this.okFunction}) : super(backgroundColor: backgroundColor, key: key);

  @override
  AlertDialog build(BuildContext context) {
    return AlertDialog(
      backgroundColor: super.backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      title: Icon(
        icon,
        color: iconColor,
        size: 80,
      ),
      content: SingleChildScrollView(
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            Text(
              mensagem,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: textColor),
            ),
            const Divider(
              color: Colors.green,
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextButton(
                  child: Text(
                    confirmarText,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 25,
                        color: textColor,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: okFunction ?? () => Navigator.of(context).pop()
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}