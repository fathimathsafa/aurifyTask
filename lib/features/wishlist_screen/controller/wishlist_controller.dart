import 'package:flutter/material.dart';
import '../../home_screen/model/product_model.dart';

class WishlistController extends ChangeNotifier {
  final List<ProductModel> _items = [];
  final Set<String> _cartItemIds = {};

  WishlistController({List<ProductModel>? initialItems}) {
    if (initialItems != null && initialItems.isNotEmpty) {
      _items.addAll(initialItems);
    } else {
      // Default demo wishlisted items for rich showcase
      _items.addAll([
        const ProductModel(
          id: '1',
          title: 'Minimalist Chrono Watch',
          description:
              'Engineered with premium surgical-grade stainless steel and sapphire crystal glass. Features Japanese quartz movement with precision chronometer sub-dials.',
          category: 'Watches',
          brand: 'AURIFY TIMEPIECES',
          price: 249.00,
          originalPrice: 299.00,
          discountPercentage: 17.0,
          rating: 4.8,
          reviewCount: 128,
          stock: 14,
          tags: ['Bestseller', 'Waterproof', 'Sapphire Glass'],
          imageUrl:
              'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600&auto=format&fit=crop&q=80',
          images: [
            'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600&auto=format&fit=crop&q=80',
            'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?w=600&auto=format&fit=crop&q=80',
          ],
        ),
        const ProductModel(
          id: '3',
          title: 'Matte Black Studio Headphones',
          description:
              'Equipped with custom 45mm neodymium dynamic drivers delivering pristine high-fidelity acoustics. Hybrid active noise cancellation.',
          category: 'Audio',
          brand: 'AURIFY ACOUSTICS',
          price: 329.00,
          originalPrice: 389.00,
          discountPercentage: 15.0,
          rating: 4.7,
          reviewCount: 96,
          stock: 8,
          tags: ['Noise Cancelling', 'Hi-Res Audio'],
          imageUrl:
              'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600&auto=format&fit=crop&q=80',
          images: [
            'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600&auto=format&fit=crop&q=80',
          ],
        ),
      ]);
    }
  }

  List<ProductModel> get items => List.unmodifiable(_items);
  int get itemCount => _items.length;
  bool get isEmpty => _items.isEmpty;

  bool isInCart(String productId) => _cartItemIds.contains(productId);

  void removeItem(ProductModel product, BuildContext context) {
    _items.removeWhere((item) => item.id == product.id);
    notifyListeners();

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Removed "${product.title}" from Wishlist'),
        backgroundColor: Colors.black,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void moveToCart(ProductModel product, BuildContext context) {
    _cartItemIds.add(product.id);
    _items.removeWhere((item) => item.id == product.id);
    notifyListeners();

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Moved "${product.title}" to Cart'),
        backgroundColor: Colors.black,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void moveAllToCart(BuildContext context) {
    for (final item in _items) {
      _cartItemIds.add(item.id);
    }
    final count = _items.length;
    _items.clear();
    notifyListeners();

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

  void clearWishlist(BuildContext context) {
    _items.clear();
    notifyListeners();

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Wishlist cleared'),
        backgroundColor: Colors.black,
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
