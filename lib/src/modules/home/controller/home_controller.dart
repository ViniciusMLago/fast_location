import 'package:geocoding/geocoding.dart' hide Location;
import 'package:map_launcher/map_launcher.dart';
import 'package:mobx/mobx.dart';
import '../model/address_model.dart';
import '../service/address_service.dart';

part 'home_controller.g.dart';

class HomeController = _HomeControllerBase with _$HomeController;

abstract class _HomeControllerBase with Store {
  final AddressService _service;

  _HomeControllerBase({AddressService? service})
      : _service = service ?? AddressService();

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @observable
  bool emptySearch = false;

  @observable
  AddressModel? lastAddress;

  @observable
  ObservableList<AddressModel> addresses = ObservableList<AddressModel>();

  @action
  void loadInitialData() {
    final history = _service.getHistory();
    addresses = ObservableList<AddressModel>.of(history);
    lastAddress = _service.getLastAddress();
  }

  @action
  Future<void> searchByCep(String cep) async {
    isLoading = true;
    errorMessage = null;
    emptySearch = false;

    try {
      final result = await _service.searchByCep(cep);
      lastAddress = result;
      addresses = ObservableList<AddressModel>.of(_service.getHistory());
    } catch (e) {
      emptySearch = true;
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> searchByAddress({
    required String uf,
    required String city,
    required String street,
  }) async {
    isLoading = true;
    errorMessage = null;
    emptySearch = false;

    try {
      final results = await _service.searchByAddress(
        uf: uf,
        city: city,
        street: street,
      );

      if (results.isEmpty) {
        emptySearch = true;
        errorMessage = 'Nenhum CEP encontrado para o endereço informado.';
      } else {
        lastAddress = results.first;
        addresses = ObservableList<AddressModel>.of(_service.getHistory());
      }
    } catch (e) {
      emptySearch = true;
      errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> selectAddress(AddressModel address) async {
    await _service.saveAddress(address);
    lastAddress = address;
    addresses = ObservableList<AddressModel>.of(_service.getHistory());
  }

  @action
  Future<void> traceRouteToLastAddress() async {
    final target = lastAddress;
    if (target == null) {
      errorMessage = 'Consulte um endereço antes de traçar a rota.';
      return;
    }

    isLoading = true;
    errorMessage = null;

    try {
      final query = '${target.formattedAddress}, ${target.cep}, Brasil';
      final locations = await locationFromAddress(query);

      if (locations.isEmpty) {
        errorMessage = 'Não foi possível obter as coordenadas deste endereço.';
        return;
      }

      final destination = locations.first;

      await MapLauncher.directions(
        Location.coords(
          destination.latitude,
          destination.longitude,
          title: target.formattedAddress,
        ),
      ).show();
    } catch (e) {
      errorMessage =
          'Erro ao traçar rota: ${e.toString().replaceFirst('Exception: ', '')}';
    } finally {
      isLoading = false;
    }
  }
}
