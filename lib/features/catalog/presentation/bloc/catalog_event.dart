import 'package:equatable/equatable.dart';

abstract class CatalogEvent extends Equatable {
  const CatalogEvent();

  @override
  List<Object?> get props => [];
}

class CatalogLoadRequested extends CatalogEvent {
  const CatalogLoadRequested();
}

class CatalogSearchQueryChanged extends CatalogEvent {
  final String query;

  const CatalogSearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class CatalogCategorySelected extends CatalogEvent {
  final String category;

  const CatalogCategorySelected(this.category);

  @override
  List<Object?> get props => [category];
}

class CatalogClearFiltersRequested extends CatalogEvent {
  const CatalogClearFiltersRequested();
}

class CatalogFavoriteToggled extends CatalogEvent {
  final String productId;

  const CatalogFavoriteToggled(this.productId);

  @override
  List<Object?> get props => [productId];
}
