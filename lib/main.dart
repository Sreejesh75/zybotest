import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zybo_test/logic/auth/auth_bloc.dart';
import 'package:zybo_test/logic/banner/banner_bloc.dart';
import 'package:zybo_test/logic/product/product_bloc.dart';
import 'package:zybo_test/presntation/screens/login_screen.dart';
import 'package:zybo_test/presntation/screens/splash_screen.dart';
import 'package:zybo_test/repository/apiservices/auth_provider.dart';
import 'package:zybo_test/repository/apiservices/banner_repository.dart';
import 'package:zybo_test/repository/apiservices/product_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final bannerRepo = BannerRepository();
    final productRepo = ProductRepository();
    final authRepo = AuthProvider();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => BannerBloc(bannerRepo)),
        BlocProvider(create: (_) => ProductBloc(productRepo)),
        BlocProvider(create: (_) => AuthBloc(authRepo)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Product Listing App',
        theme: ThemeData(primarySwatch: Colors.deepPurple),
        home: const SplashScreen(),
      ),
    );
  }
}
