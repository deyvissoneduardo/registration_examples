import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:controle_de_cadastro/config/database/Firebase.dart';
import 'package:flutter/material.dart';

class Viagens {

  /** atributos **/
  String _idViagem;
  String _title;
  List _photos;
  String _description;
  String _dateInit;
  String _dateEnd;

  /** construtores **/
  Viagens();

  Viagens.fromDocumentsSnapshot(DocumentSnapshot documentSnapshot) {
    this.idViagem = documentSnapshot.documentID;
    this.title = documentSnapshot[Firebase.DOC_TITLE];
    this.photos = documentSnapshot[Firebase.DOC_PHOTOS];
    this.description = documentSnapshot[Firebase.DOC_DESCRIPTION];
    this.dateInit = documentSnapshot[Firebase.DOC_DATE_INIT];
    this.dateEnd = documentSnapshot[Firebase.DOC_DATE_END];
  }

  Viagens.geraId() {
    /** inicia lista de images **/
    this.photos = [];
    /** gera o id do anuncio **/
    Firestore banco = Firestore.instance;
    CollectionReference anuncios = banco.collection(Firebase.COLECAO_USUARIOS);
    this.idViagem = anuncios.document().documentID;
  }

  Map<String, dynamic> toMap(){
    Map<String, dynamic> map = {
      'title': this.title,
      'photos': this.photos,
      'description': this.description,
      'dateInit': this.dateInit,
      'dateEnd': this.dateEnd
    };
    return map;
  }

  /** getrs e setrs **/
  String get description => _description;

  set description(String value) {
    _description = value;
  }

  List get photos => _photos;

  set photos(List value) {
    _photos = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  String get idViagem => _idViagem;

  set idViagem(String value) {
    _idViagem = value;
  }

  String get dateInit => _dateInit;

  set dateInit(String value) {
    _dateInit = value;
  }

  String get dateEnd => _dateEnd;

  set dateEnd(String value) {
    _dateEnd = value;
  }
}