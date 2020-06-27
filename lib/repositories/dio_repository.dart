import 'package:dio/dio.dart';
import 'package:yorglass_ik/services/authentication-service.dart';

class RestApi {
  Dio dio;
  String baseUrl = 'http://178.18.207.118:8080';
//  String localUrl = 'http://192.168.1.104:8080';
  String localUrl = 'http://localhost:8080';

  static final RestApi _instance = RestApi._privateConstructor();

  RestApi._privateConstructor() {
    final Map<String,dynamic> headers = {};
    if (AuthenticationService?.verifiedAuth?.token != null) {
      headers.putIfAbsent(
          'Authorization', () => 'Bearer ' + AuthenticationService?.verifiedAuth?.token);
    }
    BaseOptions options = new BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: 10000,
      headers: headers,
      receiveTimeout: 10000,
    );
    dio = Dio(options);
  }

  static RestApi get instance => _instance;
}
