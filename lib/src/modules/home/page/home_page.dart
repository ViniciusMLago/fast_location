import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import '../../../routes/app_routes.dart';
import '../../../shared/colors/app_colors.dart';
import '../../../shared/components/loading_widget.dart';
import '../../../shared/metrics/app_metrics.dart';
import '../components/address_list_component.dart';
import '../components/empty_search_component.dart';
import '../components/last_address_component.dart';
import '../components/search_address_dialog.dart';
import '../controller/home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _controller = HomeController();
  late final ReactionDisposer _errorDisposer;

  @override
  void initState() {
    super.initState();
    _controller.loadInitialData();

    _errorDisposer = reaction<String?>(
      (_) => _controller.errorMessage,
      (message) {
        if (message != null && message.isNotEmpty && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _errorDisposer();
    super.dispose();
  }

  void _openSearchDialog() {
    showDialog<void>(
      context: context,
      builder: (_) => SearchAddressDialog(
        onSearchByCep: _controller.searchByCep,
        onSearchByAddress: _controller.searchByAddress,
      ),
    );
  }

  Future<void> _openHistory() async {
    await Navigator.pushNamed(context, AppRoutes.history);
    _controller.loadInitialData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'FastLocation',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
        actions: [
          IconButton(
            tooltip: 'Histórico de consultas',
            onPressed: _openHistory,
            icon: const Icon(Icons.history_rounded),
          ),
        ],
      ),
      body: Observer(
        builder: (_) {
          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: () async => _controller.loadInitialData(),
                child: ListView(
                  padding: const EdgeInsets.all(AppMetrics.defaultPadding),
                  children: [
                    LastAddressComponent(
                      address: _controller.lastAddress,
                      onTraceRoute: _controller.traceRouteToLastAddress,
                    ),
                    const SizedBox(height: AppMetrics.defaultPadding),
                    OutlinedButton.icon(
                      onPressed: _openSearchDialog,
                      icon: const Icon(Icons.search_rounded),
                      label: const Text('Nova Consulta de CEP / Endereço'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(AppMetrics.borderRadius),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppMetrics.largePadding),
                    const Text(
                      'Consultas Recentes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppMetrics.smallPadding),
                    if (_controller.emptySearch &&
                        _controller.addresses.isEmpty)
                      const EmptySearchComponent(
                        message:
                            'Resultado não encontrado para a busca realizada.',
                      )
                    else
                      AddressListComponent(
                        addresses: _controller.addresses.toList(),
                        onSelectAddress: _controller.selectAddress,
                      ),
                  ],
                ),
              ),
              if (_controller.isLoading) const LoadingWidget(),
            ],
          );
        },
      ),
    );
  }
}
