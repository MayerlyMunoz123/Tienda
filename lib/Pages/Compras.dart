import 'package:flutter/material.dart';
import 'package:fluttertienda_app/Servicios/firepbase.service.dart';

class HomeProductos extends StatefulWidget {
  const HomeProductos({Key? key}) : super(key: key);

  @override
  State<HomeProductos> createState() => _HomeProductosState();
}

class _HomeProductosState extends State<HomeProductos> {
  final FirebaseService _firebaseService = FirebaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Administración de Productos"),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _firebaseService.getProductos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          List<Map<String, dynamic>> productos = snapshot.data ?? [];

          return ListView.builder(
            itemCount: productos.length,
            itemBuilder: (context, index) {
              var producto = productos[index];
              var nombre = producto["nombre"] ?? "";
              var descripcion = producto["descripcion"] ?? "";
              var imageUrl = producto["imageUrl"] ?? "";
              var precio = producto["precio"] ?? 0.0;
              var id = producto["id"] ?? ""; 

              return ListTile(
                title: Text(nombre),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(descripcion),
                    Text('\$$precio'),
                  ],
                ),
                leading: Image.network(
                  imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              _buildEditarProductoDialog(producto),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) =>
                              _buildEliminarProductoDialog(id),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => _buildCrearProductoDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildCrearProductoDialog() {
    final TextEditingController nombreController = TextEditingController();
    final TextEditingController descripcionController = TextEditingController();
    final TextEditingController imageUrlController = TextEditingController();
    final TextEditingController precioController = TextEditingController();

    return AlertDialog(
      title: const Text('Crear Producto'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nombreController,
            decoration: const InputDecoration(labelText: 'Nombre'),
          ),
          TextField(
            controller: descripcionController,
            decoration: const InputDecoration(labelText: 'Descripción'),
          ),
          TextField(
            controller: imageUrlController,
            decoration: const InputDecoration(labelText: 'URL de Imagen'),
          ),
          TextField(
            controller: precioController,
            decoration: const InputDecoration(labelText: 'Precio'),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () async {
            await _firebaseService.agregarProducto({
              'nombre': nombreController.text,
              'descripcion': descripcionController.text,
              'imageUrl': imageUrlController.text,
              'precio': double.parse(precioController.text),
            });
            Navigator.of(context).pop();
            setState(() {}); 
          },
          child: const Text('Crear'),
        ),
      ],
    );
  }

  Widget _buildEditarProductoDialog(Map<String, dynamic> producto) {
    final TextEditingController nombreController =
        TextEditingController(text: producto["nombre"]);
    final TextEditingController descripcionController =
        TextEditingController(text: producto["descripcion"]);
    final TextEditingController imageUrlController =
        TextEditingController(text: producto["imageUrl"]);
    final TextEditingController precioController =
        TextEditingController(text: producto["precio"].toString());

    return AlertDialog(
      title: const Text('Editar Producto'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nombreController,
            decoration: const InputDecoration(labelText: 'Nombre'),
            onChanged: (value) {
              setState(() {
                producto["nombre"] = value; 
              });
            },
          ),
          TextField(
            controller: descripcionController,
            decoration: const InputDecoration(labelText: 'Descripción'),
            onChanged: (value) {
              setState(() {
                producto["descripcion"] = value; 
              });
            },
          ),
          TextField(
            controller: imageUrlController,
            decoration: const InputDecoration(labelText: 'URL de Imagen'),
            onChanged: (value) {
              setState(() {
                producto["imageUrl"] = value; 
              });
            },
          ),
          TextField(
            controller: precioController,
            decoration: const InputDecoration(labelText: 'Precio'),
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                producto["precio"] = double.parse(value); 
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () async {
            await _firebaseService.actualizarProducto(producto["id"], {
              'nombre': nombreController.text,
              'descripcion': descripcionController.text,
              'imageUrl': imageUrlController.text,
              'precio': double.parse(precioController.text),
            });
            Navigator.of(context).pop();
            setState(() {}); 
          },
          child: const Text('Actualizar'),
        ),
      ],
    );
  }

  Widget _buildEliminarProductoDialog(String idProducto) {
    if (idProducto.isEmpty) {
      return AlertDialog(
        title: const Text('Error'),
        content: const Text('No se puede eliminar el producto porque el ID es nulo.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cerrar'),
          ),
        ],
      );
    }

    return AlertDialog(
      title: const Text('Confirmar eliminación'),
      content: const Text('¿Estás seguro de que deseas eliminar este producto?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () async {
            await _firebaseService.eliminarProducto(idProducto);
            Navigator.of(context).pop();
            setState(() {}); 
          },
          child: const Text('Eliminar'),
        ),
      ],
    );
  }
}
