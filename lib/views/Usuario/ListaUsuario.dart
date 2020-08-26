import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_de_cadastro/config/database/Firebase.dart';
import 'package:controle_de_cadastro/models/Usuario/Usuario.dart';
import 'package:controle_de_cadastro/routes/routes.dart';
import 'package:controle_de_cadastro/widgets/CarregandoWidget.dart';
import 'package:controle_de_cadastro/views/Usuario/Widget/ListViewWidgetUsuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ListaUsuario extends StatefulWidget {
  @override
  _ListaUsuarioState createState() => _ListaUsuarioState();
}

class _ListaUsuarioState extends State<ListaUsuario> {
  /** instancias **/
  FirebaseStorage _storage = FirebaseStorage.instance;
  Firestore _banco = Firestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  String _idUsuario;

  /** controladores **/
  final _controller = StreamController<QuerySnapshot>.broadcast();

  /** recupera dados do usuairo logado **/
  _recuperaDadosUsuario() async {
    FirebaseUser usuarioLoagado = await _auth.currentUser();
    _idUsuario = usuarioLoagado.uid;
  }

  /** recupera dados do usuario **/
  Future<Stream<QuerySnapshot>> _adcionarListener() async {
    await _recuperaDadosUsuario();

    Stream<QuerySnapshot> stream = _banco
        .collection(Firebase.COLECAO_USUARIOS)
        .document(_idUsuario)
        .collection(Firebase.COLECAO_CONTATOS)
        .snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  _ligarTelefone(String telefone) async {
    if (await canLaunch('tel:${telefone}')) {
      await launch('tel:${telefone}');
    } else {
      return Container();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _adcionarListener();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Lista de Usuarios'),
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 7,
          foregroundColor: Colors.white,
          child: Icon(Icons.person_add),
          onPressed: () {
            Navigator.pushReplacementNamed(
                context, RouteGenerate.ROTA_CADASTRO_USUARIO);
          },
        ),
        body: StreamBuilder(
          stream: _controller.stream,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return CarregandoWidget(texto: 'Carregando....');
                break;
              case ConnectionState.active:
              case ConnectionState.done:
                /** verifica possiveis erros **/
                if (snapshot.hasError) {
                  return CarregandoWidget(texto: 'Erro ao carregar dados');
                }
                /** recupera os dados caso nao haja erro **/
                QuerySnapshot querySnapshot = snapshot.data;
                return ListView.builder(
                    itemCount: querySnapshot.documents.length,
                    itemBuilder: (_, index) {
                      /** transforma snapshot em lista **/
                      List<DocumentSnapshot> usuarios =
                          querySnapshot.documents.toList();
                      /** pega pelo index **/
                      DocumentSnapshot documentSnapshot = usuarios[index];

                      /** muda para tipo snapshot **/
                      Usuario usuario =
                          Usuario.fromDocumentsSnapshot(documentSnapshot);

                      return ListViewWidgetUsuario(
                        usuario: usuario,
                        icon: Icon(
                          Icons.phone,
                          size: 35,
                          color: Colors.blue,
                        ),
                        onPressedRemover: () {
                          _ligarTelefone(usuario.phone);
                        },
                      );
                    });
            }
            return Container();
          },
        ));
  }
}
