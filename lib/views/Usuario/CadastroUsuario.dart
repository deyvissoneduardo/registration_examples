import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_de_cadastro/config/database/Firebase.dart';
import 'package:controle_de_cadastro/config/themes/ThemeDefault.dart';
import 'package:controle_de_cadastro/models/Usuario.dart';
import 'package:controle_de_cadastro/routes/routes.dart';
import 'package:controle_de_cadastro/widgets/ButtonWidget.dart';
import 'package:controle_de_cadastro/widgets/FlatButtonWidget.dart';
import 'package:controle_de_cadastro/widgets/TextFildWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:validadores/validadores.dart';

class CadastroUsuario extends StatefulWidget {
  @override
  _CadastroUsuarioState createState() => _CadastroUsuarioState();
}

class _CadastroUsuarioState extends State<CadastroUsuario> {
  FirebaseStorage _storage = FirebaseStorage.instance;
  Firestore _banco = Firestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  /**  chave de validacao form **/
  final _formKey = GlobalKey<FormState>();

  /** inicia listas **/
  List<File> _listaImagens = List();

  /** context global **/
  BuildContext _dialogContext;

  Usuario _usuario = Usuario();

  _selecionarImagem() async {
    File imagemSelecionada =
        await ImagePicker.pickImage(source: ImageSource.camera);

    if (imagemSelecionada != null) {
      setState(() {
        _listaImagens.add(imagemSelecionada);
      });
    }
  }

  Future _uploadImages() async {
    StorageReference pastaRaiz = _storage.ref();
    for (var images in _listaImagens) {
      String nomeImage = DateTime.now().millisecondsSinceEpoch.toString();
      StorageReference arquivo = pastaRaiz
          .child(Firebase.COLECAO_USUARIOS)
          .child(_usuario.idUsuario)
          .child(nomeImage);
      /** comeca upload **/
      StorageUploadTask uploadTask = arquivo.putFile(images);
      StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
      String url = await taskSnapshot.ref.getDownloadURL();
      _usuario.fotos.add(url);
    }
  }

  Future _salvarDadosDoUsuario(String idUsuario) async {
    /** recupera usuario logado **/
    FirebaseUser usuarioLoagado = await _auth.currentUser();
    String idUsuario = usuarioLoagado.uid;

    _banco
        .collection(Firebase.COLECAO_USUARIOS)
        .document(idUsuario)
        .collection(Firebase.COLECAO_CONTATOS)
        .document(_usuario.idUsuario)
        .setData(_usuario.toMap())
        .then((_) {
      Navigator.pop(_dialogContext);
      Navigator.pushReplacementNamed(context, RouteGenerate.ROTA_LISTA_USUARIO);
    });
  }

  /** metodo que exibe popup de salvando anuncio **/
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

  _salvarUsuario() async {
    _abriDailog(_dialogContext);
    /** upload das imagens **/
    await _uploadImages();
    /** salva  no banco **/
    _salvarDadosDoUsuario(_usuario.idUsuario);
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _usuario = Usuario.geraId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Novo Usuario',
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
                      return 'Necessário ao menos uma imagem';
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
                                        _selecionarImagem();
                                      },
                                      child: CircleAvatar(
                                        backgroundColor: Colors.grey[500],
                                        radius: 50,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Icon(
                                              Icons.add_a_photo,
                                              size: 40,
                                              color: Colors.grey[100],
                                            ),
                                            Text(
                                              'Adicionar',
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
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    child: GestureDetector(
                                      onTap: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) => Dialog(
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Image.file(
                                                          _listaImagens[index]),
                                                      FlatButton(
                                                        child: Text('Excluir'),
                                                        textColor: Colors.red,
                                                        onPressed: () {
                                                          setState(() {
                                                            _listaImagens
                                                                .removeAt(
                                                                    index);
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          });
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                ));
                                      },
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundImage:
                                            FileImage(_listaImagens[index]),
                                        child: Container(
                                          color: Color.fromRGBO(
                                              255, 255, 255, 0.4),
                                          alignment: Alignment.center,
                                          child: Icon(
                                            Icons.delete,
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
                    hint: 'Nome',
                    onSaved: (name) {
                      _usuario.name = name;
                    },
                    validator: (valor) {
                      return Validador()
                          .add(Validar.OBRIGATORIO, msg: 'Campo Obrigatorio')
                          .valido(valor);
                    },
                  ),
                ),
                TextFildWidget(
                  hint: 'CPF',
                  onSaved: (cpf) {
                    _usuario.cpf = cpf;
                  },
                  inputTypetype: TextInputType.number,
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                    CpfInputFormatter()
                  ],
                  validator: (valor) {
                    return Validador()
                        .add(Validar.OBRIGATORIO, msg: 'Campo Obrigatorio')
                        .add(Validar.CPF)
                        .valido(valor);
                  },
                ),
                TextFildWidget(
                  hint: 'Telefone',
                  onSaved: (phone) {
                    _usuario.phone = phone;
                  },
                  inputTypetype: TextInputType.phone,
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                    TelefoneInputFormatter()
                  ],
                  validator: (valor) {
                    return Validador()
                        .add(Validar.OBRIGATORIO, msg: 'Campo Obrigatorio')
                        .valido(valor);
                  },
                ),
                TextFildWidget(
                  hint: 'E-mail',
                  onSaved: (emial) {
                    _usuario.email = emial;
                  },
                  inputTypetype: TextInputType.emailAddress,
                  validator: (valor) {
                    return Validador()
                        .add(Validar.OBRIGATORIO, msg: 'Campo Obrigatorio')
                        .add(Validar.EMAIL)
                        .valido(valor);
                  },
                ),
                TextFildWidget(
                  obscure: true,
                  hint: 'Senha',
                  inputFormatters: [],
                  onSaved: (password) {
                    _usuario.password = password;
                  },
                  inputTypetype: TextInputType.visiblePassword,
                  validator: (valor) {
                    return Validador()
                        .add(Validar.OBRIGATORIO, msg: 'Campo Obrigatorio')
                        .valido(valor);
                  },
                ),
                ButtonWidget(
                  text: 'Cadastra Usuario',
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      /** salva dados do form **/
                      _formKey.currentState.save();
                      /** configura o context do dialog**/
                      _dialogContext = context;
                      /** salva o usuario **/
                      _salvarUsuario();
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
