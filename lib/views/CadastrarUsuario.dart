import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localonibus/models/Usuario.dart';
import 'package:localonibus/views/widgets/BotaoCustomizado.dart';
import 'package:localonibus/views/widgets/InputCustomizado.dart';
import 'package:validadores/Validador.dart';
import 'package:validadores/validadores.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Cadastrar extends StatefulWidget {

  @override
  _CadastrarState createState() => _CadastrarState();
}

class _CadastrarState extends State<Cadastrar> {

  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();

  String _mensagemErro = "";

  _validarCampos() {

    //Recupera dados dos campos
    String nome = _controllerNome.text;
    String email = _controllerEmail.text + "@localonibus.com.br";
    String senha = _controllerSenha.text + "12345";

    if (selectedTipoUsuario != null) {
      if (nome.isNotEmpty) {
        if(email.length >= 20) {
          if(senha.length >= 6) {

        //Configura usuario
        Usuario usuario = Usuario();
        usuario.tipoUsuario = selectedTipoUsuario!;
        usuario.nome = nome;
        usuario.email = email;
        usuario.senha = senha;

        _cadastrarUsuario(usuario);

      } else {
            setState(() {
              _mensagemErro = "PREENCHER SENHA!";
              print(selectedTipoUsuario);
            });
          }
        }
          else {
        setState(() {
          _mensagemErro = "PREENCHER LOGIN!";
        });
      }
    }
      else {
        setState(() {
          _mensagemErro = "PREENCHER NOME!";
        });
      }
    } else {
      setState(() {
        _mensagemErro = "SELECIONAR CLASSE!";
      });
    }

  }

  List<String> tipoUsuario = ["MOTORISTA", "PREPOSTO", "GERENTE", "CLIENTE"];

  String? selectedTipoUsuario;

  _cadastrarUsuario(Usuario usuario) {

    _abrirDialog(context);

    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;
    
    auth.createUserWithEmailAndPassword(
        email: usuario.email,
        password: usuario.senha
    ).then((firebaseUser){
      
      db.collection("USUARIOS")
        .doc(firebaseUser.user!.uid)
        .set(usuario.toMap());

      Navigator.pushNamedAndRemoveUntil(context, "/Login", (route) => false);

    }).catchError((error) {

      setState(() {
        _mensagemErro = "ERRO! CONTATE O ADMINISTRADOR!";
      });

    });

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
        title: Text("CADASTRAR USUÁRIO"),
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
                  Text("CLASSE:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: DropdownButtonFormField<String>(
                        value: selectedTipoUsuario,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20
                        ),
                        hint: Text("SELECIONAR"),
                        items: tipoUsuario.map((String value) {
                          return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value)
                          );
                        }).toList(),
                        validator: (value) {
                          return Validador()
                              .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                              .valido(value);
                        },
                        onChanged: (tipoUsuario) {
                          setState(() {
                            selectedTipoUsuario = tipoUsuario;
                          });
                        },
                      ),
                    ),
                  ),
                ],),
                Row(children: <Widget>[
                  Text("NOME:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  Expanded(child: Padding(
                    padding: EdgeInsets.all(8),
                    child: InputCustomizado(
                        controller: _controllerNome,
                        hint: "NOME",
                        validator: (value){

                          if (_controllerEmail.text.isEmpty)
                          {return "[Campo Obrigatório]";}

                          return null;

                        },
                        type: TextInputType.text,
                        inputFormatters: [
                          UpperCaseTextFormatter(),
                        ],
                    ),
                  ))
                ],),
                Row(children: <Widget>[
                  Text("LOGIN:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  Expanded(child: Padding(
                    padding: EdgeInsets.all(8),
                    child: InputCustomizado(
                        controller: _controllerEmail,
                        hint: "MATRÍCULA",
                        type: TextInputType.number,
                        inputFormatters:
                        [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (value){

                          if (_controllerEmail.text.isEmpty)
                          {return "[Campo Obrigatório]";}

                          return null;

                        },
                    ),
                  ))
                ],),
                Row(children: <Widget>[
                  Text("SENHA:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  Expanded(child: Padding(
                    padding: EdgeInsets.all(8),
                    child: InputCustomizado(
                        controller: _controllerSenha,
                        hint: "SENHA",
                      type: TextInputType.number,
                      inputFormatters:
                      [
                        FilteringTextInputFormatter.digitsOnly
                      ],
                        validator: (value){

                          if (_controllerSenha.text.isEmpty)
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
                    texto: "CADASTRAR",
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
