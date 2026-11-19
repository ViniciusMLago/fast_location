import '../model/address_model.dart';
import '../repositories/address_local_repository.dart';
import '../repositories/address_remote_repository.dart';

class AddressService {
  final AddressRemoteRepository _remoteRepository;
  final AddressLocalRepository _localRepository;

  AddressService({
    AddressRemoteRepository? remoteRepository,
    AddressLocalRepository? localRepository,
  })  : _remoteRepository = remoteRepository ?? AddressRemoteRepository(),
        _localRepository = localRepository ?? AddressLocalRepository();

  Future<AddressModel> searchByCep(String cep) async {
    final address = await _remoteRepository.getAddressByCep(cep);
    await _localRepository.saveAddress(address);
    return address;
  }

  Future<List<AddressModel>> searchByAddress({
    required String uf,
    required String city,
    required String street,
  }) async {
    final results = await _remoteRepository.getCepByAddress(
      uf: uf,
      city: city,
      street: street,
    );
    if (results.isNotEmpty) {
      await _localRepository.saveAddress(results.first);
    }
    return results;
  }

  Future<void> saveAddress(AddressModel address) async {
    await _localRepository.saveAddress(address);
  }

  List<AddressModel> getHistory() {
    return _localRepository.getHistory();
  }

  AddressModel? getLastAddress() {
    return _localRepository.getLastAddress();
  }
}
