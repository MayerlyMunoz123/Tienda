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
    final _formKey = GlobalKey<FormState>();
    final TextEditingController nombreController = TextEditingController();
    final TextEditingController descripcionController = TextEditingController();
    final TextEditingController imageUrlController = TextEditingController();
    final TextEditingController precioController = TextEditingController();

    return AlertDialog(
      title: const Text('Crear Producto'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese un nombre';
                }
                if (RegExp(r'\d').hasMatch(value)) {
                  return 'El nombre no debe contener números';
                }
                return null;
              },
            ),
            TextFormField(
              controller: descripcionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese una descripción';
                }
                return null;
              },
            ),
            TextFormField(
              controller: imageUrlController,
              decoration: const InputDecoration(labelText: 'URL de Imagen'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese una URL de imagen';
                }
                return null;
              },
            ),
            TextFormField(
              controller: precioController,
              decoration: const InputDecoration(labelText: 'Precio'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese un precio';
                }
                final double? precio = double.tryParse(value);
                if (precio == null || precio <= 0) {
                  return 'Por favor ingrese un precio válido mayor a 0';
                }
                return null;
              },
            ),
          ],
        ),
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
            if (_formKey.currentState!.validate()) {
              await _firebaseService.agregarProducto({
                'nombre': nombreController.text,
                'descripcion': descripcionController.text,
                'imageUrl': imageUrlController.text,
                'precio': double.parse(precioController.text),
              });
              Navigator.of(context).pop();
              setState(() {}); 
            }
          },
          child: const Text('Crear'),
        ),
      ],
    );
  }

  Widget _buildEditarProductoDialog(Map<String, dynamic> producto) {
    final _formKey = GlobalKey<FormState>();
    final TextEditingController nombreController =
        TextEditingController(text: producto["nombre"]);
    final TextEditingController descripcionController =
        TextEditingController(text: producto["descripcion"]);
    final TextEditingController imageUrlController =
        TextEditingController(text: producto["imageUrl"]);
    final TextEditingController precioController =
        TextEditingController(text: producto["precio"].toString());

    return AlertDialog(
      title: const Text('Editar Estilo'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: nombreController,
              decoration: const InputDecoration(labelText: 'Nombre'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese un nombre';
                }
                if (RegExp(r'\d').hasMatch(value)) {
                  return 'El nombre no debe contener números';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  producto["nombre"] = value; 
                });
              },
            ),
            TextFormField(
              controller: descripcionController,
              decoration: const InputDecoration(labelText: 'Descripción'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese una descripción';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  producto["descripcion"] = value; 
                });
              },
            ),
            TextFormField(
              controller: imageUrlController,
              decoration: const InputDecoration(labelText: 'URL de Imagen'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese una URL de imagen';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  producto["imageUrl"] = value; 
                });
              },
            ),
            TextFormField(
              controller: precioController,
              decoration: const InputDecoration(labelText: 'Precio'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor ingrese un precio';
                }
                final double? precio = double.tryParse(value);
                if (precio == null || precio <= 0) {
                  return 'Por favor ingrese un precio válido mayor a 0';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  producto["precio"] = double.parse(value); 
                });
              },
            ),
          ],
        ),
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
            if (_formKey.currentState!.validate()) {
              await _firebaseService.actualizarProducto(producto["id"], {
                'nombre': nombreController.text,
                'descripcion': descripcionController.text,
                'imageUrl': imageUrlController.text,
                'precio': double.parse(precioController.text),
              });
              Navigator.of(context).pop();
              setState(() {}); 
            }
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
