import 'package:how_vi/banco_de_dados/bd.dart';
import 'package:how_vi/interface/novo_pedido_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'novo_cliente_page.dart';


enum OrdemOptions { ordemAZ, ordemZA }


class PedidosPage extends StatefulWidget {


  @override
  _PedidosPageState createState() => _PedidosPageState();
}

class _PedidosPageState extends State<PedidosPage> {

  ListaPedidos pedidos = ListaPedidos();

  // ignore: deprecated_member_use
  List<Pedido> pedidoList = List();

  @override
  void initState() {
    super.initState();

    _getAllPedidos();
  }

// Gerando tela
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pedidos"),
        backgroundColor: Colors.red,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<OrdemOptions>(
            itemBuilder: (context) =>
            <PopupMenuEntry<OrdemOptions>>[
              const PopupMenuItem<OrdemOptions>(
                child: Text("Ordenar de A-Z"),
                value: OrdemOptions.ordemAZ,
              ),
              const PopupMenuItem<OrdemOptions>(
                child: Text("Ordenar de Z-A"),
                value: OrdemOptions.ordemZA,
              ),
            ],
            onSelected: _ordemLista,
          )
        ],
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showPedidosPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body:
      ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: pedidoList.length,
          itemBuilder: (context, index) {
            return _pedidoCard(context, index);
          }
      ),

    );
  }

// Criacao do card
  Widget _pedidoCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(pedidoList[index].produto ?? "",
                      style: TextStyle(fontSize: 22.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(pedidoList[index].quantidade ?? "",
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        _showOpcoes(context, index);
      },
    );
  }

// Opcoes ao clicar no botao
  void _showOpcoes(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container( //Janela com as opcoes
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  //essa função preenche o minimo de espaço na tela
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextButton(
                        child: Text("Editar",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _showPedidosPage(pedido: pedidoList[index]);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextButton(
                        child: Text("Excluir",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: () {
                          pedidos.deletePedido(pedidoList[index].id);
                          setState(() {
                            pedidoList.removeAt(index);
                            Navigator.pop(context);
                          });
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
    );
  }

// exibicao do conteúdo
  void _showPedidosPage({Pedido pedido}) async {
    final recPedido = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => NovoPedidoPage(pedido: pedido,))
    );
    if (recPedido != null) {
      if (pedido != null) {
        await pedidos.updatePedido(recPedido);
        _getAllPedidos();
      } else {
        await pedidos.savePedido(recPedido);
      }
      _getAllPedidos();
    }
  }
// captura de todos os Pedidos
  void _getAllPedidos() {
    pedidos.getAllPedido().then((list) {
      setState(() {
        pedidoList = list;
      });
    });
  }
// funcao de ordenacao da lista de Pedidos
  void _ordemLista(OrdemOptions result) {
    switch (result) {
      case OrdemOptions.ordemAZ:
        pedidoList.sort((a, b) {
          return a.produto.toLowerCase().compareTo(b.produto.toLowerCase());
        });
        break;
      case OrdemOptions.ordemZA:
        pedidoList.sort((a, b) {
          return b.produto.toLowerCase().compareTo(a.produto.toLowerCase());
        });
        break;
    }
    setState(() {

    });
  }
}
