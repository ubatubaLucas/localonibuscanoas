import 'package:flutter/material.dart';
import 'package:localonibus/views/Tab3.dart';
import 'package:localonibus/views/Tab2.dart';
import 'package:localonibus/views/Tab1.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {

  String? _nomeMotorista;

  _buscarNome() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nomeMotorista = prefs.getString('nomeUser')!;
    });
  }

  late TabController _tabController;

  @override
  void initState() {
    _buscarNome();
    _tabController = TabController(
        length: 3,
        vsync: this,
        initialIndex: 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("OLÁ, $_nomeMotorista!"),
        bottom: TabBar(
          indicatorColor: Colors.white.withOpacity(0.5),
          controller: _tabController,
          tabs: <Widget>[
            Tab(
              text: "REGISTRAR",
              icon: Icon(Icons.add),
            ),
            Tab(
              text: "CONSULTAR",
              icon: Icon(Icons.search),
            ),
            Tab(
              text: "CONTA",
              icon: Icon(Icons.account_circle),
            ),
          ],
        ),

        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body:
        TabBarView(
          controller: _tabController,
          children: <Widget>[
            Menu(),
            Contatos(),
            Conta()
          ]
      ),
    );
  }
}
