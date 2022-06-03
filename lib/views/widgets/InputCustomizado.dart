import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputCustomizado extends StatelessWidget {

  final TextEditingController controller;
  final List<String>? autofillHints;
  final String hint;
  final bool obscure;
  final bool autofocus;
  final TextInputType type;
  final int? maxLines;
  final TextInputAction action;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String>? validator;
  final FormFieldValidator<String>? onSaved;
  final bool readOnly;

  InputCustomizado({
    required this.controller,
    this.autofillHints,
    required this.hint,
    this.obscure = false,
    this.autofocus = false,
    this.type = TextInputType.text,
    this.action = TextInputAction.next,
    this.inputFormatters,
    this.maxLines = 1,
    this.validator,
    this.onSaved,
    this.readOnly = false,
});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: this.controller,
      autofillHints: this.autofillHints,
      obscureText: this.obscure,
      textInputAction: this.action,
      autofocus: this.autofocus,
      keyboardType: this.type,
      inputFormatters: this.inputFormatters,
      validator: this.validator,
      maxLines: this.maxLines,
      onSaved: this.onSaved,
      readOnly: this.readOnly,
      style: TextStyle(fontSize: 20),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(25, 10, 25, 10),
          hintText: this.hint,
          filled: true,
          fillColor: Colors.white,
          focusedBorder: OutlineInputBorder(
              //borderSide: BorderSide(color: Colors.orange)
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6)
          )
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
