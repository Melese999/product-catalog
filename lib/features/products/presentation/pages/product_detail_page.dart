import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tech_gadol_catalog/core/design_system/app_colors.dart';
import 'package:tech_gadol_catalog/core/design_system/theme_cubit.dart';
import 'package:tech_gadol_catalog/core/design_system/widgets/status_states.dart';
import 'package:tech_gadol_catalog/features/products/domain/entities/product.dart';
import 'package:tech_gadol_catalog/features/products/domain/repositories/product_repository.dart';
import 'package:tech_gadol_catalog/features/products/presentation/bloc/product_bloc.dart';

class ProductDetailPage extends StatelessWidget {
  final int productId;
  final bool showAppBar;

  const ProductDetailPage({
    super.key,
    required this.productId,
    this.showAppBar = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProductBloc(
        context.read<ProductRepository>(),
      )..add(FetchProductDetail(productId)),
      child: _ProductDetailView(showAppBar: showAppBar),
    );
  }
}

class _ProductDetailView extends StatelessWidget {
  final bool showAppBar;

  const _ProductDetailView({required this.showAppBar});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        return Scaffold(
          appBar: showAppBar
              ? AppBar(
                  title: const Text('Product Details'),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.brightness_4),
                      onPressed: () => context.read<ThemeCubit>().toggleTheme(),
                    ),
                  ],
                )
              : null,
          body: _buildBody(context, state),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, ProductState state) {
    switch (state.detailStatus) {
      case ProductStatus.initial:
      case ProductStatus.loading:
        return const _ProductDetailShimmer();
      case ProductStatus.loaded:
        if (state.selectedProduct == null) {
          return const EmptyState(message: 'Product not found');
        }
        return _ProductDetailContent(product: state.selectedProduct!);
      case ProductStatus.error:
        return ErrorState(
          onRetry: () => context.read<ProductBloc>().add(FetchProductDetail(state.selectedProduct?.id ?? 0)),
          message: state.errorMessage ?? 'An error occurred',
        );
      case ProductStatus.empty:
        return const EmptyState(message: 'Product not found');
    }
  }
}

class _ProductDetailShimmer extends StatelessWidget {
  const _ProductDetailShimmer();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final baseColor = isDark ? Colors.grey[900]! : Colors.grey[300]!;
    final highlightColor = isDark ? Colors.grey[800]! : Colors.grey[100]!;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 32, width: 250, color: Colors.white),
                  const SizedBox(height: 16),
                  Container(height: 24, width: 150, color: Colors.white),
                  const SizedBox(height: 24),
                  Container(height: 20, width: double.infinity, color: Colors.white),
                  const SizedBox(height: 8),
                  Container(height: 20, width: double.infinity, color: Colors.white),
                  const SizedBox(height: 8),
                  Container(height: 20, width: 200, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductDetailContent extends StatelessWidget {
  final Product product;

  const _ProductDetailContent({required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ImageGallery(images: product.images, productId: product.id),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        product.title,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: isDark ? AppColors.gold : null,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '\$${product.price.toStringAsFixed(0)}',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: isDark ? Colors.white : AppColors.gold,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  product.category.toUpperCase(),
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: AppColors.gold,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.star_rounded, color: AppColors.gold, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            product.rating.toString(),
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.gold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '${product.stock} Units Available',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: product.stock < 10 ? AppColors.error : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Text(
                  'Overview',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  product.description,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    height: 1.6,
                    color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.gold,
                      foregroundColor: AppColors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                        letterSpacing: 1,
                      ),
                    ),
                    child: const Text('ADD TO CART'),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageGallery extends StatefulWidget {
  final List<String> images;
  final int productId;

  const _ImageGallery({required this.images, required this.productId});

  @override
  State<_ImageGallery> createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<_ImageGallery> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.images.length,
            onPageChanged: (index) => setState(() => _currentIndex = index),
            itemBuilder: (context, index) {
              final image = widget.images[index];
              final imageWidget = CachedNetworkImage(
                imageUrl: image,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey[900]! : Colors.grey[300]!,
                  highlightColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800]! : Colors.grey[100]!,
                  child: Container(color: Colors.white),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              );

              if (index == 0) {
                return Hero(
                  tag: 'product-image-${widget.productId}',
                  child: imageWidget,
                );
              }
              return imageWidget;
            },
          ),
        ),
        if (widget.images.length > 1) ...[
          // Left Arrow
          if (_currentIndex > 0)
            Positioned(
              left: 10,
              child: _ArrowButton(
                icon: Icons.chevron_left_rounded,
                onPressed: () => _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ),
              ),
            ),
          // Right Arrow
          if (_currentIndex < widget.images.length - 1)
            Positioned(
              right: 10,
              child: _ArrowButton(
                icon: Icons.chevron_right_rounded,
                onPressed: () => _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                ),
              ),
            ),
          // Dots
          Positioned(
            bottom: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.images.length,
                (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index 
                        ? AppColors.gold 
                        : Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _ArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _ArrowButton({required this.icon, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.3),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 28),
        onPressed: onPressed,
      ),
    );
  }
}
