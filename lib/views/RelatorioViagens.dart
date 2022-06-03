import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RelatorioViagens extends StatefulWidget {

  @override
  _RelatorioViagensState createState() => _RelatorioViagensState();
}

class _RelatorioViagensState extends State<RelatorioViagens> {

  final _controllerOcupacaoConsulta = StreamController<QuerySnapshot>.broadcast();
  late StreamSubscription _subscription;

  List<String> clientes = [];
  List<String> clientesPosData = ["AGCO", "EDLO", "EVENTUAL", "FRUKI", "KUEHNE NAGEL", "MIDEA CARRIER", "MILLS", "PETROBRAS", "PROLEC GE", "TEDESCO", "TERESA", "UNIDASUL"];

  List<String> turnos = [];
  List<String> turnosAgco = ["ADM", "ESTAGIARIOS", "T2"];
  List<String> turnosEdlo = ["ADM"];
  List<String> turnosFruki = ["ESTACAO"];
  List<String> turnosKuehne = ["4X3", "5X2", "6X1", "REFEICOES"];
  List<String> turnosMidea = ["ADM", "T2"];
  List<String> turnosMills = ["ADM"];
  List<String> turnosPetrobras = ["ADM", "INTERNO", "TURNO"];
  List<String> turnosProlec = ["ADM", "ESTAGIARIOS", "T1", "T2"];
  List<String> turnosTedesco = ["ADM", "TURNO A", "TURNO B", "TURNO C"];
  List<String> turnosTeresa = ["CIRCULAR"];
  List<String> turnosUnidasul = ["ESTACAO", "T1", "T2"];

  List<String> rotasAgcoAdm = ["01","02","03","04","05","07","08","09","10","11","12","13","15","16","18","19","20","21","22","23","24","25","26","27","28","29","30","31","32","33","34","35","36","37"];
  List<String> rotasAgcoEstagiarios = ["201", "202", "203", "204", "205"];
  List<String> rotasAgcoT2 = ["102", "103", "108", "109", "110", "111"];
  List<String> rotasEdloAdm = ["1"];
  List<String> rotasFrukiEstacao = ["05H50", "10H50", "12H50", "16H00", "17H15", "23H10"];
  List<String> rotasKuehne4x3 = ["01", "02", "03", "04", "05", "06", "07"];
  List<String> rotasKuehne5x2 = ["202", "204", "205", "206", "208", "209", "211"];
  List<String> rotasKuehne6x1 = ["41", "42"];
  List<String> rotasKuehneRefeicoes = ["CAFE", "ALMOCO", "CEIA"];
  List<String> rotasMideaAdm = ["01","02","03","04","05","06","07","08","09","10","11"];
  List<String> rotasMideaT2 = ["20", "21"];
  List<String> rotasMillsAdm = ["1"];
  List<String> rotasPetrobrasAdm = ["01","02","03","04","05","06","07","08","09","10","11","12","13"];
  List<String> rotasPetrobrasInterno = ["ALMOCO","CIRCULAR","INTEGRACAO"];
  List<String> rotasPetrobrasTurno = ["01","02","03","04","05","06","07","08","09","10"];
  List<String> rotasProlecAdm = ["10","11","12","13","14"];
  List<String> rotasProlecEstagiarios = ["12H10"];
  List<String> rotasProlecT1 = ["01","02","03","04","05","06","07"];
  List<String> rotasProlecT2 = ["20", "21", "22", "23"];
  List<String> rotasTedescoAdm = ["2"];
  List<String> rotasTedescoTurnoA = ["1"];
  List<String> rotasTedescoTurnoB = ["3"];
  List<String> rotasTedescoTurnoC = ["4"];
  List<String> rotasTeresaCircular = ["07H45", "11H40", "15H40"];
  List<String> rotasUnidasulEstacao = ["04H55", "09H50", "10H55", "14H30", "16H40", "20H00"];
  List<String> rotasUnidasulT1 = ["01","02","03","04"];
  List<String> rotasUnidasulT2 = ["10","11","12","13"];
  List<String> rotas = [];

  List<String> normalExtra = ["NORMAL", "EXTRA"];
  List<String> entradaSaida = ["ENTRADA", "SAIDA"];

  String? selectedCliente;
  String? selectedTurno;
  String? selectedRota;
  String? selectedSentido;
  String? selectedTipo;
  String? selectedMotorista;
  String? selectedVeiculo;
  String? selectedDataInicio;
  TextEditingController _controllerDataInicio = TextEditingController();

  Future<Stream<QuerySnapshot>?> _filtrarViagens() async {

    FirebaseFirestore db = FirebaseFirestore.instance;
    Query query = await db
        .collection("VIAGENS")
        .orderBy("dataInicioDTORDERBY", descending: true)
        .orderBy("turnoORDERBY", descending: false)
        .orderBy("rotaORDERBY", descending: false)
        .orderBy("horaInicio", descending: false)
        .limit(100)
    ;

    if (selectedCliente != null) {
      query = query.where("cliente", isEqualTo: selectedCliente);
    }

    if (selectedTurno != null) {
      query = query.where("turno", isEqualTo: selectedTurno);
    }

    if (selectedRota != null) {
      query = query.where("rota", isEqualTo: selectedRota);
    }

    if (selectedDataInicio != null) {
      query = query.where("dataInicioDT", isEqualTo: Timestamp.fromDate(DateFormat("dd/MM/yyyy").parse(_controllerDataInicio.text)));
    }

    if (selectedTipo != null) {
      query = query.where("normalExtra", isEqualTo: selectedTipo);
    }

    if (selectedSentido != null) {
      query = query.where("entradaSaida", isEqualTo: selectedSentido);
    }

    Stream<QuerySnapshot> stream = query.snapshots();
    _subscription = stream.listen((dados) {
      _controllerOcupacaoConsulta.add(dados);
      _subscription.cancel();

    });
    return null;

  }

  Future<Stream<QuerySnapshot>?> _adicionarListenerConsultaViagem() async {

    FirebaseFirestore db = FirebaseFirestore.instance;
    Stream<QuerySnapshot> stream = await db
        .collection("VIAGENS")
        .orderBy("regTime", descending: true)
        .limit(10)
        .snapshots();

    _subscription = stream.listen((dados) {
      _controllerOcupacaoConsulta.add(dados);
      _subscription.cancel();

    });
    return null;

  }

  _showDatePickerInicio() {
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2022),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
            data: ThemeData().copyWith(
              colorScheme: ColorScheme.light(
                  primary: Colors.orange,
                  onPrimary: Colors.white,
                  onSurface: Colors.black
              ),
            ),
            child: child!,);

        }
    ).then((pickedDateInicio) {
      if(pickedDateInicio == null) {
        return;
      }
      setState(() {
        selectedDataInicio = DateFormat("dd/MM/yyyy").format(pickedDateInicio);
        _controllerDataInicio.text = selectedDataInicio!;
        _filtrarViagens();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _adicionarListenerConsultaViagem();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("RELATÓRIO"),
        centerTitle: true,
        backgroundColor: Colors.orange,
        actions: <Widget>[
          IconButton(onPressed: (){

            showDialog(
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                      builder: (context, setState) {

                        return AlertDialog(
                          content: SingleChildScrollView(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 1,
                              padding: EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Text("DATA:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                  Row(children: <Widget>[
                                    Expanded(child: TextFormField(
                                      readOnly: true,
                                      style: TextStyle(
                                          fontSize: 20
                                      ),
                                      controller: _controllerDataInicio,
                                      decoration: InputDecoration(
                                          hintText: "SELECIONAR",
                                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black54))
                                      ),
                                    )),

                                    IconButton(
                                        onPressed: () {
                                          _showDatePickerInicio();

                                          setState(() {
                                            clientes = clientesPosData;
                                          });

                                        },
                                        icon: Icon(Icons.date_range)
                                    ),
                                  ],),
                                  Padding(padding: EdgeInsets.only(bottom: 20)),
                                  Text("CLIENTE:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                  DropdownButtonFormField<String>(
                                    value: selectedCliente,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20
                                    ),
                                    hint: Text("SELECIONAR"),
                                    items: clientes.map((String value) {
                                      return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value.toUpperCase())
                                      );
                                    }).toList(),
                                    onChanged: (cliente) {

                                      if (cliente == "AGCO") {
                                        turnos = turnosAgco;}
                                      else if (cliente == "EDLO") {
                                        turnos = turnosEdlo; }
                                      else if (cliente == "FRUKI") {
                                        turnos = turnosFruki; }
                                      else if (cliente == "KUEHNE NAGEL") {
                                        turnos = turnosKuehne; }
                                      else if (cliente == "MIDEA CARRIER") {
                                        turnos = turnosMidea; }
                                      else if (cliente == "MILLS") {
                                        turnos = turnosMills; }
                                      else if (cliente == "PETROBRAS") {
                                        turnos = turnosPetrobras; }
                                      else if (cliente == "PROLEC GE") {
                                        turnos = turnosProlec; }
                                      else if (cliente == "TEDESCO") {
                                        turnos = turnosTedesco; }
                                      else if (cliente == "TERESA") {
                                        turnos = turnosTeresa; }
                                      else if (cliente == "UNIDASUL") {
                                        turnos = turnosUnidasul; }
                                      else {turnos = [];}

                                      setState(() {
                                        selectedCliente = cliente;
                                        selectedTurno = null;
                                        selectedRota = null;
                                        rotas = [];
                                        _filtrarViagens();
                                        //_getNumero();
                                      });

                                    },
                                  ),
                                  Padding(padding: EdgeInsets.only(bottom: 20)),
                                  Text("TURNO:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                  DropdownButtonFormField<String>(
                                    value: selectedTurno,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20
                                    ),
                                    hint: Text("SELECIONAR"),
                                    items: turnos.map((String value) {
                                      return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value.toUpperCase())
                                      );
                                    }).toList(),
                                    onChanged: (turno) {

                                      if (turno == "ADM" && selectedCliente == "AGCO") {
                                        rotas = rotasAgcoAdm;}
                                      else if (turno == "ESTAGIARIOS" && selectedCliente == "AGCO") {
                                        rotas = rotasAgcoEstagiarios;}
                                      else if (turno == "T2" && selectedCliente == "AGCO") {
                                        rotas = rotasAgcoT2;}
                                      else if (turno == "ADM" && selectedCliente == "EDLO") {
                                        rotas = rotasEdloAdm;}
                                      else if (turno == "ESTACAO" && selectedCliente == "FRUKI") {
                                        rotas = rotasFrukiEstacao;}
                                      else if (turno == "4X3" && selectedCliente == "KUEHNE NAGEL") {
                                        rotas = rotasKuehne4x3;}
                                      else if (turno == "5X2" && selectedCliente == "KUEHNE NAGEL") {
                                        rotas = rotasKuehne5x2;}
                                      else if (turno == "6X1" && selectedCliente == "KUEHNE NAGEL") {
                                        rotas = rotasKuehne6x1;}
                                      else if (turno == "REFEICOES" && selectedCliente == "KUEHNE NAGEL") {
                                        rotas = rotasKuehneRefeicoes;}
                                      else if (turno == "ADM" && selectedCliente == "MIDEA CARRIER") {
                                        rotas = rotasMideaAdm;}
                                      else if (turno == "T2" && selectedCliente == "MIDEA CARRIER") {
                                        rotas = rotasMideaT2;}
                                      else if (turno == "ADM" && selectedCliente == "MILLS") {
                                        rotas = rotasMillsAdm;}
                                      else if (turno == "ADM" && selectedCliente == "PETROBRAS") {
                                        rotas = rotasPetrobrasAdm;}
                                      else if (turno == "INTERNO" && selectedCliente == "PETROBRAS") {
                                        rotas = rotasPetrobrasInterno;}
                                      else if (turno == "TURNO" && selectedCliente == "PETROBRAS") {
                                        rotas = rotasPetrobrasTurno;}
                                      else if (turno == "ADM" && selectedCliente == "PROLEC GE") {
                                        rotas = rotasProlecAdm;}
                                      else if (turno == "ESTAGIARIOS" && selectedCliente == "PROLEC GE") {
                                        rotas = rotasProlecEstagiarios;}
                                      else if (turno == "T1" && selectedCliente == "PROLEC GE") {
                                        rotas = rotasProlecT1;}
                                      else if (turno == "T2" && selectedCliente == "PROLEC GE") {
                                        rotas = rotasProlecT2;}
                                      else if (turno == "ADM" && selectedCliente == "TEDESCO") {
                                        rotas = rotasTedescoAdm;}
                                      else if (turno == "TURNO A" && selectedCliente == "TEDESCO") {
                                        rotas = rotasTedescoTurnoA;}
                                      else if (turno == "TURNO B" && selectedCliente == "TEDESCO") {
                                        rotas = rotasTedescoTurnoB;}
                                      else if (turno == "TURNO C" && selectedCliente == "TEDESCO") {
                                        rotas = rotasTedescoTurnoC;}
                                      else if (turno == "CIRCULAR" && selectedCliente == "TERESA") {
                                        rotas = rotasTeresaCircular;}
                                      else if (turno == "ESTACAO" && selectedCliente == "UNIDASUL") {
                                        rotas = rotasUnidasulEstacao;}
                                      else if (turno == "T1" && selectedCliente == "UNIDASUL") {
                                        rotas = rotasUnidasulT1;}
                                      else if (turno == "T2" && selectedCliente == "UNIDASUL") {
                                        rotas = rotasUnidasulT2;}
                                      else {rotas = [];}

                                      setState(() {
                                        selectedTurno = turno;
                                        selectedRota = null;
                                        _filtrarViagens();
                                        //_getNumero();
                                      });

                                    },
                                  ),
                                  Padding(padding: EdgeInsets.only(bottom: 20)),
                                  Text("ROTA:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                  DropdownButtonFormField<String>(
                                    value: selectedRota,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20
                                    ),
                                    hint: Text("SELECIONAR"),
                                    items: rotas.map((String value) {
                                      return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value.toUpperCase())
                                      );
                                    }).toList(),
                                    onChanged: (rota) {

                                      setState(() {
                                        selectedRota = rota;
                                        _filtrarViagens();
                                        //_getNumero();
                                      });

                                    },
                                  ),
                                  Padding(padding: EdgeInsets.only(bottom: 20)),
                                  Text("SENTIDO:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                  DropdownButtonFormField<String>(
                                    value: selectedSentido,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20
                                    ),
                                    hint: Text("SELECIONAR"),
                                    items: entradaSaida.map((String value) {
                                      return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value.toUpperCase())
                                      );
                                    }).toList(),
                                    onChanged: (sentido) {

                                      setState(() {
                                        selectedSentido = sentido;
                                        _filtrarViagens();
                                        //_getNumero();
                                      });

                                    },
                                  ),
                                  Padding(padding: EdgeInsets.only(bottom: 20)),
                                  Text("TIPO:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                  DropdownButtonFormField<String>(
                                    value: selectedTipo,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20
                                    ),
                                    hint: Text("SELECIONAR"),
                                    items: normalExtra.map((String value) {
                                      return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value.toUpperCase())
                                      );
                                    }).toList(),
                                    onChanged: (tipo) {

                                      setState(() {
                                        selectedTipo = tipo;
                                        _filtrarViagens();
                                        //_getNumero();
                                      });

                                    },
                                  ),
                                  Padding(padding: EdgeInsets.only(bottom: 20)),
                                  ElevatedButton(
                                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.orange)),
                                      onPressed: (){
                                        Navigator.pop(context);
                                      },
                                      child: Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10), child: Text("FILTRAR", style: TextStyle(fontSize: 20),),)),


                                  Padding(padding: EdgeInsets.only(bottom: 20)),
                                  ElevatedButton(
                                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.orange)),
                                      onPressed: (){
                                        setState(() {
                                          selectedCliente = null;
                                          selectedTurno = null;
                                          selectedRota = null;
                                          selectedSentido = null;
                                          selectedTipo = null;
                                          selectedDataInicio = null;
                                          selectedVeiculo = null;
                                          _controllerDataInicio.text = "";
                                          clientes = [];
                                          rotas = [];
                                          turnos = [];
                                          _adicionarListenerConsultaViagem();
                                        });
                                      },
                                      child: Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10), child: Text("LIMPAR", style: TextStyle(fontSize: 20),),)),
                                  Padding(padding: EdgeInsets.only(bottom: 20)),
                                  ElevatedButton(
                                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.orange)),
                                      onPressed: (){
                                        setState(() {
                                          selectedCliente = null;
                                          selectedTurno = null;
                                          selectedRota = null;
                                          selectedSentido = null;
                                          selectedTipo = null;
                                          selectedDataInicio = null;
                                          selectedVeiculo = null;
                                          _controllerDataInicio.text = "";
                                          clientes = [];
                                          rotas = [];
                                          turnos = [];
                                          _adicionarListenerConsultaViagem();
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10), child: Text("CANCELAR", style: TextStyle(fontSize: 20),),)),

                                ],
                              ),
                            ),
                          ),
                        );

                      });
                }
            );

          }, icon: Icon(Icons.filter_alt))
        ],
      ),
      body: Container(
        child: ListView(children: <Widget>[
          Column(children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    color: Colors.grey[400],
                    child: Table(
                      columnWidths:({
                        0: FlexColumnWidth(0.2),
                        1: FlexColumnWidth(0.2),
                        2: FlexColumnWidth(0.2),
                        3: FlexColumnWidth(0.2),
                        4: FlexColumnWidth(0.2),
                        5: FlexColumnWidth(0.2),
                      }),
                      border: TableBorder.all(),
                      children: <TableRow>[
                        TableRow(
                            children: <Widget>[
                              TableCell(
                                child: Container(alignment: Alignment.center, height: 50, child: Text("DATA", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),),
                              ),
                              TableCell(
                                child: Container(alignment: Alignment.center, height: 50, child: Text("CLIENTE", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),),
                              ),
                              TableCell(
                                child: Container(alignment: Alignment.center, height: 50, child: Text("TURNO", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),),
                              ),
                              TableCell(
                                child: Container(alignment: Alignment.center, height: 50, child: Text("ROTA", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),),
                              ),
                              TableCell(
                                child: Container(alignment: Alignment.center, height: 50, child: Text("SITUAÇÃO", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),),
                              ),
                            ]
                        )
                      ],
                    ),
                  ),
                ),
              ],),
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    //color: Colors.grey[300],
                    child: Table(

                      columnWidths:({
                        0: FlexColumnWidth(0.2),
                        1: FlexColumnWidth(0.2),
                        2: FlexColumnWidth(0.2),
                        3: FlexColumnWidth(0.2),
                        4: FlexColumnWidth(0.2),
                        5: FlexColumnWidth(0.2),
                      }),
                      border: TableBorder.all(),
                      children: <TableRow>[
                        TableRow(
                          //decoration: BoxDecoration(color: Colors.green),
                            children: <Widget>[
                              TableCell(
                                child: Container(alignment: Alignment.center, height: 50, child: Text( (selectedDataInicio == null) ? "(selecionar)" : selectedDataInicio.toString(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),),
                              ),
                              TableCell(
                                child: Container(alignment: Alignment.center, height: 50, child: Text( (selectedCliente == null) ? "(selecionar)" : "kkk", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),),
                              ),
                              TableCell(
                                child: Container(alignment: Alignment.center, height: 50, child: Text( (selectedTurno == null) ? "(selecionar)" : selectedTurno.toString(), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),),
                              ),
                              TableCell(
                                child: Container(alignment: Alignment.center, height: 50, child: Text( (selectedTurno == null) ? "(selecionar)" : "(rota)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),),
                              ),
                              TableCell(
                                child: Container(alignment: Alignment.center, height: 50, child: Text( (selectedTurno == null) ? "(selecionar)" : "(situação)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), textAlign: TextAlign.center,),),
                              ),
                            ]
                        ),
                      ],
                    ),
                  ),
                ),
              ],)
          ])
        ],)),

    );
  }
}
