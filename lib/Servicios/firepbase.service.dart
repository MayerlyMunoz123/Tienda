import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getProductos() async {
    QuerySnapshot querySnapshot = await _firestore.collection('productos').get();
    return querySnapshot.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      data['id'] = doc.id; 
      return data;
    }).toList();
  }

  Future<void> agregarProducto(Map<String, dynamic> nuevoProducto) async {
    await _firestore.collection('productos').add(nuevoProducto);
  }

  Future<void> actualizarProducto(String id, Map<String, dynamic> nuevosDatos) async {
    await _firestore.collection('productos').doc(id).update(nuevosDatos);
  }

  Future<void> eliminarProducto(String id) async {
    await _firestore.collection('productos').doc(id).delete();
  }
}
