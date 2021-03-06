import 'package:controle_de_cadastro/config/themes/ThemeDefault.dart';
import 'package:controle_de_cadastro/models/Usuario/Usuario.dart';
import 'package:controle_de_cadastro/routes/routes.dart';
import 'package:controle_de_cadastro/views/Login/Sing_in_Goolgle.dart';
import 'package:controle_de_cadastro/widgets/ButtonWidget.dart';
import 'package:controle_de_cadastro/widgets/TextFildWidget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:validadores/validadores.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  /** controladores **/
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerPassword = TextEditingController();

  Usuario _usuario = Usuario();

  /** mensagens padrao **/
  String _mensageError = '';

  /** instacia do firebase **/
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future _verificaUsuarioLogado() async {
    /** recupera usuario logado **/
    FirebaseUser usuarioLogado = await _auth.currentUser();
    if (usuarioLogado == null) {
      Navigator.pushNamed(context, RouteGenerate.ROTA_LOGIN);
    } else {
      Navigator.pushNamed(context, RouteGenerate.ROTA_CADASTROS);
    }
  }

  /** valida os campos **/
  _validarCampos() {
    /** recupera valores digitados **/
    String email = _controllerEmail.text;
    String password = _controllerPassword.text;

    /** verifica se os texto sao validos **/
    if (email.isNotEmpty && email.contains('@')) {
      if (password.isNotEmpty && password.length > 6) {
        /** configura usuario **/
        _usuario.email = email;
        _usuario.password = password;
        _logarUsuario(_usuario);
      } else {
        setState(() {
          _mensageError = 'Senha Invalida e/ou minimo de 7 caracteres';
        });
      }
    } else {
      setState(() {
        _mensageError = 'Favor Digite e-mail valido';
      });
    }
  }

  _logarUsuario(Usuario usuario) {
    _auth
        .signInWithEmailAndPassword(
            email: usuario.email, password: usuario.password)
        .then((firabaseUser) {
      /** redireciona tela principal **/
      Navigator.pushReplacementNamed(context, RouteGenerate.ROTA_CADASTROS);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _verificaUsuarioLogado();
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
                /** fiel e-email **/
                TextFildWidget(
                  controller: _controllerEmail,
                  icon: Icon(Icons.email),
                  autofocus: true,
                  hint: 'E-mail',
                  onSaved: (email) {
                    _usuario.email = email;
                  },
                  inputTypetype: TextInputType.emailAddress,
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
                  icon: Icon(Icons.security, color: temaPadrao.primaryColor,),
                  obscure: true,
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
                    text: "Logar",
                    onPressed: () {
                      _validarCampos();
                    },
                  ),
                ),
                /** btn google **/
                Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: _signInButton(context)
                ),
                Padding(
                  padding: EdgeInsets.only(top: 150),
                  child: GestureDetector(
                    child: Center(
                      child: Text('Não tem conta? cadastre-se',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white
                      ),),
                    ),
                    onTap: (){
                      Navigator.pushReplacementNamed(context, RouteGenerate.ROTA_REGISTRA_USUARIO);
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

Widget _signInButton(BuildContext context) {
  return OutlineButton(
    splashColor: temaPadrao.primaryColor,
    onPressed: () {
      signInWithGoogle().whenComplete(() {
        Navigator.pushReplacementNamed(context, RouteGenerate.ROTA_CADASTROS);
      });
    },
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    highlightElevation: 0,
    borderSide: BorderSide(color: temaPadrao.primaryColor),
    child: Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image(image: AssetImage("images/google_logo.png"), height: 35),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Text(
              'Logar com Google',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold
              ),
            ),
          )
        ],
      ),
    ),
  );
}
