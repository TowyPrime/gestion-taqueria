import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gestion_taqueria_lety/models/pedido_item.dart';

class Pedido {
  final String id;
  final String status;
  final double total;
  final DateTime? createdAt;
  final String orderType;
  final List<PedidoItem> items;

  const Pedido({
    required this.id,
    required this.status,
    required this.total,
    this.createdAt,
    this.orderType = 'domicilio',
    required this.items,
  });

  factory Pedido.fromFirestore(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final c = data['createdAt'];
    final rawItems = data['items'];

    return Pedido(
      id: doc.id,
      status: data['status'] ?? 'desconocido',
      total: (data['total'] as num?)?.toDouble() ?? 0.0,
      createdAt: c is Timestamp ? c.toDate() : null,
      orderType: data['orderType'] ?? 'domicilio',
      items: rawItems is List
          ? rawItems
                .whereType<Map<String, dynamic>>()
                .map(PedidoItem.fromMap)
                .toList()
          : [],
    );
  }

  String get horaPedido {
    final c = createdAt;
    if (c == null) return 'Hora desconocida';

    return '${c.hour.toString().padLeft(2, '0')}:${c.minute.toString().padLeft(2, '0')}';
  }

  String get idCorto {
    if (id.length < 4) return 'idDesconocido';
    final idCorto = id.substring(id.length - 4).toUpperCase();
    return idCorto;
  }

  (String? etiqueta, String? siguienteEstado) get infoSiguienteEstado {
    return switch (status) {
      'pendiente' => ('Empezar a preparar', 'en preparación'),
      'en preparación' || 'preparando' => ('Listo', 'listo para entrega'),
      _ => (null, null),
    };
  }

  (IconData icono, String tipo) get infoTipoPedido {
    return switch (orderType.trim().toLowerCase()) {
      'mesa' => (Icons.table_restaurant_rounded, 'Mesa'),
      'barra' => (Icons.countertops_rounded, 'Barra'),
      'para llevar' ||
      'para_llevar' => (Icons.shopping_bag_rounded, 'Para llevar'),
      'domicilio' => (Icons.delivery_dining_rounded, 'Domicilio'),
      _ => (Icons.receipt_long_rounded, 'Desconocido'),
    };
  }
}
