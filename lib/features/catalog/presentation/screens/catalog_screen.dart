import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../di.dart';
import '../bloc/catalog_bloc.dart';
import '../bloc/catalog_event.dart';
import '../bloc/catalog_state.dart';
import '../widgets/catalog_app_bar_widget.dart';
import '../widgets/catalog_empty_widget.dart';
import '../widgets/catalog_error_widget.dart';
import '../widgets/catalog_loading_widget.dart';
import '../widgets/category_filter_widget.dart';
import '../widgets/product_grid_widget.dart';
import '../widgets/search_bar_widget.dart';
import '../widgets/summary_card_widget.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({super.key});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  late final TextEditingController _searchTextController;

  @override
  void initState() {
    super.initState();
    _searchTextController = TextEditingController();
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CatalogBloc>(
      create: (_) => getIt<CatalogBloc>()..add(const CatalogLoadRequested()),
      child: Scaffold(
        appBar: const CatalogAppBarWidget(),
        body: SafeArea(
          child: BlocBuilder<CatalogBloc, CatalogState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: SummaryCardWidget(
                      favoriteCount: state.favoriteCount,
                      favoriteTotalPrice: state.favoriteTotalPrice,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SearchBarWidget(
                      controller: _searchTextController,
                      onChanged: (query) {
                        context
                            .read<CatalogBloc>()
                            .add(CatalogSearchQueryChanged(query));
                      },
                    ),
                  ),
                  const SizedBox(height: 8),
                  CategoryFilterWidget(
                    categories: ['All', ...state.categories],
                    selectedCategory: state.selectedCategory,
                    onCategorySelected: (category) {
                      context
                          .read<CatalogBloc>()
                          .add(CatalogCategorySelected(category));
                    },
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: _buildBody(context, state),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, CatalogState state) {
    if (state.isLoading) {
      return const CatalogLoadingWidget();
    }

    if (state.hasError) {
      return CatalogErrorWidget(
        message: state.errorMessage!,
        onRetry: () {
          context.read<CatalogBloc>().add(const CatalogLoadRequested());
        },
      );
    }

    if (state.isEmpty) {
      return CatalogEmptyWidget(
        onClearFilters: () {
          _searchTextController.clear();
          context.read<CatalogBloc>().add(const CatalogClearFiltersRequested());
        },
      );
    }

    return const ProductGridWidget();
  }
}
