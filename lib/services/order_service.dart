import 'package:cloud_firestore/cloud_firestore.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> cambiarEstadoPedido({
    required String orderId,
    required String nuevoEstado,
  }) async {
    await _firestore.collection('orders').doc(orderId).update({
      'status': nuevoEstado,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
