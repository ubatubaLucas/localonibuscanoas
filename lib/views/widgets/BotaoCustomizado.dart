import 'package:flutter/material.dart';

class BotaoCustomizado extends StatelessWidget {
  
  final String texto;
  final Color corTexto;
  final Color corFundo;
  final VoidCallback onPressed;
  
  BotaoCustomizado({
    required this.texto,
    this.corTexto = Colors.white,
    this.corFundo = Colors.grey,
    required this.onPressed
});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom
        (
          primary: this.corFundo,
          padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6)
          )
      ),
      child: Text(
        this.texto,
        style: TextStyle(
            color: this.corTexto,
            fontSize: 20
        ),
      ),
      onPressed: this.onPressed,
    );
  }
}
