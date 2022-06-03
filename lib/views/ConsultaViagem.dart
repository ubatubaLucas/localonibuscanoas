import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localonibus/models/Viagem.dart';
import 'package:localonibus/views/widgets/ListViewViagem.dart';
import 'package:intl/intl.dart';

class ConsultaViagem extends StatefulWidget {

  @override
  _ConsultaViagemState createState() => _ConsultaViagemState();

}

class _ConsultaViagemState extends State<ConsultaViagem> {

  late StreamSubscription _subscription;

  final _controllerConsultaViagem = StreamController<QuerySnapshot>.broadcast();
  //final _controllerGetNumero = StreamController<QuerySnapshot>.broadcast();
  String _nViagensEncontradas = "ÚLTIMAS VIAGENS REGISTRADAS...";
  String _nViagensGetNumero = "";
  //String _nVia = "";

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

  List<int> veiculos = [200,201,202,203,204,205,206,207,208,209,210,211,500,501,502,503,504,505,506,507,508,509,510,511,1000,1001,1002,1003,1004,1005,1006,1007,1008,1009,1010,1011,1012,1013,1014,1015,1016,1017,1018,1100,1200,1300,1400,1500,1600,1700,1800,1900,2000,2100,2240,2244,2245,2246,2247,2249,2250,2251,2252,2253,2254,2255,2256,2257,2258,2259,2260,2261,2262,2263,2264,2265,2266,2267,2268,2269,2270,2271,2272,2273,2600,2900,3000,3100,3200,3300,3400,3500,3600,3700,3800,3900,4000,4100,4200,4300,4400,4500,4600,4700,4800,4900,7200,7300,7400,7500,7600,7700,7800,8700,8800,8900,9000,9100,9200,9300,9400,9500,9600,9700,9800,9900];

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

  /*Future<Stream<QuerySnapshot>?> _getNumero() async {

    FirebaseFirestore db = FirebaseFirestore.instance;
    Query query = await db.collection("ROTAS");

    if (selectedCliente != null) {
      query = query.where("cliente", isEqualTo: selectedCliente!.toLowerCase());
    }

    if (selectedTurno != null) {
      query = query.where("turno", isEqualTo: selectedTurno!.toLowerCase());
    }

    if (selectedRota != null) {
      query = query.where("rota", isEqualTo: selectedRota!.toLowerCase());
    }

    Stream<QuerySnapshot> streamGetNumero = query.snapshots();
    streamGetNumero.listen((dadosGetNumero) {
      _controllerGetNumero.add(dadosGetNumero);

      if (!mounted) return;
      setState(() {
        _nVia = (dadosGetNumero.docs.length * 2).toString();
        _nViagensGetNumero = " / " + _nVia;
      });

    });

  }*/

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

    if (selectedVeiculo != null) {
      query = query.where("veiculo", isEqualTo: selectedVeiculo);
    }

    if (selectedTipo != null) {
      query = query.where("normalExtra", isEqualTo: selectedTipo);
    }

    if (selectedSentido != null) {
      query = query.where("entradaSaida", isEqualTo: selectedSentido);
    }

    Stream<QuerySnapshot> stream = query.snapshots();
    _subscription = stream.listen((dados) {
      _controllerConsultaViagem.add(dados);
      _subscription.cancel();

      if (!mounted) return;
      setState(() {
        _nViagensEncontradas = "NÚMERO DE VIAGENS: " + dados.docs.length.toString();
      });

    });
    return null;

  }

  Future<Stream<QuerySnapshot>?> _adicionarListenerConsultaViagem() async {

    FirebaseFirestore db = await FirebaseFirestore.instance;
    Stream<QuerySnapshot> stream = db
        .collection("VIAGENS")
        .orderBy("regTime", descending: true)
        .limit(10)
        .snapshots();

    _subscription = stream.listen((dados) {
      _controllerConsultaViagem.add(dados);
      _subscription.cancel();

      if (!mounted) return;
      setState(() {
        _nViagensEncontradas = "ÚLTIMOS REGISTROS...";
      });

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

  _removerAnuncio(String viagemId){

    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("VIAGENS")
        .doc( viagemId )
        .delete();
  }

  @override
  void initState() {
    super.initState();
    _adicionarListenerConsultaViagem();
  }

  @override
  Widget build(BuildContext context) {

    var carregandoViagens = Center(
      child: Column(children: <Widget>[

        Text("CARREGANDO VIAGENS..."),
        CircularProgressIndicator()

      ],),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("CONSULTAR VIAGEM"),
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
                                          turnos = turnosAgco;
                                          _nViagensGetNumero = " / " + (((rotasAgcoAdm.length * 2) - 1) + rotasAgcoEstagiarios.length * 1 + rotasAgcoT2.length * 2).toString();
                                        }
                                        else if (cliente == "EDLO") {
                                          turnos = turnosEdlo;
                                          _nViagensGetNumero = " / " + (rotasEdloAdm.length * 2).toString();
                                        }
                                        else if (cliente == "FRUKI") {
                                          turnos = turnosFruki;
                                          _nViagensGetNumero = " / " + (rotasFrukiEstacao.length).toString();
                                        }
                                        else if (cliente == "KUEHNE NAGEL") {
                                          turnos = turnosKuehne;
                                          _nViagensGetNumero = " / " + (rotasKuehne4x3.length * 4 + rotasKuehne5x2.length * 2 + (rotasKuehne6x1.length * 1) + (rotasKuehneRefeicoes.length)*1 + 1).toString();
                                        }
                                        else if (cliente == "MIDEA CARRIER") {
                                          turnos = turnosMidea;
                                          _nViagensGetNumero = " / " + ((rotasMideaAdm.length + rotasMideaT2.length) * 2).toString();
                                        }
                                        else if (cliente == "MILLS") {
                                          turnos = turnosMills;
                                          _nViagensGetNumero = " / " + (rotasMillsAdm.length * 2).toString();
                                        }
                                        else if (cliente == "PETROBRAS") {
                                          turnos = turnosPetrobras;
                                          _nViagensGetNumero = " / " + (rotasPetrobrasAdm.length * 2 + rotasPetrobrasTurno.length * 4).toString();
                                        }
                                        else if (cliente == "PROLEC GE") {
                                          turnos = turnosProlec;
                                          _nViagensGetNumero = " / " + (rotasProlecAdm.length * 2 + rotasProlecEstagiarios.length * 1 + ((rotasProlecT1.length * 2) - 1) + rotasProlecT2.length * 2).toString();
                                        }
                                        else if (cliente == "TEDESCO") {
                                          turnos = turnosTedesco;
                                          _nViagensGetNumero = " / " + ((rotasTedescoAdm.length + rotasTedescoTurnoA.length + rotasTedescoTurnoB.length + rotasTedescoTurnoC.length) * 2).toString();
                                        }
                                        else if (cliente == "TERESA") {
                                          turnos = turnosTeresa;
                                          _nViagensGetNumero = " / " + (rotasTeresaCircular.length).toString();
                                        }
                                        else if (cliente == "UNIDASUL") {
                                          turnos = turnosUnidasul;
                                          _nViagensGetNumero = " / " + (rotasUnidasulEstacao.length * 1 + rotasUnidasulT1.length * 2 + rotasUnidasulT2.length * 2).toString();
                                        }
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
                                              rotas = rotasAgcoAdm;
                                              _nViagensGetNumero = " / " + (((rotasAgcoAdm.length)*2)-1).toString();}
                                            else if (turno == "ESTAGIARIOS" && selectedCliente == "AGCO") {
                                              rotas = rotasAgcoEstagiarios;
                                              _nViagensGetNumero = " / " + ((rotasAgcoEstagiarios.length)*1).toString();}
                                            else if (turno == "T2" && selectedCliente == "AGCO") {
                                              rotas = rotasAgcoT2;
                                              _nViagensGetNumero = " / " + ((rotasAgcoT2.length)*2).toString();}
                                            else if (turno == "ADM" && selectedCliente == "EDLO") {
                                              rotas = rotasEdloAdm;
                                              _nViagensGetNumero = " / " + ((rotasEdloAdm.length)*2).toString();}
                                            else if (turno == "ESTACAO" && selectedCliente == "FRUKI") {
                                              rotas = rotasFrukiEstacao;
                                              _nViagensGetNumero = " / " + ((rotasFrukiEstacao.length)*1).toString();}
                                            else if (turno == "4X3" && selectedCliente == "KUEHNE NAGEL") {
                                              rotas = rotasKuehne4x3;
                                              _nViagensGetNumero = " / " + ((rotasKuehne4x3.length)*4).toString();}
                                            else if (turno == "5X2" && selectedCliente == "KUEHNE NAGEL") {
                                              rotas = rotasKuehne5x2;
                                              _nViagensGetNumero = " / " + ((rotasKuehne5x2.length)*2).toString();}
                                            else if (turno == "6X1" && selectedCliente == "KUEHNE NAGEL") {
                                              rotas = rotasKuehne6x1;
                                              _nViagensGetNumero = " / " + ((rotasKuehne6x1.length)*1).toString();}
                                            else if (turno == "REFEICOES" && selectedCliente == "KUEHNE NAGEL") {
                                              rotas = rotasKuehneRefeicoes;
                                              _nViagensGetNumero = " / " + ((rotasKuehneRefeicoes.length)*1 + 1).toString();}
                                            else if (turno == "ADM" && selectedCliente == "MIDEA CARRIER") {
                                              rotas = rotasMideaAdm;
                                              _nViagensGetNumero = " / " + ((rotasMideaAdm.length)*2).toString();}
                                            else if (turno == "T2" && selectedCliente == "MIDEA CARRIER") {
                                              rotas = rotasMideaT2;
                                              _nViagensGetNumero = " / " + ((rotasMideaT2.length)*2).toString();}
                                            else if (turno == "ADM" && selectedCliente == "MILLS") {
                                              rotas = rotasMillsAdm;
                                              _nViagensGetNumero = " / " + ((rotasMillsAdm.length)*2).toString();}
                                            else if (turno == "ADM" && selectedCliente == "PETROBRAS") {
                                              rotas = rotasPetrobrasAdm;
                                              _nViagensGetNumero = " / " + ((rotasPetrobrasAdm.length)*2).toString();}
                                            else if (turno == "INTERNO" && selectedCliente == "PETROBRAS") {
                                              rotas = rotasPetrobrasInterno;
                                              _nViagensGetNumero = " / " + (1).toString();}
                                            else if (turno == "TURNO" && selectedCliente == "PETROBRAS") {
                                              rotas = rotasPetrobrasTurno;
                                              _nViagensGetNumero = " / " + ((rotasPetrobrasTurno.length)*4).toString();}
                                            else if (turno == "ADM" && selectedCliente == "PROLEC GE") {
                                              rotas = rotasProlecAdm;
                                              _nViagensGetNumero = " / " + ((rotasProlecAdm.length)*2).toString();}
                                            else if (turno == "ESTAGIARIOS" && selectedCliente == "PROLEC GE") {
                                              rotas = rotasProlecEstagiarios;
                                              _nViagensGetNumero = " / " + ((rotasProlecEstagiarios.length)*1).toString();}
                                            else if (turno == "T1" && selectedCliente == "PROLEC GE") {
                                              rotas = rotasProlecT1;
                                              _nViagensGetNumero = " / " + (((rotasProlecT1.length)*2)-1).toString();}
                                            else if (turno == "T2" && selectedCliente == "PROLEC GE") {
                                              rotas = rotasProlecT2;
                                              _nViagensGetNumero = " / " + ((rotasProlecT2.length)*2).toString();}
                                            else if (turno == "ADM" && selectedCliente == "TEDESCO") {
                                              rotas = rotasTedescoAdm;
                                              _nViagensGetNumero = " / " + ((rotasTedescoAdm.length)*2).toString();}
                                            else if (turno == "TURNO A" && selectedCliente == "TEDESCO") {
                                              rotas = rotasTedescoTurnoA;
                                              _nViagensGetNumero = " / " + ((rotasTedescoTurnoA.length)*2).toString();}
                                            else if (turno == "TURNO B" && selectedCliente == "TEDESCO") {
                                              rotas = rotasTedescoTurnoB;
                                              _nViagensGetNumero = " / " + ((rotasTedescoTurnoB.length)*2).toString();}
                                            else if (turno == "TURNO C" && selectedCliente == "TEDESCO") {
                                              rotas = rotasTedescoTurnoC;
                                              _nViagensGetNumero = " / " + ((rotasTedescoTurnoC.length)*2).toString();}
                                            else if (turno == "CIRCULAR" && selectedCliente == "TERESA") {
                                              rotas = rotasTeresaCircular;
                                              _nViagensGetNumero = " / " + ((rotasTeresaCircular.length)*1).toString();}
                                            else if (turno == "ESTACAO" && selectedCliente == "UNIDASUL") {
                                              rotas = rotasUnidasulEstacao;
                                              _nViagensGetNumero = " / " + ((rotasUnidasulEstacao.length)*1).toString();}
                                            else if (turno == "T1" && selectedCliente == "UNIDASUL") {
                                              rotas = rotasUnidasulT1;
                                              _nViagensGetNumero = " / " + ((rotasUnidasulT1.length)*2).toString();}
                                            else if (turno == "T2" && selectedCliente == "UNIDASUL") {
                                              rotas = rotasUnidasulT2;
                                              _nViagensGetNumero = " / " + ((rotasUnidasulT2.length)*2).toString();}
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

                                            if (selectedTurno == "ESTAGIARIOS" && selectedCliente == "AGCO") {
                                              _nViagensGetNumero = " / " + (1).toString();}
                                            else if (selectedTurno == "ESTACAO" && selectedCliente == "FRUKI") {
                                              _nViagensGetNumero = " / " + (1).toString();}
                                            else if (selectedTurno == "4X3" && selectedCliente == "KUEHNE NAGEL") {
                                              _nViagensGetNumero = " / " + (4).toString();}
                                            else if (selectedTurno == "REFEICOES" && selectedCliente == "KUEHNE NAGEL") {
                                              _nViagensGetNumero = " / " + (1).toString();}
                                            else if (selectedTurno == "INTERNO" && selectedCliente == "PETROBRAS") {
                                              _nViagensGetNumero = " / " + (1).toString();}
                                            else if (selectedTurno == "TURNO" && selectedCliente == "PETROBRAS") {
                                              _nViagensGetNumero = " / " + (4).toString();}
                                            else if (selectedTurno == "ESTAGIARIOS" && selectedCliente == "PROLEC GE") {
                                              _nViagensGetNumero = " / " + (1).toString();}
                                            else if (selectedTurno == "CIRCULAR" && selectedCliente == "TERESA") {
                                              _nViagensGetNumero = " / " + (1).toString();}
                                            else if (selectedTurno == "ESTACAO" && selectedCliente == "UNIDASUL") {
                                              _nViagensGetNumero = " / " + (1).toString();}
                                            else {_nViagensGetNumero = " / " + (2).toString();}

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
                                                _nViagensGetNumero = "";
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
                                                _nViagensGetNumero = "";
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

          }, icon: Icon(Icons.filter_alt)),
        ],
      ),
      body: Container(child:
      Column(children: <Widget>[
        Row(children: <Widget>[
          Expanded(
            child: Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(_nViagensEncontradas + _nViagensGetNumero, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                )),
          ),
        ],),

        StreamBuilder(
          stream: _controllerConsultaViagem.stream,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return carregandoViagens;
              case ConnectionState.active:
              case ConnectionState.done:

                QuerySnapshot querySnapshot = snapshot.data as QuerySnapshot;

                if (querySnapshot.docs.length == 0) {
                  return Container(
                    padding: EdgeInsets.all(25),
                    child: Text("NENHUMA VIAGEM ENCONTRADA!",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),),
                  );
                }

                return Expanded(
                    child: ListView.builder(
                        itemCount: querySnapshot.docs.length,
                        itemBuilder: (_, indice){

                          List<DocumentSnapshot> viagens = querySnapshot.docs.toList();
                          DocumentSnapshot documentSnapshot = viagens[indice];
                          Viagem viagem = Viagem.fromDocumentSnapshot(documentSnapshot);

                          return ListViewViagem(
                            viagem: viagem,
                            onPressedRemover: () {
                              showDialog(
                                  context: context,
                                  builder: (context){
                                    return AlertDialog(
                                      contentPadding: EdgeInsets.symmetric(),
                                      content: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          Padding(padding: EdgeInsets.fromLTRB(0, 25, 0, 15), child: Text("DESEJA REALMENTE EXCLUIR A VIAGEM?", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),),
                                        ],
                                      ),
                                      actions: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(25, 0, 25, 0),
                                          child: Container(
                                              decoration: BoxDecoration(
                                                  border: Border.all(color: Colors.black)
                                              ),
                                              alignment: Alignment.center,
                                              child: Padding(
                                                  padding: EdgeInsets.all(20),
                                                  child: Column(
                                                    children: <Widget>[
                                                      Row(children: <Widget>[
                                                        Text("DATA: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                                        Text(viagem.dataInicio, style: TextStyle(fontSize: 18),),
                                                      ],),
                                                      Row(children: <Widget>[
                                                        Text("CLIENTE: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                                        Text(viagem.cliente.toUpperCase(), style: TextStyle(fontSize: 18),),
                                                      ],),
                                                      Row(children: <Widget>[
                                                        Text("TURNO: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                                        Text(viagem.turno.toUpperCase(), style: TextStyle(fontSize: 18),),
                                                      ],),
                                                      Row(children: <Widget>[
                                                        Text("ROTA: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                                        Text(viagem.rota, style: TextStyle(fontSize: 18),),
                                                      ],),
                                                      Row(children: <Widget>[
                                                        Text("SENTIDO: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                                        Text(viagem.entradaSaida.toUpperCase(), style: TextStyle(fontSize: 18),),
                                                      ],),
                                                      Row(children: <Widget>[
                                                        Text("TIPO: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                                        Text(viagem.normalExtra.toUpperCase(), style: TextStyle(fontSize: 18),),
                                                      ],),
                                                      Row(children: <Widget>[
                                                        Text("MOTORISTA: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                                        Text(viagem.motorista.toUpperCase(), style: TextStyle(fontSize: 18),),
                                                      ],),
                                                      Row(children: <Widget>[
                                                        Text("VEÍCULO: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                                        Text(viagem.veiculo, style: TextStyle(fontSize: 18),),
                                                      ],),
                                                    ],
                                                    mainAxisAlignment: MainAxisAlignment.start,)
                                              )
                                          ),
                                        ),


                                        Padding(padding: EdgeInsets.only(bottom: 25)),

                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: <Widget>[
                                            Container(
                                              width: 90,
                                              child: ElevatedButton(
                                                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.orange)),
                                                  onPressed: (){
                                            _removerAnuncio( viagem.id );
                                            (selectedCliente != null) ? _filtrarViagens() : _adicionarListenerConsultaViagem();
                                            Navigator.pop(context);
                                          },
                                                  child: Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10), child: Text("SIM", style: TextStyle(fontSize: 20),),)),
                                            ),

                                            Container(
                                              width: 90,
                                              child: ElevatedButton(
                                                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.orange)),
                                                  onPressed: (){
                                                    Navigator.pop(context);
                                                  },
                                                  child: Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10), child: Text("NÃO", style: TextStyle(fontSize: 20),),)),
                                            ),

                                          ],
                                        ),
                                        Padding(padding: EdgeInsets.only(bottom: 15)),
                                      ],
                                    );
                                  }
                              );
                            },
                          );

                        }
                    )
                );

            }
          },
        )]),),

    );
  }
}
