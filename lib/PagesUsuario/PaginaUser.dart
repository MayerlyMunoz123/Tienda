import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertienda_app/PagesUsuario/Home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertienda_app/PagesUsuario/Comprasuser.dart';
import 'package:fluttertienda_app/PagesUsuario/Ofertas.dart';

class User {
  final String? Nombre;
  final String? Apellido;
  final String? Usuario;

  User({
    this.Nombre,
    this.Apellido,
    this.Usuario,
  });
}

class UserNavbar extends StatefulWidget {
  const UserNavbar({Key? key}) : super(key: key);

  @override
  _UserNavbarState createState() => _UserNavbarState();
}

class _UserNavbarState extends State<UserNavbar> {
  User? usuario;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      User? currentUser = await _getClientes();
      setState(() {
        usuario = currentUser;
      });
    } catch (e) {
      print("Error al cargar datos de usuario: $e");
    }
  }

  Future<User?> _getClientes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? usuario = prefs.getString('usuario');

    if (usuario != null) {
      try {
        QuerySnapshot<Map<String, dynamic>> result = await FirebaseFirestore.instance
            .collection('Usuario')
            .where('Usuario', isEqualTo: usuario)
            .limit(1)
            .get();

        if (result.docs.isNotEmpty) {
          var userData = result.docs.first.data();
          return User(
            Nombre: userData['Nombre'],
            Apellido: userData['Apellido'],
            Usuario: userData['Usuario'],
          );
        } else {
          print('No se encontraron documentos para el usuario con ID: $usuario');
          return null;
        }
      } catch (e) {
        print('Error al obtener datos del usuario desde Firestore: $e');
        return null;
      }
    } else {
      print('El ID de usuario almacenado en SharedPreferences es nulo.');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iconic Mundial'),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: FutureBuilder<User?>(
        future: _getClientes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Drawer(child: CircularProgressIndicator());
          }

          User? usuario = snapshot.data;

          return usuario != null ? _buildDrawer(usuario) : const Drawer(child: Text('No se pudo cargar el usuario'));
        },
      ),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            '¡Bienvenidos al sitio de compras más intuitivo y emocionante!',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(User usuario) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          _buildDrawerHeader(usuario),
          const Divider(),
          _buildDrawerItem(
            text: 'Inicio',
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const UserNavbar()),
              );
            },
          ),
          _buildDrawerItem(
            text: 'Compras',
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ComprasPage()),
              );
            },
          ),
          _buildDrawerItem(
            text: 'Ofertas',
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const DescripcionPage()),
              );
            },
          ),
              _buildDrawerItem(
            text: 'Cerrar Sesion',
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomePage()),
              );
            },
          ),
        ],
      ),
    );
  }

 Widget _buildDrawerHeader(User usuario) {
  return DrawerHeader(
    decoration: const BoxDecoration(
      color: Colors.blue,
    ),
    padding: const EdgeInsets.all(20.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(
          backgroundColor: Colors.white,
          radius: 30,
          child: Icon(
            Icons.person,
            size: 50,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${usuario.Nombre ?? ''} ${usuario.Apellido ?? ''}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4.0),
              Text(
                usuario.Usuario ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

  Widget _buildDrawerItem({required String text, required VoidCallback onTap}) {
    return ListTile(
      title: Text(text),
      onTap: onTap,
    );
  }
}
