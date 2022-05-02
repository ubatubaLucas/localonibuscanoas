import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Viagem {

  late String _id;
  late String _cliente;
  late String _turno;
  late String _turnoORDERBY;
  late String _rota;
  late String _rotaORDERBY;
  late String _motorista;
  late String _veiculo;
  late String _dataInicio;
  late String _dataFim;
  late String _horaInicio;
  late String _horaFim;
  late int _kmInicio;
  late int _kmFim;
  late int _qtdPax;
  late String _userId;
  late Timestamp _dataInicioDT;
  late Timestamp _dataInicioDTORDERBY;
  late Timestamp _dataFimDT;
  late Timestamp _regTime;
  late String _entradaSaida;
  late String _normalExtra;

  Viagem();

  Viagem.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){

    this.id = documentSnapshot.id;
    this.cliente = documentSnapshot["cliente"];
    this.turno = documentSnapshot["turno"];
    this.turnoORDERBY = documentSnapshot["turnoORDERBY"];
    this.rota = documentSnapshot["rota"];
    this.rotaORDERBY = documentSnapshot["rotaORDERBY"];
    this.motorista = documentSnapshot["motorista"];
    this.veiculo = documentSnapshot["veiculo"];
    this.dataInicio = documentSnapshot["dataInicio"];
    this.dataFim = documentSnapshot["dataFim"];
    this.horaInicio = documentSnapshot["horaInicio"];
    this.horaFim = documentSnapshot["horaFim"];
    this.kmInicio = documentSnapshot["kmInicio"];
    this.kmFim = documentSnapshot["kmFim"];
    this.qtdPax = documentSnapshot["qtdPax"];
    this.dataInicioDT = documentSnapshot["dataInicioDT"];
    this.dataInicioDTORDERBY = documentSnapshot["dataInicioDTORDERBY"];
    this.dataFimDT = documentSnapshot["dataFimDT"];
    this.entradaSaida = documentSnapshot["entradaSaida"];
    this.normalExtra = documentSnapshot["normalExtra"];

  }

  Viagem.usuarioLogado(){

    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = auth.currentUser;
    this.userId = usuarioLogado!.uid;

    FirebaseFirestore db = FirebaseFirestore.instance;
    CollectionReference viagens = db.collection("20220303");
    this.id = viagens.doc().id;

  }

  Map<String, dynamic> toMap() {

    Map<String, dynamic> map = {

      "id" : this.id,
      "cliente" : this.cliente,
      "turno" : this.turno,
      "turnoORDERBY" : this.turnoORDERBY,
      "rota" : this.rota,
      "rotaORDERBY" : this.rotaORDERBY,
      "motorista" : this.motorista,
      "veiculo" : this.veiculo,
      "dataInicio" : this.dataInicio,
      "dataFim" : this.dataFim,
      "horaInicio" : this.horaInicio,
      "horaFim" : this.horaFim,
      "kmInicio" : this.kmInicio,
      "kmFim" : this.kmFim,
      "qtdPax" : this.qtdPax,
      "userId" : this.userId,
      "dataInicioDT" : this.dataInicioDT,
      "dataInicioDTORDERBY" : this.dataInicioDTORDERBY,
      "dataFimDT" : this.dataFimDT,
      "regTime" : this.regTime,
      "entradaSaida" : this.entradaSaida,
      "normalExtra" : this.normalExtra,

    };

    return map;

  }

  String get entradaSaida => _entradaSaida;

  set entradaSaida(String value) {
    _entradaSaida = value;
  }

  String get normalExtra => _normalExtra;

  set normalExtra(String value) {
    _normalExtra = value;
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

  Timestamp get dataFimDT => _dataFimDT;

  set dataFimDT(Timestamp value) {
    _dataFimDT = value;
  }

  String get userId => _userId;

  set userId(String value) {
    _userId = value;
  }

  int get qtdPax => _qtdPax;

  set qtdPax(int value) {
    _qtdPax = value;
  }

  int get kmFim => _kmFim;

  set kmFim(int value) {
    _kmFim = value;
  }

  int get kmInicio => _kmInicio;

  set kmInicio(int value) {
    _kmInicio = value;
  }

  String get horaFim => _horaFim;

  set horaFim(String value) {
    _horaFim = value;
  }

  String get horaInicio => _horaInicio;

  set horaInicio(String value) {
    _horaInicio = value;
  }

  String get dataFim => _dataFim;

  set dataFim(String value) {
    _dataFim = value;
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

  String get rota => _rota;

  set rota(String value) {
    _rota = value;
  }

  String get rotaORDERBY => _rotaORDERBY;

  set rotaORDERBY(String value) {
    _rotaORDERBY = value;
  }

  String get turno => _turno;

  set turno(String value) {
    _turno = value;
  }

  String get turnoORDERBY => _turnoORDERBY;

  set turnoORDERBY(String value) {
    _turnoORDERBY = value;
  }

  String get cliente => _cliente;

  set cliente(String value) {
    _cliente = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

}