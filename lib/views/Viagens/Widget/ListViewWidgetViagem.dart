import 'package:controle_de_cadastro/models/Viagens/Viagens.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ListViewWidgetViagem extends StatelessWidget {
  Viagens viagens;
  VoidCallback onTapItem;
  VoidCallback onPressedRemover;

  ListViewWidgetViagem(
      {@required this.viagens, this.onTapItem, this.onPressedRemover});

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
                  viagens.photos[0],
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
                        viagens.title,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text('Inicio dessa Viagem ${viagens.dateInit}'),
                      Text('Termino dessa Viagem ${viagens.dateEnd}')
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
