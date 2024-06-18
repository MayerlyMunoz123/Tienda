import 'package:flutter/material.dart';
import 'package:fluttertienda_app/Servicios/firebaseservice.dart';

class Home extends StatefulWidget {
  const Home({Key? key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Material para el CRUD"),
      ),
      body: FutureBuilder(
        future: getCliente(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          List clientes = snapshot.data as List;

          return ListView.builder(
            itemCount: clientes.length,
            itemBuilder: (context, index) {
              var cliente = clientes[index];
              var nombreCompleto = '${cliente["Nombre"]} ${cliente["Apellido"]}';

              return ListTile(
                title: Text(nombreCompleto),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Actualizar usuario'),
                            content: TextFormField(
                              initialValue: nombreCompleto,
                              onChanged: (newValue) {
                                nombreCompleto = newValue;
                              },
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await updateUsuario(cliente["Nombre"], {"Nombre": nombreCompleto});
                                  setState(() {
                                    cliente["Nombre"] = nombreCompleto;
                                  });
                                  Navigator.pop(context); 
                                },
                                child: const Text('Actualizar'),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Confirmar eliminación'),
                            content: const Text('¿Estás seguro de que deseas eliminar este usuario?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancelar'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await deleteUsuario(cliente["Nombre"]);
                                  setState(() {
                                    clientes.removeAt(index);
                                  });
                                  Navigator.pop(context); 
                                },
                                child: const Text('Eliminar'),
                              ),
                            ],
                          ),
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
    );
  }
}
