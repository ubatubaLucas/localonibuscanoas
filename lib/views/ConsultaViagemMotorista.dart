import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:localonibus/models/Viagem.dart';
import 'package:localonibus/views/widgets/ListViewViagemMotorista.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConsultaViagemMotorista extends StatefulWidget {

  @override
  _ConsultaViagemMotoristaState createState() => _ConsultaViagemMotoristaState();
}

class _ConsultaViagemMotoristaState extends State<ConsultaViagemMotorista> {

  final _controllerConsultaViagem = StreamController<QuerySnapshot>.broadcast();

  String? _nomeUser;
  String? _matriculaUser;
  String? _matriculaNome;

  _buscarNome() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nomeUser = prefs.getString('nomeUser')!;
      _matriculaUser = prefs.getString('matriculaUser')!;
      _matriculaNome = _matriculaUser! + " - " + _nomeUser!;
    });
  }

  Future<Stream<QuerySnapshot>?> _adicionarListenerConsultaViagem() async {

    FirebaseFirestore db = await FirebaseFirestore.instance;

    Query query = db
        .collection("20220303")
        .orderBy("dataInicioDTORDERBY", descending: true)
        .orderBy("horaInicio", descending: true)
        .limit(6);

    query = query.where("motorista", isEqualTo: _matriculaNome);

    Stream<QuerySnapshot> stream = query.snapshots();
    stream.listen((dados) {
      _controllerConsultaViagem.add(dados);

    });
    return null;

  }

  @override
  void initState() {
    super.initState();
    _buscarNome();
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
          IconButton(onPressed: (){}, icon: Icon(Icons.filter_alt)),
        ],
      ),
      body: Container(child: Column(children: <Widget>[
        Row(children: <Widget>[
          Expanded(
            child: Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text("ÚLTIMAS VIAGENS...", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
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

                          return ListViewViagemMotorista(
                            viagem: viagem,
                          );

                        }
                    )
                );

            }
          },
        )
      ]),),

    );
  }
}
