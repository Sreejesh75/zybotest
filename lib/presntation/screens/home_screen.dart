import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zybo_test/data/models/product_model.dart';
import 'package:zybo_test/logic/banner/banner_bloc.dart';
import 'package:zybo_test/logic/product/product_bloc.dart';
import 'package:zybo_test/presntation/screens/wishlist_screen.dart';
import 'package:zybo_test/presntation/screens/profile_screen.dart';
import 'package:zybo_test/repository/apiservices/banner_repository.dart';
import 'package:zybo_test/repository/apiservices/product_repository.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const _HomeTab(),
    WishlistScreen(), // removed const
    ProfileScreen(),  // removed const
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => BannerBloc(BannerRepository())..add(FetchBanners()),
        ),
        BlocProvider(
          create: (_) => ProductBloc(ProductRepository())..add(FetchProducts()),
        ),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F7FA),
        body: SafeArea(
          child: IndexedStack(
            index: _selectedIndex,
            children: _screens,
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF6C63FF),
          unselectedItemColor: Colors.grey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Wishlist'),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

/// Home Tab (original content)
class _HomeTab extends StatefulWidget {
  const _HomeTab();

  @override
  State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _searchResults = [];
  bool _isSearching = false;
  String? _searchError;

  Future<void> _searchProducts(String query) async {
    setState(() {
      _isSearching = true;
      _searchError = null;
      _searchResults = [];
    });
    try {

final response = await http.get(
  Uri.parse('http://skilltestflutter.zybotechlab.com/api/search?query=$query'),
  headers: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  },
);


      print('Search API response status: [32m${response.statusCode}[0m');
      print('Search API response body: ${response.body}');
      if (response.statusCode == 200) {
        final List data = json.decode(response.body);
        setState(() {
          _searchResults = data.map((e) => Product.fromJson(e)).toList();
        });
      } else {
        setState(() {
          _searchError = 'Search failed: ${response.statusCode}\n${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _searchError = 'Error: $e';
      });
    } finally {
      setState(() {
        _isSearching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      children: [
        // Search Bar
        Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
          child: Row(
            children: [
              const Icon(Icons.search, color: Colors.grey),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    border: InputBorder.none,
                  ),
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      _searchProducts(value.trim());
                    }
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  final value = _searchController.text.trim();
                  if (value.isNotEmpty) {
                    _searchProducts(value);
                  }
                },
              ),
            ],
          ),
        ),
        if (_isSearching) const Center(child: CircularProgressIndicator()),
        if (_searchError != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(_searchError!, style: const TextStyle(color: Colors.red)),
          ),
        if (_searchResults.isNotEmpty)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Search Results', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 8),
              _ProductGridFull(products: _searchResults),
              const SizedBox(height: 24),
            ],
          ),
        // Banner Carousel
        BlocBuilder<BannerBloc, BannerState>(
          builder: (context, state) {
            if (state is BannerLoading) {
              return const SizedBox(
                height: 120,
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (state is BannerLoaded) {
              final banners = state.banners;
              if (banners.isEmpty) {
                return const SizedBox(height: 120);
              }
              return SizedBox(
                height: 120,
                child: PageView.builder(
                  itemCount: banners.length,
                  controller: PageController(viewportFraction: 0.92),
                  itemBuilder: (context, index) {
                    final banner = banners[index];
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
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
                      child: banner['image'] != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                banner['image'],
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            )
                          : Center(child: Text(banner['title'] ?? '')),
                    );
                  },
                ),
              );
            }
            return const SizedBox(height: 120);
          },
        ),
        const SizedBox(height: 24),
        // Popular Product Section
        const Text(
          'Popular Product',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Color(0xFF23235B),
          ),
        ),
        const SizedBox(height: 12),
        BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductLoaded) {
              final products = state.products.take(4).toList();
              return _ProductGridFull(products: products);
            } else if (state is ProductError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
        const SizedBox(height: 24),
        // Latest Products Section
        const Text(
          'Latest Products',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Color(0xFF23235B),
          ),
        ),
        const SizedBox(height: 12),
        BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductLoaded) {
              final products = state.products.reversed.take(2).toList();
              return _ProductGridFull(products: products);
            } else if (state is ProductError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}

class _ProductGridFull extends StatelessWidget {
  final List<Product> products;
  const _ProductGridFull({required this.products});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
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

  @override
  void initState() {
    super.initState();
    wishlisted = false;
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
                    const Text(
                      '4.5',
                      style: TextStyle(
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
                setState(() {
                  wishlisted = !wishlisted;
                });
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
