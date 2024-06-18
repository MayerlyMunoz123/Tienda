import 'package:flutter/material.dart';
import 'package:fluttertienda_app/PagesUsuario/PaginaUser.dart';

class DescripcionPage extends StatelessWidget {
  const DescripcionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Descripción'),
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), 
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const UserNavbar()),
            );
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.lightBlueAccent,
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            margin: const EdgeInsets.symmetric(horizontal: 30.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: const Text(
              'Proyecto enfocado en una tienda de ropa de segunda mano. Aquí podrás encontrar ropa que aún puede ser utilizada.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
