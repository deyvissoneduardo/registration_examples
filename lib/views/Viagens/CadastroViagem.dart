import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_de_cadastro/config/database/Firebase.dart';
import 'package:controle_de_cadastro/config/themes/ThemeDefault.dart';
import 'package:controle_de_cadastro/models/Viagens/Viagens.dart';
import 'package:controle_de_cadastro/routes/routes.dart';
import 'package:controle_de_cadastro/widgets/AlertDialogWidget.dart';
import 'package:controle_de_cadastro/widgets/ButtonWidget.dart';
import 'package:controle_de_cadastro/widgets/TextFildWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:validadores/Validador.dart';

class CadastroViagem extends StatefulWidget {
  @override
  _CadastroViagemState createState() => _CadastroViagemState();
}

class _CadastroViagemState extends State<CadastroViagem> {
  /** instancias **/
  FirebaseStorage _storage = FirebaseStorage.instance;
  Firestore _banco = Firestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  /**  chave de validacao form **/
  final _formKey = GlobalKey<FormState>();

  /** inicia listas **/
  List<File> _listaImagens = List();

  /** context global **/
  BuildContext _dialogContext;

  /** obj viagem **/
  Viagens _viagens = Viagens();

  _carregaFoto() async {
    File imagemSelecionada =
    await ImagePicker.pickImage(source: ImageSource.gallery);

    if (imagemSelecionada != null) {
      setState(() {
        _listaImagens.add(imagemSelecionada);
      });
    }
  }

  Future _uploadImages() async {
    /** local da imagem **/
    StorageReference pastaRaiz = _storage.ref();

    for (var images in _listaImagens) {
      /** identificador da imagem **/
      String nomeImage = DateTime.now().millisecondsSinceEpoch.toString();

      /** adic no storage **/
      StorageReference arquivo = pastaRaiz
          .child(Firebase.COLECAO_USUARIOS)
          .child(_viagens.idViagem)
          .child(nomeImage);
      /** comeca upload **/
      StorageUploadTask uploadTask = arquivo.putFile(images);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      String url = await taskSnapshot.ref.getDownloadURL();
      _viagens.photos.add(url);
    }
  }

  Future _salvarDadosDaViagem(String idViagem) async {
    /** recupera usuario logado **/
    FirebaseUser usuarioLoagado = await _auth.currentUser();
    String idUsuario = usuarioLoagado.uid;

    _banco
        .collection(Firebase.COLECAO_USUARIOS)
        .document(idUsuario)
        .collection(Firebase.COLECAO_VIAGENS)
        .document(_viagens.idViagem)
        .setData(_viagens.toMap())
        .then((_) {
      Navigator.of(_dialogContext).pop();
      Navigator.pushReplacementNamed(context, RouteGenerate.ROTA_ALBUNS_VIAGENS);
    });
  }

  /** metodo que exibe popup de salvando **/
  _abriDailog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProgressIndicator(
                  backgroundColor: temaPadrao.primaryColor,
                ),
                SizedBox(height: 20),
                Text('Salvando...')
              ],
            ),
          );
        });
  }

  _salvarAlbum()async{
    _abriDailog(context);
    /** upload das imagens **/
    await _uploadImages();
    /** salva  no banco **/
    _salvarDadosDaViagem(_viagens.idViagem);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _viagens = Viagens.geraId();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Novo Album',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                FormField<List>(
                  initialValue: _listaImagens,
                  validator: (images) {
                    if (images.length == 0) {
                      return 'Necessário ao pelo menos 1 foto';
                    }
                    return null;
                  },
                  builder: (state) {
                    return Column(
                      children: <Widget>[
                        Container(
                          height: 100,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _listaImagens.length + 1,
                              itemBuilder: (context, index) {
                                /** btn fake para adc imagem **/
                                if (index == _listaImagens.length) {
                                  return Padding(
                                    padding:
                                    EdgeInsets.symmetric(horizontal: 8),
                                    child: GestureDetector(
                                      onTap: () {
                                        _carregaFoto();
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: Colors.grey[500],
                                        radius: 50,
                                        child: Column(
                                          mainAxisAlignment:MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(Icons.add_a_photo,
                                              size: 40,
                                              color: Colors.grey[100],
                                            ),
                                            Text('Adicionar',
                                              style: TextStyle(
                                                  color: Colors.grey[100],
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w400),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                if (_listaImagens.length > 0) {
                                  /** exibe imagens selecionada **/
                                  return Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                    child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) => Dialog(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Image.file( _listaImagens[index]),
                                                  FlatButton(
                                                    child: Text('Excluir'),
                                                    textColor: Colors.red,
                                                    onPressed: () {
                                                      setState(() {
                                                        _listaImagens.removeAt(index);
                                                        Navigator.of(context).pop();
                                                      });
                                                    },
                                                  )
                                                ],
                                              ),
                                            ));
                                      },
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundImage: FileImage(_listaImagens[index]),
                                        child: Container(
                                          color: Color.fromRGBO(255, 255, 255, 0.4),
                                          alignment: Alignment.center,
                                          child: Icon( Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }
                                return Container();
                              }),
                        ),
                        /** caso haja erro no carregamendo da imagem **/
                        if (state.hasError)
                          Container(
                            child: Text(
                              '[${state.errorText}]',
                              style: TextStyle(color: Colors.red, fontSize: 14),
                            ),
                          )
                      ],
                    );
                  },
                ),
                /** caixas de texto de btn **/
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: TextFildWidget(
                    autofocus: true,
                    hint: 'Nome do Album',
                    onSaved: (title) {
                      _viagens.title = title;
                    },
                    validator: (valor) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: 'Campo Obrigatorio')
                          .valido(valor);
                    },
                  ),
                ),
                TextFildWidget(
                  hint: 'Data de Inicio',
                  inputTypetype: TextInputType.datetime,
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                    DataInputFormatter()
                  ],
                  onSaved: (dateInit){
                    _viagens.dateInit = dateInit;
                  },
                  validator: (valor) {
                    return Validador()
                        .add(Validar.OBRIGATORIO, msg: 'Campo Obrigatorio')
                        .valido(valor);
                  },
                ),
                TextFildWidget(
                  hint: 'Data de Termino',
                  inputTypetype: TextInputType.datetime,
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                    DataInputFormatter()
                  ],
                  onSaved: (dateEnd){
                    _viagens.dateEnd = dateEnd;
                  },
                  validator: (valor) {
                    return Validador()
                        .valido(valor);
                  },
                ),
                TextFildWidget(
                  hint: 'Descrição da Viagem (200 caracteres)',
                  inputTypetype: TextInputType.multiline,
                  onSaved: (description) {
                    _viagens.description = description;
                  },
                  validator: (valor) {
                    return Validador()
                        .add(Validar.OBRIGATORIO, msg: 'Campo Obrigatorio')
                        .maxLength(200, msg: 'Maximo 200 caracteres')
                        .valido(valor);
                  },
                ),
                ButtonWidget(
                  text: 'Cadastra Album',
                  corButton: temaViagen.primaryColor,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      /** salva dados do form **/
                      _formKey.currentState.save();
                      /** configura o context do dialog**/
                      _dialogContext = context;
                      /** salva **/
                      _salvarAlbum();
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
