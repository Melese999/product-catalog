import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tech_gadol_catalog/core/design_system/pages/showcase_page.dart';
import 'package:tech_gadol_catalog/features/products/presentation/pages/catalog_shell.dart';

class AppRouter {
  static final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/products',
    routes: [
      GoRoute(
        path: '/showcase',
        builder: (context, state) => const ShowcasePage(),
      ),
      GoRoute(
        path: '/products',
        builder: (context, state) => const CatalogShell(),
        routes: [
          GoRoute(
            path: ':productId',
            builder: (context, state) {
              final productId = int.tryParse(state.pathParameters['productId'] ?? '') ?? 0;
              return CatalogShell(selectedProductId: productId);
            },
          ),
        ],
      ),
    ],
  );
}
