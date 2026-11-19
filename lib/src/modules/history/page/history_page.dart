import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import '../../../shared/colors/app_colors.dart';
import '../../../shared/components/loading_widget.dart';
import '../../../shared/metrics/app_metrics.dart';
import '../../home/components/address_list_component.dart';
import '../controller/history_controller.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final HistoryController _controller = HistoryController();

  @override
  void initState() {
    super.initState();
    _controller.loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Consultas'),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
      ),
      body: Observer(
        builder: (_) {
          if (_controller.isLoading) {
            return const LoadingWidget(message: 'Carregando histórico...');
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppMetrics.defaultPadding),
            child: AddressListComponent(
              addresses: _controller.historyList.toList(),
            ),
          );
        },
      ),
    );
  }
}
