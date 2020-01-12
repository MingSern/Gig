import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Gig/utils/device.dart';

class CodeField extends StatefulWidget {
  final Function(String) onSave;
  final bool loading;

  CodeField({
    @required this.onSave,
    this.loading = false,
  });

  @override
  _CodeFieldState createState() => _CodeFieldState();
}

class _CodeFieldState extends State<CodeField> {
  final focus_1 = new FocusNode();
  final focus_2 = new FocusNode();
  final focus_3 = new FocusNode();
  final focus_4 = new FocusNode();
  final focus_5 = new FocusNode();
  final focus_6 = new FocusNode();
  final textController_1 = new TextEditingController();
  final textController_2 = new TextEditingController();
  final textController_3 = new TextEditingController();
  final textController_4 = new TextEditingController();
  final textController_5 = new TextEditingController();
  final textController_6 = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: Device.getMaxWidth(context) * 0.6,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    child: TextField(
                      controller: textController_1,
                      focusNode: focus_1,
                      autofocus: true,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        counterText: "",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) => value.length > 0 ? FocusScope.of(context).requestFocus(focus_2) : null,
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    child: TextField(
                      controller: textController_2,
                      focusNode: focus_2,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        counterText: "",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) => value.length > 0 ? FocusScope.of(context).requestFocus(focus_3) : null,
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    child: TextField(
                      controller: textController_3,
                      focusNode: focus_3,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        counterText: "",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) => value.length > 0 ? FocusScope.of(context).requestFocus(focus_4) : null,
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    child: TextField(
                      controller: textController_4,
                      focusNode: focus_4,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        counterText: "",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) => value.length > 0 ? FocusScope.of(context).requestFocus(focus_5) : null,
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    child: TextField(
                      controller: textController_5,
                      focusNode: focus_5,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.all(10),
                        counterText: "",
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) => value.length > 0 ? FocusScope.of(context).requestFocus(focus_6) : null,
                    ),
                  ),
                ),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    child: TextField(
                        controller: textController_6,
                        focusNode: focus_6,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(10),
                          counterText: "",
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          if (value.length > 0) {
                            FocusScope.of(context).requestFocus(new FocusNode());
                            var smsCode = getSmsCode();

                            widget.onSave(smsCode);
                          }
                        }),
                  ),
                ),
              ],
            ),
          ),
          widget.loading
              ? Container()
              : FlatButton(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(Icons.clear),
                      SizedBox(width: 10),
                      Text("Clear"),
                    ],
                  ),
                  onPressed: clear,
                ),
        ],
      ),
    );
  }

  void clear() {
    textController_1.clear();
    textController_2.clear();
    textController_3.clear();
    textController_4.clear();
    textController_5.clear();
    textController_6.clear();
    FocusScope.of(context).requestFocus(focus_1);
  }

  String getSmsCode() {
    String char_1 = textController_1.text;
    String char_2 = textController_2.text;
    String char_3 = textController_3.text;
    String char_4 = textController_4.text;
    String char_5 = textController_5.text;
    String char_6 = textController_6.text;
    String smsCode = char_1 + char_2 + char_3 + char_4 + char_5 + char_6;

    return smsCode;
  }
}
