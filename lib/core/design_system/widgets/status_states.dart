import 'package:flutter/material.dart';
import 'package:tech_gadol_catalog/core/design_system/widgets/product_card.dart';
import 'app_button.dart';

class StatusState extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onRetry;
  final String? retryText;

  const StatusState._({
    required this.title,
    required this.message,
    required this.icon,
    this.onRetry,
    this.retryText,
  });

  factory StatusState.empty({
    String title = 'No results found',
    String message = 'Try adjusting your filters or search terms.',
  }) {
    return StatusState._(
      title: title,
      message: message,
      icon: Icons.search_off,
    );
  }

  factory StatusState.error({
    String title = 'Something went wrong',
    String message = 'Failed to fetch products. Please check your connection.',
    required VoidCallback onRetry,
  }) {
    return StatusState._(
      title: title,
      message: message,
      icon: Icons.error_outline,
      onRetry: onRetry,
      retryText: 'Retry',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: theme.colorScheme.secondary),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.textTheme.bodySmall?.color,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              AppButton(
                text: retryText ?? 'Retry',
                onPressed: onRetry,
                type: AppButtonType.outline,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class LoadingState extends StatelessWidget {
  const LoadingState({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

class EmptyState extends StatelessWidget {
  final String message;
  const EmptyState({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return StatusState.empty(message: message);
  }
}

class ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const ErrorState({super.key, required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return StatusState.error(message: message, onRetry: onRetry);
  }
}

class ProductGridLoader extends StatelessWidget {
  final bool isList;
  const ProductGridLoader({super.key, this.isList = false});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      itemCount: 6,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) => const ProductCardShimmer.list(),
    );
  }
}
