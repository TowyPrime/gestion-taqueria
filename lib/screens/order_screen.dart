import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gestion_taqueria_lety/models/pedido.dart';
import 'package:gestion_taqueria_lety/services/order_service.dart';
import 'package:gestion_taqueria_lety/utils/action_helper.dart';
import 'package:gestion_taqueria_lety/utils/constants.dart';
import 'package:gestion_taqueria_lety/widgets/error_screen.dart';
import 'package:gestion_taqueria_lety/widgets/list_panel_pedidos.dart';
import 'package:gestion_taqueria_lety/widgets/order_card.dart';
import 'package:gestion_taqueria_lety/widgets/details_panel_pedido.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  String? selectedOrderId;

  final OrderService _orderService = OrderService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('orders')
          .where(
            'status',
            whereIn: ['pendiente', 'preparando', 'en preparación'],
          )
          .orderBy('createdAt')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          debugPrint('Error al cargar los pedidos: ${snapshot.error}');
          return const ErrorScreen(errorMessage: 'Error al cargar los pedidos');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final orders = snapshot.data!.docs;
        final pedidos = orders.map(Pedido.fromFirestore).toList();

        if (pedidos.isEmpty) {
          return const Center(child: Text('No hay pedidos disponibles'));
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= widthDesign) {
              final effectiveSelectedId =
                  selectedOrderId != null &&
                      pedidos.any((p) => p.id == selectedOrderId)
                  ? selectedOrderId!
                  : pedidos.first.id;

              final pedidoSeleccionado = pedidos.firstWhere(
                (p) => p.id == effectiveSelectedId,
              );

              return Row(
                children: [
                  SizedBox(
                    width: widthList,
                    child: ListPanelPedidos(
                      pedidos: pedidos,
                      selectedOrderId: effectiveSelectedId,
                      onOrderSelected: (orderId) =>
                          setState(() => selectedOrderId = orderId),
                    ),
                  ),
                  const VerticalDivider(width: 1, thickness: 1),

                  Expanded(
                    child: DetailsPanelPedido(
                      pedidoSeleccionado: pedidoSeleccionado,
                      onStatusChanged: (nuevoEstado) async {
                        await ActionHelper.runWithFeedback(
                          context,
                          action: () async {
                            await _orderService.cambiarEstadoPedido(
                              orderId: pedidoSeleccionado.id,
                              nuevoEstado: nuevoEstado,
                            );
                          },
                          successMessage:
                              'Estado cambiado con éxito a: $nuevoEstado',
                          errorMessage: 'Error al intentar cambiar estado',
                        );
                      },
                    ),
                  ),
                ],
              );
            } else {
              return ListView.builder(
                itemCount: pedidos.length,
                itemBuilder: (context, index) {
                  final pedido = pedidos[index];
                  return OrderCard(pedido: pedido);
                },
              );
            }
          },
        );
      },
    );
  }
}
