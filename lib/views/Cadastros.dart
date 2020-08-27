import 'package:controle_de_cadastro/config/themes/ThemeDefault.dart';
import 'package:controle_de_cadastro/routes/routes.dart';
import 'package:controle_de_cadastro/widgets/CardWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Cadastros extends StatefulWidget {
  @override
  _CadastrosState createState() => _CadastrosState();
}

class _CadastrosState extends State<Cadastros> {
  /** recupera a instancia **/
  FirebaseAuth _auth = FirebaseAuth.instance;

  /** cria lista de menu **/
  List<String> itemMenu = ["Deslogar"];

  _escolhaMenuItem(String itemEscolhido) {
    //print(itemEscolhido);
    switch( itemEscolhido ){
      case "Deslogar":
        _deslogarUsuario();
        break;
    }
  }

  _deslogarUsuario() async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, RouteGenerate.ROTA_LOGIN);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cadastros',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _escolhaMenuItem,
            itemBuilder: (context) {
              /** constroi a lista de menu **/
              return itemMenu.map((String item) {
                return PopupMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList();
            },
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(gradient: gradientDefault),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                CardWidget(
                  icon: Icon(
                    Icons.person_add,
                    size: 90,
                    color: Colors.blue,
                  ),
                  title: 'Cadastro de Usuário',
                  subTitle:
                      'Esse e um exemplo de cadastro de usuário com validações, '
                      'com imagens da camera, '
                      'e a possibilidade de fazer ligação',
                  onTapItem: () {
                    Navigator.pushReplacementNamed(
                        context, RouteGenerate.ROTA_LISTA_USUARIO);
                  },
                ),
                CardWidget(
                  icon: Icon(
                    Icons.photo_album,
                    size: 90,
                    color: Colors.blue,
                  ),
                  title: 'Album Viagens',
                  subTitle: 'Monta um carrosel com as imagens selecionadas, '
                      'como tambem detalhes de como foi a viagem',
                  onTapItem: (){
                    Navigator.pushReplacementNamed(context, RouteGenerate.ROTA_ALBUNS_VIAGENS);
                  },
                ),
                CardWidget(
                  icon: Icon(
                    Icons.location_on,
                    size: 90,
                    color: Colors.blue,
                  ),
                  title: 'Localização',
                  subTitle: 'Pega sua localição ataul, e acordo com a pesquisa'
                      ' mostra o trajeto',
                  onTapItem: (){
                    Navigator.pushReplacementNamed(context, RouteGenerate.ROTA_LOCALIZACOES);
                  },
                ),
                CardWidget(
                  icon: Icon(
                    Icons.list,
                    size: 90,
                    color: Colors.blue,
                  ),
                  title: 'Anotações',
                  subTitle: 'Lista de anotações com banco de dados local',
                  onTapItem: (){
                    Navigator.pushReplacementNamed(context, RouteGenerate.ROTA_ANOTACOES);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
