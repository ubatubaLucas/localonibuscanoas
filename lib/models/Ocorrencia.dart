import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Ocorrencia {

  late String _id;
  late String _categoria;
  late String _tipo;
  late String _tipoORDERBY;
  late String _motorista;
  late String _veiculo;
  late String _dataInicio;
  late String _userId;
  late Timestamp _dataInicioDT;
  late Timestamp _dataInicioDTORDERBY;
  late Timestamp _regTime;
  late String _gravidade;
  late String _probabilidade;
  late String _descricao;

  Ocorrencia();

  Ocorrencia.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){

    this.id = documentSnapshot.id;
    this.categoria = documentSnapshot["categoria"];
    this.tipo = documentSnapshot["tipo"];
    this.tipoORDERBY = documentSnapshot["tipoORDERBY"];
    this.motorista = documentSnapshot["motorista"];
    this.veiculo = documentSnapshot["veiculo"];
    this.dataInicio = documentSnapshot["dataInicio"];
    this.dataInicioDT = documentSnapshot["dataInicioDT"];
    this.dataInicioDTORDERBY = documentSnapshot["dataInicioDTORDERBY"];
    this.probabilidade = documentSnapshot["probabilidade"];
    this.gravidade = documentSnapshot["gravidade"];
    this.descricao = documentSnapshot["descricao"];

  }

  Ocorrencia.usuarioLogado(){

    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = auth.currentUser;
    this.userId = usuarioLogado!.uid;

    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference ocorrencias = db.collection("OCORRENCIAS");
    this.id = ocorrencias.doc().id;

  }

  Map<String, dynamic> toMap() {

    Map<String, dynamic> map = {

      "id" : this.id,
      "categoria" : this.categoria,
      "tipo" : this.tipo,
      "tipoORDERBY" : this.tipoORDERBY,
      "motorista" : this.motorista,
      "veiculo" : this.veiculo,
      "dataInicio" : this.dataInicio,
      "userId" : this.userId,
      "dataInicioDT" : this.dataInicioDT,
      "dataInicioDTORDERBY" : this.dataInicioDTORDERBY,
      "regTime" : this.regTime,
      "probabilidade" : this.probabilidade,
      "gravidade" : this.gravidade,
      "descricao" : this.descricao,

    };

    return map;

  }

  String get descricao => _descricao;

  set descricao(String value) {
    _descricao = value;
  }

  String get probabilidade => _probabilidade;

  set probabilidade(String value) {
    _probabilidade = value;
  }

  String get gravidade => _gravidade;

  set gravidade(String value) {
    _gravidade = value;
  }

  Timestamp get regTime => _regTime;

  set regTime(Timestamp value) {
    _regTime = value;
  }

  Timestamp get dataInicioDT => _dataInicioDT;

  set dataInicioDT(Timestamp value) {
    _dataInicioDT = value;
  }

  Timestamp get dataInicioDTORDERBY => _dataInicioDTORDERBY;

  set dataInicioDTORDERBY(Timestamp value) {
    _dataInicioDTORDERBY = value;
  }

  String get userId => _userId;

  set userId(String value) {
    _userId = value;
  }

  String get dataInicio => _dataInicio;

  set dataInicio(String value) {
    _dataInicio = value;
  }

  String get veiculo => _veiculo;

  set veiculo(String value) {
    _veiculo = value;
  }

  String get motorista => _motorista;

  set motorista(String value) {
    _motorista = value;
  }

  String get tipo => _tipo;

  set tipo(String value) {
    _tipo = value;
  }

  String get tipoORDERBY => _tipoORDERBY;

  set tipoORDERBY(String value) {
    _tipoORDERBY = value;
  }

  String get categoria => _categoria;

  set categoria(String value) {
    _categoria = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

}