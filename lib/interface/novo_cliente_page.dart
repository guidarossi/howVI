import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:how_vi/banco_de_dados/bd.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';



class NovoClientePage extends StatefulWidget {



  final Cliente cliente;

  NovoClientePage({this.cliente}); // entre {} contato opcional

  @override
  _ClientePage createState() => _ClientePage();
}

class _ClientePage extends State<NovoClientePage> {

  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();

  final _nomeFocus = FocusNode();

  bool _userEditar = false;

  Cliente _editarCliente;

  @override
  void initState() {
    super.initState();

    readData().then((value) => (data){
      setState(() {
        toDoList = json.decode(data);
      });
    });

    if (widget.cliente == null) {
      _editarCliente = Cliente();
    } else {
      _editarCliente = Cliente.fromMap(widget.cliente.toMap());

      _nomeController.text = _editarCliente.nome;
      _emailController.text = _editarCliente.email;
      _telefoneController.text = _editarCliente.telefone;
    }
  }








  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(_editarCliente.nome ?? "Novo Cliente"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            _addToName();
            saveData();
            print("PRINT $toDoList");

            if(_editarCliente.nome != null && _editarCliente.nome.isNotEmpty){
              Navigator.pop(context, _editarCliente); // POP volta para a tela anterior
            } else {
              FocusScope.of(context).requestFocus(_nomeFocus); //não salva com o campo name vazio e indica o campo
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.red,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              GestureDetector(
                child: Container(
                  width: 140.0,
                  height: 140.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: _editarCliente.img != null ?
                        FileImage(File(_editarCliente.img)) :
                        AssetImage("images/perfilPng.png"),
                        fit: BoxFit.cover
                    ),
                  ),
                ),
                onTap: (){

                  // ignore: deprecated_member_use
                  ImagePicker.pickImage(source: ImageSource.camera).then((file){
                    if(file == null) return;
                    setState(() {
                      _editarCliente.img = file.path;
                    });
                  });
                },
              ),
              TextField(
                controller: _nomeController,
                focusNode: _nomeFocus,
                decoration: InputDecoration(labelText: "Nome"),
                onChanged: (text){
                  _userEditar = true;
                  setState(() {
                    _editarCliente.nome = text;
                  });
                },
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
                onChanged: (text){
                  _userEditar = true;
                  _editarCliente.email = text;
                },
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: _telefoneController,
                decoration: InputDecoration(labelText: "Phone"),
                onChanged: (text){
                  _userEditar = true;
                  _editarCliente.telefone = text;
                },
                keyboardType: TextInputType.phone,
              ),
            ],
          ),
        ),
      ),
    );
  }







  Future<bool> _requestPop(){
    if(_userEditar){
      showDialog(context: context,
          builder: (context){
            return AlertDialog(
              title: Text("Descartar Alterações?"),
              content: Text("Se sair as alterações serão perdidas."),
              actions: <Widget>[
                TextButton(
                  child: Text("Cancelar"),
                  onPressed: (){
                    Navigator.pop(context);
                  },
                ),
                TextButton(
                  child: Text("Sim"),
                  onPressed: (){
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          }
      );
      return Future.value(false); //nao permite que o usuario saia da tela
    } else {
      return Future.value(true); //ppermite que o usuario saia da tela
    }
  }



  List toDoList = [];

  void _addToName(){
    setState(() {
      Map<String, dynamic> newName = Map();
      newName["Nome"] = _nomeController.text;
      _nomeController.text = '';
      newName["Email"] = _emailController.text;
      _emailController.text = '';
      newName["Phone"] = _telefoneController.text;
      _telefoneController.text = '';
      toDoList.add(newName);
      saveData();
    });
  }



  Future<File> getFile() async{
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/clientes.json");
  }

  Future<File> saveData() async {
    String data = json.encode(toDoList);
    final file = await getFile();
    return file.writeAsString(data);
  }

  Future<String> readData() async{
    try{
      final file = await getFile();
      return file.readAsString();
    }catch (e){
      return null;
    }
  }


}


class ClientesName {
  int id;
  String name;

  ClientesName({this.id, this.name});

  ClientesName.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    return data;
  }
}

class ClientesViewModel {

  static List<ClientesName> clientes;

  static Future loadClientes() async {
    try {
      // ignore: deprecated_member_use
      clientes = new List<ClientesName>();
      String jsonString = await rootBundle.loadString("assets/clientes.json");
      Map parsedJson = json.decode(jsonString);
      var categoryJson = parsedJson['name'] as List;
      for (int i = 0; i < categoryJson.length; i++) {
        clientes.add(new ClientesName.fromJson(categoryJson[i]));
      }
    } catch (e) {
      print(e);
    }
  }
}

