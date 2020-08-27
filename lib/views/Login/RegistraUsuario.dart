import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_de_cadastro/config/database/Firebase.dart';
import 'package:controle_de_cadastro/config/themes/ThemeDefault.dart';
import 'package:controle_de_cadastro/models/Usuario/Usuario.dart';
import 'package:controle_de_cadastro/routes/routes.dart';
import 'package:controle_de_cadastro/widgets/ButtonWidget.dart';
import 'package:controle_de_cadastro/widgets/TextFildWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:validadores/Validador.dart';

class RegistraUsuario extends StatefulWidget {
  @override
  _RegistraUsuarioState createState() => _RegistraUsuarioState();
}

class _RegistraUsuarioState extends State<RegistraUsuario> {
  /** controladores **/
  TextEditingController _controllerName = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();

  /** instacia**/
  FirebaseAuth _auth = FirebaseAuth.instance;
  Firestore _banco = Firestore.instance;
  Usuario _usuario = Usuario();

  /** mensagens padrao **/
  String _mensageError = '';

  /** valida os campos **/
  _validarCampos() {
    /** recupera valores digitados **/
    String name = _controllerName.text;
    String email = _controllerEmail.text;
    String password = _controllerPassword.text;

    /** verifica se os texto sao validos **/
    /** valida os dados **/
    if (name.isNotEmpty) {
      if (email.isNotEmpty && email.contains("@")) {
        if (password.isNotEmpty && password.length > 6) {
          setState(() {
            _mensageError = "";
          });
          /** config usurio**/
          _usuario.name = name;
          _usuario.email = email;
          _usuario.password = password;
          _cadastraUsuario(_usuario);
        } else {
          setState(() {
            _mensageError = "Senha deve ter no minimo 8 caracteres";
          });
        }
      } else {
        setState(() {
          _mensageError = "E-mail obrigatorio";
        });
      }
    } else {
      setState(() {
        _mensageError = 'Preencha o nome';
      });
    }
  }

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

  _cadastraUsuario(Usuario usuario) async {
    FirebaseUser idUsuarioFirebase = await _auth.currentUser();
    String idUsuario = idUsuarioFirebase.uid;

    _auth
        .createUserWithEmailAndPassword(
            email: usuario.email, password: usuario.password)
        .then((firebaseUser) {
      /** salva os dados no firebase **/
      _banco
          .collection(Firebase.COLECAO_USUARIOS)
          .document(idUsuario)
          .collection(Firebase.COLECAO_REGISTRO)
          .document(_usuario.idUsuario)
          .setData(usuario.toMapRegistro())
          .then((_) {
        _abriDailog(context);
        Navigator.pushNamedAndRemoveUntil(
            context, RouteGenerate.ROTA_CADASTROS, (_) => false);
      });
    }).catchError((error) {
      setState(() {
        _mensageError = "Error ao cadastra!!";
      });
    });
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
        title: Text(''),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: gradientDefault),
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                /** logo **/
                Padding(
                  padding: EdgeInsets.only(bottom: 32),
                  child: FlutterLogo(
                    size: 150,
                  ),
                ),
                /** feld name **/
                TextFildWidget(
                  controller: _controllerName,
                  autofocus: true,
                  icon: Icon(Icons.person),
                  hint: 'Nome',
                  onSaved: (name) {
                    _usuario.name = name;
                  },
                  inputFormatters: [],
                  validator: (valor) {
                    return Validador()
                        .add(Validar.OBRIGATORIO, msg: 'Campo Obrigatorio')
                        .valido(valor);
                  },
                ),
                /** fiel e-email **/
                TextFildWidget(
                  controller: _controllerEmail,
                  icon: Icon(Icons.email),
                  hint: 'E-mail',
                  onSaved: (email) {
                    _usuario.email = email;
                  },
                  inputTypetype: TextInputType.emailAddress,
                  inputFormatters: [],
                  validator: (valor) {
                    return Validador()
                        .add(Validar.OBRIGATORIO, msg: 'Campo Obrigatorio')
                        .add(Validar.EMAIL)
                        .valido(valor);
                  },
                ),
                /** field password **/
                TextFildWidget(
                  controller: _controllerPassword,
                  obscure: true,
                  icon: Icon(Icons.security),
                  hint: 'Senha',
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
                /** button **/
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: ButtonWidget(
                    corButton: temaPadrao.primaryColor,
                    text: "Cadastrar",
                    onPressed: () {
                      _validarCampos();
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    _mensageError,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
