import 'package:dartz/dartz.dart';
import 'package:tech_gadol_catalog/core/network/product_client.dart';
import 'package:tech_gadol_catalog/features/products/data/datasources/product_local_data_source.dart';
import 'package:tech_gadol_catalog/features/products/domain/entities/product.dart';
import 'package:tech_gadol_catalog/features/products/domain/repositories/product_repository.dart';
import 'package:tech_gadol_catalog/features/products/data/models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductClient _client;
  final ProductLocalDataSource _localDataSource;

  ProductRepositoryImpl(this._client, this._localDataSource);

  @override
  Future<Either<Exception, List<Product>>> getProducts({int limit = 20, int skip = 0}) async {
    try {
      final response = await _client.getProducts(limit: limit, skip: skip);
      final productResponse = ProductResponse.fromJson(response.data);
      await _localDataSource.cacheProducts(productResponse.products);
      return Right(productResponse.products);
    } catch (e) {
      if (skip == 0) {
        final cached = await _localDataSource.getLastProducts();
        if (cached.isNotEmpty) return Right(cached);
      }
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, List<Product>>> searchProducts(String query, {int limit = 20, int skip = 0}) async {
    try {
      final response = await _client.searchProducts(query, limit: limit, skip: skip);
      final productResponse = ProductResponse.fromJson(response.data);
      return Right(productResponse.products);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, List<String>>> getCategories() async {
    try {
      final response = await _client.getCategories();
      // DummyJSON returns a list of objects or strings depending on version, 
      // but usually it's a list of strings for /categories
      if (response.data is List) {
        final List<dynamic> data = response.data;
        if (data.isNotEmpty && data.first is Map) {
          return Right(data.map((e) => e['slug'] as String).toList());
        }
        return Right(data.map((e) => e.toString()).toList());
      }
      return Left(Exception('Invalid categories response'));
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, List<Product>>> getProductsByCategory(String category, {int limit = 20, int skip = 0}) async {
    try {
      final response = await _client.getProductsByCategory(category, limit: limit, skip: skip);
      final productResponse = ProductResponse.fromJson(response.data);
      await _localDataSource.cacheProducts(productResponse.products);
      return Right(productResponse.products);
    } catch (e) {
      return Left(Exception(e.toString()));
    }
  }

  @override
  Future<Either<Exception, Product>> getProduct(int id) async {
    try {
      final response = await _client.getProduct(id);
      final product = ProductModel.fromJson(response.data);
      await _localDataSource.cacheProduct(product);
      return Right(product);
    } catch (e) {
      final cached = await _localDataSource.getProduct(id);
      if (cached != null) return Right(cached);
      return Left(Exception(e.toString()));
    }
  }
}
