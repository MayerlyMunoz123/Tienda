import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertienda_app/PagesUsuario/PaginaUser.dart';

class Producto {
  final String nombre;
  final String descripcion;
  final double precio;
  final String imageUrl;

  Producto({
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.imageUrl,
  });
}

class ComprasPage extends StatelessWidget {
  Future<List<Producto>> fetchProductos() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('productos').get();
    return snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;

      String nombre = data['nombre'] ?? '';
      String descripcion = data['descripcion'] ?? '';
      double precio = (data['precio'] ?? 0).toDouble();
      String imageUrl = data['imageUrl'] ?? '';

      return Producto(
        nombre: nombre,
        descripcion: descripcion,
        precio: precio,
        imageUrl: imageUrl,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
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
      body: FutureBuilder<List<Producto>>(
        future: fetchProductos(),
        builder:
            (BuildContext context, AsyncSnapshot<List<Producto>> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay productos disponibles.'));
          }

          List<Producto> productos = snapshot.data!;

          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75, 
            ),
            itemCount: productos.length,
            itemBuilder: (BuildContext context, int index) {
              Producto producto = productos[index];
              return Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: const Radius.circular(10),
                        ),
                        child: Image.network(
                          producto.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            producto.nombre,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '\$${producto.precio.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            producto.descripcion,
                            style: const TextStyle(
                              fontSize: 14,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
