import 'package:dio/dio.dart';
import '../../../http/http_client.dart';
import '../model/address_model.dart';

class AddressRemoteRepository {
  final Dio _dio;

  AddressRemoteRepository({Dio? dio}) : _dio = dio ?? HttpClient.instance;

  Future<AddressModel> getAddressByCep(String cep) async {
    final cleanCep = cep.replaceAll(RegExp(r'\D'), '');
    if (cleanCep.length != 8) {
      throw Exception('Informe um CEP válido com 8 dígitos.');
    }

    final response = await _dio.get('/$cleanCep/json/');
    final data = response.data;

    if (data is Map<String, dynamic>) {
      if (data['erro'] == true || data['erro'] == 'true') {
        throw Exception('CEP não encontrado na base do ViaCEP.');
      }
      return AddressModel.fromJson(data);
    }

    throw Exception('Resposta inválida ao consultar o CEP.');
  }

  Future<List<AddressModel>> getCepByAddress({
    required String uf,
    required String city,
    required String street,
  }) async {
    final cleanUf = uf.trim().toUpperCase();
    final cleanCity = Uri.encodeComponent(city.trim());
    final cleanStreet = Uri.encodeComponent(street.trim());

    if (cleanUf.length != 2 ||
        city.trim().length < 3 ||
        street.trim().length < 3) {
      throw Exception(
          'Preencha UF (2 letras), cidade e logradouro (mín. 3 caracteres).');
    }

    final response = await _dio.get('/$cleanUf/$cleanCity/$cleanStreet/json/');
    final data = response.data;

    if (data is List) {
      return data
          .whereType<Map<String, dynamic>>()
          .map(AddressModel.fromJson)
          .toList();
    }

    return [];
  }
}
