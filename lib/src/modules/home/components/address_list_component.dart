import 'package:flutter/material.dart';
import '../../../shared/colors/app_colors.dart';
import '../../../shared/metrics/app_metrics.dart';
import '../model/address_model.dart';
import 'empty_search_component.dart';

class AddressListComponent extends StatelessWidget {
  final List<AddressModel> addresses;
  final ValueChanged<AddressModel>? onSelectAddress;

  const AddressListComponent({
    super.key,
    required this.addresses,
    this.onSelectAddress,
  });

  @override
  Widget build(BuildContext context) {
    if (addresses.isEmpty) {
      return const EmptySearchComponent(
        message: 'Nenhuma consulta realizada até o momento.',
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: addresses.length,
      separatorBuilder: (_, __) =>
          const SizedBox(height: AppMetrics.smallPadding),
      itemBuilder: (context, index) {
        final item = addresses[index];
        return Card(
          color: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppMetrics.borderRadius),
          ),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppColors.primary,
              child: Icon(Icons.location_on_outlined, color: AppColors.surface),
            ),
            title: Text(
              item.cep,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            subtitle: Text(
              item.formattedAddress,
              style: const TextStyle(color: AppColors.textSecondary),
            ),
            trailing: onSelectAddress != null
                ? const Icon(Icons.near_me_outlined, color: AppColors.primary)
                : null,
            onTap:
                onSelectAddress != null ? () => onSelectAddress!(item) : null,
          ),
        );
      },
    );
  }
}
