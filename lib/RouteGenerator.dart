import 'package:flutter/material.dart';
import 'package:localonibus/views/AtualizarSenha.dart';
import 'package:localonibus/views/CadastrarUsuario.dart';
import 'package:localonibus/views/ConsultaMotorista.dart';
import 'package:localonibus/views/ConsultaOcorrencia.dart';
import 'package:localonibus/views/ConsultaVeiculo.dart';
import 'package:localonibus/views/ConsultaViagem.dart';
import 'package:localonibus/views/ConsultaViagemCliente.dart';
import 'package:localonibus/views/ConsultaViagemMotorista.dart';
import 'package:localonibus/views/HomeCliente.dart';
import 'package:localonibus/views/HomePreposto.dart';
import 'package:localonibus/views/OcupacaoConsulta.dart';
import 'package:localonibus/views/RegistrarOcorrencia.dart';
import 'package:localonibus/views/RegistrarViagem.dart';
import 'package:localonibus/views/Login.dart';
import 'package:localonibus/views/Home.dart';
import 'package:localonibus/views/HomeMotorista.dart';
import 'package:localonibus/views/RegistrarViagemMotorista.dart';
import 'package:localonibus/views/RelatorioViagens.dart';

class RouteGenerator {

  static Route<dynamic>? generateRoute(RouteSettings settings) {

    //final args = settings.arguments;

    switch(settings.name){
      case "/" :
        return MaterialPageRoute(
            builder: (_) => Login()
        );
      case "/Login" :
        return MaterialPageRoute(
            builder: (_) => Login()
        );
      case "/Home" :
        return MaterialPageRoute(
            builder: (_) => Home()
        );
        case "/HomeMotorista" :
        return MaterialPageRoute(
            builder: (_) => HomeMotorista()
        );
        case "/HomePreposto" :
        return MaterialPageRoute(
            builder: (_) => HomePreposto()
        );
        case "/HomeCliente" :
        return MaterialPageRoute(
            builder: (_) => HomeCliente()
        );
      case "/DigitarViagem" :
        return MaterialPageRoute(
            builder: (_) => DigitarViagem()
        );
      case "/RegistrarViagemMotorista" :
        return MaterialPageRoute(
            builder: (_) => RegistrarViagemMotorista()
        );
        case "/RegistrarOcorrencia" :
        return MaterialPageRoute(
            builder: (_) => RegistrarOcorrencia()
        );
      case "/CadastrarUsuario" :
        return MaterialPageRoute(
            builder: (_) => Cadastrar()
        );
        case "/AtualizarSenha" :
        return MaterialPageRoute(
            builder: (_) => AtualizarSenha()
        );
        case "/ConsultarViagem" :
        return MaterialPageRoute(
            builder: (_) => ConsultaViagem()
        );
      case "/RelatorioViagens" :
        return MaterialPageRoute(
            builder: (_) => RelatorioViagens()
        );
        case "/ConsultarViagemMotorista" :
        return MaterialPageRoute(
            builder: (_) => ConsultaViagemMotorista()
        );
        case "/ConsultarViagemCliente" :
        return MaterialPageRoute(
            builder: (_) => ConsultaViagemCliente()
        );
      case "/ConsultarOcupacao" :
        return MaterialPageRoute(
            builder: (_) => OcupacaoConsulta()
        );
      case "/ConsultarVeiculo" :
        return MaterialPageRoute(
            builder: (_) => ConsultaVeiculo()
        );
      case "/ConsultarMotorista" :
        return MaterialPageRoute(
            builder: (_) => ConsultaMotorista()
        );
      case "/ConsultarOcorrencia" :
        return MaterialPageRoute(
            builder: (_) => ConsultaOcorrencia()
        );
      default:
        _erroRota();
    }
    return null;

  }

  static Route<dynamic> _erroRota(){

    return MaterialPageRoute(
        builder: (_) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Tela n??o encontrada!"),
            ),
            body: Center(
              child: Text("Tela n??o encontrada!"),
            ),
          );
        }
    );

  }

}