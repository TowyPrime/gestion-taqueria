import 'package:flutter/material.dart';
import 'package:gestion_taqueria_lety/models/pedido.dart';
import 'package:gestion_taqueria_lety/services/order_service.dart';
import 'package:gestion_taqueria_lety/widgets/app_notifier.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.pedido});

  final Pedido pedido;

  @override
  Widget build(BuildContext context) {
    final (etiqueta, siguienteEstado) = pedido.infoSiguienteEstado;

    return Card(
      margin: const EdgeInsetsDirectional.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      child: ListTile(
        title: Text('Pedido #${pedido.id}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Estado: ${pedido.status}'),
            Text('Creado a las: ${pedido.horaPedido}'),
            const SizedBox(height: 4),
            if (etiqueta != null && siguienteEstado != null)
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final orderService = OrderService();

                    try {
                      await orderService.cambiarEstadoPedido(
                        orderId: pedido.id,
                        nuevoEstado: siguienteEstado,
                      );
                      if (context.mounted) {
                        AppNotifier.show(
                          context,
                          message:
                              'Estado del pedido cambiado a "$siguienteEstado"',
                          type: 'success',
                        );
                      }
                    } catch (e) {
                      debugPrint('Error al cambiar el estado del pedido: $e');
                      if (context.mounted) {
                        AppNotifier.show(
                          context,
                          message: 'Error al cambiar el estado del pedido',
                          type: 'error',
                        );
                      }
                    }
                  },
                  child: Text(etiqueta),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
