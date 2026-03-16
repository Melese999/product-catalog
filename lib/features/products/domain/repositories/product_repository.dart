import 'package:dartz/dartz.dart';
import 'package:tech_gadol_catalog/features/products/domain/entities/product.dart';

abstract class ProductRepository {
  Future<Either<Exception, List<Product>>> getProducts({int limit = 20, int skip = 0});
  Future<Either<Exception, List<Product>>> searchProducts(String query, {int limit = 20, int skip = 0});
  Future<Either<Exception, List<String>>> getCategories();
  Future<Either<Exception, List<Product>>> getProductsByCategory(String category, {int limit = 20, int skip = 0});
  Future<Either<Exception, Product>> getProduct(int id);
}
