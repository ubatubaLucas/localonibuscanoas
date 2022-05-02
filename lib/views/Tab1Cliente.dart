import 'package:flutter/material.dart';
import 'package:localonibus/views/widgets/BotaoCustomizado.dart';

class MenuCliente extends StatefulWidget {

  @override
  _MenuClienteState createState() => _MenuClienteState();
}

class _MenuClienteState extends State<MenuCliente> {

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
