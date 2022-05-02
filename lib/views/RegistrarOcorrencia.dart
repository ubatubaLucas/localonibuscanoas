import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localonibus/models/Viagem.dart';
import 'package:localonibus/views/widgets/BotaoCustomizado.dart';
import 'package:localonibus/views/widgets/InputCustomizado.dart';
import 'package:validadores/validadores.dart';
import 'package:validadores/Validador.dart';
import 'package:intl/intl.dart';

class RegistrarOcorrencia extends StatefulWidget {

  @override
  _RegistrarOcorrenciaState createState() => _RegistrarOcorrenciaState();
}

class _RegistrarOcorrenciaState extends State<RegistrarOcorrencia> {

  List<String> clientes = ["VIA URBANA", "RODOVIA", "ESTRADA NÃO PAVIMENTADA", "ESTACIONAMENTO COLETIVO", "ESTACIONAMENTO PRIVADO", "GARAGEM COLETIVA", "GARAGEM PRIVADA", "PROPRIEDADE PRIVADA"];
  List<String> turnos = ["CRUZAMENTO COM SINALEIRA", "CRUZAMENTO SEM SINALEIRA", "ACESSO A OUTRA VIA OU ESTRADA", "SAÍDA OU ENTRADA DE VEÍCULOS", "ROTATÓRIA", "PONTE", "TREVO", "VIADUTO", "TÚNEL", "OUTRO"];
  List<String> rotas = ["TOMBAMENTO", "CAPOTAGEM", "QUEDA", "CHOQUE", "COLISÃO", "INCÊNDIO", "ABALROAMENTO"];

  String? selectedCliente;
  String? selectedTurno;
  String? selectedRota;

  final _formKey = GlobalKey<FormState>();
  late Viagem _viagem;

  TextEditingController _iconButtonInicio = TextEditingController();
  TextEditingController _iconButtonFim = TextEditingController();
  TextEditingController _controllerMotorista = TextEditingController(text: "");
  TextEditingController _controllerHoraInicio = TextEditingController(text: "");
  TextEditingController _controllerQtdPax = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    _viagem = Viagem();
  }

  _showDatePickerInicio() {
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2022),
        lastDate: DateTime.now(),
        builder: (context, child) {
          return Theme(
            data: ThemeData().copyWith(
              colorScheme: ColorScheme.light(
                  primary: Colors.orange,
                  onPrimary: Colors.white,
                  onSurface: Colors.black
              ),
            ),
            child: child!,);

        }
    ).then((pickedDateInicio) {
      if(pickedDateInicio == null) {
        return;
      }
      setState(() {
        _viagem.dataInicio = DateFormat("dd/MM/yyyy").format(pickedDateInicio);
        _iconButtonInicio.text = _viagem.dataInicio;
        _iconButtonFim.text = _viagem.dataInicio;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("REGISTRAR OCORRÊNCIA"),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(children: <Widget>[
                  Text("COMUNICANTE:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  Expanded(child: Padding(
                    padding: EdgeInsets.all(8),
                    child: InputCustomizado(
                        controller: _controllerMotorista,
                        hint: "NOME",
                        onSaved: (motorista) {
                          _viagem.motorista = motorista!;
                          return null;
                        },
                        validator: (value){
                          return Validador()
                              .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                              .valido(value);
                        },
                        type: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ]
                    ),
                  ))
                ],),
                Row(children: <Widget>[
                  Text("MOTORISTA 1:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  Expanded(child: Padding(
                    padding: EdgeInsets.all(8),
                    child: InputCustomizado(
                        controller: _controllerMotorista,
                        hint: "NOME",
                        onSaved: (motorista) {
                          _viagem.motorista = motorista!;
                          return null;
                        },
                        validator: (value){
                          return Validador()
                              .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                              .valido(value);
                        },
                        type: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ]
                    ),
                  ))
                ],),
                Row(children: <Widget>[
                  Text("MOTORISTA 2:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  Expanded(child: Padding(
                    padding: EdgeInsets.all(8),
                    child: InputCustomizado(
                        controller: _controllerMotorista,
                        hint: "NOME",
                        onSaved: (motorista) {
                          _viagem.motorista = motorista!;
                          return null;
                        },
                        validator: (value){
                          return Validador()
                              .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                              .valido(value);
                        },
                        type: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ]
                    ),
                  ))
                ],),
                Row(children: <Widget>[
                  Text("VEÍCULO 1:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  Expanded(child: Padding(
                    padding: EdgeInsets.all(8),
                    child: InputCustomizado(
                        controller: _controllerMotorista,
                        hint: "PLACA",
                        onSaved: (motorista) {
                          _viagem.motorista = motorista!;
                          return null;
                        },
                        validator: (value){
                          return Validador()
                              .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                              .valido(value);
                        },
                        type: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ]
                    ),
                  ))
                ],),
                Row(children: <Widget>[
                  Text("VEÍCULO 2:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  Expanded(child: Padding(
                    padding: EdgeInsets.all(8),
                    child: InputCustomizado(
                        controller: _controllerMotorista,
                        hint: "PLACA",
                        onSaved: (motorista) {
                          _viagem.motorista = motorista!;
                          return null;
                        },
                        validator: (value){
                          return Validador()
                              .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                              .valido(value);
                        },
                        type: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ]
                    ),
                  ))
                ],),
                Row(children: <Widget>[
                  Text("LOCAL:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: DropdownButtonFormField<String>(
                        value: selectedCliente,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20
                        ),
                        hint: Text("SELECIONAR"),
                        items: clientes.map((String value) {
                          return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value)
                          );
                        }).toList(),
                        onSaved: (cliente) {
                          _viagem.cliente = cliente!;
                        },
                        validator: (value) {
                          return Validador()
                              .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                              .valido(value);
                        },
                        onChanged: (cliente) {
                          setState(() {
                            selectedCliente = cliente;
                          });

                        },
                      ),
                    ),
                  ),
                ],),
                Row(children: <Widget>[
                  Text("OBS:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: DropdownButtonFormField<String>(
                        value: selectedTurno,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20
                        ),
                        hint: Text("SELECIONAR"),
                        items: turnos.map((String value) {
                          return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value)
                          );
                        }).toList(),
                        onSaved: (turno) {
                          _viagem.turno = turno!;
                        },
                        validator: (value) {
                          return Validador()
                              .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                              .valido(value);
                        },
                        onChanged: (turno) {
                          setState(() {
                            selectedTurno = turno;
                          });
                        },
                      ),
                    ),
                  ),
                ],),
                Row(children: <Widget>[
                  Text("TIPO:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: DropdownButtonFormField<String>(
                        value: selectedRota,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20
                        ),
                        hint: Text("SELECIONAR"),
                        items: rotas.map((String value) {
                          return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value)
                          );
                        }).toList(),
                        onSaved: (rota) {
                          _viagem.rota = rota!;
                        },
                        validator: (value) {
                          return Validador()
                              .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                              .valido(value);
                        },
                        onChanged: (rota) {
                          setState(() {
                            selectedRota = rota;
                          });
                        },
                      ),
                    ),
                  ),
                ],),


                Row(children: <Widget>[
                  Text("DATA:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  Expanded(child:

                  Padding(
                    padding: EdgeInsets.all(8),
                    child: InputCustomizado(
                        hint: "DD/MM/AAAA",
                        controller: _iconButtonInicio ,
                        validator: (value) {

                          if (_iconButtonInicio.text.isEmpty)
                          {return "[Campo Obrigatório]";}

                          if (_iconButtonInicio.text.length < 10)
                          {return "[Valor Inválido]";}

                          return null;

                        },
                        onSaved: (dataInicio) {
                          _viagem.dataInicio = dataInicio!;
                          return null;
                        },
                        type: TextInputType.number,
                        inputFormatters:
                        [
                          FilteringTextInputFormatter.digitsOnly,
                          DataInputFormatter()
                        ]
                    ),

                  )
                  ),
                  IconButton(
                      onPressed: _showDatePickerInicio,
                      icon: Icon(Icons.date_range)
                  )
                ],),


                Row(children: <Widget>[
                  Text("HORA:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  Expanded(child: Padding(
                    padding: EdgeInsets.all(8),
                    child: InputCustomizado(
                        controller: _controllerHoraInicio,
                        hint: "HH:MM",
                        onSaved: (horaInicio) {
                          _viagem.horaInicio = horaInicio!;
                          return null;
                        },
                        validator: (value){

                          if (_controllerHoraInicio.text.isEmpty)
                          {return "[Campo Obrigatório]";}

                          if (_controllerHoraInicio.text.length < 5)
                          {return "[Valor Inválido]";}

                          return null;

                        },
                        type: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          HoraInputFormatter()
                        ]
                    ),
                  ))
                ],),
                Row(children: <Widget>[
                  Text("DESCRIÇÃO:", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                  Expanded(child: Padding(
                    padding: EdgeInsets.all(8),
                    child: InputCustomizado(
                        controller: _controllerQtdPax,
                        hint: "DESCRIÇÃO",
                        onSaved: (qtdPax) {
                          return null;

                          //_viagem.qtdPax = qtdPax!;
                        },
                        validator: (value){
                          return Validador()
                              .add(Validar.OBRIGATORIO, msg: "Campo Obrigatório")
                              .valido(value);
                        },
                        type: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ]
                    ),
                  ))
                ],),

                Padding(
                  padding: EdgeInsets.all(8),
                  child: BotaoCustomizado(
                    texto: "ENVIAR",
                    onPressed: () {
                      if ( _formKey.currentState!.validate() ) {
                        //_formKey.currentState?.save();
                        //_dialogContext = context;
                        //_salvarViagem();
                      }
                    },
                  ),
                ),
              ],),
          ),
        ),
      ),
    );
  }
}
