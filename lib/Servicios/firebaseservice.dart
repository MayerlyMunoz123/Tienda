import "package:cloud_firestore/cloud_firestore.dart";
import "package:shared_preferences/shared_preferences.dart";

FirebaseFirestore bdA = FirebaseFirestore.instance;

Future<void> RegisterUsuario(Map<String, dynamic> usuario) async {
  try {
    CollectionReference collectionReferenceUsuario = bdA.collection('Usuario');
    await collectionReferenceUsuario.add(usuario);
    print("Registro Exitoso");
  } catch (e) {
    print('Error: $e');
  }
}

Future<List> getCliente() async {
  List Usuario = [];
  CollectionReference collectionReferenceCliente = bdA.collection("Usuario");
  QuerySnapshot queryCliente = await collectionReferenceCliente.get();

  queryCliente.docs.forEach((documento) {
    Usuario.add(documento.data());
  });
  return Usuario;
}

Future<void> deleteUsuario(String name) async {
    try {
      CollectionReference collectionReferenceUsuario = FirebaseFirestore.instance.collection('Usuario');
      QuerySnapshot querySnapshot = await collectionReferenceUsuario.where("Nombre", isEqualTo: name).get();

      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs.first.reference.delete();
        print("Usuario eliminado con éxito");
      } else {
        print("No se encontró ningún usuario con el nombre: $name");
      }
    } catch (e) {
      print('Error al eliminar el usuario: $e');
    }
  }
 Future<void> updateUsuario(String name, Map<String, dynamic> newData) async {
    try {
      CollectionReference collectionReferenceUsuario = FirebaseFirestore.instance.collection('Usuario');
      QuerySnapshot querySnapshot = await collectionReferenceUsuario.where("Nombre", isEqualTo: name).get();

      if (querySnapshot.docs.isNotEmpty) {
        await querySnapshot.docs.first.reference.update(newData);
        print("Usuario actualizado con éxito");
      } else {
        print("No se encontró ningún usuario con el nombre: $name");
      }
    } catch (e) {
      print('Error al actualizar el usuario: $e');
    }
    Future<QuerySnapshot<Map<String, dynamic>>> getClientes() async {
  print("este es el servicio");
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? usuario = prefs.getString('usuario');
  print("el usuario es :$usuario");
  QuerySnapshot<Map<String, dynamic>> result = await bdA
      .collection('Usuario')
      .where('Usuario', isEqualTo: usuario)
      .limit(1)
      .get();
  var userData = result.docs.first.data();
  print("la data es $userData");
  return result;
}
  }
