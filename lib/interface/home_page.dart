
import 'package:how_vi/interface/clientes_page.dart';

import 'package:flutter/material.dart';
import 'package:how_vi/interface/produtos_page.dart';





class HomePage extends StatefulWidget {


  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {








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
          Container(color: Colors.red,),
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