

abstract class WishlistEvent {}

class LoadWishlist extends WishlistEvent {}

class ToggleWishlist extends WishlistEvent {
  final int productId;
  ToggleWishlist(this.productId);
}
