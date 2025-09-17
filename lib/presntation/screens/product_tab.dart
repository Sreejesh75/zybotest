import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zybo_test/data/models/product_model.dart';
import 'package:zybo_test/logic/product/product_bloc.dart';
import 'package:zybo_test/repository/apiservices/product_repository.dart';
import 'package:zybo_test/services/wishlist_service.dart';

class ProductTab extends StatelessWidget {
  const ProductTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductBloc(ProductRepository())..add(FetchProducts()),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7FA),
        appBar: AppBar(
          title: const Text(
            'Popular Product',
            style: TextStyle(
              color: Color(0xFF23235B),
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          iconTheme: const IconThemeData(color: Color(0xFF23235B)),
        ),
        body: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductError) {
              return Center(child: Text(state.message));
            } else if (state is ProductLoaded) {
              final products = state.products;
              if (products.isEmpty) {
                return const Center(child: Text('No products found.'));
              }
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 8.0,
                ),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.75,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return _ProductCard(product: product);
                  },
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _ProductCard extends StatefulWidget {
  final Product product;
  const _ProductCard({required this.product});

  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  late bool wishlisted;

  get async => null;

  @override
  void initState() {
    super.initState();
    wishlisted = false;
    _checkWishlist();
  }

  Future<void> _checkWishlist() async {
    final wishlist = await WishlistService.getWishlist();
    setState(() {
      wishlisted = wishlist.any((item) => item['id'] == widget.product.id);
    });
  }

  void _toggleWishlist(String productId) async {
    if (wishlisted) {
      await WishlistService.removeFromWishlist(widget.product.id);
    } else {
      await WishlistService.addToWishlist({
        "id": widget.product.id,
        "name": widget.product.name,
        "mrp": widget.product.mrp,
        "salePrice": widget.product.salePrice,
        "image": widget.product.featuredImage,
      });
    }
    _checkWishlist();
    setState(() {
      wishlisted = !wishlisted;
    });
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
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
                  child: product.featuredImage != null
                      ? Image.network(product.featuredImage!, fit: BoxFit.cover)
                      : Container(color: Colors.grey[200]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
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
                      '4.5', // Static rating for now
                      style: const TextStyle(
                        color: Color(0xFF23235B),
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            top: 12,
            right: 12,
            child: GestureDetector(
              onTap: () {
                _toggleWishlist(widget.product.id.toString());
              },

              child: Image.asset(
                wishlisted
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
