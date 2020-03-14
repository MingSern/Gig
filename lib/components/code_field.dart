import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Gig/utils/device.dart';

class CodeField extends StatefulWidget {
  final Function(String, dynamic) onSave;
  final bool loading;

  CodeField({
    @required this.onSave,
    this.loading = false,
  });

  @override
  _CodeFieldState createState() => _CodeFieldState();
}

class _CodeFieldState extends State<CodeField> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  FocusNode focus_1;
  FocusNode focus_2;
  FocusNode focus_3;
  FocusNode focus_4;
  FocusNode focus_5;
  FocusNode focus_6;
  TextEditingController textController_1;
  TextEditingController textController_2;
  TextEditingController textController_3;
  TextEditingController textController_4;
  TextEditingController textController_5;
  TextEditingController textController_6;

  @override
  void initState() {
    focus_1 = new FocusNode();
    focus_2 = new FocusNode();
    focus_3 = new FocusNode();
    focus_4 = new FocusNode();
    focus_5 = new FocusNode();
    focus_6 = new FocusNode();

    textController_1 = new TextEditingController();
    textController_2 = new TextEditingController();
    textController_3 = new TextEditingController();
    textController_4 = new TextEditingController();
    textController_5 = new TextEditingController();
    textController_6 = new TextEditingController();

    textController_1.addListener(() {
      if (textController_1.text.length > 0) {
        FocusScope.of(context).requestFocus(focus_2);
      }
    });

    textController_2.addListener(() {
      if (textController_2.text.length > 0) {
        FocusScope.of(context).requestFocus(focus_3);
      }
    });

    textController_3.addListener(() {
      if (textController_3.text.length > 0) {
        FocusScope.of(context).requestFocus(focus_4);
      }
    });

    textController_4.addListener(() {
      if (textController_4.text.length > 0) {
        FocusScope.of(context).requestFocus(focus_5);
      }
    });

    textController_5.addListener(() {
      if (textController_5.text.length > 0) {
        FocusScope.of(context).requestFocus(focus_6);
      }
    });

    textController_6.addListener(() {
      if (textController_6.text.length > 0) {
        FocusScope.of(context).requestFocus(new FocusNode());
        var smsCode = getSmsCode();
        widget.onSave(smsCode, formKey);
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    textController_1.dispose();
    textController_2.dispose();
    textController_3.dispose();
    textController_4.dispose();
    textController_5.dispose();
    textController_6.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: Device.getMaxWidth(context) * 0.7,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      child: TextField(
                        enabled: !widget.loading,
                        controller: textController_1,
                        focusNode: focus_1,
                        autofocus: true,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(5),
                          counterText: "",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      child: TextField(
                        enabled: !widget.loading,
                        controller: textController_2,
                        focusNode: focus_2,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(5),
                          counterText: "",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      child: TextField(
                        enabled: !widget.loading,
                        controller: textController_3,
                        focusNode: focus_3,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(5),
                          counterText: "",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      child: TextField(
                        enabled: !widget.loading,
                        controller: textController_4,
                        focusNode: focus_4,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(5),
                          counterText: "",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      child: TextField(
                        enabled: !widget.loading,
                        controller: textController_5,
                        focusNode: focus_5,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(5),
                          counterText: "",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      child: TextField(
                        enabled: !widget.loading,
                        controller: textController_6,
                        focusNode: focus_6,
                        textAlign: TextAlign.center,
                        maxLength: 1,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(5),
                          counterText: "",
                          border: OutlineInputBorder(),
                        ),
                      ),
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
