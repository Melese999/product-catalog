import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tech_gadol_catalog/core/design_system/app_colors.dart';
import 'package:tech_gadol_catalog/core/design_system/theme_cubit.dart';
import 'package:tech_gadol_catalog/core/design_system/widgets/app_button.dart';
import 'package:tech_gadol_catalog/core/design_system/widgets/category_chip.dart';
import 'package:tech_gadol_catalog/core/design_system/widgets/product_card.dart';
import 'package:tech_gadol_catalog/core/design_system/widgets/search_bar.dart' as ds;
import 'package:tech_gadol_catalog/core/design_system/widgets/status_states.dart';
import 'package:tech_gadol_catalog/features/products/domain/entities/product.dart';

class ShowcasePage extends StatelessWidget {
  const ShowcasePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Design System Showcase'),
        actions: [
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, mode) {
              return IconButton(
                icon: Icon(mode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
                onPressed: () => context.read<ThemeCubit>().toggleTheme(),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(context, 'Typography', [
            Text('Headline Large', style: theme.textTheme.headlineLarge),
            Text('Headline Medium', style: theme.textTheme.headlineMedium),
            Text('Title Large', style: theme.textTheme.titleLarge),
            Text('Title Medium', style: theme.textTheme.titleMedium),
            Text('Body Large', style: theme.textTheme.bodyLarge),
            Text('Body Medium', style: theme.textTheme.bodyMedium),
            Text('Label Small', style: theme.textTheme.labelSmall),
          ]),
          _buildSection(context, 'Colors', [
            _buildColorRow('Primary', theme.colorScheme.primary, theme.colorScheme.onPrimary),
            _buildColorRow('Secondary', theme.colorScheme.secondary, theme.colorScheme.onSecondary),
            _buildColorRow('Surface', theme.colorScheme.surface, theme.colorScheme.onSurface),
            _buildColorRow('Gold', AppColors.gold, Colors.black),
          ]),
          _buildSection(context, 'Buttons', [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                AppButton(text: 'Primary', onPressed: () {}, type: AppButtonType.primary),
                AppButton(text: 'Secondary', onPressed: () {}, type: AppButtonType.secondary),
                AppButton(text: 'Outline', onPressed: () {}, type: AppButtonType.outline),
                AppButton(text: 'Ghost', onPressed: () {}, type: AppButtonType.ghost),
                const AppButton(text: 'Loading', onPressed: null, isLoading: true),
                const AppButton(text: 'Disabled', onPressed: null),
              ],
            ),
          ]),
          _buildSection(context, 'Chips', [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                CategoryChip(label: 'Smartphones', isSelected: true, onSelected: () {}),
                CategoryChip(label: 'Laptops', isSelected: false, onSelected: () {}),
                CategoryChip(label: 'Fragrances', isSelected: false, onSelected: () {}),
              ],
            ),
          ]),
          _buildSection(context, 'Search Bar', [
            ds.AppSearchBar(
              controller: TextEditingController(),
              onChanged: (_) {},
            ),
          ]),
          _buildSection(context, 'Product Cards', [
            const Text('Professional List View Card (Gold Accent)'),
            const SizedBox(height: 8),
            ProductCard(
              product: _dummyProduct,
              isWide: true,
              onTap: () {},
            ),
          ]),
          _buildSection(context, 'Shimmer Loading', [
            const ProductCardShimmer.list(),
          ]),
          _buildSection(context, 'Status States', [
            const Text('Empty State'),
            StatusState.empty(),
            const Divider(),
            const Text('Error State'),
            StatusState.error(onRetry: () {}),
          ]),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title.toUpperCase(),
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: AppColors.gold,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const Divider(color: AppColors.gold, thickness: 1),
            ],
          ),
        ),
        ...children,
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildColorRow(String name, Color color, Color textColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(name, style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
            ),
            Flexible(
              child: Text(color.toString().toUpperCase().replaceAll('COLOR(', '').replaceAll(')', ''), 
                   style: TextStyle(color: textColor, fontSize: 10),
                   overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }

  static const _dummyProduct = Product(
    id: 1,
    title: 'iPhone 13 Pro Max Special Edition',
    description: 'A premium gadget with gold accents.',
    price: 999.0,
    discountPercentage: 10.5,
    rating: 4.8,
    stock: 50,
    brand: 'Apple',
    category: 'smartphones',
    thumbnail: 'https://cdn.dummyjson.com/product-images/1/thumbnail.jpg',
    images: [],
  );
}
