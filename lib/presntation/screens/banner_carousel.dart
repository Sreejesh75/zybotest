import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zybo_test/logic/banner/banner_bloc.dart';

class BannerCarousel extends StatelessWidget {
  const BannerCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BannerBloc, BannerState>(
      builder: (context, state) {
        if (state is BannerLoading) {
          return const SizedBox(
            height: 160,
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (state is BannerError) {
          return SizedBox(
            height: 160,
            child: Center(child: Text(state.message, style: TextStyle(color: Colors.red))),
          );
        } else if (state is BannerLoaded) {
          final banners = state.banners;
          if (banners.isEmpty) {
            return const SizedBox(height: 160);
          }
          return SizedBox(
            height: 160,
            child: PageView.builder(
              itemCount: banners.length,
              
              controller: PageController(viewportFraction: 0.9),
              itemBuilder: (context, index) {
                final banner = banners[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: banner['image'] != null
                        ? Image.network(
                            banner['image'],
                            fit: BoxFit.cover,
                            width: double.infinity,
                          )
                        : Container(color: Colors.grey[300]),
                  ),
                );
              },
            ),
          );
        }
        return const SizedBox(height: 160);
      },
    );
  }
}
