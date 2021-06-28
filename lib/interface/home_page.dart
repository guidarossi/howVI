
import 'package:how_vi/interface/clientes_page.dart';

import 'package:flutter/material.dart';
import 'package:how_vi/interface/pedidos_page.dart';
import 'package:how_vi/interface/produtos_page.dart';





class HomePage extends StatefulWidget {


  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {


  PageController _pageController;
  int _page = 0;


  @override
  void initState() {
    super.initState();

    _pageController = PageController();
  }


  @override
  void dispose() {
    _pageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.red,
          primaryColor: Colors.white,

        ),
        child: BottomNavigationBar(
          currentIndex: _page,
          onTap: (p){
            _pageController.animateToPage(p, duration: Duration(milliseconds: 500), curve: Curves.ease);
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
        controller: _pageController,
        onPageChanged: (p){
          setState(() {
            _page = p;
          });
        },
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