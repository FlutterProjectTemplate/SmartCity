import 'dart:io';
import 'package:dio/dio.dart';

class DioClient{
  static final DioClient _singletonDioClient = DioClient._internal();
  static DioClient get getInstance => _singletonDioClient;
  factory DioClient() {
    HttpOverrides.global = MyHttpOverrides();
    return _singletonDioClient;
  }

  DioClient._internal();
  Dio dio = Dio();

  void initial(){
    BaseOptions options = BaseOptions(
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 60), // 30 seconds
      receiveTimeout: const Duration(seconds: 60), // 30 seconds
    );
    dio = Dio(options);
  }
  Dio getDioClient(){
    BaseOptions options = BaseOptions(
      receiveDataWhenStatusError: true,
      connectTimeout: const Duration(seconds: 60), // 30 seconds
      receiveTimeout: const Duration(seconds: 60), // 30 seconds
    );
    dio.options = options;
    return dio;
  }
}

class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}