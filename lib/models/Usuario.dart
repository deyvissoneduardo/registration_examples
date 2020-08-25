import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_de_cadastro/config/database/Firebase.dart';

class Usuario {
  /** atributos **/
  String _idUsuario;
  String _name;
  String _cpf;
  String _phone;
  String _email;
  List _fotos;
  String _password;

  Usuario();

  Usuario.fromDocumentsSnapshot(DocumentSnapshot documentSnapshot) {
    this.idUsuario = documentSnapshot.documentID;
    this.name = documentSnapshot[Firebase.DOC_NAME];
    this.cpf = documentSnapshot[Firebase.DOC_CPF];
    this.phone = documentSnapshot[Firebase.DOC_PHONE];
    this.email = documentSnapshot[Firebase.DOC_EMAIL];
    this.fotos = documentSnapshot[Firebase.DOC_FOTOS];
  }

  Usuario.geraId() {
    /** inicia lista de images **/
    this.fotos = [];
    /** gera o id do anuncio **/
    Firestore banco = Firestore.instance;
    CollectionReference anuncios = banco.collection(Firebase.COLECAO_USUARIOS);
    this.idUsuario = anuncios.document().documentID;
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'name': this.name,
      'cpf': this.cpf,
      'phone': this.phone,
      'fotos': this.fotos,
      'email': this.email,
    };
    return map;
  }

  List get fotos => _fotos;

  set fotos(List value) {
    _fotos = value;
  }

  String get phone => _phone;

  set phone(String value) {
    _phone = value;
  }

  String get cpf => _cpf;

  set cpf(String value) {
    _cpf = value;
  }

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get idUsuario => _idUsuario;

  set idUsuario(String value) {
    _idUsuario = value;
  }
}
