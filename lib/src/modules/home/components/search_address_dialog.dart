import 'package:flutter/material.dart';
import '../../../shared/colors/app_colors.dart';
import '../../../shared/metrics/app_metrics.dart';

class SearchAddressDialog extends StatefulWidget {
  final Future<void> Function(String cep) onSearchByCep;
  final Future<void> Function({
    required String uf,
    required String city,
    required String street,
  }) onSearchByAddress;

  const SearchAddressDialog({
    super.key,
    required this.onSearchByCep,
    required this.onSearchByAddress,
  });

  @override
  State<SearchAddressDialog> createState() => _SearchAddressDialogState();
}

class _SearchAddressDialogState extends State<SearchAddressDialog> {
  bool _searchByCepMode = true;
  final _cepController = TextEditingController();
  final _ufController = TextEditingController();
  final _cityController = TextEditingController();
  final _streetController = TextEditingController();

  @override
  void dispose() {
    _cepController.dispose();
    _ufController.dispose();
    _cityController.dispose();
    _streetController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    Navigator.of(context).pop();
    if (_searchByCepMode) {
      await widget.onSearchByCep(_cepController.text);
    } else {
      await widget.onSearchByAddress(
        uf: _ufController.text,
        city: _cityController.text,
        street: _streetController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nova Consulta'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('Por CEP')),
                ButtonSegment(value: false, label: Text('Por Endereço')),
              ],
              selected: {_searchByCepMode},
              onSelectionChanged: (selection) {
                setState(() => _searchByCepMode = selection.first);
              },
            ),
            const SizedBox(height: AppMetrics.defaultPadding),
            if (_searchByCepMode)
              TextField(
                controller: _cepController,
                keyboardType: TextInputType.number,
                maxLength: 9,
                decoration: const InputDecoration(
                  labelText: 'CEP',
                  hintText: 'Ex: 01001000',
                  border: OutlineInputBorder(),
                ),
              )
            else ...[
              TextField(
                controller: _ufController,
                textCapitalization: TextCapitalization.characters,
                maxLength: 2,
                decoration: const InputDecoration(
                  labelText: 'UF (Estado)',
                  hintText: 'Ex: ES',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppMetrics.smallPadding),
              TextField(
                controller: _cityController,
                decoration: const InputDecoration(
                  labelText: 'Cidade',
                  hintText: 'Ex: Vila Velha',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppMetrics.smallPadding),
              TextField(
                controller: _streetController,
                decoration: const InputDecoration(
                  labelText: 'Logradouro',
                  hintText: 'Ex: Avenida Champagnat',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: AppColors.surface,
          ),
          child: const Text('Buscar'),
        ),
      ],
    );
  }
}
