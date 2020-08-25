import 'package:controle_de_cadastro/config/themes/ThemeDefault.dart';
import 'package:flutter/material.dart';

class CarregandoWidget extends StatelessWidget {
  String texto;

  CarregandoWidget({@required this.texto});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: <Widget>[
            Text(
              this.texto,
              style: TextStyle(fontSize: 20),
            ),
            CircularProgressIndicator(
              backgroundColor: temaPadrao.primaryColor,
            )
          ],
        ),
      ),
    );
  }
}
