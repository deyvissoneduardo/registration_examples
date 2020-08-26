import 'package:controle_de_cadastro/views/Anotacao/Anotacoes.dart';
import 'package:controle_de_cadastro/views/Cadastros.dart';
import 'package:controle_de_cadastro/views/Login/Login.dart';
import 'package:controle_de_cadastro/views/Usuario/ListaUsuario.dart';
import 'package:controle_de_cadastro/views/Usuario/CadastroUsuario.dart';
import 'package:controle_de_cadastro/views/Viagens/AlbunsViagens.dart';
import 'package:controle_de_cadastro/views/Viagens/CadastroViagem.dart';
import 'package:controle_de_cadastro/views/Viagens/DetalhesViagens.dart';
import 'package:flutter/material.dart';

class RouteGenerate {
  static const String ROTA_HOME = '/';
  static const String ROTA_LOGIN = '/Login';
  static const String ROTA_CADASTROS = '/Cadastros';
  static const String ROTA_CADASTRO_USUARIO = '/CadastroUsuario';
  static const String ROTA_LISTA_USUARIO = '/ListaUsuario';
  static const String ROTA_ALBUNS_VIAGENS = '/AlbunsViagens';
  static const String ROTA_CADASTRO_VIAGEM = '/CadastroViagem';
  static const String ROTA_DETALHES_VIAGEM = '/DetalhesViagens';
  static const String ROTA_ANOTACOES = '/Anotacoes';

  static Route<dynamic> genetareRoutes(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case ROTA_HOME:
        return MaterialPageRoute(builder: (_) => Login());
      case ROTA_LOGIN:
        return MaterialPageRoute(builder: (_) => Login());
      case ROTA_CADASTROS:
        return MaterialPageRoute(builder: (_) => Cadastros());
      /** usuario **/
      case ROTA_CADASTRO_USUARIO:
        return MaterialPageRoute(builder: (_) => CadastroUsuario());
      case ROTA_LISTA_USUARIO:
        return MaterialPageRoute(builder: (_) => ListaUsuario());
      /** viagem **/
      case ROTA_CADASTRO_VIAGEM:
        return MaterialPageRoute(builder: (_) => CadastroViagem());
      case ROTA_ALBUNS_VIAGENS:
        return MaterialPageRoute(builder: (_) => AlbunsViagens());
      case ROTA_DETALHES_VIAGEM:
        return MaterialPageRoute(builder: (_) => DetalhesViagens(args));
        /** anotacao **/
      case ROTA_ANOTACOES:
        return MaterialPageRoute(builder: (_) => Anotacoes());
      default:
        _erroRota();
    }
  }

  static Route<dynamic> _erroRota() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        backgroundColor: Colors.red,
        appBar: AppBar(
          title: Text('Tela Não Encontrada'),
        ),
        body: Center(
          child: Text('Tela Não Encontrada'),
        ),
      );
    });
  }
}
