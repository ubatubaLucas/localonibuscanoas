import 'package:flutter/material.dart';
import 'package:localonibus/views/widgets/BotaoCustomizado.dart';

class ConsultaPreposto extends StatefulWidget {

  @override
  _ConsultaPrepostoState createState() => _ConsultaPrepostoState();
}

class _ConsultaPrepostoState extends State<ConsultaPreposto> {

  _consultarViagem() {

    Navigator.pushNamed(context, "/ConsultarViagem");

  }

  _consultarOcupacao() {

    Navigator.pushNamed(context, "/ConsultarOcupacao");

  }

  _consultarVeiculo() {

    Navigator.pushNamed(context, "/ConsultarVeiculo");

  }

  _consultarMotorista() {

    Navigator.pushNamed(context, "/ConsultarMotorista");

  }

  _relatorioViagens() {

    Navigator.pushNamed(context, "/RelatorioViagens");

  }

  _consultarOcorrencia() {

    Navigator.pushNamed(context, "/ConsultarOcorrencia");

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
                    corFundo: Colors.orange,
                    texto: "OCUPAÇÃO",
                    onPressed: () {
                      _consultarOcupacao();
                    }
                )
            ),
            SizedBox(height: 20,),
            SizedBox(
                width: 250,
                child: BotaoCustomizado(
                    corFundo: Colors.grey,
                    texto: "RELATÓRIO",
                    onPressed: () {
                      _relatorioViagens();
                    }
                )
            ),
            SizedBox(height: 40,),
            SizedBox(
                width: 250,
                child: Text(
                  "OPERACIONAL",
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
                    texto: "MOTORISTA",
                    onPressed: () {
                      _consultarMotorista();
                    }
                )
            ),
            SizedBox(height: 20,),
            SizedBox(
                width: 250,
                child: BotaoCustomizado(
                    corFundo: Colors.orange,
                    texto: "VEÍCULO",
                    onPressed: () {
                      _consultarVeiculo();
                    }
                )
            ),
            SizedBox(height: 20,),
            SizedBox(
                width: 250,
                child: BotaoCustomizado(
                    corFundo: Colors.orange,
                    texto: "OCORRÊNCIA",
                    onPressed: () {
                      _consultarOcorrencia();
                    }
                )
            ),
            SizedBox(height: 20,),
          ],
        ),
        ));
  }
}
