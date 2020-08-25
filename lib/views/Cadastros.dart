import 'package:controle_de_cadastro/config/themes/ThemeDefault.dart';
import 'package:controle_de_cadastro/routes/routes.dart';
import 'package:controle_de_cadastro/widgets/CardWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Cadastros extends StatefulWidget {
  @override
  _CadastrosState createState() => _CadastrosState();
}

class _CadastrosState extends State<Cadastros> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cadastros',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: gradientDefault),
        child: Padding(
          padding: EdgeInsets.all(8),
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
                subTitle: 'com Validações',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
