import 'package:flutter/material.dart';
import 'package:localonibus/models/Ocorrencia.dart';

class ListViewOcorrencia extends StatelessWidget {
  
  final Ocorrencia ocorrencia;
  final VoidCallback? onPressedRemover;
  
  ListViewOcorrencia(
      {
        required this.ocorrencia,
        this.onPressedRemover
      }
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){},
      child: Container(
        child: Padding(
          padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
          child: Column(children: <Widget>[
            Divider(
              height: 1,
              thickness: 1,
              color: Colors.black,
            ),
            SizedBox(height: 10,),
            Row(children: <Widget>[
              Expanded(child:
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(children: <Widget>[
                      Text("DATA: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                      Text(ocorrencia.dataInicio, style: TextStyle(fontSize: 18),),
                    ],),
                    Row(children: <Widget>[
                      Text("CATEGORIA: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                      Text(ocorrencia.categoria.toUpperCase(), style: TextStyle(fontSize: 18),),
                    ],),
                    Row(children: <Widget>[
                      Text("TIPO: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                      Text(ocorrencia.tipo.toUpperCase(), style: TextStyle(fontSize: 18),),
                    ],),
                    Row(children: <Widget>[
                      Text("MOTORISTA: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                      Text(ocorrencia.motorista.toUpperCase(), style: TextStyle(fontSize: 18),),
                    ],),
                    Row(children: <Widget>[
                      Text("VEÍCULO: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                      Text(ocorrencia.veiculo, style: TextStyle(fontSize: 18),),
                    ],),
                    Row(children: <Widget>[
                      Text("GRAVIDADE: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                      Text(ocorrencia.gravidade, style: TextStyle(fontSize: 18),),
                    ],),
                    Row(children: <Widget>[
                      Text("PROBABILIDADE: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                      Text(ocorrencia.probabilidade, style: TextStyle(fontSize: 18),),
                    ],),
                    Row(children: <Widget>[
                      Text("DESCRIÇÃO: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                      Expanded(
                        child: Text(ocorrencia.descricao,
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.justify,
                        ),),
                    ],),
                  ],),),

              Column(children: <Widget>[
                Row(children: <Widget>[
                  Container(decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1),
                    color: Colors.white,
                    shape: BoxShape.rectangle,
                  ),
                    child: IconButton(onPressed: this.onPressedRemover,
                      icon: Icon(Icons.delete_forever_outlined), iconSize: 40.0,),),
                ],),
                Row(children: <Widget>[
                  Text("EXCLUIR"),
                ],),

              ],),
            ],),
          ],
          ),
        ),
      ),
    );
  }
}
