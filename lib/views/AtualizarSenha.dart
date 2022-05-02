import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localonibus/views/widgets/BotaoCustomizado.dart';
import 'package:localonibus/views/widgets/InputCustomizado.dart';

class AtualizarSenha extends StatefulWidget {

  @override
  _AtualizarSenhaState createState() => _AtualizarSenhaState();
}

class _AtualizarSenhaState extends State<AtualizarSenha> {

  TextEditingController _controllerNovaSenha = TextEditingController();
  TextEditingController _controllerConfirmarSenha = TextEditingController();

  String _mensagemErro = "";

  _validarCampos() {

    String novaSenha = _controllerNovaSenha.text + "12345";
    String confirmarSenha = _controllerConfirmarSenha.text + "12345";

    if (novaSenha.length >= 6) {
      if (confirmarSenha.length >= 6) {
        if (novaSenha == confirmarSenha) {

            _alterarSenha(novaSenha);

          } else {
            setState(() {
              _mensagemErro = "SENHAS DIFERENTES!";
            });
          }
        } else {
            setState(() {
              _mensagemErro = "PREENCHER CONFIRMAR!";
            });
          }
        }
        else {
          setState(() {
            _mensagemErro = "PREENCHER NOVA SENHA!";
          });
        }

  }

  _alterarSenha(String novaSenha) async {
    User? user = await FirebaseAuth.instance.currentUser;

    user!.updatePassword(novaSenha).then((_){
      // Password has been updated.
      _abrirDialog(context);
      Navigator.pushNamedAndRemoveUntil(context, "/Login", (route) => false);
    }).catchError((error){
      // An error has occured.
      setState(() {
        _mensagemErro = "ERRO! CONTATE O ADMINISTRADOR!";
      });
    });}

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
                Text("SALVANDO INFORMAÇÕES...")
              ],
            ),
          );

        });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ALTERAR SENHA"),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(children: <Widget>[
                Text("NOVA SENHA:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                Expanded(child: Padding(
                  padding: EdgeInsets.all(8),
                  child: InputCustomizado(
                    controller: _controllerNovaSenha,
                    hint: "NOVA SENHA",
                    type: TextInputType.number,
                    inputFormatters:
                    [
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    validator: (value){

                      if (_controllerNovaSenha.text.isEmpty)
                      {return "[Campo Obrigatório]";}

                      return null;

                    },
                  ),
                ))
              ],),
              Row(children: <Widget>[
                Text("REPETIR:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                Expanded(child: Padding(
                  padding: EdgeInsets.all(8),
                  child: InputCustomizado(
                    controller: _controllerConfirmarSenha,
                    hint: "REPETIR SENHA",
                    type: TextInputType.number,
                    inputFormatters:
                    [
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    validator: (value){

                      if (_controllerConfirmarSenha.text.isEmpty)
                      {return "[Campo Obrigatório]";}

                      return null;

                    },
                  ),
                ))
              ],),

              Padding(
                padding: EdgeInsets.all(8),
                child: BotaoCustomizado(
                  corFundo: Colors.orange,
                  texto: "ALTERAR",
                  onPressed: () {
                    _validarCampos();
                  },
                ),
              ),
              SizedBox(height: 10,),
              Padding(padding: EdgeInsets.only(top: 20),
                child: Text(_mensagemErro,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red
                  ),),)
            ],),
        ),
      ),
    );
  }
}
