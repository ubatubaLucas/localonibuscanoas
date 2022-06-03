import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localonibus/models/Usuario.dart';
import 'package:localonibus/views/widgets/BotaoCustomizado.dart';
import 'package:localonibus/views/widgets/InputCustomizado.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {

  TextEditingController _controllerEmail = TextEditingController(text: "");
  TextEditingController _controllerSenha = TextEditingController(text: "");

  String _mensagemErro = "";
  String _textoBotao = "ENTRAR";
  List<String> itensMenu = [
    "SUGESTÕES", "ELOGIOS", "RECLAMAÇÕES"
  ];

  _validarCampos() {

    //Recupera dados dos campos
    String email = _controllerEmail.text + "@localonibus.com.br";
    String senha = _controllerSenha.text + "12345";

    if (email.isNotEmpty && email.length >= 20) {
      if (senha.isNotEmpty && senha.length >= 6) {

        //Configura usuario
        Usuario usuario = Usuario();
        usuario.email = email;
        usuario.senha = senha;

        _logarUsuario(usuario);

      } else {
        setState(() {
          _mensagemErro = "PREENCHER SENHA!";
        });
      }
    } else {
      setState(() {
        _mensagemErro = "PREENCHER LOGIN!";
      });
    }

  }

  _logarUsuario (Usuario usuario) {

    FirebaseAuth auth = FirebaseAuth.instance;

    auth.signInWithEmailAndPassword(
        email: usuario.email,
        password: usuario.senha
    ).then((firebaseUser){
      _abrirDialog(context);
      _recuperarDadosUsuario(firebaseUser.user!.uid);

    }).catchError((error) {

      setState(() {
        _mensagemErro = "LOGIN E/OU SENHA INCORRETOS!";
      });

    });

  }

  _gravarNome(String nomeUsuario, String matriculaUsuario, String tipoUsuario) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nomeUser', nomeUsuario);
    await prefs.setString('matriculaUser', matriculaUsuario);
    await prefs.setString('tipoUser', tipoUsuario);
  }

  _recuperarDadosUsuario(String idUsuario) async {

    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot<Map<String, dynamic>> snapshot = await db
        .collection("USUARIOS")
        .doc(idUsuario)
        .get();

    var dados = snapshot.data();

    String nomeUsuario = dados!["nome"];
    String emailUsuario = dados["email"];
    String matriculaUsuario = emailUsuario.replaceAll("@localonibus.com.br", "");
    String tipoUsuario = dados["tipoUsuario"];

    _gravarNome(nomeUsuario, matriculaUsuario, tipoUsuario);

    switch(tipoUsuario){
      case "MOTORISTA" :
        Navigator.pushNamedAndRemoveUntil(context, "/HomeMotorista", (route) => false);
        break;
      case "PREPOSTO" :
        Navigator.pushNamedAndRemoveUntil(context, "/HomePreposto", (route) => false);
        break;
      case "GERENTE" :
        Navigator.pushNamedAndRemoveUntil(context, "/Home", (route) => false);
        break;
      case "CLIENTE" :
        Navigator.pushNamedAndRemoveUntil(context, "/HomeCliente", (route) => false);
        break;
    }
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
                Text("ENTRANDO...")
              ],
            ),
          );

        });

  }

  _verificarUsuarioLogado() async {

    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = await auth.currentUser;
    if ( usuarioLogado != null ) {

      String idUsuario = usuarioLogado.uid;
      _recuperarDadosUsuario(idUsuario);

    }
  }

  @override
  void initState() {

    _verificarUsuarioLogado();

    super.initState();
  }

  _escolhaMenuItem(String itemEscolhido) {

    switch(itemEscolhido){
      case "SUGESTÕES":
        print("SUGESTÕES");
        break;
      case "ELOGIOS":
        print("ELOGIOS");
        break;
      case "RECLAMAÇÕES":
        print("RECLAMAÇÕES");
        break;
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        backgroundColor: Colors.orange,
        actions: <Widget>[
          PopupMenuButton<String>(
              onSelected: _escolhaMenuItem,
              itemBuilder: (context) {
                return itensMenu.map((String item){
                  return PopupMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList();
              }
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(bottom: 75),
                  child: Image.asset(
                    "imagens/logolocal.png",
                    width: 250,
                    height: 115,
                  ),
                ),

                InputCustomizado(
                  controller: _controllerEmail,
                  type: TextInputType.number,
                  inputFormatters:
                  [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  hint: "LOGIN",
                ),

                SizedBox(height: 10), // ESPACO ENTRE TEXTFIELDS

                InputCustomizado(
                  controller: _controllerSenha,
                  type: TextInputType.number,
                  inputFormatters:
                  [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  hint: "SENHA",
                  obscure: true,
                ),

                SizedBox(height: 10), // ESPACO ENTRE senha e entrar
                BotaoCustomizado(
                  corFundo: Colors.orange,
                  texto: _textoBotao,
                  onPressed: ()
                  {
                    _validarCampos();
                  },
                ),
                SizedBox(height: 10,),
                Text("v. 2.2.0",
                  textAlign: TextAlign.center,),

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
      ),
    );
  }
}
