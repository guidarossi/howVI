
import 'package:how_vi/interface/clientes_page.dart';

import 'package:flutter/material.dart';
import 'package:how_vi/interface/pedidos_page.dart';
import 'package:how_vi/interface/produtos_page.dart';





class HomePage extends StatefulWidget {


  @override
  _HomePageState createState() => _HomePageState();
}
// Tela Inicial do sistema
class _HomePageState extends State<HomePage> {







// Build do app
  @override
  Widget build(BuildContext context) {
    return Scaffold(


      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.red,
          primaryColor: Colors.white,

        ),
        child: BottomNavigationBar(
          onTap: (p){

          },
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.person),
              label: ("Clientes"),

            ),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart),
                label: ("Pedidos")
            ),
            BottomNavigationBarItem(icon: Icon(Icons.list),
                label: ("Produtos")
            ),
          ],
        ),
      ),
      body: PageView(
        children: <Widget>[
          ClientesPage(),
          PedidosPage(),
          ProdutosPage()
        ],
      ),
    );
  }


  /*Widget _pages(BuildContext context) {
    return Container(
      child: Row(
          children: <Widget>[
            Column(

            ),
            Column(

            ),
            Column(

            )
          ]
      ),
    );
  }*/




}