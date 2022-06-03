import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localonibus/models/Viagem.dart';
import 'package:localonibus/views/widgets/BotaoCustomizado.dart';
import 'package:localonibus/views/widgets/InputCustomizado.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validadores/validadores.dart';
import 'package:validadores/Validador.dart';
import 'package:intl/intl.dart';

class RegistrarViagemMotorista extends StatefulWidget {

  @override
  _RegistrarViagemMotoristaState createState() => _RegistrarViagemMotoristaState();
}

class _RegistrarViagemMotoristaState extends State<RegistrarViagemMotorista> {

  List<String> clientes = ["AGCO", "EDLO", "EVENTUAL", "FRUKI", "KUEHNE NAGEL", "MIDEA CARRIER", "MILLS", "PETROBRAS", "PROLEC GE", "TEDESCO", "TERESA", "UNIDASUL"];

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

  List<String> entradaSaida = ["ENTRADA", "SAIDA"];
  List<String> normalExtra = ["NORMAL", "EXTRA"];

  String? selectedCliente;
  String? selectedTurno;
  String? selectedRota;
  String? selectedEntradaSaida;
  String? selectedNormalExtra;

  final _formKey = GlobalKey<FormState>();
  late Viagem _viagem;
  late BuildContext _dialogContext;

  TextEditingController _iconButtonInicio = TextEditingController(text: DateFormat("dd/MM/yyyy").format(DateTime.now()).toString());
  TextEditingController _iconButtonFim = TextEditingController(text: DateFormat("dd/MM/yyyy").format(DateTime.now()).toString());
  TextEditingController _controllerVeiculo = TextEditingController(text: "");
  TextEditingController _controllerHoraInicio = TextEditingController(text: "");
  TextEditingController _controllerHoraFim = TextEditingController(text: "");
  TextEditingController _controllerKmInicio = TextEditingController(text: "");
  TextEditingController _controllerKmFim = TextEditingController(text: "");
  TextEditingController _controllerQtdPax = TextEditingController(text: "");
  TextEditingController _controllerFicha = TextEditingController(text: "");

  late DateTime _getDataInicioDT;
  late DateTime _getDataFimDT;

  _abrirDialog(BuildContext context) {

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(height: 20,),
                Text("SALVANDO INFORMAÇÕES......")
              ],
            ),
          );

        });
  }

  String? _nomeUser;
  String? _matriculaUser;
  String? _tipoUser;

  _buscarNome() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nomeUser = prefs.getString('nomeUser')!;
      _matriculaUser = prefs.getString('matriculaUser')!;
      _tipoUser = prefs.getString('tipoUser')!;
    });
  }

  _salvarViagem() async {
    _abrirDialog(_dialogContext);

    FirebaseAuth auth = FirebaseAuth.instance;

    User? usuarioLogado = await auth.currentUser;
    if (usuarioLogado != null) {

      FirebaseFirestore db = FirebaseFirestore.instance;

      /*
      String idUsuario = usuarioLogado.uid;

    DocumentSnapshot<Map<String, dynamic>> snapshot = await db
        .collection("USUARIOS")
        .doc(idUsuario)
        .get();

    var dados = snapshot.data();

    String nomeUsuario = dados!["nome"];
    String emailUsuario = dados["email"];
    String matriculaUsuario = emailUsuario.replaceAll("@localonibus.com.br", "");
    String tipoUsuario = dados["tipoUsuario"];*/

    _viagem.regTime = Timestamp.fromDate(DateTime.now());

    _viagem.dataInicioDT = Timestamp.fromDate(_getDataInicioDT);
    _viagem.dataInicioDTORDERBY = _viagem.dataInicioDT;

    _viagem.dataFimDT = Timestamp.fromDate(_getDataFimDT);

    _viagem.motorista = _matriculaUser! + " - " + _nomeUser!;

    if (selectedCliente == "EVENTUAL") {

      _viagem.turno = "EVENTUAL";
      _viagem.turnoORDERBY = "EVENTUAL";
      _viagem.rota = "EVENTUAL";
      _viagem.rotaORDERBY = "EVENTUAL";
      _viagem.normalExtra = "EVENTUAL";
      _viagem.entradaSaida = "EVENTUAL";

    }

      if (selectedCliente != "EVENTUAL") {

        _viagem.ficha = 0;

      }



      db.collection("VIAGENS")
          .doc( _viagem.id )
          .set(_viagem.toMap()).then((_) {
        Navigator.pop(_dialogContext);

      switch(_tipoUser){
        case "MOTORISTA" :
          Navigator.pushNamedAndRemoveUntil(context, "/HomeMotorista", (route) => false);
          break;
        case "PREPOSTO" :
          Navigator.pushNamedAndRemoveUntil(context, "/HomePreposto", (route) => false);
          break;
        case "GERENTE" :
          Navigator.pushNamedAndRemoveUntil(context, "/Home", (route) => false);
          break;
        case "CLIENTE" :
          Navigator.pushNamedAndRemoveUntil(context, "/HomeCliente", (route) => false);
          break;
      }
    });
  }
  }

  @override
  void initState() {
    _buscarNome();
    super.initState();
    _viagem = Viagem.usuarioLogado();
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
        _viagem.dataInicio = DateFormat("dd/MM/yyyy").format(pickedDateInicio);
        _iconButtonInicio.text = _viagem.dataInicio;
        _iconButtonFim.text = _viagem.dataInicio;
        _getDataInicioDT = pickedDateInicio;
        _getDataFimDT = pickedDateInicio;
      });
    });
  }

  _showDatePickerFim() {
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
    ).then((pickedDateFim) {
      if(pickedDateFim == null) {
        return;
      }
      setState(() {
        //_selectedDateFim = pickedDateFim;
        _viagem.dataFim = DateFormat("dd/MM/yyyy").format(pickedDateFim);
        _iconButtonFim.text = _viagem.dataFim;
        _getDataFimDT = pickedDateFim;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("REGISTRAR VIAGEM"),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(children: <Widget>[
                  Text("CLIENTE:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: DropdownButtonFormField<dynamic>(
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
                        onSaved: (cliente) {
                          _viagem.cliente = cliente!;
                        },
                        validator: (value) {
                          return Validador()
                              .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                              .valido(value);
                        },
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
                          });
                        },
                      ),
                    ),
                  ),
                ],),
                if (selectedCliente == "EVENTUAL") ...[
                  Row(children: <Widget>[
                    Text("FICHA:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    Expanded(child: Padding(
                      padding: EdgeInsets.all(8),
                      child: InputCustomizado(
                          controller: _controllerFicha,
                          hint: "N° VIAGEM",
                          onSaved: (ficha) {
                            _viagem.ficha = int.parse(ficha!.replaceAll(".", ""));
                            return null;
                          },
                          validator: (value) {
                            return Validador()
                                .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                                .valido(value);
                          },
                          type: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ]
                      ),
                    ))
                  ],),
                ] else ...[
                  Row(children: <Widget>[
                    Text("TURNO:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: DropdownButtonFormField<String>(
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
                          onSaved: (turno) {
                            _viagem.turno = turno!;
                            _viagem.turnoORDERBY = _viagem.turno;
                          },
                          validator: (value) {
                            return Validador()
                                .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                                .valido(value);
                          },
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

                            });

                          },
                        ),
                      ),
                    ),
                  ],),
                  Row(children: <Widget>[
                    Text("ROTA:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: DropdownButtonFormField<String>(
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
                          onSaved: (rota) {
                            _viagem.rota = rota!;
                            _viagem.rotaORDERBY = _viagem.rota;
                          },
                          validator: (value) {
                            return Validador()
                                .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                                .valido(value);
                          },
                          onChanged: (rota) {
                            setState(() {
                              selectedRota = rota;
                            });
                          },
                        ),
                      ),
                    ),
                  ],),
                  Row(children: <Widget>[
                    Text("SENTIDO:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: DropdownButtonFormField<String>(
                          value: selectedEntradaSaida,
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
                          onSaved: (e) {
                            _viagem.entradaSaida = e!;
                          },
                          validator: (value) {
                            return Validador()
                                .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                                .valido(value);
                          },
                          onChanged: (e) {
                            setState(() {
                              selectedEntradaSaida = e;
                            });
                          },
                        ),
                      ),
                    ),
                  ],),
                  Row(children: <Widget>[
                    Text("TIPO:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: DropdownButtonFormField<String>(
                          value: selectedNormalExtra,
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
                          onSaved: (n) {
                            _viagem.normalExtra = n!;
                          },
                          validator: (value) {
                            return Validador()
                                .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                                .valido(value);
                          },
                          onChanged: (n) {
                            setState(() {
                              selectedNormalExtra = n;
                            });
                          },
                        ),
                      ),
                    ),
                  ],),
                ],

                Row(children: <Widget>[
                  Text("VEÍCULO:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  Expanded(child: Padding(
                    padding: EdgeInsets.all(8),
                    child: InputCustomizado(
                        controller: _controllerVeiculo,
                        hint: "PREFIXO",
                        onSaved: (veiculo) {
                          _viagem.veiculo = veiculo!;
                          return null;
                        },
                        validator: (value){

                          if(_controllerVeiculo.text.isEmpty) {
                            return "[Campo Obrigatório]";
                          }

                          if(!veiculos.contains(int.parse(_controllerVeiculo.text))) {
                            return "[Prefixo Inválido]";
                          }

                          return null;

                        },
                        type: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ]
                    ),
                  ))
                ],),

                Row(children: <Widget>[
                  Text("DATA INI:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  Expanded(child:

                  Padding(
                    padding: EdgeInsets.all(8),
                    child: InputCustomizado(
                        readOnly: true,
                        hint: "DD/MM/AAAA",
                        controller: _iconButtonInicio ,
                        validator: (value) {

                          if (_iconButtonInicio.text.isEmpty)
                          {return "[Campo Obrigatório]";}

                          if (_iconButtonInicio.text.length < 10)
                          {return "[Valor Inválido]";}

                          return null;

                        },
                        onSaved: (dataInicio) {
                          _getDataInicioDT = DateFormat("dd/MM/yyyy").parse(dataInicio!);
                          _viagem.dataInicio = dataInicio;
                          return null;
                        },
                        type: TextInputType.number,
                        inputFormatters:
                        [
                          FilteringTextInputFormatter.digitsOnly,
                          DataInputFormatter()
                        ]
                    ),

                  )
                  ),
                  IconButton(
                      onPressed: _showDatePickerInicio,
                      icon: Icon(Icons.date_range)
                  )
                ],),

                Row(children: <Widget>[
                  Text("DATA FIM:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  Expanded(child:

                  Padding(
                    padding: EdgeInsets.all(8),
                    child: InputCustomizado(
                        readOnly: true,
                        hint: "DD/MM/AAAA",
                        controller: _iconButtonFim,
                        validator: (value) {

                          if (_iconButtonFim.text.isEmpty)
                          {return "[Campo Obrigatório]";}

                          if (_iconButtonFim.text.length < 10)
                          {return "[Valor Inválido]";}

                          if (DateFormat("dd/MM/yyyy").parse(_iconButtonFim.text).compareTo(DateFormat("dd/MM/yyyy").parse(_iconButtonInicio.text))<0)
                          {return "[Valor Inválido]";}

                          return null;

                        },
                        onSaved: (dataFim) {
                          _getDataFimDT = DateFormat("dd/MM/yyyy").parse(dataFim!);
                          _viagem.dataFim = dataFim;
                          return null;
                        },
                        type: TextInputType.number,
                        inputFormatters:
                        [
                          FilteringTextInputFormatter.digitsOnly,
                          DataInputFormatter()
                        ]
                    ),

                  )
                  ),
                  IconButton(
                      onPressed: _showDatePickerFim,
                      icon: Icon(Icons.date_range)
                  )
                ],),

                Row(children: <Widget>[
                  Text("HORA INI:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  Expanded(child: Padding(
                    padding: EdgeInsets.all(8),
                    child: InputCustomizado(
                        controller: _controllerHoraInicio,
                        hint: "HH:MM",
                        onSaved: (horaInicio) {
                          _viagem.horaInicio = horaInicio!;
                          return null;
                        },
                        validator: (value){

                          if (_controllerHoraInicio.text.isEmpty)
                          {return "[Campo Obrigatório]";}

                          if (_controllerHoraInicio.text.length < 5)
                          {return "[Valor Inválido]";}

                          return null;

                        },
                        type: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          HoraInputFormatter()
                        ]
                    ),
                  ))
                ],),
                Row(children: <Widget>[
                  Text("HORA FIM:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  Expanded(child: Padding(
                    padding: EdgeInsets.all(8),
                    child: InputCustomizado(
                        controller: _controllerHoraFim,
                        hint: "HH:MM",
                        onSaved: (horaFim) {
                          _viagem.horaFim = horaFim!;
                          return null;
                        },
                        validator: (value){

                          if (_controllerHoraFim.text.isEmpty)
                          {return "[Campo Obrigatório]";}

                          if (_controllerHoraFim.text.length < 5)
                          {return "[Valor Inválido]";}

                          if (double.parse(_controllerHoraFim.text.replaceAll(":", ".")) <= double.parse(_controllerHoraInicio.text.replaceAll(":", ".")) && DateFormat("dd/MM/yyyy").parse(_iconButtonFim.text).compareTo(DateFormat("dd/MM/yyyy").parse(_iconButtonInicio.text))<=0)
                          {return "[Valor Inválido]";}

                          return null;

                        },
                        type: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          HoraInputFormatter()
                        ]
                    ),
                  ))
                ],),
                Row(children: <Widget>[
                  Text("KM INI:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  Expanded(child: Padding(
                    padding: EdgeInsets.all(8),
                    child: InputCustomizado(
                        controller: _controllerKmInicio,
                        hint: "KM INICIAL",
                        onSaved: (kmInicio) {
                          _viagem.kmInicio = int.parse(kmInicio!.replaceAll(".", ""));
                          return null;
                        },
                        validator: (value) {
                          return Validador()
                              .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                              .valido(value);
                        },
                        type: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          KmInputFormatter()
                        ]
                    ),
                  ))
                ],),
                Row(children: <Widget>[
                  Text("KM FIM:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  Expanded(child: Padding(
                    padding: EdgeInsets.all(8),
                    child: InputCustomizado(
                        controller: _controllerKmFim,
                        hint: "KM FINAL",
                        onSaved: (kmFim) {
                          _viagem.kmFim = int.parse(kmFim!.replaceAll(".", ""));
                          return null;
                        },
                        validator: (value) {

                          if (_controllerKmFim.text.isEmpty)
                          {return "[Campo Obrigatório]";}

                          if (int.parse(_controllerKmFim.text.replaceAll(RegExp("[^0-9]"), "")) <= int.parse(_controllerKmInicio.text.replaceAll(RegExp("[^0-9]"), "")))
                          {return "[Valor Inválido]";}

                          return null;

                        },
                        type: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          KmInputFormatter()
                        ]
                    ),
                  ))
                ],),

                Row(children: <Widget>[
                  Text("QTD PAX:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  Expanded(child: Padding(
                    padding: EdgeInsets.all(8),
                    child: InputCustomizado(
                        controller: _controllerQtdPax,
                        hint: "QTD PAX",
                        onSaved: (qtdPax) {
                          _viagem.qtdPax = int.parse(qtdPax!.replaceAll(new RegExp(r'^0+(?=.)'), ''));
                          return null;
                        },
                        validator: (value){
                          return Validador()
                              .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                              .valido(value);
                        },
                        type: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ]
                    ),
                  ))
                ],),

                Padding(
                  padding: EdgeInsets.all(8),
                  child: BotaoCustomizado(
                    corFundo: Colors.orange,
                    texto: "ENVIAR",
                    onPressed: () {
                      if ( _formKey.currentState!.validate() ) {
                        _formKey.currentState?.save();
                        _dialogContext = context;
                        _salvarViagem();
                      }
                    },
                  ),
                ),
              ],),
          ),
        ),
      ),
    );
  }
}
