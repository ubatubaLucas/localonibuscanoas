import 'package:flutter/material.dart';
import 'package:localonibus/models/Viagem.dart';

class ListViewOcupacao extends StatelessWidget {

  final Viagem viagem;

  ListViewOcupacao(
      {
        required this.viagem
      }
      );

  final Map<String, int> mapVeiculos = {
    "200" : 15,
    "201" : 15,
    "202" : 15,
    "203" : 15,
    "204" : 15,
    "205" : 15,
    "206" : 15,
    "207" : 15,
    "208" : 15,
    "209" : 15,
    "210" : 15,
    "211" : 17,
    "500" : 31,
    "501" : 31,
    "502" : 31,
    "503" : 31,
    "504" : 31,
    "505" : 26,
    "506" : 31,
    "507" : 31,
    "508" : 31,
    "509" : 31,
    "510" : 31,
    "511" : 31,
    "1000" : 29,
    "1001" : 29,
    "1002" : 29,
    "1003" : 29,
    "1004" : 29,
    "1005" : 29,
    "1006" : 29,
    "1007" : 29,
    "1008" : 29,
    "1009" : 32,
    "1010" : 32,
    "1011" : 32,
    "1012" : 32,
    "1013" : 33,
    "1014" : 33,
    "1015" : 33,
    "1016" : 33,
    "1017" : 33,
    "1018" : 33,
    "1100" : 29,
    "1200" : 29,
    "1300" : 29,
    "1400" : 29,
    "1500" : 29,
    "1600" : 29,
    "1700" : 29,
    "1800" : 29,
    "1900" : 29,
    "2000" : 29,
    "2100" : 29,
    "2240" : 44,
    "2244" : 44,
    "2245" : 45,
    "2246" : 45,
    "2247" : 45,
    "2249" : 44,
    "2250" : 44,
    "2251" : 44,
    "2252" : 44,
    "2253" : 44,
    "2254" : 44,
    "2255" : 44,
    "2256" : 44,
    "2257" : 44,
    "2258" : 44,
    "2259" : 44,
    "2260" : 44,
    "2261" : 44,
    "2262" : 44,
    "2263" : 44,
    "2264" : 44,
    "2265" : 42,
    "2266" : 46,
    "2267" : 44,
    "2268" : 44,
    "2269" : 44,
    "2270" : 44,
    "2271" : 44,
    "2272" : 44,
    "2273" : 44,
    "2600" : 32,
    "2900" : 33,
    "3000" : 29,
    "3100" : 29,
    "3200" : 29,
    "3300" : 29,
    "3400" : 29,
    "3500" : 29,
    "3600" : 29,
    "3700" : 29,
    "3800" : 29,
    "3900" : 33,
    "4000" : 22,
    "4100" : 19,
    "4200" : 19,
    "4300" : 19,
    "4400" : 19,
    "4500" : 19,
    "4600" : 19,
    "4700" : 19,
    "4800" : 19,
    "4900" : 19,
    "7200" : 28,
    "7300" : 30,
    "7400" : 29,
    "7500" : 29,
    "7600" : 29,
    "7700" : 29,
    "7800" : 29,
    "8700" : 29,
    "8800" : 29,
    "8900" : 19,
    "9000" : 29,
    "9100" : 29,
    "9200" : 29,
    "9300" : 29,
    "9400" : 29,
    "9500" : 29,
    "9600" : 29,
    "9700" : 29,
    "9800" : 29,
    "9900" : 29,
  };

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
                child: Container(alignment: Alignment.center, height: 50, child: Text(viagem.rota, style: TextStyle(fontSize: 18), textAlign: TextAlign.center,),),
              ),
              TableCell(
                child: Container(alignment: Alignment.center, height: 50, child: Text(viagem.entradaSaida.toUpperCase(), style: TextStyle(fontSize: 18), textAlign: TextAlign.center,),),
              ),
              TableCell(
                child: Container(alignment: Alignment.center, height: 50, child: Text(viagem.qtdPax.toString(), style: TextStyle(fontSize: 18), textAlign: TextAlign.center,),),
              ),
              TableCell(
                child: Container(alignment: Alignment.center, height: 50, child: Text("${(viagem.qtdPax/mapVeiculos[viagem.veiculo]!*100).round().toString()}%", style: TextStyle(fontSize: 18), textAlign: TextAlign.center,),),
              ),
            ]
        )
      ],
    );
  }
}
