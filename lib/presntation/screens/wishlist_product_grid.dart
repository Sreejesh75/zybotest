import 'package:flutter/material.dart';
import '../../data/models/wishlist_product.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/wishlist/wishlist_bloc.dart';
import '../../logic/wishlist/wishlist_event.dart';

class WishlistProductGrid extends StatelessWidget {
  final List<WishlistProduct> products;
  const WishlistProductGrid({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.7,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return _WishlistProductCard(product: product);
      },
    );
  }
}

class _WishlistProductCard extends StatelessWidget {
  final WishlistProduct product;
  const _WishlistProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      color: const Color(0xFFF7F7FA),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                  child: product.featuredImage.isNotEmpty
                      ? Image.network(product.featuredImage, fit: BoxFit.cover)
                      : Container(color: Colors.grey[200]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Text(
                      '₹${product.mrp}',
                      style: const TextStyle(
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '₹${product.salePrice}',
                      style: const TextStyle(
                        color: Color(0xFF2323C7),
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.star, color: Color(0xFFFFA800), size: 18),
                    const SizedBox(width: 4),
                    Text(
                      product.avgRating.toStringAsFixed(1),
                      style: const TextStyle(
                        color: Color(0xFF23235B),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(
                  product.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF23235B),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Positioned(
            top: 10,
            right: 10,
            child: GestureDetector(
              onTap: () {
                context.read<WishlistBloc>().add(ToggleWishlist(product.id));
              },
              child: Image.asset(
                product.inWishlist
                    ? 'assets/images/wishlisted.png'
                    : 'assets/images/not_wishlisted.png',
                width: 28,
                height: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
