import 'package:flutter/material.dart';
import 'package:gestion_taqueria_lety/models/pedido.dart';
import 'package:gestion_taqueria_lety/services/order_service.dart';
import 'package:gestion_taqueria_lety/utils/action_helper.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.pedido});

  final Pedido pedido;

  @override
  Widget build(BuildContext context) {
    final (etiqueta, siguienteEstado) = pedido.infoSiguienteEstado;
    final orderService = OrderService();

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
                    await ActionHelper.runWithFeedback(
                      context,
                      action: () async {
                        await orderService.cambiarEstadoPedido(
                          orderId: pedido.id,
                          nuevoEstado: siguienteEstado,
                        );
                      },
                      successMessage:
                          'Estado cambiado con éxito a $siguienteEstado',
                      errorMessage: 'Ocurrió un error al intentar cambiar de estado al pedido.',
                    );
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
