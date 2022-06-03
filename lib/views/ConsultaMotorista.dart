import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localonibus/models/Viagem.dart';
import 'package:localonibus/views/widgets/ListViewViagem.dart';
import 'package:intl/intl.dart';

class ConsultaMotorista extends StatefulWidget {

  @override
  _ConsultaMotoristaState createState() => _ConsultaMotoristaState();
}

class _ConsultaMotoristaState extends State<ConsultaMotorista> {

  final _controllerConsultaViagem = StreamController<QuerySnapshot>.broadcast();
  String _nViagensEncontradas = "FILTRE O MOTORISTA...";
  String _nViagensGetNumero = "";

  String? selectedDataInicio;
  String? selectedMotorista;
  TextEditingController _controllerDataInicio = TextEditingController();
  TextEditingController _controllerMotorista = TextEditingController();

  List<String> motoristas = [];

  Future<Stream<QuerySnapshot>?> _filtrarViagens() async {

    FirebaseFirestore db = FirebaseFirestore.instance;
    Query query = await db
        .collection("VIAGENS")
        .orderBy("dataInicioDTORDERBY", descending: true)
        .orderBy("turnoORDERBY", descending: false)
        .orderBy("rotaORDERBY", descending: false)
        .orderBy("horaInicio", descending: false)
        .limit(10)
    ;

    if (selectedDataInicio != null) {
      query = query.where("dataInicioDT", isEqualTo: Timestamp.fromDate(DateFormat("dd/MM/yyyy").parse(_controllerDataInicio.text)));
    }

    if (selectedMotorista != null) {
      query = query
          .where("motorista", isEqualTo: selectedMotorista);
    }

    Stream<QuerySnapshot> stream = query.snapshots();
    stream.listen((dados) {
      _controllerConsultaViagem.add(dados);

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

  @override
  void initState() {
    super.initState();
    _getListaMotoristas();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("CONSULTAR MOTORISTA"),
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
                                        },
                                        icon: Icon(Icons.date_range)
                                    ),
                                  ],),
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
                                          selectedDataInicio = null;
                                          selectedMotorista = null;
                                          _controllerMotorista.text = "";
                                          _controllerDataInicio.text = "";
                                          _nViagensGetNumero = "";
                                        });
                                      },
                                      child: Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10), child: Text("LIMPAR", style: TextStyle(fontSize: 20),),)),
                                  Padding(padding: EdgeInsets.only(bottom: 20)),
                                  ElevatedButton(
                                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.orange)),
                                      onPressed: (){
                                        setState(() {
                                          selectedDataInicio = null;
                                          selectedMotorista = null;
                                          _controllerMotorista.text = "";
                                          _controllerDataInicio.text = "";
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
                return Center();
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
