import 'package:flutter/material.dart';
import 'package:gestion_taqueria_lety/models/pedido.dart';

class DetailsPanelPedido extends StatelessWidget {
  const DetailsPanelPedido({
    super.key,
    required this.pedidoSeleccionado,
    this.onStatusChanged,
  });

  final Pedido pedidoSeleccionado;
  final ValueChanged<String>? onStatusChanged;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final (_, tipo) = pedidoSeleccionado.infoTipoPedido;

    final (etiqueta, siguienteEstado) = pedidoSeleccionado.infoSiguienteEstado;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pedido #${pedidoSeleccionado.idCorto}',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Chip(label: Text(tipo), visualDensity: VisualDensity.compact),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Hora de pedido: ${pedidoSeleccionado.horaPedido}',
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const Divider(height: 32),
          Text(
            'Artículos del pedido',
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: pedidoSeleccionado.items.isEmpty
                ? const Center(child: Text('El pedido no tiene productos'))
                : ListView.builder(
                    itemCount: pedidoSeleccionado.items.length,
                    itemBuilder: (context, index) {
                      final producto = pedidoSeleccionado.items[index];
                      final items = producto.renglones;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 40,
                              child: Text(
                                '${producto.quantity} x',
                                style: textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    producto.name,
                                    style: textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  if (producto.type == 'plato' ||
                                      producto.quantity > 1) ...[
                                    Text(
                                      'El plato contiene:',
                                      style: textTheme.headlineSmall,
                                    ),
                                  ],
                                  ...items.map(
                                    (item) => Padding(
                                      padding: const EdgeInsets.only(
                                        left: 12.0,
                                        top: 2.0,
                                      ),
                                      child: Text(
                                        item,
                                        style: textTheme.bodyLarge?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ),
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
          if (etiqueta != null && siguienteEstado != null) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onStatusChanged == null
                    ? null
                    : () => onStatusChanged!(siguienteEstado),
                icon: Icon(Icons.arrow_forward_ios, size: 16),
                label: Text(
                  etiqueta,
                  style: textTheme.titleMedium?.copyWith(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
