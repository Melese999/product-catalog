import 'package:flutter/material.dart';
import 'package:tech_gadol_catalog/features/products/presentation/pages/product_list_page.dart';
import 'package:tech_gadol_catalog/features/products/presentation/pages/product_detail_page.dart';

class CatalogShell extends StatefulWidget {
  final int? selectedProductId;

  const CatalogShell({super.key, this.selectedProductId});

  @override
  State<CatalogShell> createState() => _CatalogShellState();
}

class _CatalogShellState extends State<CatalogShell> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 768) {
          return _MasterDetailLayout(
            selectedProductId: widget.selectedProductId,
          );
        }
        if (widget.selectedProductId != null) {
          return ProductDetailPage(productId: widget.selectedProductId!);
        }
        return const ProductListPage();
      },
    );
  }
}

class _MasterDetailLayout extends StatelessWidget {
  final int? selectedProductId;

  const _MasterDetailLayout({this.selectedProductId});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Master Panel - 3 Proportion
        const Expanded(
          flex: 5,
          child: ProductListPage(
            showAppBar: true,
            isListMode: true, // One product per line on tablet
          ),
        ),
        const VerticalDivider(width: 1),
        // Detail Panel - 9 Proportion
        Expanded(
          flex: 7,
          child: selectedProductId != null
              ? ProductDetailPage(
                  productId: selectedProductId!,
                  showAppBar: false,
                )
              : const Scaffold(
                  body: Center(
                    child: Text('Select a product to view details'),
                  ),
                ),
        ),
      ],
    );
  }
}
