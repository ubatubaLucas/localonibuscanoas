import 'package:flutter/material.dart';
import 'package:localonibus/views/widgets/BotaoCustomizado.dart';

class ConsultaMotorista extends StatefulWidget {

  @override
  _ConsultaMotoristaState createState() => _ConsultaMotoristaState();
}

class _ConsultaMotoristaState extends State<ConsultaMotorista> {

  _consultarViagem() {

    Navigator.pushNamed(context, "/ConsultarViagemMotorista");

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
                "CONSULTAR",
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
        ],
      ),
    ));
  }
}
