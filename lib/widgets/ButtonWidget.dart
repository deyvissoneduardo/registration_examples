import 'package:controle_de_cadastro/config/themes/ThemeDefault.dart';
import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final Color corText;
  final VoidCallback onPressed;

  ButtonWidget(
      {@required this.text, this.corText = Colors.white, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Text(
        this.text,
        style: TextStyle(color: this.corText, fontSize: 20),
      ),
      color: temaPadrao.primaryColor,
      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
      onPressed: this.onPressed,
    );
  }
}
