import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zybo_test/logic/banner/banner_bloc.dart';
import 'package:zybo_test/logic/product/product_bloc.dart';
import 'package:zybo_test/presntation/screens/wishlist_screen.dart';
import 'package:zybo_test/presntation/screens/profile_screen.dart';
import 'package:zybo_test/repository/apiservices/banner_repository.dart';
import 'package:zybo_test/repository/apiservices/product_repository.dart';
import 'package:zybo_test/logic/search/search_bloc.dart';
import 'package:zybo_test/logic/search/search_event.dart';
import 'package:zybo_test/logic/search/search_state.dart';
import 'package:zybo_test/presntation/screens/product_grid.dart';
import 'package:zybo_test/presntation/screens/banner_carousel.dart';

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
        BlocProvider(
          create: (_) => SearchBloc(),
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Search Bar at the top
          Container(
            margin: const EdgeInsets.only(bottom: 16, top: 16),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
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
                        context.read<SearchBloc>().add(SearchProducts(value.trim()));
                      }
                      setState(() {});
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () {
                    final value = _searchController.text.trim();
                    if (value.isNotEmpty) {
                      context.read<SearchBloc>().add(SearchProducts(value));
                    }
                    setState(() {});
                  },
                ),
              ],
            ),
          ),
          // Banner carousel below search bar
          const BannerCarousel(),
          BlocBuilder<SearchBloc, SearchState>(
            builder: (context, searchState) {
              final isSearching = _searchController.text.trim().isNotEmpty;
              if (isSearching) {
                if (searchState is SearchLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (searchState is SearchError) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(searchState.message, style: const TextStyle(color: Colors.red)),
                  );
                } else if (searchState is SearchLoaded) {
                  if (searchState.products.isEmpty) {
                    return const Center(child: Text('No products found.'));
                  }
                  return ProductGrid(products: searchState.products);
                }
                return const SizedBox();
              } else {
                // Show all products if not searching
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Text(
                        'Popular Products',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF23235B),
                        ),
                      ),
                    ),
                    BlocBuilder<ProductBloc, ProductState>(
                      builder: (context, productState) {
                        if (productState is ProductLoading) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (productState is ProductError) {
                          return Center(child: Text(productState.message, style: TextStyle(color: Colors.red)));
                        } else if (productState is ProductLoaded) {
                          return ProductGrid(products: productState.products);
                        }
                        return const SizedBox();
                      },
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

