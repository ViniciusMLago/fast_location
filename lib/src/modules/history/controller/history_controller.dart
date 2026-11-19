import 'package:mobx/mobx.dart';
import '../../home/model/address_model.dart';
import '../../home/service/address_service.dart';

part 'history_controller.g.dart';

class HistoryController = _HistoryControllerBase with _$HistoryController;

abstract class _HistoryControllerBase with Store {
  final AddressService _service;

  _HistoryControllerBase({AddressService? service})
      : _service = service ?? AddressService();

  @observable
  bool isLoading = false;

  @observable
  ObservableList<AddressModel> historyList = ObservableList<AddressModel>();

  @action
  void loadHistory() {
    isLoading = true;
    final items = _service.getHistory();
    historyList = ObservableList<AddressModel>.of(items);
    isLoading = false;
  }
}
