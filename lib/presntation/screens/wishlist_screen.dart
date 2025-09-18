import 'package:zybo_test/logic/wishlist/wishlist_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zybo_test/logic/wishlist/wishlist_state.dart';
import 'wishlist_product_grid.dart';
import 'package:zybo_test/logic/wishlist/wishlist_bloc.dart';

import 'package:zybo_test/repository/apiservices/wishlist_service.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => WishlistBloc(WishlistService())..add(LoadWishlist()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Wishlist'),
          automaticallyImplyLeading: false,
        ),
        body: BlocBuilder<WishlistBloc, WishlistState>(
          builder: (context, state) {
            if (state is WishlistLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is WishlistError) {
              return Center(child: Text(state.message));
            } else if (state is WishlistLoaded) {
              if (state.products.isEmpty) {
                return const Center(child: Text('No products in wishlist.'));
              }
              return Padding(
                padding: const EdgeInsets.all(12.0),
                child: WishlistProductGrid(products: state.products),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
