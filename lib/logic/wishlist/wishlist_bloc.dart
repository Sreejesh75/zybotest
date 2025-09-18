import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/wishlist_product.dart';
import '../../repository/apiservices/wishlist_service.dart';
import 'wishlist_event.dart';
import 'wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final WishlistService wishlistService;

  WishlistBloc(this.wishlistService) : super(WishlistLoading()) {
    on<LoadWishlist>((event, emit) async {
      emit(WishlistLoading());
      try {
        final products = await wishlistService.fetchWishlist();
        emit(WishlistLoaded(products));
      } catch (e) {
        emit(WishlistError("Failed to load wishlist: $e"));
      }
    });

    on<ToggleWishlist>((event, emit) async {
      try {
        final success = await wishlistService.toggleWishlist(event.productId);
        if (success) {
          // Optionally reload wishlist
          final products = await wishlistService.fetchWishlist();
          emit(WishlistLoaded(products));
        } else {
          emit(WishlistError("Failed to update wishlist."));
        }
      } catch (e) {
        emit(WishlistError("Failed to update wishlist: $e"));
      }
    });
  }
}
