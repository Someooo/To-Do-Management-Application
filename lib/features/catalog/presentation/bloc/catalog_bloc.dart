import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/product_model.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/catalog_repository.dart';
import 'catalog_event.dart';
import 'catalog_state.dart';

class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  CatalogBloc({required CatalogRepository repository})
      : _repository = repository,
        super(const CatalogState()) {
    on<CatalogLoadRequested>(_onLoadRequested);
    on<CatalogSearchQueryChanged>(_onSearchQueryChanged);
    on<CatalogCategorySelected>(_onCategorySelected);
    on<CatalogClearFiltersRequested>(_onClearFiltersRequested);
    on<CatalogFavoriteToggled>(_onFavoriteToggled);
  }

  final CatalogRepository _repository;

  Future<void> _onLoadRequested(
    CatalogLoadRequested event,
    Emitter<CatalogState> emit,
  ) async {
    emit(state.copyWith(status: CatalogStatus.loading, errorMessage: null));

    try {
      final products = await _repository.getProducts();

      var count = 0;
      var total = 0.0;
      for (final p in products) {
        if (p.isFavorite) {
          count++;
          total += p.price;
        }
      }

      final categories = _buildCategories(products);
      final filtered = _applyFilters(
        allProducts: products,
        category: state.selectedCategory,
        query: state.searchQuery,
      );

      emit(state.copyWith(
        status: CatalogStatus.success,
        allProducts: products,
        filteredProducts: filtered,
        categories: categories,
        favoriteCount: count,
        favoriteTotalPrice: total,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: CatalogStatus.failure,
        errorMessage: 'Failed to load products. Please try again.',
      ));
    }
  }

  void _onSearchQueryChanged(
    CatalogSearchQueryChanged event,
    Emitter<CatalogState> emit,
  ) {
    final filtered = _applyFilters(
      allProducts: state.allProducts,
      category: state.selectedCategory,
      query: event.query,
    );
    emit(state.copyWith(
      searchQuery: event.query,
      filteredProducts: filtered,
    ));
  }

  void _onCategorySelected(
    CatalogCategorySelected event,
    Emitter<CatalogState> emit,
  ) {
    final filtered = _applyFilters(
      allProducts: state.allProducts,
      category: event.category,
      query: state.searchQuery,
    );
    emit(state.copyWith(
      selectedCategory: event.category,
      filteredProducts: filtered,
    ));
  }

  void _onClearFiltersRequested(
    CatalogClearFiltersRequested event,
    Emitter<CatalogState> emit,
  ) {
    final filtered = _applyFilters(
      allProducts: state.allProducts,
      category: '',
      query: '',
    );
    emit(state.copyWith(
      searchQuery: '',
      selectedCategory: '',
      filteredProducts: filtered,
    ));
  }

  void _onFavoriteToggled(
    CatalogFavoriteToggled event,
    Emitter<CatalogState> emit,
  ) {
    final updatedAllProducts = state.allProducts.map((p) {
      if (p.id == event.productId) {
        return ProductModel(
          id: p.id,
          name: p.name,
          category: p.category,
          price: p.price,
          imageUrl: p.imageUrl,
          isFavorite: !p.isFavorite,
        );
      }
      return p;
    }).toList();

    var count = 0;
    var total = 0.0;
    for (final p in updatedAllProducts) {
      if (p.isFavorite) {
        count++;
        total += p.price;
      }
    }

    final filtered = _applyFilters(
      allProducts: updatedAllProducts,
      category: state.selectedCategory,
      query: state.searchQuery,
    );

    emit(state.copyWith(
      allProducts: updatedAllProducts,
      filteredProducts: filtered,
      favoriteCount: count,
      favoriteTotalPrice: total,
    ));
  }

  List<ProductEntity> _applyFilters({
    required List<ProductEntity> allProducts,
    required String category,
    required String query,
  }) {
    final cleanCategory = (category == 'All') ? '' : category;
    final cleanQuery = query.trim().toLowerCase();

    if (cleanCategory.isNotEmpty && cleanQuery.isNotEmpty) {
      return allProducts
          .where((p) =>
              p.category == cleanCategory &&
              p.name.toLowerCase().contains(cleanQuery))
          .toList();
    } else if (cleanCategory.isNotEmpty) {
      return allProducts.where((p) => p.category == cleanCategory).toList();
    } else if (cleanQuery.isNotEmpty) {
      return allProducts
          .where((p) => p.name.toLowerCase().contains(cleanQuery))
          .toList();
    } else {
      return allProducts;
    }
  }

  List<String> _buildCategories(List<ProductEntity> products) {
    final seen = <String>{};
    final result = <String>[];
    for (final product in products) {
      if (seen.add(product.category)) {
        result.add(product.category);
      }
    }
    result.sort();
    return result;
  }
}
