import 'package:flutter/material.dart';
import '../../../shared/colors/app_colors.dart';
import '../../../shared/metrics/app_metrics.dart';
import '../model/address_model.dart';

class LastAddressComponent extends StatelessWidget {
  final AddressModel? address;
  final VoidCallback onTraceRoute;

  const LastAddressComponent({
    super.key,
    required this.address,
    required this.onTraceRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surface,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppMetrics.borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppMetrics.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Row(
              children: [
                Icon(Icons.pin_drop_rounded, color: AppColors.primary),
                SizedBox(width: AppMetrics.smallPadding),
                Text(
                  'Último endereço consultado',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const Divider(height: AppMetrics.largePadding),
            if (address == null)
              const Text(
                'Nenhum endereço consultado ainda. Faça uma busca para habilitar a rota.',
                style: TextStyle(color: AppColors.textSecondary),
              )
            else ...[
              Text(
                'CEP: ${address!.cep}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                address!.formattedAddress,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
              if (address!.complemento.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  'Complemento: ${address!.complemento}',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
              const SizedBox(height: AppMetrics.defaultPadding),
              ElevatedButton.icon(
                onPressed: onTraceRoute,
                icon: const Icon(Icons.directions_rounded),
                label: const Text('Traçar Rota no Mapa'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.surface,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppMetrics.borderRadius),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
