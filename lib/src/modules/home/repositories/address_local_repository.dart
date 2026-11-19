import 'package:hive/hive.dart';
import '../../../shared/storage/hive_config.dart';
import '../model/address_model.dart';

class AddressLocalRepository {
  Box<AddressModel> get _box =>
      Hive.box<AddressModel>(HiveConfig.addressBoxName);

  Future<void> saveAddress(AddressModel address) async {
    await _box.add(
      AddressModel(
        cep: address.cep,
        logradouro: address.logradouro,
        complemento: address.complemento,
        bairro: address.bairro,
        localidade: address.localidade,
        uf: address.uf,
      ),
    );
  }

  List<AddressModel> getHistory() {
    return _box.values.toList().reversed.toList();
  }

  AddressModel? getLastAddress() {
    if (_box.isEmpty) return null;
    return _box.values.last;
  }
}
