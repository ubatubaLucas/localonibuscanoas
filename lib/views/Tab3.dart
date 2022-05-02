import 'package:flutter/material.dart';
import 'package:localonibus/views/widgets/BotaoCustomizado.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Conta extends StatefulWidget {

  @override
  _ContaState createState() => _ContaState();
}

class _ContaState extends State<Conta> {

  /*Future _verificarUsuarioLogado() async {

    FirebaseAuth auth = FirebaseAuth.instance;

    User? usuarioLogado = await auth.currentUser;

  }*/

  _deslogarUsuario() async {

    _abrirDialog(context);

    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    
    Navigator.pushNamedAndRemoveUntil(context, "/Login", (route) => false);

  }

  _atualizarSenha() async {

    Navigator.pushNamed(context, "/AtualizarSenha");

  }

  _abrirDialog(BuildContext context) {

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(height: 20,),
                Text("SAINDO...")
              ],
            ),
          );

        });

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
                    "CONTA",
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
                      texto: "ALTERAR SENHA",
                      onPressed: () {
                        _atualizarSenha();
                      }
                      )
              ),

              SizedBox(height: 20,),

              SizedBox(
                width: 250,
                child: BotaoCustomizado(
                    corFundo: Colors.orange,
                    texto: "DESLOGAR",
                    onPressed: () {
                      _deslogarUsuario();
                    }
                    ),
              )
            ],
          ),
        ));
  }
}
