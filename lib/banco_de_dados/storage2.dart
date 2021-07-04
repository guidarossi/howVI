import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import '../interface/novo_cliente_page.dart';



class AutoComplete extends StatefulWidget {
  @override
  _AutoCompleteState createState() => new _AutoCompleteState();
}

class _AutoCompleteState extends State<AutoComplete> {

  NovoClientePage novoClientePage  = NovoClientePage();

  static List<String> namesClientes;

  @override
  void initState() {
    super.initState();

    novoClientePage.createState().readData().then((data) => (){
      setState(() {
        namesClientes = json.decode(data);
      });
    });
  }

  List<String> added = [];
  String currentText = "";
  GlobalKey<AutoCompleteTextFieldState<String>> key = new GlobalKey();

  _AutoCompleteState() {
    textField = SimpleAutoCompleteTextField(
      key: key,
      decoration: new InputDecoration(errorText: "Beans"),
      controller: TextEditingController(text: "Starting Text"),
      suggestions: suggestions,
      textChanged: (text) => currentText = text,
      clearOnSubmit: true,
      textSubmitted: (text) => setState(() {
        if (text != "") {
          added.add(text);
        }
      }),
    );
  }

  List<String> suggestions = namesClientes;

  SimpleAutoCompleteTextField textField;
  bool showWhichErrorText = false;

  @override
  Widget build(BuildContext context) {
    Column body = new Column(children: [
      new ListTile(
          title: textField,
          trailing: new IconButton(
              icon: new Icon(Icons.add),
              onPressed: () {
                textField.triggerSubmitted();
                showWhichErrorText = !showWhichErrorText;
                textField.updateDecoration(
                    decoration: new InputDecoration(
                        errorText: showWhichErrorText ? "Beans" : "Tomatoes"));
              })),
    ]);

    body.children.addAll(added.map((item) {
      return new ListTile(title: new Text(item));
    }));

    return new Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: new AppBar(
            title: new Text('AutoComplete TextField Demo Simple'),
            actions: [
              new IconButton(
                  icon: new Icon(Icons.edit),
                  onPressed: () => showDialog(
                      builder: (_) {
                        String text = "";

                        return new AlertDialog(
                            title: new Text("Change Suggestions"),
                            content: new TextField(
                                onChanged: (newText) => text = newText),
                            actions: [
                              new TextButton(
                                  onPressed: () {
                                    if (text != "") {
                                      suggestions.add(text);
                                      textField.updateSuggestions(suggestions);
                                    }
                                    Navigator.pop(context);
                                  },
                                  child: new Text("Add")),
                            ]);
                      },
                      context: context))
            ]),
        body: body);
  }
}