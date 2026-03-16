import 'package:hive/hive.dart';
import 'package:tech_gadol_catalog/features/products/data/models/product_model.dart';

abstract class ProductLocalDataSource {
  Future<void> cacheProducts(List<ProductModel> products);
  Future<List<ProductModel>> getLastProducts();
  Future<void> cacheProduct(ProductModel product);
  Future<ProductModel?> getProduct(int id);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  final Box _box;

  ProductLocalDataSourceImpl(this._box);

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    final Map<int, Map<String, dynamic>> productMap = {
      for (var p in products) p.id: p.toJson()
    };
    await _box.putAll(productMap);
  }

  @override
  Future<List<ProductModel>> getLastProducts() async {
    final productMaps = _box.values.toList();
    return productMaps.map((e) => ProductModel.fromJson(Map<String, dynamic>.from(e))).toList();
  }

  @override
  Future<void> cacheProduct(ProductModel product) async {
    await _box.put(product.id, product.toJson());
  }

  @override
  Future<ProductModel?> getProduct(int id) async {
    final data = _box.get(id);
    if (data != null) {
      return ProductModel.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }
}
