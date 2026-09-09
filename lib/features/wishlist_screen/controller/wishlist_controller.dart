import 'package:flutter/material.dart';
import '../../../core/services/cart_service.dart';
import '../../../core/services/favorites_service.dart';
import '../../home_screen/model/product_model.dart';

class WishlistController extends ChangeNotifier {
  final FavoritesService _favoritesService = FavoritesService.instance;
  final CartService _cartService = CartService.instance;

  WishlistController() {
    _favoritesService.addListener(_onServiceChanged);
    _cartService.addListener(_onServiceChanged);
  }

  void _onServiceChanged() {
    notifyListeners();
  }

  List<Product> get items => _favoritesService.favorites;
  int get itemCount => _favoritesService.count;
  bool get isEmpty => _favoritesService.favorites.isEmpty;

  bool isInCart(int? productId) => _cartService.isInCart(productId);

  Future<void> toggleWishlist(Product product, BuildContext context) async {
    if (product.id == null) return;
    final isNowFav = await _favoritesService.toggleFavorite(product);

    if (context.mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isNowFav
                ? 'Added "${product.displayTitle}" to Favorites'
                : 'Removed "${product.displayTitle}" from Favorites',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> removeItem(Product product, BuildContext context) async {
    if (product.id == null) return;
    await _favoritesService.removeFavorite(product.id!);

    if (context.mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Removed "${product.displayTitle}" from Favorites'),
          backgroundColor: Colors.black,
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> moveToCart(Product product, BuildContext context) async {
    if (product.id != null) {
      await _cartService.addToCart(product);
      await _favoritesService.removeFavorite(product.id!);
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Moved "${product.displayTitle}" to Cart'),
          backgroundColor: Colors.black,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> moveAllToCart(BuildContext context) async {
    final count = _favoritesService.count;
    for (final item in _favoritesService.favorites) {
      if (item.id != null) {
        await _cartService.addToCart(item);
      }
    }
    await _favoritesService.clearFavorites();

    if (context.mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Moved all $count items to Cart!'),
          backgroundColor: Colors.black,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> clearWishlist(BuildContext context) async {
    await _favoritesService.clearFavorites();

    if (context.mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Favorites cleared'),
          backgroundColor: Colors.black,
          duration: Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void dispose() {
    _favoritesService.removeListener(_onServiceChanged);
    _cartService.removeListener(_onServiceChanged);
    super.dispose();
  }
}
