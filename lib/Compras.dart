import 'package:flutter/material.dart';

class Producto {
  final String nombre;
  final String descripcion;
  final double precio;


  Producto({required this.nombre, required this.descripcion, required this.precio});
}

class ComprasPage extends StatelessWidget {
  final List<Producto> productos = [
    Producto(
        nombre: 'Producto 1',
        descripcion: 'Descripción del producto 1',
        precio: 10.0,
        ),
    Producto(
        nombre: 'Producto 2',
        descripcion: 'Descripción del producto 2',
        precio: 20.0,
    ),
    Producto(
        nombre: 'Producto 3',
        descripcion: 'Descripción del producto 3',
        precio: 30.0,),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pantalla de Compras'),
      ),
      body: ListView.builder(
        itemCount: productos.length,
        itemBuilder: (BuildContext context, int index) {
          Producto producto = productos[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(
                producto.nombre,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                producto.descripcion,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
