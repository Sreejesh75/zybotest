

import 'package:zybo_test/data/models/wishlist_product.dart';

abstract class WishlistState {}

class WishlistLoading extends WishlistState {}

class WishlistLoaded extends WishlistState {
  final List<WishlistProduct> products;
  WishlistLoaded(this.products);
}

class WishlistError extends WishlistState {
  final String message;
  WishlistError(this.message);
}
