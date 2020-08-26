import 'package:controle_de_cadastro/config/themes/ThemeDefault.dart';
import 'package:flutter/material.dart';

class AlertDialogWidget extends StatelessWidget {
  BuildContext context;
  String texto;
  Color cor;

  AlertDialogWidget(
      {@required this.context, @required this.texto, this.cor = Colors.blue});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _abriDialog(this.context),
    );
  }

  Widget _abriDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProgressIndicator(
                  backgroundColor: this.cor,
                ),
                SizedBox(height: 20),
                Text(this.texto)
              ],
            ),
          );
        });
  }
}
