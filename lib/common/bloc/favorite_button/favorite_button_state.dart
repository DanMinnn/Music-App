abstract class FavoritesButtonState {}

class FavoritesButtonInitial extends FavoritesButtonState {}

class FavoritesButtonUpdate extends FavoritesButtonState {
  final bool isFavorites;

  FavoritesButtonUpdate({required this.isFavorites});
}
