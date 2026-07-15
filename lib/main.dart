import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/food_repository.dart';
import 'providers/cart_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/food_provider.dart';
import 'routes/app_routes.dart';
import 'screens/cart_screen.dart';
import 'screens/food_details_screen.dart';
import 'screens/login_screen.dart';
import 'screens/main_shell.dart';
import 'screens/order_success_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/splash_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const FineDineApp());
}

class FineDineApp extends StatelessWidget {
  const FineDineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(
          create: (_) => FoodProvider(FoodRepository()),
        ),
      ],
      child: MaterialApp(
        title: 'FINE DINE',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.splash,
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case AppRoutes.splash:
              return _fadeRoute(const SplashScreen());
            case AppRoutes.onboarding:
              return _fadeRoute(const OnboardingScreen());
            case AppRoutes.login:
              return _fadeRoute(const LoginScreen());
            case AppRoutes.main:
              return _fadeRoute(const MainShell());
            case AppRoutes.home:
              return _fadeRoute(const MainShell());
            case AppRoutes.foodDetails:
              final foodId = settings.arguments as String;
              return MaterialPageRoute(
                builder: (_) => FoodDetailsScreen(foodId: foodId),
              );
            case AppRoutes.cart:
              return MaterialPageRoute(builder: (_) => const CartScreen());
            case AppRoutes.orderSuccess:
              return _fadeRoute(const OrderSuccessScreen());
            default:
              return _fadeRoute(const SplashScreen());
          }
        },
      ),
    );
  }

  static PageRouteBuilder<dynamic> _fadeRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, _, _) => page,
      transitionsBuilder: (_, animation, _, child) {
        return FadeTransition(opacity: animation, child: child);
      },
      transitionDuration: const Duration(milliseconds: 400),
    );
  }
}
