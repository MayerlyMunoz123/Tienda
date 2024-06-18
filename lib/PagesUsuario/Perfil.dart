import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertienda_app/Pages/navbar.dart';

import 'package:fluttertienda_app/PagesUsuario/Home.dart';
import 'package:fluttertienda_app/PagesUsuario/PaginaUser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

 void _login() async {
  String username = _usernameController.text.trim();
  String password = _passwordController.text.trim();

  if (username.isEmpty || password.isEmpty) {
    _showErrorDialog('Ingrese todos los campos');
    return;
  }
  String adminUsername = 'admin';
  String adminPassword = 'admin123';

  if (username == adminUsername && password == adminPassword) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const Navbar()),
    );
    return;
  }

  try {
    QuerySnapshot result = await _firestore
        .collection('Usuario')
        .where('Usuario', isEqualTo: username) 
        .limit(1)
        .get();

    if (result.docs.isEmpty) {
      _showErrorDialog('No se a encontrado el usuario.');
      return;
    }

    var user = result.docs.first.data() as Map<String, dynamic>;  
    if (user['Contraseña'] == password) {
       SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('usuario', user['Usuario']);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const UserNavbar()),
      );
    } else {
      _showErrorDialog('Contraseña Incorrecta');
    }
  } catch (e) {
    _showErrorDialog('El ingreso a fallado intente mas tarde');
  }
}


  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Fallo el ingreso'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio de Sesion'),
        backgroundColor: const Color.fromARGB(255, 146, 176, 211),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), 
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) =>  HomePage()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Usuario'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
