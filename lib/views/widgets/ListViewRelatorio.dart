import 'package:flutter/material.dart';
import 'package:localonibus/models/Viagem.dart';

class ListViewRelatorio extends StatelessWidget {

  final Viagem viagem;

  ListViewRelatorio(
      {
        required this.viagem
      }
      );

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths:({
        0: FlexColumnWidth(0.2),
        1: FlexColumnWidth(0.2),
        2: FlexColumnWidth(0.2),
        3: FlexColumnWidth(0.2),
        4: FlexColumnWidth(0.2),
        5: FlexColumnWidth(0.2),
      }),
      border: TableBorder.all(),
      children: <TableRow>[
        TableRow(
            children: <Widget>[
              TableCell(
                child: Container(alignment: Alignment.center, height: 50, child: Text(viagem.dataInicio, style: TextStyle(fontSize: 18), textAlign: TextAlign.center,),),
              ),
              TableCell(
                child: Container(alignment: Alignment.center, height: 50, child: Text(viagem.cliente, style: TextStyle(fontSize: 18), textAlign: TextAlign.center,),),
              ),
              TableCell(
                child: Container(alignment: Alignment.center, height: 50, child: Text(viagem.turno, style: TextStyle(fontSize: 18), textAlign: TextAlign.center,),),
              ),
              TableCell(
                child: Container(alignment: Alignment.center, height: 50, child: Text(viagem.rota, style: TextStyle(fontSize: 18), textAlign: TextAlign.center,),),
              ),
              TableCell(
                child: Container(alignment: Alignment.center, height: 50, child: Text(viagem.veiculo, style: TextStyle(fontSize: 18), textAlign: TextAlign.center,),),
              ),
            ]
        )
      ],
    );
  }
}
