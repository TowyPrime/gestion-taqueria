import 'package:flutter/material.dart';
import 'package:gestion_taqueria_lety/models/pedido.dart';

class OrderQueueTile extends StatelessWidget {
  const OrderQueueTile({
    super.key,
    required this.pedido,
    required this.isSelected,
    required this.onTap,
    this.isTurno = false,
  });

  final Pedido pedido;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isTurno;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;
    final (iconoPedido, tipoPedido) = pedido.infoTipoPedido;

    final borderColor = isSelected
        ? colorScheme.primary
        : (isTurno
              ? colorScheme.primary.withValues(alpha: 0.4)
              : theme.dividerColor.withValues(alpha: 0.2));
    final borderWidth = isSelected ? 2.0 : (isTurno ? 1.5 : 1.0);
    final backgroundColor = isSelected
        ? colorScheme.primaryContainer.withValues(alpha: isTurno ? 0.8 : 0.6)
        : theme.cardColor;

    return Card(
      elevation: isTurno ? 4 : 3,
      margin: EdgeInsets.symmetric(vertical: isTurno ? 4 : 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: borderColor, width: borderWidth),
      ),
      color: backgroundColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          // Control absoluto del relleno sin el padding interno forzado de ListTile
          padding: EdgeInsets.all(isTurno ? 14.0 : 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Fila superior: ID del pedido (más grande si es turno) y Tipo de pedido
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Pedido #${pedido.idCorto}',
                      style:
                          (isTurno
                                  ? textTheme.headlineSmall
                                  : textTheme.titleMedium)
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? colorScheme.onPrimaryContainer
                                    : colorScheme.onSurface,
                              ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  // Tipo de pedido (Icono + Texto)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.5,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(iconoPedido, size: 14, color: colorScheme.primary),
                        const SizedBox(width: 4),
                        Text(
                          tipoPedido,
                          style: textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              // Subtítulos / Información adicional
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Hora: ${pedido.horaPedido}',
                    style: isTurno ? textTheme.bodyMedium : textTheme.bodySmall,
                  ),
                  if (isTurno)
                    Text(
                      'Estado: ${pedido.status}',
                      style: textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: colorScheme.primary,
                      ),
                    )
                  else
                    Icon(
                      Icons.chevron_right,
                      size: 18,
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
