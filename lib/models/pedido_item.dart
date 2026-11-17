int _asInt(Object? v) => (v as num?)?.toInt() ?? 0;

class PedidoItemProduct {
  final String productId;
  final String name;
  final int quantity;

  const PedidoItemProduct({
    required this.productId,
    required this.name,
    required this.quantity,
  });

  factory PedidoItemProduct.fromMap(Map<String, dynamic> map) {
    return PedidoItemProduct(
      productId: map['productId'] ?? 'desconocido',
      name: map['name'] ?? '',
      quantity: _asInt(map['quantity']),
    );
  }
}

class PedidoItem {
  final String name;
  final int quantity;
  final String type;
  final List<PedidoItemProduct> products;
  final List<String> contents;

  const PedidoItem({
    required this.name,
    required this.quantity,
    required this.type,
    this.products = const [],
    this.contents = const [],
  });

  factory PedidoItem.fromMap(Map<String, dynamic> map) {
    final rawProductos = map['products'];
    final rawContents = map['contents'];

    return PedidoItem(
      name: map['name'] ?? 'desconocido',
      quantity: _asInt(map['quantity']),
      type: map['type'] ?? 'individual',
      products: rawProductos is List
          ? rawProductos
                .whereType<Map<String, dynamic>>()
                .map(PedidoItemProduct.fromMap)
                .toList()
          : [],
      contents: rawContents is List
          ? rawContents.whereType<String>().toList()
          : [],
    );
  }

  List<String> get renglones {
    switch (type) {
      case 'plato':
        return products.map((p) => '${p.quantity} × ${p.name}').toList();
      default:
        if (contents.isNotEmpty) {
          return contents;
        }
        return [];
    }
  }
}
