import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localonibus/models/Ocorrencia.dart';
import 'package:localonibus/views/widgets/BotaoCustomizado.dart';
import 'package:localonibus/views/widgets/InputCustomizado.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:validadores/validadores.dart';
import 'package:validadores/Validador.dart';
import 'package:intl/intl.dart';

class RegistrarOcorrencia extends StatefulWidget {

  @override
  _RegistrarOcorrenciaState createState() => _RegistrarOcorrenciaState();
}

class _RegistrarOcorrenciaState extends State<RegistrarOcorrencia> {

  List<String> categoria = ["ACIDENTE", "ATRASO", "COMPORTAMENTAL", "DOCUMENTACAO", "MEIO AMBIENTE", "RECLAMACAO", "SOCORRO"];

  List<String> tipo = [];
  List<String> tipoAcidente = ["QUASE ACIDENTE", "APENAS DANO MATERIAL", "DANO PESSOAL SEM AFASTAMENTO", "DANO PESSOAL COM AFASTAMENTO", "ACIDENTE FATAL"];
  List<String> tipoAtraso = ["CHEGADA CLIENTE", "LIGACAO PLANTAO"];
  List<String> tipoComportamental = ["MANUTENCAO VEICULO", "LIMPEZA VEICULO", "INFRACAO TRANSITO"];
  List<String> tipoDocumentacao = ["FALTANDO", "VENCIDA"];
  List<String> tipoMeioAmbiente = ["CONTAMINACAO AGUA", "CONTAMINACAO AR", "CONTAMINACAO SOLO"];
  List<String> tipoReclamacao = ["CLIENTE", "TERCEIRO"];
  List<String> tipoSocorro = ["BORRACHARIA", "ELETRICA", "MECANICA"];

  List<int> veiculos = [200,201,202,203,204,205,206,207,208,209,210,211,500,501,502,503,504,505,506,507,508,509,510,511,1000,1001,1002,1003,1004,1005,1006,1007,1008,1009,1010,1011,1012,1013,1014,1015,1016,1017,1018,1100,1200,1300,1400,1500,1600,1700,1800,1900,2000,2100,2240,2244,2245,2246,2247,2249,2250,2251,2252,2253,2254,2255,2256,2257,2258,2259,2260,2261,2262,2263,2264,2265,2266,2267,2268,2269,2270,2271,2272,2273,2600,2900,3000,3100,3200,3300,3400,3500,3600,3700,3800,3900,4000,4100,4200,4300,4400,4500,4600,4700,4800,4900,7200,7300,7400,7500,7600,7700,7800,8700,8800,8900,9000,9100,9200,9300,9400,9500,9600,9700,9800,9900];
  List<String> motoristas = [];

  List<String> gravidadeList = ["1 - ALTA", "2 - MEDIA", "3 - BAIXA"];
  List<String> probabilidadeList = ["1 - MUITO PROVAVEL", "2 - PROVAVEL", "3 - POUCO PROVAVEL"];

  String? selectedCategoria;
  String? selectedTipo;
  String? selectedGravidade;
  String? selectedProbabilidade;

  final _formKey = GlobalKey<FormState>();
  late Ocorrencia _ocorrencia;
  late BuildContext _dialogContext;
  late DateTime _getDataInicioDT;

  TextEditingController _iconButtonInicio = TextEditingController();
  TextEditingController _iconButtonFim = TextEditingController();
  TextEditingController _controllerMotorista = TextEditingController(text: "");
  TextEditingController _controllerVeiculo = TextEditingController(text: "");
  TextEditingController _controllerDescricao = TextEditingController(text: "");

  _getListaMotoristas() async {

    FirebaseFirestore db = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await db
        .collection("USUARIOS")
        .get();

    final listaMotorista = querySnapshot.docs.map((doc) => doc["email"]).toSet().toList();

    setState(() {
      motoristas = List.from(listaMotorista);
    });

  }

  String? _tipoUser;

  _buscarNome() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _tipoUser = prefs.getString('tipoUser')!;
    });
  }

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

  String _nomeMotoristaConsulta = "KKK";

  _salvarOcorrencia() async {
    _abrirDialog(_dialogContext);

    FirebaseAuth auth = FirebaseAuth.instance;

    User? usuarioLogado = await auth.currentUser;
    if (usuarioLogado != null) {

      FirebaseFirestore db = FirebaseFirestore.instance;

      _ocorrencia.regTime = Timestamp.fromDate(DateTime.now());

      _ocorrencia.dataInicioDT = Timestamp.fromDate(_getDataInicioDT);
      _ocorrencia.dataInicioDTORDERBY = _ocorrencia.dataInicioDT;

      //FUNCAO PARA PEGAR NOME BASEADO NO CODIGO DO MOTORISTA

      QuerySnapshot querySnapshot = await db
          .collection("USUARIOS")
          .where("email", isEqualTo: _controllerMotorista.text + "@localonibus.com.br")
          .get();

      for (DocumentSnapshot item in querySnapshot.docs) {
        var dados = item.data() as dynamic;
        String nomeMotorista = dados["nome"];

        setState(() {
          _nomeMotoristaConsulta = nomeMotorista;
        });
      }

      _ocorrencia.motorista = _controllerMotorista.text + " - " + _nomeMotoristaConsulta;

      db.collection("OCORRENCIAS")
          .doc( _ocorrencia.id )
          .set(_ocorrencia.toMap()).then((_) {
        Navigator.pop(_dialogContext);

        switch (_tipoUser) {
          case "MOTORISTA" :
            Navigator.pushNamedAndRemoveUntil(
                context, "/HomeMotorista", (route) => false);
            break;
          case "PREPOSTO" :
            Navigator.pushNamedAndRemoveUntil(
                context, "/HomePreposto", (route) => false);
            break;
          case "GERENTE" :
            Navigator.pushNamedAndRemoveUntil(context, "/Home", (route) => false);
            break;
          case "CLIENTE" :
            Navigator.pushNamedAndRemoveUntil(
                context, "/HomeCliente", (route) => false);
            break;
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _ocorrencia = Ocorrencia.usuarioLogado();
    _getListaMotoristas();
    _buscarNome();
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
        _ocorrencia.dataInicio = DateFormat("dd/MM/yyyy").format(pickedDateInicio);
        _iconButtonInicio.text = _ocorrencia.dataInicio;
        _iconButtonFim.text = _ocorrencia.dataInicio;
        _getDataInicioDT = pickedDateInicio;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("REGISTRAR OCORRÊNCIA"),
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
                  Text("DATA:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
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
                          _ocorrencia.dataInicio = dataInicio;
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
                  Text("CATEGORIA:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: DropdownButtonFormField<String>(
                        value: selectedCategoria,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20
                        ),
                        hint: Text("SELECIONAR"),
                        items: categoria.map((String value) {
                          return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value)
                          );
                        }).toList(),
                        onSaved: (categoria) {
                          _ocorrencia.categoria = categoria!;
                        },
                        validator: (value) {
                          return Validador()
                              .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                              .valido(value);
                        },
                        onChanged: (categoria) {

                          if (categoria == "ACIDENTE") {
                            tipo = tipoAcidente;}
                          else if (categoria == "ATRASO") {
                            tipo = tipoAtraso; }
                          else if (categoria == "COMPORTAMENTAL") {
                            tipo = tipoComportamental; }
                          else if (categoria == "DOCUMENTACAO") {
                            tipo = tipoDocumentacao; }
                          else if (categoria == "MEIO AMBIENTE") {
                            tipo = tipoMeioAmbiente; }
                          else if (categoria == "RECLAMACAO") {
                            tipo = tipoReclamacao; }
                          else if (categoria == "SOCORRO") {
                            tipo = tipoSocorro; }
                          else {tipo = [];}

                          setState(() {
                            selectedCategoria = categoria;
                            selectedTipo = null;
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
                        value: selectedTipo,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20
                        ),
                        hint: Text("SELECIONAR"),
                        items: tipo.map((String value) {
                          return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value)
                          );
                        }).toList(),
                        onSaved: (tipo) {
                          _ocorrencia.tipo = tipo!;
                          _ocorrencia.tipoORDERBY = _ocorrencia.tipo;
                        },
                        validator: (value) {
                          return Validador()
                              .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                              .valido(value);
                        },
                        onChanged: (tipo) {

                          setState(() {
                            selectedTipo = tipo;
                          });
                        },
                      ),
                    ),
                  ),
                ],),
                Row(children: <Widget>[
                  Text("GRAVIDADE:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: DropdownButtonFormField<String>(
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
                        onSaved: (g) {
                          _ocorrencia.gravidade = g!;
                        },
                        validator: (value) {
                          return Validador()
                              .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                              .valido(value);
                        },
                        onChanged: (g) {
                          setState(() {
                            selectedGravidade = g;
                          });
                        },
                      ),
                    ),
                  ),
                ],),
                Row(children: <Widget>[
                  Text("PROBABILIDADE:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: DropdownButtonFormField<String>(
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
                        onSaved: (p) {
                          _ocorrencia.probabilidade = p!;
                        },
                        validator: (value) {
                          return Validador()
                              .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                              .valido(value);
                        },
                        onChanged: (p) {
                          setState(() {
                            selectedProbabilidade = p;
                          });
                        },
                      ),
                    ),
                  ),
                ],),
                Row(children: <Widget>[
                  Text("MOTORISTA:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  Expanded(child: Padding(
                    padding: EdgeInsets.all(8),
                    child: InputCustomizado(
                        controller: _controllerMotorista,
                        hint: "CÓDIGO",
                        onSaved: (motorista) {
                          _ocorrencia.motorista = motorista!;
                          return null;
                        },
                        validator: (value){

                          if(_controllerMotorista.text.isEmpty) {
                            return "[Campo Obrigatório]";
                          }

                          if(!motoristas.contains(_controllerMotorista.text + "@localonibus.com.br")) {
                            return "[Código Inválido]";
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
                  Text("VEÍCULO:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  Expanded(child: Padding(
                    padding: EdgeInsets.all(8),
                    child: InputCustomizado(
                        controller: _controllerVeiculo,
                        hint: "PREFIXO",
                        onSaved: (veiculo) {
                          _ocorrencia.veiculo = veiculo!;
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
                  Text("DESCRIÇÃO:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  Expanded(child: Padding(
                    padding: EdgeInsets.all(8),
                    child: InputCustomizado(
                        controller: _controllerDescricao,
                        hint: "DESCRIÇÃO",
                        onSaved: (descricao) {
                          _ocorrencia.descricao = descricao!;
                          return null;
                        },
                      maxLines: null,
                        inputFormatters: [
                          UpperCaseTextFormatter()
                        ],
                        validator: (value){
                          return Validador()
                              .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                              .valido(value);
                        },
                        type: TextInputType.text,
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
                        _salvarOcorrencia();
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
