import 'package:dio/dio.dart';

class HttpClient {
  static Dio get instance {
    return Dio(
      BaseOptions(
        baseUrl: 'https://viacep.com.br/ws',
      ),
    );
  }
}
