import 'package:flutter/material.dart';
import 'package:fluttertienda_app/Configuracion.dart';
import 'package:fluttertienda_app/Perfil.dart';
import 'package:fluttertienda_app/navbar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Menu App',
      home: Scaffold(
        drawer: const Navbar(),
        appBar: AppBar(
          title: const Text('Material App Bar'),
          backgroundColor: Colors.amber,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Pagina inicial',
                style: TextStyle(fontSize: 45.0),
              ),
              Builder(
                builder: (BuildContext context) {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PerfilPage()),
                      );
                    },
                    child: const Text('Ir a Perfil'),
                  );
                },
              ),
              const SizedBox(height: 20),
              Builder(
                builder: (BuildContext context) {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const RegisterPage()),
                      );
                    },
                    child: const Text('Registrate'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
