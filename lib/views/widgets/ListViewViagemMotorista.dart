import 'package:flutter/material.dart';
import 'package:localonibus/models/Viagem.dart';

class ListViewViagemMotorista extends StatelessWidget {

  final Viagem viagem;

  ListViewViagemMotorista(
      {
        required this.viagem
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
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(children: <Widget>[
                    Text("CLIENTE: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                    Text(viagem.cliente.toUpperCase(), style: TextStyle(fontSize: 18),),
                  ],),
                  Row(children: <Widget>[
                    Text("TURNO: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                    Text(viagem.turno.toUpperCase(), style: TextStyle(fontSize: 18),),
                  ],),
                  Row(children: <Widget>[
                    Text("ROTA: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                    Text(viagem.rota, style: TextStyle(fontSize: 18),),
                  ],),
                  Row(children: <Widget>[
                    Text("SENTIDO: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                    Text(viagem.entradaSaida.toUpperCase(), style: TextStyle(fontSize: 18),),
                  ],),
                  Row(children: <Widget>[
                    Text("TIPO: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                    Text(viagem.normalExtra.toUpperCase(), style: TextStyle(fontSize: 18),),
                  ],),
                  Row(children: <Widget>[
                    Text("MOTORISTA: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                    Text(viagem.motorista.toUpperCase(), style: TextStyle(fontSize: 18),),
                  ],),
                  Row(children: <Widget>[
                    Text("VE??CULO: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                    Text(viagem.veiculo, style: TextStyle(fontSize: 18),),
                  ],),
                  Row(children: <Widget>[
                    Text("DATA IN??CIO: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                    Text(viagem.dataInicio, style: TextStyle(fontSize: 18),),
                  ],),
                  Row(children: <Widget>[
                    Text("DATA FIM: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                    Text(viagem.dataFim, style: TextStyle(fontSize: 18),),
                  ],),
                  Row(children: <Widget>[
                    Text("HOR??RIO IN??CIO: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                    Text(viagem.horaInicio, style: TextStyle(fontSize: 18),),
                  ],),
                  Row(children: <Widget>[
                    Text("HOR??RIO FIM: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                    Text(viagem.horaFim, style: TextStyle(fontSize: 18),),
                  ],),
                  Row(children: <Widget>[
                    Text("KM IN??CIO: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                    Text(viagem.kmInicio.toString(), style: TextStyle(fontSize: 18),),
                  ],),
                  Row(children: <Widget>[
                    Text("KM FIM: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                    Text(viagem.kmFim.toString(), style: TextStyle(fontSize: 18),),
                  ],),
                  Row(children: <Widget>[
                    Text("QTD PAX: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
                    Text(viagem.qtdPax.toString(), style: TextStyle(fontSize: 18),),
                  ],),
                ],),),

            ],),
          ],
          ),
        ),
      ),
    );
  }
}
