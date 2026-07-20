import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/catalog_bloc.dart';
import '../bloc/catalog_event.dart';
import '../bloc/catalog_state.dart';
import 'product_card_widget.dart';

class ProductGridWidget extends StatelessWidget {
  const ProductGridWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CatalogBloc, CatalogState>(
      builder: (context, state) {
        final products = state.filteredProducts;

        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.68,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            final isFav = state.isFavorite(product.id);
            return ProductCardWidget(
              productId: product.id,
              name: product.name,
              category: product.category,
              price: product.price,
              imageUrl: product.imageUrl,
              isFavorite: isFav,
              onFavoriteTap: () {
                context
                    .read<CatalogBloc>()
                    .add(CatalogFavoriteToggled(product.id));
              },
            );
          },
        );
      },
    );
  }
}
