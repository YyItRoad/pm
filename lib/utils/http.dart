import 'package:dio/dio.dart';
import 'package:pm/config/application.dart';
import '../env.dart';

class HttpUtil {
  static HttpUtil instance;
  String key = Env.apiKey;
  Dio dio;

  static HttpUtil getInstance() {
    if (instance == null) {
      instance = new HttpUtil();
    }
    return instance;
  }

  HttpUtil() {
    dio = Dio(
      BaseOptions(
        baseUrl: Env.rootUrl,
        connectTimeout: 10000,
        receiveTimeout: 10000,
      ),
    );
  }

  get(Map<String, dynamic> data) async {
    data.addAll(
        {'key': key, 'image_type': 'photo', 'pretty': Application.debug});
    Response response;
    try {
      response = await dio.get('', queryParameters: data);
    } catch (e) {}
    return response.data;
  }
}
