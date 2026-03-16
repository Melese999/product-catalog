import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_gadol_catalog/core/design_system/theme_cubit.dart';
import 'package:tech_gadol_catalog/core/design_system/widgets/category_chip.dart';
import 'package:tech_gadol_catalog/core/design_system/widgets/product_card.dart';
import 'package:tech_gadol_catalog/core/design_system/widgets/search_bar.dart';
import 'package:tech_gadol_catalog/core/design_system/widgets/status_states.dart';
import 'package:tech_gadol_catalog/features/products/domain/repositories/product_repository.dart';
import 'package:tech_gadol_catalog/features/products/presentation/bloc/product_bloc.dart';

class ProductListPage extends StatelessWidget {
  final bool showAppBar;
  final bool isListMode;

  const ProductListPage({
    super.key,
    this.showAppBar = true,
    this.isListMode = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductBloc(
        context.read<ProductRepository>(),
      )..add(const FetchProducts()),
      child: _ProductListView(
        showAppBar: showAppBar,
        isListMode: isListMode,
      ),
    );
  }
}

class _ProductListView extends StatefulWidget {
  final bool showAppBar;
  final bool isListMode;

  const _ProductListView({
    required this.showAppBar,
    required this.isListMode,
  });

  @override
  State<_ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<_ProductListView> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<ProductBloc>().add(LoadMoreProducts());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.showAppBar
          ? AppBar(
              title: const Text('Product Catalog'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.style_rounded, size: 20),
                  tooltip: 'Design System Showcase',
                  onPressed: () => context.push('/showcase'),
                ),
                IconButton(
                  icon: const Icon(Icons.brightness_4),
                  onPressed: () => context.read<ThemeCubit>().toggleTheme(),
                ),
              ],
            )
          : null,
      body: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: AppSearchBar(
                  controller: _searchController,
                  onChanged: (query) => context.read<ProductBloc>().add(SearchProductsEvent(query)),
                ),
              ),
              if (state.categories.isNotEmpty)
                SizedBox(
                  height: 64,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: state.categories.length,
                    itemBuilder: (context, index) {
                      final category = state.categories[index];
                      return CategoryChip(
                        label: category,
                        isSelected: state.selectedCategory == category,
                        onSelected: () => context.read<ProductBloc>().add(SelectCategory(category)),
                      );
                    },
                  ),
                ),
              Expanded(
                child: _buildBody(context, state),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, ProductState state) {
    switch (state.listStatus) {
      case ProductStatus.initial:
      case ProductStatus.loading:
        if (state.products.isEmpty) {
          return ProductGridLoader(isList: widget.isListMode);
        }
        return _buildItemsView(context, state);
      case ProductStatus.loaded:
        if (state.products.isEmpty) {
          return const EmptyState(message: 'No products found');
        }
        return _buildItemsView(context, state);
      case ProductStatus.empty:
        return const EmptyState(message: 'No products found');
      case ProductStatus.error:
        if (state.products.isEmpty) {
          return ErrorState(
            onRetry: () => context.read<ProductBloc>().add(const FetchProducts(isRefresh: true)),
            message: state.errorMessage ?? 'An error occurred',
          );
        }
        return _buildItemsView(context, state);
    }
  }

  Widget _buildItemsView(BuildContext context, ProductState state) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<ProductBloc>().add(const FetchProducts(isRefresh: true));
      },
      child: AnimationLimiter(
        child: ListView.separated(
          controller: _scrollController,
          padding: const EdgeInsets.all(16),
          itemCount: state.hasReachedMax ? state.products.length : state.products.length + 1,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) => _buildItem(context, state, index, true),
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, ProductState state, int index, bool isList) {
    if (index >= state.products.length) {
      return const Center(child: Padding(
        padding: EdgeInsets.all(8.0),
        child: CircularProgressIndicator(),
      ));
    }
    final product = state.products[index];
    return AnimationConfiguration.staggeredList(
      position: index,
      duration: const Duration(milliseconds: 375),
      child: SlideAnimation(
        verticalOffset: 50.0,
        child: FadeInAnimation(
          child: ProductCard(
            product: product,
            isWide: isList,
            onTap: () => context.go('/products/${product.id}'),
          ),
        ),
      ),
    );
  }
}
