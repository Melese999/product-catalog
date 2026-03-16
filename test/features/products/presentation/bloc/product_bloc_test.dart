import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tech_gadol_catalog/features/products/domain/entities/product.dart';
import 'package:tech_gadol_catalog/features/products/domain/repositories/product_repository.dart';
import 'package:tech_gadol_catalog/features/products/presentation/bloc/product_bloc.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late ProductBloc bloc;
  late MockProductRepository mockRepository;

  setUp(() {
    mockRepository = MockProductRepository();
    bloc = ProductBloc(mockRepository);
  });

  tearDown(() {
    bloc.close();
  });

  const tProduct = Product(
    id: 1,
    title: 'Test Product',
    description: 'Description',
    price: 100,
    discountPercentage: 0,
    rating: 4.5,
    stock: 10,
    brand: 'Brand',
    category: 'Category',
    thumbnail: '...',
    images: [],
  );

  group('ProductBloc', () {
    test('initial state should be ProductState', () {
      expect(bloc.state, const ProductState());
    });

    group('FetchProducts', () {
      blocTest<ProductBloc, ProductState>(
        'emits [loading, loading with categories, loaded] when FetchProducts is successful',
        build: () {
          when(() => mockRepository.getCategories())
              .thenAnswer((_) async => const Right(['Category']));
          when(() => mockRepository.getProducts(limit: any(named: 'limit'), skip: any(named: 'skip')))
              .thenAnswer((_) async => const Right([tProduct]));
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchProducts()),
        expect: () => [
          const ProductState(listStatus: ProductStatus.loading),
          const ProductState(listStatus: ProductStatus.loading, categories: ['Category']),
          const ProductState(
            listStatus: ProductStatus.loaded,
            products: [tProduct],
            categories: ['Category'],
            skip: 1,
            hasReachedMax: true,
          ),
        ],
      );

      blocTest<ProductBloc, ProductState>(
        'emits [loading, error] when FetchProducts fails',
        build: () {
          when(() => mockRepository.getCategories())
              .thenAnswer((_) async => Left(Exception('Failed')));
          when(() => mockRepository.getProducts(limit: any(named: 'limit'), skip: any(named: 'skip')))
              .thenAnswer((_) async => Left(Exception('Failed')));
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchProducts()),
        expect: () => [
          const ProductState(listStatus: ProductStatus.loading),
          isA<ProductState>().having((s) => s.listStatus, 'listStatus', ProductStatus.error),
        ],
      );
    });

    group('SearchProducts', () {
      blocTest<ProductBloc, ProductState>(
        'emits [loading, loaded] when SearchProductsEvent is added',
        build: () {
          when(() => mockRepository.searchProducts(any(), limit: any(named: 'limit'), skip: any(named: 'skip')))
              .thenAnswer((_) async => const Right([tProduct]));
          return bloc;
        },
        act: (bloc) => bloc.add(const SearchProductsEvent('phone')),
        wait: const Duration(milliseconds: 600), // Account for debounce
        expect: () => [
          const ProductState(
            listStatus: ProductStatus.loading,
            searchQuery: 'phone',
            skip: 0,
            products: [],
            hasReachedMax: false,
          ),
          const ProductState(
            listStatus: ProductStatus.loaded,
            products: [tProduct],
            searchQuery: 'phone',
            skip: 1,
            hasReachedMax: true,
          ),
        ],
      );
    });

    group('FetchProductDetail', () {
      blocTest<ProductBloc, ProductState>(
        'emits [loading, loaded] when FetchProductDetail is successful',
        build: () {
          when(() => mockRepository.getProduct(any()))
              .thenAnswer((_) async => const Right(tProduct));
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchProductDetail(1)),
        expect: () => [
          const ProductState(detailStatus: ProductStatus.loading),
          const ProductState(
            detailStatus: ProductStatus.loaded,
            selectedProduct: tProduct,
          ),
        ],
      );

      blocTest<ProductBloc, ProductState>(
        'emits [loading, error] when FetchProductDetail fails',
        build: () {
          when(() => mockRepository.getProduct(any()))
              .thenAnswer((_) async => Left(Exception('Failed')));
          return bloc;
        },
        act: (bloc) => bloc.add(const FetchProductDetail(1)),
        expect: () => [
          const ProductState(detailStatus: ProductStatus.loading),
          isA<ProductState>().having((s) => s.detailStatus, 'detailStatus', ProductStatus.error),
        ],
      );
    });
  });
}
