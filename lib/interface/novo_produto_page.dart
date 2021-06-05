import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:how_vi/banco_de_dados/bd.dart';
import 'package:image_picker/image_picker.dart';



class NovoProdutoPage extends StatefulWidget {

  final Produto produto;

  NovoProdutoPage({this.produto}); // entre {} contato opcional


  @override
  _NovoProdutoPage createState() => _NovoProdutoPage();
}

class _NovoProdutoPage extends State<NovoProdutoPage> {

  final _nomeController = TextEditingController();
  final _categoriaController = TextEditingController();
  final _valorController = TextEditingController();
  final _quantidadeController = TextEditingController();

  final _nomeFocus = FocusNode();

  bool _produtoEditar = false;

  Produto _editarProduto;

  @override
  void initState() {
    super.initState();

    if (widget.produto == null) {
      _editarProduto = Produto();
    } else {
      _editarProduto = Produto.fromMap(widget.produto.toMap());

      _nomeController.text = _editarProduto.nome;
      _categoriaController.text = _editarProduto.categoria;
      _valorController.text = _editarProduto.valor as String;
      _quantidadeController.text = _editarProduto.quantidade as String;
    }
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(_editarProduto.nome ?? "Novo Produto"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            if(_editarProduto.nome != null && _editarProduto.nome.isNotEmpty){
              Navigator.pop(context, _editarProduto); // POP volta para a tela anterior
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
                        image: _editarProduto.img != null ?
                        FileImage(File(_editarProduto.img)) :
                        AssetImage("images/sem-imagem.png"),
                        fit: BoxFit.cover
                    ),
                  ),
                ),
                onTap: (){

                  // ignore: deprecated_member_use
                  ImagePicker.pickImage(source: ImageSource.camera).then((file){
                    if(file == null) return;
                    setState(() {
                      _editarProduto.img = file.path;
                    });
                  });
                },
              ),
              TextField(
                controller: _nomeController,
                focusNode: _nomeFocus,
                decoration: InputDecoration(labelText: "Nome do Produto"),
                onChanged: (text){
                  _produtoEditar = true;
                  setState(() {
                    _editarProduto.nome = text;
                  });
                },
              ),
              TextField(
                controller: _categoriaController,
                decoration: InputDecoration(labelText: "Categoria"),
                onChanged: (text){
                  _produtoEditar = true;
                  _editarProduto.categoria = text;
                },
              ),
              TextField(
                controller: _valorController,
                decoration: InputDecoration(labelText: "Valor"),
                onChanged: (text){
                  _produtoEditar = true;
                  _editarProduto.valor = text as double;
                },
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _quantidadeController,
                decoration: InputDecoration(labelText: "Quantidade"),
                onChanged: (text){
                  _produtoEditar = true;
                  _editarProduto.quantidade = text as int;
                },
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ),
    );
  }



  Future<bool> _requestPop(){
    if(_produtoEditar){
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