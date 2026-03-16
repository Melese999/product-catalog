import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tech_gadol_catalog/features/products/domain/entities/product.dart';
import 'package:tech_gadol_catalog/features/products/domain/repositories/product_repository.dart';

// --- Events ---
abstract class ProductEvent extends Equatable {
  const ProductEvent();
  @override
  List<Object?> get props => [];
}

class FetchProducts extends ProductEvent {
  final bool isRefresh;
  const FetchProducts({this.isRefresh = false});
  @override
  List<Object?> get props => [isRefresh];
}

class SearchProductsEvent extends ProductEvent {
  final String query;
  const SearchProductsEvent(this.query);
  @override
  List<Object?> get props => [query];
}

class SelectCategory extends ProductEvent {
  final String? category;
  const SelectCategory(this.category);
  @override
  List<Object?> get props => [category];
}

class LoadMoreProducts extends ProductEvent {}

class FetchProductDetail extends ProductEvent {
  final int id;
  const FetchProductDetail(this.id);
  @override
  List<Object?> get props => [id];
}

// --- States ---
enum ProductStatus { initial, loading, loaded, error, empty }

class ProductState extends Equatable {
  final ProductStatus listStatus;
  final ProductStatus detailStatus;
  final List<Product> products;
  final List<String> categories;
  final String? selectedCategory;
  final String searchQuery;
  final int skip;
  final bool hasReachedMax;
  final Product? selectedProduct;
  final String? errorMessage;

  const ProductState({
    this.listStatus = ProductStatus.initial,
    this.detailStatus = ProductStatus.initial,
    this.products = const [],
    this.categories = const [],
    this.selectedCategory,
    this.searchQuery = '',
    this.skip = 0,
    this.hasReachedMax = false,
    this.selectedProduct,
    this.errorMessage,
  });

  ProductState copyWith({
    ProductStatus? listStatus,
    ProductStatus? detailStatus,
    List<Product>? products,
    List<String>? categories,
    String? selectedCategory,
    String? searchQuery,
    int? skip,
    bool? hasReachedMax,
    Product? selectedProduct,
    String? errorMessage,
  }) {
    return ProductState(
      listStatus: listStatus ?? this.listStatus,
      detailStatus: detailStatus ?? this.detailStatus,
      products: products ?? this.products,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      skip: skip ?? this.skip,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      selectedProduct: selectedProduct ?? this.selectedProduct,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        listStatus,
        detailStatus,
        products,
        categories,
        selectedCategory,
        searchQuery,
        skip,
        hasReachedMax,
        selectedProduct,
        errorMessage,
      ];
}

// --- Bloc ---
class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _repository;
  static const int _limit = 20;

  ProductBloc(this._repository) : super(const ProductState()) {
    on<FetchProducts>(_onFetchProducts);
    on<SearchProductsEvent>(
      _onSearchProducts,
      transformer: (events, mapper) => events
          .debounceTime(const Duration(milliseconds: 500))
          .switchMap(mapper),
    );
    on<SelectCategory>(_onSelectCategory);
    on<LoadMoreProducts>(_onLoadMoreProducts);
    on<FetchProductDetail>(_onFetchProductDetail);
  }

  Future<void> _onFetchProducts(FetchProducts event, Emitter<ProductState> emit) async {
    if (event.isRefresh) {
      emit(state.copyWith(listStatus: ProductStatus.loading, skip: 0, products: [], hasReachedMax: false));
    } else if (state.products.isEmpty) {
      emit(state.copyWith(listStatus: ProductStatus.loading));
    }

    if (state.categories.isEmpty) {
      final categoryResult = await _repository.getCategories();
      categoryResult.fold(
        (l) => null,
        (r) => emit(state.copyWith(categories: r)),
      );
    }

    await _fetchData(emit);
  }

  Future<void> _onSearchProducts(SearchProductsEvent event, Emitter<ProductState> emit) async {
    if (event.query == state.searchQuery) return;
    emit(state.copyWith(
      listStatus: ProductStatus.loading,
      searchQuery: event.query,
      skip: 0,
      products: [],
      hasReachedMax: false,
    ));
    await _fetchData(emit);
  }

  Future<void> _onSelectCategory(SelectCategory event, Emitter<ProductState> emit) async {
    final newCategory = event.category == state.selectedCategory ? null : event.category;
    emit(state.copyWith(
      listStatus: ProductStatus.loading,
      selectedCategory: newCategory,
      skip: 0,
      products: [],
      hasReachedMax: false,
    ));
    await _fetchData(emit);
  }

  Future<void> _onLoadMoreProducts(LoadMoreProducts event, Emitter<ProductState> emit) async {
    if (state.hasReachedMax || state.listStatus == ProductStatus.loading) return;
    await _fetchData(emit);
  }

  Future<void> _onFetchProductDetail(FetchProductDetail event, Emitter<ProductState> emit) async {
    emit(state.copyWith(detailStatus: ProductStatus.loading));
    final result = await _repository.getProduct(event.id);
    result.fold(
      (l) => emit(state.copyWith(detailStatus: ProductStatus.error, errorMessage: l.toString())),
      (r) => emit(state.copyWith(detailStatus: ProductStatus.loaded, selectedProduct: r)),
    );
  }

  Future<void> _fetchData(Emitter<ProductState> emit) async {
    final result = state.searchQuery.isNotEmpty
        ? await _repository.searchProducts(state.searchQuery, limit: _limit, skip: state.skip)
        : state.selectedCategory != null
            ? await _repository.getProductsByCategory(state.selectedCategory!, limit: _limit, skip: state.skip)
            : await _repository.getProducts(limit: _limit, skip: state.skip);

    result.fold(
      (l) => emit(state.copyWith(listStatus: ProductStatus.error, errorMessage: l.toString())),
      (r) {
        if (r.isEmpty) {
          if (state.skip == 0) {
            emit(state.copyWith(listStatus: ProductStatus.empty));
          } else {
            emit(state.copyWith(hasReachedMax: true));
          }
        } else {
          final int nextSkip = state.skip + r.length;
          emit(state.copyWith(
            listStatus: ProductStatus.loaded,
            products: List.of(state.products)..addAll(r),
            skip: nextSkip,
            hasReachedMax: r.length < _limit,
          ));
        }
      },
    );
  }
}
