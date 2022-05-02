import 'package:flutter/material.dart';
import 'package:localonibus/views/widgets/BotaoCustomizado.dart';

class MenuPreposto extends StatefulWidget {

  @override
  _MenuPrepostoState createState() => _MenuPrepostoState();
}

class _MenuPrepostoState extends State<MenuPreposto> {

  _digitarViagem() {

    Navigator.pushNamed(context, "/DigitarViagem");

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
                  "REGISTRAR",
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
                      _digitarViagem();
                    }
                )
            ),
            SizedBox(height: 20,),
            SizedBox(
                width: 250,
                child: BotaoCustomizado(
                    texto: "ABASTECIMENTO",
                    onPressed: () {}
                )
            ),
            SizedBox(height: 20,),
            SizedBox(
                width: 250,
                child: BotaoCustomizado(
                    texto: "SOCORRO",
                    onPressed: () {}
                )
            ),
            SizedBox(height: 20,),
            SizedBox(
                width: 250,
                child: BotaoCustomizado(
                    texto: "OCORRÊNCIA",
                    onPressed: () {
                      //_registrarOcorrencia();
                    }
                )
            ),
            SizedBox(height: 20,),
            SizedBox(
                width: 250,
                child: BotaoCustomizado(
                    texto: "ATRASO",
                    onPressed: () {}
                )
            ),

          ],
        ),
        ));
  }
}
