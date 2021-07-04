import 'package:autocomplete_textfield/autocomplete_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'banco_de_dados/bd.dart';


class BackendService extends StatefulWidget {
  @override
  _BackendServiceState createState() => _BackendServiceState();
}

class _BackendServiceState extends State<BackendService> {
  ListaClientes clientes = ListaClientes();


  List<Cliente> clienteList;


  @override
  void initState() {
    super.initState();
    clientes.getCliente2();
  }

  void getAllClientes(String query) {
    clientes.getAllClientesNames(query).then((list) {
      clienteList = list as List<Cliente>;
    });
  }


   Future<List<Map<String, String>>> getSuggestions() async {
    await Future.delayed(Duration(seconds: 1));
    List<String> matches = <String>[];

    return List.generate(matches.toString().length, (index) {
    //print(clienteList[index].nome.toString());
      return {
        matches.toString():clienteList.first.nome
        //"nome":clienteList[index].nome.toString()
        //"nome":"tati"
      };
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children:[
      TypeAheadField(
        textFieldConfiguration: TextFieldConfiguration(
            autofocus: true,
            style: DefaultTextStyle
                .of(context)
                .style
                .copyWith(
                fontStyle: FontStyle.italic
            ),
            decoration: InputDecoration(
                border: OutlineInputBorder()
            )
        ),
        suggestionsCallback: (pattern) async {
          getAllClientes(pattern);
          return getSuggestions();
        },
        itemBuilder: (context, suggestion) {
          return ListTile(
            title: Text(suggestion.toString()),

          );
        },
        onSuggestionSelected: (suggestion) {
          clienteList = suggestion;
        },
      ),

    Column(

    children: [
    new ListTile(
    title: textField,
    trailing: new IconButton(
    icon: new Icon(Icons.add),
    onPressed: () {
    textField.triggerSubmitted();
    showWhichErrorText = !showWhichErrorText;
    textField.updateDecoration(
    decoration: new InputDecoration(
    errorText: showWhichErrorText
    ? "Beans"
        : "Tomatoes"));
    })),
    ])






  ]
      )
    );
  }

  List<String> added = [];
  String currentText = "";

  SimpleAutoCompleteTextField textField;
  bool showWhichErrorText = false;



    Widget newColumn() {



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

      );
    }
List<String> suggestions = [];


}





class CitiesService {
  static final List<String> cities = BackendService().createState().clienteList.cast<String>();

  static List<String> getSuggestions(String query) {
    List<String> matches = <String>[];
    matches.addAll(cities);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}

