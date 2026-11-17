import 'package:flutter/material.dart';
import 'package:gestion_taqueria_lety/models/pedido.dart';
import 'package:gestion_taqueria_lety/widgets/order_queue_tile.dart';

class ListPanelPedidos extends StatelessWidget {
  const ListPanelPedidos({
    super.key,
    required this.pedidos,
    required this.selectedOrderId,
    required this.onOrderSelected,
  });

  final List<Pedido> pedidos;
  final String? selectedOrderId;
  final ValueChanged<String> onOrderSelected;

  @override
  Widget build(BuildContext context) {
    if (pedidos.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final pedidoEnTurno = pedidos.first;
    final siguientes = pedidos.skip(1).toList();

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: [
        // Encabezado del Turno
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          child: Row(
            children: [
              Icon(Icons.bolt, size: 16, color: theme.colorScheme.primary),
              const SizedBox(width: 6),
              Expanded(
                child: Text('PEDIDO EN TURNO', style: textTheme.titleLarge),
              ),
            ],
          ),
        ),

        // Tarjeta destacada del turno
        OrderQueueTile(
          pedido: pedidoEnTurno,
          isSelected: pedidoEnTurno.id == selectedOrderId,
          isTurno: true,
          onTap: () => onOrderSelected(pedidoEnTurno.id),
        ),

        const SizedBox(height: 16),

        // Encabezado de siguientes pedidos
        if (siguientes.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
            child: Text(
              'SIGUIENTES EN COLA (${siguientes.length})',
              style: textTheme.titleMedium,
            ),
          ),

          // Listado de los demás mediante el bucle for
          for (final p in siguientes)
            OrderQueueTile(
              pedido: p,
              isSelected: p.id == selectedOrderId,
              isTurno: false,
              onTap: () => onOrderSelected(p.id),
            ),
        ],
      ],
    );
  }
}
