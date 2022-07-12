import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class ListaUsuarios extends StatelessWidget {
  Future<List<Map<String, Object?>>> buscarDados2() async {
    String caminhBD = join(await getDatabasesPath(), 'banco.db');
    Database banco =
    await openDatabase(caminhBD, version: 1, onCreate: (db, version) {
      db.execute(''' 
        CREATE TABLE usuario(
          id INTEGER PRIMARY KEY,
          nome TEXT NOT NULL,
          descricao TEXT NOT NULL
        )
      ''');
      db.execute(
          'INSERT INTO usuario (nome, email ) VALUES ("Matheus", "mthws.henrique@hotmail.com")');
      db.execute(
          'INSERT INTO usuario (nome, email ) VALUES ("Igor", "igor.email@hotmail.br")');
      db.execute(
          'INSERT INTO usuario (nome, email ) VALUES ("Fulano", "ciclano@@beltrano.com")');
    });

    List<Map<String, Object?>> usuario =
    await banco.rawQuery('SELECT * FROM usuario');
    return usuario;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Usuários'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, '/addUsuarios'),
          )
        ],
      ),
      body: FutureBuilder(
        future: buscarDados2(),
        builder:
            (context, AsyncSnapshot<List<Map<String, Object?>>> dadosFuturos) {
          if (!dadosFuturos.hasData) return const CircularProgressIndicator();
          var usuario = dadosFuturos.data!;
          return ListView.builder(
            itemCount: usuario.length,
            itemBuilder: (context, index) {
              var usuarios = usuario[index];

              return Card(
                elevation: 4,
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.black,
                    child: Text(usuario[index]["nome"]
                        .toString()
                        .substring(0, 1)
                        .toUpperCase()),
                  ),
                  title: Text(usuarios['nome'].toString()),
                  subtitle: Text(usuarios['descricao'].toString()),
                  trailing: const Icon(Icons.arrow_forward_ios_outlined),
                ),
              );
            },
          );
        },
      ),
    );
  }
}