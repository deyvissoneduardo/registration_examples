import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_de_cadastro/config/database/Firebase.dart';
import 'package:controle_de_cadastro/models/Viagens/Viagens.dart';
import 'package:controle_de_cadastro/routes/routes.dart';
import 'package:controle_de_cadastro/views/Viagens/Widget/ListViewWidgetViagem.dart';
import 'package:controle_de_cadastro/widgets/CarregandoWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AlbunsViagens extends StatefulWidget {
  @override
  _AlbunsViagensState createState() => _AlbunsViagensState();
}

class _AlbunsViagensState extends State<AlbunsViagens> {
  /** instancias **/
  FirebaseStorage _storage = FirebaseStorage.instance;
  Firestore _banco = Firestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  String _idUsuario;

  /** controller **/
  final _controller = StreamController<QuerySnapshot>.broadcast();

  /** recupera dados do usuairo logado **/
  _recuperaDadosUsuario() async {
    FirebaseUser usuarioLoagado = await _auth.currentUser();
    _idUsuario = usuarioLoagado.uid;
  }

  /** recupera dados **/
  Future<Stream<QuerySnapshot>> _adcionarListenerAlbum() async {
    await _recuperaDadosUsuario();

    Stream<QuerySnapshot> stream = _banco
        .collection(Firebase.COLECAO_USUARIOS)
        .document(_idUsuario)
        .collection(Firebase.COLECAO_VIAGENS)
        .snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  _remover(String idViagem) {
    _banco
        .collection(Firebase.COLECAO_USUARIOS)
        .document(_idUsuario)
        .collection(Firebase.COLECAO_VIAGENS)
        .document(idViagem)
        .delete();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _adcionarListenerAlbum();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Albuns de Viagem',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        elevation: 7,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushReplacementNamed(
              context, RouteGenerate.ROTA_CADASTRO_VIAGEM);
        },
      ),
      body: StreamBuilder(
        stream: _controller.stream,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return CarregandoWidget(texto: 'Carregando...');
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
                  List<DocumentSnapshot> viagens = querySnapshot.documents
                      .toList();
                  /** pega pelo index **/
                  DocumentSnapshot documentSnapshot = viagens[index];

                  /** muda para tipo snapshot **/
                  Viagens viagensSnapshot =
                  Viagens.fromDocumentsSnapshot(documentSnapshot);

                  return ListViewWidgetViagem(
                    viagens: viagensSnapshot,
                    onTapItem: () {
                      Navigator.pushNamed(
                          context, RouteGenerate.ROTA_DETALHES_VIAGEM,
                          arguments: viagensSnapshot);
                    },
                    onPressedRemover: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Confirmar'),
                              content: Text('Deseja excluir?'),
                              elevation: 5,
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Cancelar',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                FlatButton(
                                  child: Text('Remover',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  onPressed: () {
                                    _remover(viagensSnapshot.idViagem);
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            );
                          });
                    },
                  );
                },
              );
          }
          return Container();
        },
      ),
    );
  }
}
