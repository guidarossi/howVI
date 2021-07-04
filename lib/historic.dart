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

    return List.generate(10, (index) {
    //print(clienteList[index].nome.toString());
      return {
        //matches.toString():clienteList.toString()
        //"nome":clienteList[index].nome.toString()
        "nome":"tati"
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return
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
          print("itemBuilder ");
          print(suggestion);
          return ListTile(
            title: Text(suggestion.toString()),

          );
        },
        onSuggestionSelected: (suggestion) {
          clienteList = suggestion;
        },
      );
  }

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

