import 'package:flutter/material.dart';
import 'package:localonibus/views/widgets/BotaoCustomizado.dart';

class MenuMotorista extends StatefulWidget {

  @override
  _MenuMotoristaState createState() => _MenuMotoristaState();
}

class _MenuMotoristaState extends State<MenuMotorista> {

  _digitarViagem() {

    Navigator.pushNamed(context, "/RegistrarViagemMotorista");

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


        ],
      ),
    ));
  }
}
