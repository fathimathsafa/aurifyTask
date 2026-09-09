import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../features/cart_screen/controller/cart_controller.dart';
import '../../features/cart_screen/view/cart_screen.dart';
import '../../features/home_screen/controller/home_controller.dart';
import '../../features/home_screen/model/product_model.dart';
import '../../features/home_screen/view/home_screen.dart';
import '../../features/login_screen/controller/login_controller.dart';
import '../../features/login_screen/view/login_screen.dart';
import '../../features/product_details_screen/controller/product_details_controller.dart';
import '../../features/product_details_screen/view/product_details_screen.dart';
import '../../features/profile_screen/controller/profile_controller.dart';
import '../../features/profile_screen/view/profile_screen.dart';
import '../../features/registration_screen/controller/registration_controller.dart';
import '../../features/registration_screen/view/registration_screen.dart';
import '../../features/splash_screen/view/splash_screen.dart';
import '../../features/wishlist_screen/controller/wishlist_controller.dart';
import '../../features/wishlist_screen/view/wishlist_screen.dart';
import 'app_routes.dart';

class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.initial:
      case AppRoutes.splash:
        return _buildRoute(
          settings: settings,
          builder: (_) => const SplashScreen(),
        );

      case AppRoutes.register:
        return _buildRoute(
          settings: settings,
          builder: (_) => ChangeNotifierProvider(
            create: (_) => RegistrationController(),
            child: RegistrationScreen(),
          ),
        );

      case AppRoutes.login:
        return _buildRoute(
          settings: settings,
          builder: (_) => ChangeNotifierProvider(
            create: (_) => LoginController(),
            child: LoginScreen(),
          ),
        );

      case AppRoutes.home:
        return _buildRoute(
          settings: settings,
          builder: (_) => ChangeNotifierProvider(
            create: (_) => HomeController(),
            child: const HomeScreen(),
          ),
        );

      case AppRoutes.productDetails:
        return _buildRoute(
          settings: settings,
          builder: (_) => ChangeNotifierProvider(
            create: (_) => ProductDetailsController(
              productId: settings.arguments is int ? settings.arguments as int : null,
              initialProduct: settings.arguments is Product ? settings.arguments as Product : null,
            ),
            child: ProductDetailsScreen(),
          ),
        );

      case AppRoutes.wishlist:
        return _buildRoute(
          settings: settings,
          builder: (_) => ChangeNotifierProvider(
            create: (_) => WishlistController(),
            child: WishlistScreen(),
          ),
        );

      case AppRoutes.cart:
        return _buildRoute(
          settings: settings,
          builder: (_) => ChangeNotifierProvider(
            create: (_) => CartController(),
            child: CartScreen(),
          ),
        );

      case AppRoutes.profile:
        return _buildRoute(
          settings: settings,
          builder: (_) => ChangeNotifierProvider(
            create: (_) => ProfileController(),
            child: ProfileScreen(),
          ),
        );

      default:
        return _errorRoute(settings);
    }
  }

  static MaterialPageRoute<dynamic> _buildRoute({
    required RouteSettings settings,
    required WidgetBuilder builder,
  }) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: builder,
    );
  }

  static Route<dynamic> _errorRoute(RouteSettings settings) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Page Not Found')),
        body: Center(
          child: Text('No route defined for ${settings.name}'),
        ),
      ),
    );
  }
}

extension AppNavigationExtension on BuildContext {
  Future<T?> pushNamed<T extends Object?>(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed<T>(routeName, arguments: arguments);
  }

  Future<T?> pushReplacementNamed<T extends Object?, TO extends Object?>(
    String routeName, {
    TO? result,
    Object? arguments,
  }) {
    return Navigator.of(this).pushReplacementNamed<T, TO>(
      routeName,
      result: result,
      arguments: arguments,
    );
  }

  Future<T?> pushNamedAndRemoveUntil<T extends Object?>(
    String newRouteName,
    bool Function(Route<dynamic>) predicate, {
    Object? arguments,
  }) {
    return Navigator.of(this).pushNamedAndRemoveUntil<T>(
      newRouteName,
      predicate,
      arguments: arguments,
    );
  }

  void pop<T extends Object?>([T? result]) {
    Navigator.of(this).pop<T>(result);
  }
}
