import 'package:flutter_test/flutter_test.dart';
import 'package:tech_gadol_catalog/features/products/data/models/product_model.dart';

void main() {
  group('ProductModel', () {
    final tJson = {
      'id': 1,
      'title': 'iPhone 9',
      'description': 'An apple mobile which is nothing like apple',
      'price': 549,
      'discountPercentage': 12.96,
      'rating': 4.69,
      'stock': 94,
      'brand': 'Apple',
      'category': 'smartphones',
      'thumbnail': '...',
      'images': ['...', '...'],
    };

    test('should return a valid model from JSON', () {
      final result = ProductModel.fromJson(tJson);
      expect(result.id, 1);
      expect(result.title, 'iPhone 9');
      expect(result.price, 549.0);
    });

    test('should handle missing or null fields gracefully', () {
      final jsonMissingFields = {
        'id': 1,
        // title, description, price are missing
      };
      
      final result = ProductModel.fromJson(jsonMissingFields);
      
      expect(result.title, 'Unknown Title');
      expect(result.description, 'No description available');
      expect(result.price, 0.0);
      expect(result.brand, 'Unknown Brand');
    });

    test('should handle negative price by defaulting to 0.0', () {
      final jsonNegativePrice = {
        'id': 1,
        'price': -100,
      };
      
      final result = ProductModel.fromJson(jsonNegativePrice);
      
      expect(result.price, 0.0);
    });

    test('should calculate discounted price correctly', () {
      final jsonWithDiscount = {
        'id': 1,
        'price': 100,
        'discountPercentage': 10,
      };
      
      final result = ProductModel.fromJson(jsonWithDiscount);
      
      expect(result.discountedPrice, 90.0);
    });
  });
}
