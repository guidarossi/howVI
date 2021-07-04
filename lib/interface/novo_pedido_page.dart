import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:how_vi/banco_de_dados/bd.dart';
import 'package:how_vi/historic.dart';
import '../historic.dart';




// Tela de Pedidos
class NovoPedidoPage extends StatefulWidget {

  final Pedido pedido;
  final ListaClientes listaClientes;

  NovoPedidoPage({this.pedido, this.listaClientes}); // entre {} contato opcional

  @override
  _PedidoPage createState() => _PedidoPage();
}

class _PedidoPage extends State<NovoPedidoPage> {

  final _nomeProdutoController = TextEditingController();
  final _quantidadeController = TextEditingController();
  final _nomeClienteController = TextEditingController();

  final _nomeFocus = FocusNode();

  bool _userEditar = false;

  List<String> itemsList;


  Pedido _editarPedido;

  @override
  void initState() {
    super.initState();

    if (widget.pedido == null) {
      _editarPedido = Pedido();

    } else {
      _editarPedido = Pedido.fromMap(widget.pedido.toMap());


      _nomeClienteController.text = _editarPedido.nomeCliente;
      _nomeProdutoController.text = _editarPedido.produto;
      _quantidadeController.text = _editarPedido.quantidade;
    }
  }




// Build da tela
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text(_editarPedido.produto ?? "Pedido"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            if(_editarPedido.produto != null && _editarPedido.produto.isNotEmpty){
              Navigator.pop(context, _editarPedido); // POP volta para a tela anterior
            } else {
              FocusScope.of(context).requestFocus(_nomeFocus); //não salva com o campo name vazio e indica o campo
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.red,
        ),
        body:BackendService()
      ),
    );
  }






//Pergunta ao solicitar sair sem salvar
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

class ProductPage extends StatelessWidget {
  final Map<String, String> product;

  ProductPage({this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: [
            Text(
              this.product['name'],
              style: Theme.of(context).textTheme.headline5,
            ),

          ],
        ),
      ),
    );
  }
}