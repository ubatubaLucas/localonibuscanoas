import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localonibus/models/Viagem.dart';
import 'package:localonibus/views/widgets/ListViewViagem.dart';
import 'package:intl/intl.dart';

class ConsultaVeiculo extends StatefulWidget {

  @override
  _ConsultaVeiculoState createState() => _ConsultaVeiculoState();
}

class _ConsultaVeiculoState extends State<ConsultaVeiculo> {

  final _controllerConsultaViagem = StreamController<QuerySnapshot>.broadcast();
  String _nViagensEncontradas = "FILTRE O VEÍCULO...";
  String _nViagensGetNumero = "";

  List<int> veiculos = [200,201,202,203,204,205,206,207,208,209,210,211,500,501,502,503,504,505,506,507,508,509,510,511,1000,1001,1002,1003,1004,1005,1006,1007,1008,1009,1010,1011,1012,1013,1014,1015,1016,1017,1018,1100,1200,1300,1400,1500,1600,1700,1800,1900,2000,2100,2240,2244,2245,2246,2247,2249,2250,2251,2252,2253,2254,2255,2256,2257,2258,2259,2260,2261,2262,2263,2264,2265,2266,2267,2268,2269,2270,2271,2272,2273,2600,2900,3000,3100,3200,3300,3400,3500,3600,3700,3800,3900,4000,4100,4200,4300,4400,4500,4600,4700,4800,4900,7200,7300,7400,7500,7600,7700,7800,8700,8800,8900,9000,9100,9200,9300,9400,9500,9600,9700,9800,9900];

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
        .limit(10)
    ;

    if (selectedDataInicio != null) {
      query = query.where("dataInicioDT", isEqualTo: Timestamp.fromDate(DateFormat("dd/MM/yyyy").parse(_controllerDataInicio.text)));
    }

    if (selectedVeiculo != null) {
      query = query.where("veiculo", isEqualTo: selectedVeiculo);
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("CONSULTAR VEÍCULO"),
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
                                          selectedDataInicio = null;
                                          selectedVeiculo = null;
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
                                          selectedVeiculo = null;
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
