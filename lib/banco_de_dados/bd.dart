
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';



final String tabelaClientes = "tabelaClientes";
final String idColumn = "idColumn";
final String nomeColumn = "nomeColumn";
final String emailColumn = "emailColumn";
final String telefoneColumn = "telefoneColumn";
final String imgColumn = "imgColumn";

final String tabelaPedidos = "tabelaPedidos";
final String clienteColumn = "nomeCliente";
final String quantidadeColumn = "quantidade";
final String produtoColumn = "produto";
final String idPedido = "idPedido";

final String tabelaProdutos = "tabelaProdutos";
final String idProduto = "idProduto";
final String nomeProduto = "nomeProduto";
final String categoriaProduto = "categoriaProduto";
final String valorProduto = "valorProduto";
final String quantidadeProduto = "quantidadeProduto";
final String imgProduto = "imgProduto";


class ListaClientes {


  static final ListaClientes _instance = ListaClientes.interno();

  factory ListaClientes() => _instance;

  ListaClientes.interno();

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "clientes.db");

    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newerVersion) async {
          await db.execute(
              "CREATE TABLE $tabelaClientes($idColumn INTEGER PRIMARY KEY, $nomeColumn TEXT, $emailColumn TEXT,"
                  "$telefoneColumn TEXT, $imgColumn TEXT)");
        });
  }

  Future<List<String>> getClientes() async {
    Database dbCliente = await db;

    final getClientes = await dbCliente.query("$tabelaClientes");

    return getClientes.map((Map<String, dynamic> row) {
      return row["$nomeColumn"] as String;
    }).toList();
  }

// ignore: missing_return
  Future<String> getCliente2() async {
    Database dbCliente = await db;
    List<Map> maps = await dbCliente.query(
        tabelaClientes, //query me permite pegar apenas os dados que eu quiser
        columns: [nomeColumn],
        where: "$nomeColumn = ?",
        whereArgs: [

        ] //obter o contato onde traga apenas o contato id da coluna que id que foi chamada
    );
    if (maps.length != null) {
      return Cliente().nome;
      // ignore: unnecessary_statements
    } else null;
  }


  Future<Cliente> saveCliente(Cliente cliente) async {
    Database dbCliente = await db;
    cliente.id = await dbCliente.insert(tabelaClientes, cliente.toMap());
    return cliente;
  }

  // ignore: missing_return
  Future<Cliente> getCliente(int id) async {
    Database dbCliente = await db;
    List<Map> maps = await dbCliente.query(
        tabelaClientes, //query me permite pegar apenas os dados que eu quiser
        columns: [idColumn, nomeColumn, emailColumn, telefoneColumn, imgColumn],
        where: "$id = ?",
        whereArgs: [
          id
        ] //obter o contato onde traga apenas o contato id da coluna que id que foi chamada
    );
    if (maps.length > 0) {
      return Cliente.fromMap(maps.first);
      // ignore: unnecessary_statements
    } else null;
  }

  Future<int> deleteCliente(int id) async {
    Database dbCliente = await db;
    return await dbCliente.delete(
        tabelaClientes, where: "$idColumn = ?", whereArgs: [id]);
  }

  Future<int> updateCliente(Cliente cliente) async {
    Database dbCliente = await db;
    return await dbCliente.update(tabelaClientes, cliente.toMap(),
        where: "$idColumn = ?", whereArgs: [cliente.id]);
  }

  Future<List> getAllClientes() async {
    Database dbCliente = await db;
    List listMap = await dbCliente.rawQuery("SELECT * FROM $tabelaClientes");
    // ignore: deprecated_member_use
    List<Cliente> listCliente = List();
    for (Map m in listMap) {
      listCliente.add(Cliente.fromMap(m));
    }
    return listCliente;
  }

  Future<List> getAllClientesNames(String query) async {
    Database dbCliente = await db;

      List listMap = await dbCliente.rawQuery(
          "SELECT $idColumn, $nomeColumn FROM $tabelaClientes where $nomeColumn like '%"+query+"%' ");

    // ignore: deprecated_member_use
    List<Cliente> listCliente = List();

    for (Map m in listMap) {
      listCliente.add(Cliente.fromMap(m));
      //ListCliente.add(Cliente(id:m["id"],nome:m["name"]));
    }
    return listCliente;
  }

  Future<int> getNum() async {
    Database dbCliente = await db;
    return Sqflite.firstIntValue(
        await dbCliente.rawQuery("SELECT COUNT(*) FROM $tabelaClientes"));
  }

  Future close() async {
    Database dbCliente = await db;
    dbCliente.close();
  }

}
class Cliente {
  int id;
  String nome;
  String email;
  String telefone;
  String img;

  Cliente();


  Cliente.fromMap(Map map) {
    id = map[idColumn];
    nome = map[nomeColumn];
    email = map[emailColumn];
    telefone = map[telefoneColumn];
    img = map[imgColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      nomeColumn: nome,
      emailColumn: email,
      telefoneColumn: telefone,
      imgColumn: img
    };

    if (id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Contact(id: $id, name: $nome, email: $email, phone: $telefone, img: $img)";
  }
}


class ListaPedidos {

  static final ListaPedidos _instance = ListaPedidos.interno();

  factory ListaPedidos() => _instance;

  ListaPedidos.interno();

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "pedidos.db");

    return await openDatabase(
        path, version: 2, onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $tabelaPedidos($idPedido INTEGER PRIMARY KEY, $clienteColumn TEXT, $produtoColumn TEXT, $quantidadeColumn TEXT )"
      );
    });
  }

  Future<Pedido> savePedido(Pedido pedido) async {
    Database dbPedido = await db;
    pedido.id = await dbPedido.insert(tabelaPedidos, pedido.toMap());
    return pedido;
  }

  // ignore: missing_return
  Future<Pedido> getPedido(int id) async {
    Database dbPedido = await db;
    List<Map> maps = await dbPedido.query(tabelaPedidos, //query me permite pegar apenas os dados que eu quiser
        columns: [idPedido, produtoColumn, quantidadeColumn],
        where: "$id = ?",
        whereArgs: [id] //obter o contato onde traga apenas o contato id da coluna que id que foi chamada
    );
    if(maps.length > 0){
      return Pedido.fromMap(maps.first);
      // ignore: unnecessary_statements
    } else null;

  }

  Future<int> deletePedido(int id) async{

    Database dbPedido = await db;
    return await dbPedido.delete(tabelaPedidos, where: "$idPedido = ?", whereArgs: [id]);
  }

  Future<int> updatePedido(Pedido pedido) async{
    Database dbPedido = await db;
    return await dbPedido.update(tabelaPedidos,
        pedido.toMap(),
        where: "$idPedido = ?",
        whereArgs: [pedido.id]);
  }

  Future<List> getAllPedido() async{
    Database dbPedido = await db;
    List listMap = await dbPedido.rawQuery("SELECT * FROM $tabelaPedidos");
    // ignore: deprecated_member_use
    List<Pedido> listPedido = List();
    for(Map m in listMap){
      listPedido.add(Pedido.fromMap(m));
    }
    return listPedido;
  }

  Future<int> getNumP() async{
    Database dbPedido = await db;
    return Sqflite.firstIntValue(await dbPedido.rawQuery("SELECT COUNT(*) FROM $tabelaPedidos"));
  }

  Future close() async {
    Database dbPedido = await db;
    dbPedido.close();
  }



}


class Pedido {

  int id;
  String nomeCliente;
  String quantidade;
  String produto;

  Pedido();

  Pedido.fromMap(Map map){
    id = map[idColumn];
    nomeCliente = map[clienteColumn];
    quantidade = map[quantidadeColumn];
    produto = map[produtoColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      quantidadeColumn: quantidade,
      produtoColumn: produto,
      clienteColumn: nomeCliente
    };

    if(id != null){
      map[idColumn] = id;
    }
    return map;
  }

}


class ListaProdutos {
  static final ListaProdutos _instance = ListaProdutos.interno();

  factory ListaProdutos() => _instance;

  ListaProdutos.interno();

  Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    } else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "produtos.db");

    return await openDatabase(path, version: 2,
        onCreate: (Database db, int newerVersion) async {
      await db.execute(
          "CREATE TABLE $tabelaProdutos($idProduto INTEGER PRIMARY KEY, $nomeProduto TEXT, $categoriaProduto TEXT,"
          "$valorProduto TEXT, $quantidadeProduto TEXT ,$imgColumn TEXT)");
    });
  }

  Future<Produto> saveProduto(Produto produto) async {
    Database dbProduto = await db;
    produto.id = await dbProduto.insert(tabelaProdutos, produto.toMap());
    return produto;
  }

  // ignore: missing_return
  Future<Produto> getProduto(int id) async {
    Database dbProduto = await db;
    List<Map> maps = await dbProduto.query(
        tabelaProdutos, //query me permite pegar apenas os dados que eu quiser
        columns: [
          idProduto,
          nomeProduto,
          categoriaProduto,
          valorProduto,
          quantidadeProduto,
          imgColumn
        ],
        where: "$id = ?",
        whereArgs: [
          id
        ] //obter o contato onde traga apenas o contato id da coluna que id que foi chamada
        );
    if (maps.length > 0) {
      return Produto.fromMap(maps.first);
      // ignore: unnecessary_statements
    } else null;
  }

  Future<int> deleteProduto(int id) async {
    Database dbProduto = await db;
    return await dbProduto
        .delete(tabelaProdutos, where: "$idProduto = ?", whereArgs: [id]);
  }

  Future<int> updateProduto(Produto produto) async {
    Database dbProduto = await db;
    return await dbProduto.update(tabelaProdutos, produto.toMap(),
        where: "$idProduto = ?", whereArgs: [produto.id]);
  }

  Future<List> getAllProduto() async {
    Database dbProduto = await db;
    List listMap = await dbProduto.rawQuery("SELECT * FROM $tabelaProdutos");
    // ignore: deprecated_member_use
    List<Produto> listProduto = List();
    for (Map m in listMap) {
      listProduto.add(Produto.fromMap(m));
    }
    return listProduto;
  }

  Future<int> getNumP() async {
    Database dbProduto = await db;
    return Sqflite.firstIntValue(
        await dbProduto.rawQuery("SELECT COUNT(*) FROM $tabelaProdutos"));
  }

  Future close() async {
    Database dbProduto = await db;
    dbProduto.close();
  }

}

class Produto {
  int id;
  String nome;
  String categoria;
  String valor;
  String quantidade;
  String img;

  Produto();

  Produto.fromMap(Map map) {
    id = map[idProduto];
    nome = map[nomeProduto];
    categoria = map[categoriaProduto];
    valor = map[valorProduto];
    quantidade = map[quantidadeProduto];
    img = map[imgColumn];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      nomeProduto: nome,
      categoriaProduto: categoria,
      valorProduto: valor,
      quantidadeProduto: quantidade,
      imgColumn: img
    };

    if (id != null) {
      map[idProduto] = id;
    }
    return map;
  }
}





