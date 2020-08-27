import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFildWidget extends StatelessWidget {
  final TextEditingController controller;
  final bool obscure;
  final bool autofocus;
  final String hint;
  final TextInputType inputTypetype;
  final List<TextInputFormatter> inputFormatters;
  final int maxLines;
  final Function(String) validator;
  final Function(String) onSaved;
  final Icon icon;
  TextFildWidget(
      {@required this.controller,
        @required this.hint,
        this.obscure = false,
        this.autofocus = false,
        this.inputTypetype = TextInputType.text,
        this.inputFormatters,
        this.maxLines = 1,
        this.validator,
        this.onSaved,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 5),
      child: TextFormField(
        controller: this.controller,
        obscureText: this.obscure,
        autofocus: this.autofocus,
        keyboardType: this.inputTypetype,
        inputFormatters: this.inputFormatters,
        validator: this.validator,
        maxLines: this.maxLines,
        onSaved: this.onSaved,
        decoration: InputDecoration(
          icon: this.icon,
            contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            hintText: this.hint,
            filled: true,
            fillColor: Colors.white,
            hintStyle: TextStyle(fontSize: 20)),
      ),
    );
  }
}
