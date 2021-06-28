import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:how_vi/banco_de_dados/bd.dart';
import 'package:image_picker/image_picker.dart';

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

}