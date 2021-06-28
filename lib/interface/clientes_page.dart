import 'package:how_vi/banco_de_dados/bd.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'novo_cliente_page.dart';


enum OrdemOptions { ordemAZ, ordemZA }


class ClientesPage extends StatefulWidget {


  @override
  _ClientesPageState createState() => _ClientesPageState();
}
// Página de listagem de Clientes
class _ClientesPageState extends State<ClientesPage> {

  ListaClientes clientes = ListaClientes();

  // ignore: deprecated_member_use
  List<Cliente> clienteList = List();

  @override
  void initState() {
    super.initState();

    _getAllClientes();
  }

// Gerando tela
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Clientes"),
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
          _showClientesPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body:
      ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: clienteList.length,
          itemBuilder: (context, index) {
            return _clienteCard(context, index);
          }
      ),

    );
  }

// Criacao do card
  Widget _clienteCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: clienteList[index].img != null ?
                      FileImage(File(clienteList[index].img)) :
                      AssetImage("images/perfilPng.png"),
                      fit: BoxFit.cover
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(clienteList[index].nome ?? "",
                      style: TextStyle(fontSize: 22.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(clienteList[index].email ?? "",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Text(clienteList[index].telefone ?? "",
                      style: TextStyle(fontSize: 18.0),
                    )
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
                        child: Text("Ligar",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: () {
                          launch("tel:${clienteList[index].telefone}");
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: TextButton(
                        child: Text("Editar",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          _showClientesPage(cliente: clienteList[index]);
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
                          clientes.deleteCliente(clienteList[index].id);
                          setState(() {
                            clienteList.removeAt(index);
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
  void _showClientesPage({Cliente cliente}) async {
    final recCliente = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => NovoClientePage(
                  cliente: cliente,))
    );
    if (recCliente != null) {
      if (cliente != null) {
        await clientes.updateCliente(recCliente);
        _getAllClientes();
      } else {
        await clientes.saveCliente(recCliente);
      }
      _getAllClientes();
    }
  }
// captura de todos os clientes
  void _getAllClientes() {
    clientes.getAllClientes().then((list) {
      setState(() {
        clienteList = list;
      });
    });
  }
// funcao de ordenacao da lista de clientes
  void _ordemLista(OrdemOptions result) {
    switch (result) {
      case OrdemOptions.ordemAZ:
        clienteList.sort((a, b) {
          return a.nome.toLowerCase().compareTo(b.nome.toLowerCase());
        });
        break;
      case OrdemOptions.ordemZA:
        clienteList.sort((a, b) {
          return b.nome.toLowerCase().compareTo(a.nome.toLowerCase());
        });
        break;
    }
    setState(() {

    });
  }
}
