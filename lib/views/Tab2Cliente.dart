import 'package:flutter/material.dart';
import 'package:localonibus/views/widgets/BotaoCustomizado.dart';

class ConsultaCliente extends StatefulWidget {

  @override
  _ConsultaClienteState createState() => _ConsultaClienteState();
}

class _ConsultaClienteState extends State<ConsultaCliente> {

  _consultarViagem() {

    Navigator.pushNamed(context, "/ConsultarViagemCliente");

  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: SingleChildScrollView(child:
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 40,),
            SizedBox(
                width: 250,
                child: Text(
                  "LOGÍSTICA",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                )
            ),
            SizedBox(height: 20,),
            SizedBox(
                width: 250,
                child: BotaoCustomizado(
                    corFundo: Colors.orange,
                    texto: "VIAGEM",
                    onPressed: () {
                      _consultarViagem();
                    }
                )
            ),
            SizedBox(height: 20,),
            SizedBox(
                width: 250,
                child: BotaoCustomizado(
                    texto: "OCUPAÇÃO",
                    onPressed: () {}
                )
            ),
          ],
        ),
        ));
  }
}
