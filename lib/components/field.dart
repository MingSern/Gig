import 'package:flutter/material.dart';

class Field extends StatelessWidget {
  final TextInputType keyboardType;
  final String labelText;
  final String hintText;
  final bool loading;
  final String initialValue;
  final bool obscureText;
  final int maxLines;
  final Function(String) onSaved;
  final Function(String) validator;
  final TextCapitalization textCapitalization;

  Field({
    @required this.keyboardType,
    @required this.labelText,
    @required this.onSaved,
    @required this.validator,
    this.loading = false,
    this.initialValue = "",
    this.textCapitalization = TextCapitalization.none,
    this.maxLines = 1,
    this.obscureText = false,
    this.hintText = "",
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: TextFormField(
        enabled: !this.loading,
        initialValue: this.initialValue,
        textCapitalization: this.textCapitalization,
        keyboardType: this.keyboardType,
        autofocus: false,
        obscureText: this.obscureText,
        maxLines: this.maxLines,
        decoration: InputDecoration(
          labelText: this.labelText,
          hintText: this.hintText,
          filled: true,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(25),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(25),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(25),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(25),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        onSaved: this.onSaved,
        validator: this.validator,
      ),
    );
  }
}
