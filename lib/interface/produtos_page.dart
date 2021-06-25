import 'package:how_vi/banco_de_dados/bd.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'novo_produto_page.dart';


enum OrdemOptions { ordemAZ, ordemZA }


class ProdutosPage extends StatefulWidget {


  @override
  _ProdutosPageState createState() => _ProdutosPageState();
}
// Página de listagem de Produtos
class _ProdutosPageState extends State<ProdutosPage> {


  ListaProdutos produtos = ListaProdutos();

  // ignore: deprecated_member_use
  List<Produto> produtoList = List();

  @override
  void initState() {
    super.initState();

    _getAllProdutos();
  }
// Gerando tela
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Produtos"),
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
          _showProdutosPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body:
      ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: produtoList.length,
          itemBuilder: (context, index) {
            return _produtoCard(context, index);
          }
      ),

    );
  }
















// Criacao do card
  Widget _produtoCard(BuildContext context, int index) {
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
                      image: produtoList[index].img != null ?
                      FileImage(File(produtoList[index].img)) :
                      AssetImage("images/sem-imagem.png"),
                      fit: BoxFit.cover
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(produtoList[index].nome ?? "",
                      style: TextStyle(fontSize: 22.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(produtoList[index].categoria ?? "",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Text(produtoList[index].valor ?? "",
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Text(produtoList[index].quantidade ?? "",
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
                        child: Text("Verificar",
                          style: TextStyle(color: Colors.red, fontSize: 20.0),
                        ),
                        onPressed: () {
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
                          _showProdutosPage(produto: produtoList[index]);
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
                          produtos.deleteProduto(produtoList[index].id);
                          setState(() {
                            produtoList.removeAt(index);
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
  void _showProdutosPage({Produto produto}) async {
    final recProduto = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => NovoProdutoPage(produto: produto,))
    );
    if (recProduto != null) {
      if (produto != null) {
        await produtos.updateProduto(recProduto);
        _getAllProdutos();
      } else {
        await produtos.saveProduto(recProduto);
      }
      _getAllProdutos();
    }
  }
// captura de todos os produtos
  void _getAllProdutos() {
    produtos.getAllProduto().then((list) {
      setState(() {
        produtoList = list;
      });
    });
  }
// funcao de ordenacao da lista de produtos
  void _ordemLista(OrdemOptions result) {
    switch (result) {
      case OrdemOptions.ordemAZ:
        produtoList.sort((a, b) {
          return a.nome.toLowerCase().compareTo(b.nome.toLowerCase());
        });
        break;
      case OrdemOptions.ordemZA:
        produtoList.sort((a, b) {
          return b.nome.toLowerCase().compareTo(a.nome.toLowerCase());
        });
        break;
    }
    setState(() {

    });
  }
}
