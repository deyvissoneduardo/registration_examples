import 'package:controle_de_cadastro/config/themes/ThemeDefault.dart';
import 'package:flutter/material.dart';

class FlatButtonWidget extends StatelessWidget {
  final String text;
  final Color cor;
  final VoidCallback onPressed;

  FlatButtonWidget(
      {@required this.text, @required this.onPressed, this.cor = Colors.blue});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        child: Text(
          this.text,
          style: TextStyle(color: this.cor),
        ),
        onPressed: this.onPressed);
  }
}
