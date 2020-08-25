import 'package:controle_de_cadastro/config/themes/ThemeDefault.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  String title;
  String subTitle;
  VoidCallback onTapItem;
  VoidCallback onPressedRemover;
  Icon icon;

  CardWidget(
      {this.title, this.subTitle, this.icon, this.onTapItem, this.onPressedRemover});

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
                child: this.icon,
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
                        this.title,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(this.subTitle)
                    ],
                  ),
                ),
              ),
              /** icone **/
              if (this.onPressedRemover != null)
                Expanded(
                  flex: 1,
                  child: FlatButton(
                    color: Colors.red,
                    padding: EdgeInsets.all(10),
                    onPressed: this.onPressedRemover,
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
