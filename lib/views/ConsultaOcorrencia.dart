import 'dart:async';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:localonibus/models/Ocorrencia.dart';
import 'package:flutter/material.dart';
import 'package:localonibus/views/widgets/ListViewOcorrencia.dart';

class ConsultaOcorrencia extends StatefulWidget {

  @override
  _ConsultaOcorrenciaState createState() => _ConsultaOcorrenciaState();
}

class _ConsultaOcorrenciaState extends State<ConsultaOcorrencia> {

  late StreamSubscription _subscription;

  final _controllerConsultaOcorrencia = StreamController<QuerySnapshot>.broadcast();
  String _nViagensEncontradas = "ÚLTIMAS OCORRÊNCIAS REGISTRADAS...";
  String _nViagensGetNumero = "";
  //String _nVia = "";

  List<String> categoria = ["ACIDENTE", "ATRASO", "COMPORTAMENTAL", "DOCUMENTACAO", "MEIO AMBIENTE", "RECLAMACAO", "SOCORRO"];
  List<String> tipo = [];
  List<String> tipoAcidente = ["QUASE ACIDENTE", "APENAS DANO MATERIAL", "DANO PESSOAL SEM AFASTAMENTO", "DANO PESSOAL COM AFASTAMENTO", "ACIDENTE FATAL"];
  List<String> tipoAtraso = ["CHEGADA CLIENTE", "LIGACAO PLANTAO"];
  List<String> tipoComportamental = ["MANUTENCAO VEICULO", "LIMPEZA VEICULO", "INFRACAO TRANSITO"];
  List<String> tipoDocumentacao = ["FALTANDO", "VENCIDA"];
  List<String> tipoMeioAmbiente = ["CONTAMINACAO AGUA", "CONTAMINACAO AR", "CONTAMINACAO SOLO"];
  List<String> tipoReclamacao = ["CLIENTE", "TERCEIRO"];
  List<String> tipoSocorro = ["BORRACHARIA", "ELETRICA", "MECANICA"];

  List<String> motoristas = [];
  List<int> veiculos = [200,201,202,203,204,205,206,207,208,209,210,211,500,501,502,503,504,505,506,507,508,509,510,511,1000,1001,1002,1003,1004,1005,1006,1007,1008,1009,1010,1011,1012,1013,1014,1015,1016,1017,1018,1100,1200,1300,1400,1500,1600,1700,1800,1900,2000,2100,2240,2244,2245,2246,2247,2249,2250,2251,2252,2253,2254,2255,2256,2257,2258,2259,2260,2261,2262,2263,2264,2265,2266,2267,2268,2269,2270,2271,2272,2273,2600,2900,3000,3100,3200,3300,3400,3500,3600,3700,3800,3900,4000,4100,4200,4300,4400,4500,4600,4700,4800,4900,7200,7300,7400,7500,7600,7700,7800,8700,8800,8900,9000,9100,9200,9300,9400,9500,9600,9700,9800,9900];

  List<String> gravidadeList = ["1 - ALTA", "2 - MEDIA", "3 - BAIXA"];
  List<String> probabilidadeList = ["1 - MUITO PROVAVEL", "2 - PROVAVEL", "3 - POUCO PROVAVEL"];

  String? selectedCategoria;
  String? selectedTipo;
  String? selectedMotorista;
  String? selectedVeiculo;
  String? selectedDataInicio;
  String? selectedGravidade;
  String? selectedProbabilidade;
  TextEditingController _controllerDataInicio = TextEditingController();

  Future<Stream<QuerySnapshot>?> _filtrarViagens() async {

    FirebaseFirestore db = FirebaseFirestore.instance;
    Query query = await db
        .collection("OCORRENCIAS")
        .orderBy("dataInicioDTORDERBY", descending: true)
        .limit(100)
    ;

    if (selectedCategoria != null) {
      query = query.where("categoria", isEqualTo: selectedCategoria);
    }

    if (selectedTipo != null) {
      query = query.where("tipo", isEqualTo: selectedTipo);
    }

    if (selectedGravidade != null) {
      query = query.where("gravidade", isEqualTo: selectedGravidade);
    }

    if (selectedProbabilidade != null) {
      query = query.where("probabilidade", isEqualTo: selectedProbabilidade);
    }

    if (selectedDataInicio != null) {
      query = query.where("dataInicioDT", isEqualTo: Timestamp.fromDate(DateFormat("dd/MM/yyyy").parse(_controllerDataInicio.text)));
    }

    if (selectedMotorista != null) {
      query = query.where("motorista", isEqualTo: selectedMotorista);
    }

    if (selectedVeiculo != null) {
      query = query.where("veiculo", isEqualTo: selectedVeiculo);
    }

    Stream<QuerySnapshot> stream = query.snapshots();
    _subscription = stream.listen((dados) {
      _controllerConsultaOcorrencia.add(dados);
      _subscription.cancel();

      if (!mounted) return;
      setState(() {
        _nViagensEncontradas = "NÚMERO DE OCORRÊNCIAS: " + dados.docs.length.toString();
      });

    });
    return null;

  }

  Future<Stream<QuerySnapshot>?> _adicionarListenerConsultaOcorrencia() async {

    FirebaseFirestore db = await FirebaseFirestore.instance;
    Stream<QuerySnapshot> stream = db
        .collection("OCORRENCIAS")
        .orderBy("regTime", descending: true)
        .limit(10)
        .snapshots();

    _subscription = stream.listen((dados) {
      _controllerConsultaOcorrencia.add(dados);
      _subscription.cancel();

      if (!mounted) return;
      setState(() {
        _nViagensEncontradas = "ÚLTIMOS REGISTROS...";
      });

    });
    return null;

  }

  _getListaMotoristas() async {

    FirebaseFirestore db = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await db
        .collection("USUARIOS")
        .orderBy("nome")
        .get();

    for (DocumentSnapshot item in querySnapshot.docs) {
      var dados = item.data() as dynamic;
      String nomeUser = dados["nome"];
      String emailUser = dados["email"];
      String matUser = emailUser.substring(0, emailUser.indexOf("@"));
      motoristas.add(matUser + " - " + nomeUser);
    }

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

  _removerOcorrencia(String viagemId){

    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("OCORRENCIAS")
        .doc( viagemId )
        .delete();
  }

  @override
  void initState() {
    super.initState();
    _adicionarListenerConsultaOcorrencia();
    _getListaMotoristas();
  }

  @override
  Widget build(BuildContext context) {

    var carregandoOcorrencias = Center(
      child: Column(children: <Widget>[

        Text("CARREGANDO OCORRÊNCIAS..."),
        CircularProgressIndicator()

      ],),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("CONSULTAR OCORRÊNCIA"),
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
                                            //clientes = clientesPosData;
                                          });

                                        },
                                        icon: Icon(Icons.date_range)
                                    ),
                                  ],),
                                  Padding(padding: EdgeInsets.only(bottom: 20)),
                                  Text("CATEGORIA:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                  DropdownButtonFormField<String>(
                                    value: selectedCategoria,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20
                                    ),
                                    hint: Text("SELECIONAR"),
                                    items: categoria.map((String value) {
                                      return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value.toUpperCase())
                                      );
                                    }).toList(),
                                    onChanged: (categoria) {

                                      if (categoria == "ACIDENTE") {
                                        tipo = tipoAcidente;
                                      }
                                      else if (categoria == "ATRASO") {
                                        tipo = tipoAtraso;
                                      }
                                      else if (categoria == "COMPORTAMENTAL") {
                                        tipo = tipoComportamental;
                                      }
                                      else if (categoria == "DOCUMENTACAO") {
                                        tipo = tipoDocumentacao;
                                      }
                                      else if (categoria == "MEIO AMBIENTE") {
                                        tipo = tipoMeioAmbiente;
                                      }
                                      else if (categoria == "RECLAMACAO") {
                                        tipo = tipoReclamacao;
                                      }
                                      else if (categoria == "SOCORRO") {
                                        tipo = tipoSocorro;
                                      }
                                      else {tipo = [];}

                                      setState(() {
                                        selectedCategoria = categoria;
                                        selectedTipo = null;
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
                                    items: tipo.map((String value) {
                                      return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value.toUpperCase())
                                      );
                                    }).toList(),
                                    onChanged: (turno) {

                                      setState(() {
                                        selectedTipo = turno;
                                        _filtrarViagens();
                                        //_getNumero();
                                      });

                                    },
                                  ),

                                  Padding(padding: EdgeInsets.only(bottom: 20)),
                                  Text("GRAVIDADE:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                  DropdownButtonFormField<String>(
                                    value: selectedGravidade,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20
                                    ),
                                    hint: Text("SELECIONAR"),
                                    items: gravidadeList.map((String value) {
                                      return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value.toUpperCase())
                                      );
                                    }).toList(),
                                    onChanged: (g) {

                                      setState(() {
                                        selectedGravidade = g;
                                        _filtrarViagens();
                                        //_getNumero();
                                      });

                                    },
                                  ),
                                  Padding(padding: EdgeInsets.only(bottom: 20)),
                                  Text("PROBABILIDADE:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                  DropdownButtonFormField<String>(
                                    value: selectedProbabilidade,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20
                                    ),
                                    hint: Text("SELECIONAR"),
                                    items: probabilidadeList.map((String value) {
                                      return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value.toUpperCase())
                                      );
                                    }).toList(),
                                    onChanged: (p) {

                                      setState(() {
                                        selectedProbabilidade = p;
                                        _filtrarViagens();
                                        //_getNumero();
                                      });

                                    },
                                  ),

                                  Padding(padding: EdgeInsets.only(bottom: 20)),
                                  Text("MOTORISTA:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                  DropdownButtonFormField<String>(
                                    value: selectedMotorista,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20
                                    ),
                                    hint: Text("SELECIONAR"),
                                    items: motoristas.map((String value) {
                                      return DropdownMenuItem<String>(
                                          value: value.toString(),
                                          child: Text(value.toString().toUpperCase())
                                      );
                                    }).toList(),
                                    onChanged: (motorista) {
                                      setState(() {
                                        selectedMotorista = motorista;
                                        _filtrarViagens();
                                      });
                                    },
                                  ),

                                  Padding(padding: EdgeInsets.only(bottom: 20)),
                                  Text("VEÍCULO:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                                  DropdownButtonFormField<String>(
                                    value: selectedVeiculo,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20
                                    ),
                                    hint: Text("SELECIONAR"),
                                    items: veiculos.map((int value) {
                                      return DropdownMenuItem<String>(
                                          value: value.toString(),
                                          child: Text(value.toString().toUpperCase())
                                      );
                                    }).toList(),
                                    onChanged: (veiculo) {
                                      setState(() {
                                        selectedVeiculo = veiculo;
                                        _filtrarViagens();
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
                                          selectedCategoria = null;
                                          selectedTipo = null;
                                          selectedDataInicio = null;
                                          selectedMotorista = null;
                                          selectedVeiculo = null;
                                          selectedGravidade = null;
                                          selectedProbabilidade = null;
                                          _controllerDataInicio.text = "";
                                          tipo = [];
                                          _adicionarListenerConsultaOcorrencia();
                                          _nViagensGetNumero = "";
                                        });
                                      },
                                      child: Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10), child: Text("LIMPAR", style: TextStyle(fontSize: 20),),)),
                                  Padding(padding: EdgeInsets.only(bottom: 20)),
                                  ElevatedButton(
                                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.orange)),
                                      onPressed: (){
                                        setState(() {
                                          selectedCategoria = null;
                                          selectedTipo = null;
                                          selectedDataInicio = null;
                                          selectedMotorista = null;
                                          selectedVeiculo = null;
                                          selectedGravidade = null;
                                          selectedProbabilidade = null;
                                          _controllerDataInicio.text = "";
                                          tipo = [];
                                          _adicionarListenerConsultaOcorrencia();
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
          stream: _controllerConsultaOcorrencia.stream,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return carregandoOcorrencias;
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

                            List<DocumentSnapshot> ocorrencias = querySnapshot.docs.toList();
                            DocumentSnapshot documentSnapshot = ocorrencias[indice];
                            Ocorrencia ocorrencia = Ocorrencia.fromDocumentSnapshot(documentSnapshot);

                            return ListViewOcorrencia(
                              ocorrencia: ocorrencia,
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
                                                          Text(ocorrencia.dataInicio, style: TextStyle(fontSize: 18),),
                                                        ],),
                                                        Row(children: <Widget>[
                                                          Text("CATEGORIA: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                                          Text(ocorrencia.categoria.toUpperCase(), style: TextStyle(fontSize: 18),),
                                                        ],),
                                                        Row(children: <Widget>[
                                                          Text("TIPO: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                                          Text(ocorrencia.tipo.toUpperCase(), style: TextStyle(fontSize: 18),),
                                                        ],),
                                                        Row(children: <Widget>[
                                                          Text("MOTORISTA: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                                          Text(ocorrencia.motorista.toUpperCase(), style: TextStyle(fontSize: 18),),
                                                        ],),
                                                        Row(children: <Widget>[
                                                          Text("VEÍCULO: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                                          Text(ocorrencia.veiculo, style: TextStyle(fontSize: 18),),
                                                        ],),
                                                        Row(children: <Widget>[
                                                          Text("GRAVIDADE: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                                          Text(ocorrencia.gravidade, style: TextStyle(fontSize: 18),),
                                                        ],),
                                                        Row(children: <Widget>[
                                                          Text("PROBABILIDADE: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                                                          Text(ocorrencia.probabilidade, style: TextStyle(fontSize: 18),),
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
                                                      _removerOcorrencia( ocorrencia.id );
                                                      (selectedCategoria != null) ? _filtrarViagens() : _adicionarListenerConsultaOcorrencia();
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
