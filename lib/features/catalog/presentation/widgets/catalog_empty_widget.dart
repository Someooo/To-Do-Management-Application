import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/catalog_bloc.dart';
import '../bloc/catalog_event.dart';
import '../bloc/catalog_state.dart';

class CatalogEmptyWidget extends StatelessWidget {
  const CatalogEmptyWidget({
    super.key,
    this.onClearFilters,
  });

  final VoidCallback? onClearFilters;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return BlocBuilder<CatalogBloc, CatalogState>(
      builder: (context, state) {
        final hasActiveFilters =
            state.searchQuery.isNotEmpty || state.selectedCategory.isNotEmpty;

        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.search_off_rounded,
                  size: 64,
                  color: colorScheme.onSurface.withValues(alpha: 0.25),
                ),
                const SizedBox(height: 20),
                Text(
                  'No products found',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Try changing your search or filters.',
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  textAlign: TextAlign.center,
                ),
                if (hasActiveFilters) ...[
                  const SizedBox(height: 20),
                  OutlinedButton.icon(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      if (onClearFilters != null) {
                        onClearFilters!();
                      } else {
                        context
                            .read<CatalogBloc>()
                            .add(const CatalogClearFiltersRequested());
                      }
                    },
                    icon: const Icon(Icons.filter_alt_off_rounded, size: 18),
                    label: const Text('Clear Filters'),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
