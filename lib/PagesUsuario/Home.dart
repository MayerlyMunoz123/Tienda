import 'package:flutter/material.dart';
import 'package:fluttertienda_app/PagesUsuario/Configuracion.dart';
import 'package:fluttertienda_app/PagesUsuario/Perfil.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const List<String> imageUrls = [
    'https://images.pexels.com/photos/8180707/pexels-photo-8180707.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/25752257/pexels-photo-25752257/free-photo-of-mujer-moderno-elegante-bonita.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/3687550/pexels-photo-3687550.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/7788994/pexels-photo-7788994.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/20629030/pexels-photo-20629030/free-photo-of-sentado-precioso-bonito-bonita.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/25745463/pexels-photo-25745463/free-photo-of-mujer-modelo-maqueta-sombrero.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/25461660/pexels-photo-25461660/free-photo-of-mujer-modelo-maqueta-en-pie.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/25748426/pexels-photo-25748426/free-photo-of-mujer-modelo-maqueta-joven.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/25651192/pexels-photo-25651192/free-photo-of-mujer-campo-modelo-maqueta.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1'
  ];


  static const List<Map<String, dynamic>> products = [
    {
      'name': 'Producto 1',
      'price': '\$50',
      'description': 'Descripción del Producto 1',
    },
    {
      'name': 'Producto 2',
      'price': '\$70',
      'description': 'Descripción del Producto 2',
    },
   {
      'name': 'Producto 3',
      'price': '\$50',
      'description': 'Descripción del Producto 1',
    },
    {
      'name': 'Producto 4',
      'price': '\$70',
      'description': 'Descripción del Producto 2',
    },
    {
      'name': 'Producto 5',
      'price': '\$50',
      'description': 'Descripción del Producto 1',
    },
    {
      'name': 'Producto 6',
      'price': '\$70',
      'description': 'Descripción del Producto 2',
    },
    {
      'name': 'Producto 7',
      'price': '\$50',
      'description': 'Descripción del Producto 1',
    },
    {
      'name': 'Producto 8',
      'price': '\$70',
      'description': 'Descripción del Producto 2',
    },
    {
      'name': 'Producto 9',
      'price': '\$50',
      'description': 'Descripción del Producto 1',
    },
  
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Página de Inicio'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            child: const Text(
              'Login',
              style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const RegisterPage()),
              );
            },
            child: const Text(
              'Regístrate',
              style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 0.75,
          ),
          itemCount: imageUrls.length,
          itemBuilder: (context, index) {
            return Card(
              elevation: 4.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15.0)),
                    child: Image.network(
                      imageUrls[index],
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.error,
                          color: Colors.red,
                          size: 100.0,
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                      width: double.infinity,
                      height: 150.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          products[index]['name'],
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          products[index]['price'],
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          products[index]['description'],
                          style: const TextStyle(fontSize: 14.0),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
