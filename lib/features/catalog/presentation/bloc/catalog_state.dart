import 'package:equatable/equatable.dart';
import '../../domain/entities/product_entity.dart';

enum CatalogStatus { initial, loading, success, failure }

class CatalogState extends Equatable {
  final CatalogStatus status;
  final List<ProductEntity> allProducts;
  final List<ProductEntity> filteredProducts;
  final String selectedCategory;
  final String searchQuery;
  final List<String> categories;
  final int favoriteCount;
  final double favoriteTotalPrice;
  final String? errorMessage;

  const CatalogState({
    this.status = CatalogStatus.initial,
    this.allProducts = const [],
    this.filteredProducts = const [],
    this.selectedCategory = '',
    this.searchQuery = '',
    this.categories = const [],
    this.favoriteCount = 0,
    this.favoriteTotalPrice = 0.0,
    this.errorMessage,
  });

  bool get isLoading => status == CatalogStatus.loading;
  bool get hasError => errorMessage != null;
  bool get isEmpty => status == CatalogStatus.success && filteredProducts.isEmpty;

  bool isFavorite(String productId) {
    try {
      final product = allProducts.firstWhere((p) => p.id == productId);
      return product.isFavorite;
    } catch (_) {
      return false;
    }
  }

  CatalogState copyWith({
    CatalogStatus? status,
    List<ProductEntity>? allProducts,
    List<ProductEntity>? filteredProducts,
    String? selectedCategory,
    String? searchQuery,
    List<String>? categories,
    int? favoriteCount,
    double? favoriteTotalPrice,
    String? errorMessage,
  }) {
    return CatalogState(
      status: status ?? this.status,
      allProducts: allProducts ?? this.allProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      searchQuery: searchQuery ?? this.searchQuery,
      categories: categories ?? this.categories,
      favoriteCount: favoriteCount ?? this.favoriteCount,
      favoriteTotalPrice: favoriteTotalPrice ?? this.favoriteTotalPrice,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        allProducts,
        filteredProducts,
        selectedCategory,
        searchQuery,
        categories,
        favoriteCount,
        favoriteTotalPrice,
        errorMessage,
      ];
}
