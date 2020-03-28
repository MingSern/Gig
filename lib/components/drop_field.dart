import 'package:flutter/material.dart';

class DropField extends StatelessWidget {
  final String labelText;
  final dynamic value;
  final Function validator;
  final bool loading;
  final List items;
  final Function onChanged;
  final EdgeInsets padding;
  final bool flexible;

  DropField({
    @required this.labelText,
    @required this.value,
    @required this.validator,
    @required this.items,
    @required this.onChanged,
    this.loading = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
    this.flexible = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: this.padding,
      child: DropdownButtonFormField(
        isExpanded: true,
        isDense: false,
        value: this.value,
        validator: this.validator,
        disabledHint: DropdownMenuItem(
          value: this.value,
          child: Text(
            this.value ?? "",
            style: TextStyle(color: Colors.black),
          ),
        ),
        decoration: InputDecoration(
          labelText: this.labelText,
          filled: true,
          isDense: true,
          fillColor: this.loading ? Colors.grey[50] : Colors.grey[100],
          contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: this.flexible ? 15 : 0),
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
        items: this.items.map((item) {
          return DropdownMenuItem(
            value: item,
            child: Text(item),
          );
        }).toList(),
        onChanged: this.loading ? null : this.onChanged,
      ),
    );
  }
}
