import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:localonibus/models/Viagem.dart';
import 'package:localonibus/views/widgets/ListViewViagem.dart';

class ConsultaViagemCliente extends StatefulWidget {

  @override
  _ConsultaViagemClienteState createState() => _ConsultaViagemClienteState();
}

class _ConsultaViagemClienteState extends State<ConsultaViagemCliente> {

  final _controllerConsultaViagem = StreamController<QuerySnapshot>.broadcast();
  String? _clienteLogado;
  String _nViagensEncontradas = "";

  Future<Stream<QuerySnapshot>?> _adicionarListenerConsultaViagem() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    User usuarioLogado = await auth.currentUser!;
    var idUsuarioLogado = usuarioLogado.uid;

    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot<Map<String, dynamic>> snapshot = await db.collection("USUARIOS")
        .doc(idUsuarioLogado)
        .get();

    var dados = snapshot.data();

    String nomeUsuario = dados!["nome"];

    setState(() {
      _clienteLogado = nomeUsuario;
    });

    Query query = db
        .collection("VIAGENS")
        .orderBy("dataInicio", descending: true)
        .orderBy("horaInicio", descending: true);
    query = query.where("cliente", isEqualTo: _clienteLogado);

    Stream<QuerySnapshot> stream = query.snapshots();
    stream.listen((dados) {
      _controllerConsultaViagem.add(dados);
      setState(() {
        _nViagensEncontradas = dados.docs.length.toString();
      });
    });
    return null;
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
          IconButton(onPressed: (){}, icon: Icon(Icons.filter_alt)),
        ],
      ),
      body: Container(child: Column(children: <Widget>[
        Row(children: <Widget>[
          Expanded(
            child: Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text("NÚMERO DE VIAGENS: " + _nViagensEncontradas, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
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
                    child: Text("NENHUMA VIAGEM CADASTRADA!",
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
        )
      ]),),

    );
  }
}
