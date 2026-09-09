import 'package:flutter/material.dart';
import '../../home_screen/model/product_model.dart';
import '../model/cart_item_model.dart';

class CartController extends ChangeNotifier {
  final List<CartItemModel> _items = [];
  bool _isCheckingOut = false;

  CartController({List<CartItemModel>? initialItems}) {
    if (initialItems != null && initialItems.isNotEmpty) {
      _items.addAll(initialItems);
    } else {
      _items.addAll([
        CartItemModel(
          product: const ProductModel(
            id: '1',
            title: 'Minimalist Chrono Watch',
            category: 'Watches',
            brand: 'AURIFY TIMEPIECES',
            price: 249.00,
            originalPrice: 299.00,
            discountPercentage: 17.0,
            rating: 4.8,
            reviewCount: 128,
            stock: 14,
            imageUrl:
                'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600&auto=format&fit=crop&q=80',
          ),
          quantity: 1,
        ),
        CartItemModel(
          product: const ProductModel(
            id: '2',
            title: 'Monochrome Runner Sneakers',
            category: 'Footwear',
            brand: 'AURIFY ATHLETICS',
            price: 189.50,
            originalPrice: 220.00,
            discountPercentage: 14.0,
            rating: 4.9,
            reviewCount: 254,
            stock: 22,
            imageUrl:
                'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=600&auto=format&fit=crop&q=80',
          ),
          quantity: 2,
        ),
      ]);
    }
  }

  List<CartItemModel> get items => List.unmodifiable(_items);
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  bool get isEmpty => _items.isEmpty;
  bool get isCheckingOut => _isCheckingOut;

  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get shipping => subtotal > 150 ? 0.0 : 15.0; // Free shipping above $150
  double get tax => subtotal * 0.08; // 8% tax
  double get total => subtotal + shipping + tax;

  void incrementQuantity(CartItemModel item) {
    if (item.quantity < item.product.stock) {
      item.quantity++;
      notifyListeners();
    }
  }

  void decrementQuantity(CartItemModel item, BuildContext context) {
    if (item.quantity > 1) {
      item.quantity--;
      notifyListeners();
    } else {
      removeItem(item, context);
    }
  }

  void removeItem(CartItemModel item, BuildContext context) {
    _items.removeWhere((i) => i.product.id == item.product.id);
    notifyListeners();

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Removed "${item.product.title}" from Cart'),
        backgroundColor: Colors.black,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void clearCart(BuildContext context) {
    _items.clear();
    notifyListeners();

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Cart cleared'),
        backgroundColor: Colors.black,
        duration: Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> checkout(BuildContext context) async {
    _isCheckingOut = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    _isCheckingOut = false;
    _items.clear();
    notifyListeners();

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text(
            'Order Placed!',
            style: TextStyle(fontWeight: FontWeight.w800, color: Colors.black),
          ),
          content: const Text(
            'Thank you for your purchase. Your monochrome order is being processed.',
            style: TextStyle(color: Colors.black87),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pop(ctx); // Close dialog
                Navigator.pop(context); // Go back
              },
              child: const Text('Back to Shop'),
            ),
          ],
        ),
      );
    }
  }
}
