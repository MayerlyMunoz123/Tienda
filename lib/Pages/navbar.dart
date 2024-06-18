import 'package:flutter/material.dart';
import 'package:fluttertienda_app/Pages/Compras.dart';
import 'package:fluttertienda_app/Pages/home.dart';
import 'package:fluttertienda_app/PagesUsuario/Home.dart';

class Navbar extends StatelessWidget {
  const Navbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Inicio"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const Navbar()));
              }),
          ListTile(
              leading: const Icon(Icons.account_box),
              title: const Text("Perfil"),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Home()));
              }),
          ListTile(
              leading: const Icon(Icons.shop_outlined),
              title: const Text("Compras"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const HomeProductos()));
              }),
               ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text("Cerrar Sesión"),
            onTap: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
            },
               )
              
        ],
      ),
    );
  }
}
