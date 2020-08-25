import 'package:controle_de_cadastro/models/Usuario.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListViewWidget extends StatelessWidget {
  Usuario usuario;
  VoidCallback onTapItem;
  VoidCallback onPressedRemover;
  Icon icon;

  ListViewWidget(
      {@required this.usuario,
        @required this.icon,
        this.onTapItem,
        this.onPressedRemover});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTapItem,
      child: Card(
        elevation: 8,
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            children: <Widget>[
              /** imagem **/
              SizedBox(
                height: 120,
                width: 120,
                child: Image.network(
                 usuario.fotos[0],
                  fit: BoxFit.cover,
                ),
              ),
              /** conteudo **/
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        usuario.name,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(usuario.email),
                      Text(usuario.phone)
                    ],
                  ),
                ),
              ),
              /** icone **/
              if (this.onPressedRemover != null)
                Expanded(
                  flex: 1,
                  child: FlatButton(
                    padding: EdgeInsets.all(10),
                    onPressed: this.onPressedRemover,
                    child: this.icon
                    ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
