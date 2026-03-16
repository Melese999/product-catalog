import 'package:dio/dio.dart';

class ProductClient {
  final Dio _dio;
  static const String baseUrl = 'https://dummyjson.com';

  ProductClient(this._dio) {
    _dio.options.baseUrl = baseUrl;
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => print('API Log: $obj'),
    ));
  }

  Future<Response> getProducts({int limit = 20, int skip = 0}) async {
    return _dio.get('/products', queryParameters: {
      'limit': limit,
      'skip': skip,
    });
  }

  Future<Response> searchProducts(String query, {int limit = 20, int skip = 0}) async {
    return _dio.get('/products/search', queryParameters: {
      'q': query,
      'limit': limit,
      'skip': skip,
    });
  }

  Future<Response> getCategories() async {
    return _dio.get('/products/categories');
  }

  Future<Response> getProductsByCategory(String category, {int limit = 20, int skip = 0}) async {
    return _dio.get('/products/category/$category', queryParameters: {
      'limit': limit,
      'skip': skip,
    });
  }

  Future<Response> getProduct(int id) async {
    return _dio.get('/products/$id');
  }
}
