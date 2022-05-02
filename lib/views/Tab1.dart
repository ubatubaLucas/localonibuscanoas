import 'package:flutter/material.dart';
import 'package:localonibus/views/widgets/BotaoCustomizado.dart';

class Menu extends StatefulWidget {

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {

  _digitarViagem() {

    Navigator.pushNamed(context, "/DigitarViagem");

  }

  _cadastrarUsuario() {

    Navigator.pushNamed(context, "/CadastrarUsuario");

  }

  @override
  Widget build(BuildContext context) {
    return Container(child:
            SingleChildScrollView(child:
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
                SizedBox(height: 40,),
                SizedBox(
                    width: 250,
                    child: Text(
                      "CADASTRAR",
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
                        texto: "USUÁRIO",
                        onPressed: () {
                          _cadastrarUsuario();
                        }
                    )
                ),
                SizedBox(height: 40,),
              ],
          ),
        ));
  }
}
