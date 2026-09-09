import 'package:flutter/material.dart';
import '../../home_screen/model/product_model.dart';
import '../model/cart_item_model.dart';
import '../service/cart_service.dart';

class CartController extends ChangeNotifier {
  final CartService _cartService = CartService.instance;
  bool _isCheckingOut = false;

  CartController() {
    _cartService.addListener(_onCartChanged);
  }

  void _onCartChanged() {
    notifyListeners();
  }

  List<CartItemModel> get items => _cartService.items;
  int get itemCount => _cartService.itemCount;
  bool get isEmpty => _cartService.isEmpty;
  bool get isCheckingOut => _isCheckingOut;

  double get subtotal => _cartService.subtotal;
  double get shipping => _cartService.shipping;
  double get tax => _cartService.tax;
  double get total => _cartService.total;

  Future<void> addToCart(Product product, {int quantity = 1}) async {
    await _cartService.addToCart(product, quantity: quantity);
  }

  Future<void> incrementQuantity(CartItemModel item) async {
    if (item.product.id != null) {
      await _cartService.incrementQuantity(item.product.id!);
    }
  }

  Future<void> decrementQuantity(CartItemModel item, BuildContext context) async {
    if (item.product.id != null) {
      if (item.quantity > 1) {
        await _cartService.decrementQuantity(item.product.id!);
      } else {
        await removeItem(item, context);
      }
    }
  }

  Future<void> removeItem(CartItemModel item, BuildContext context) async {
    if (item.product.id != null) {
      await _cartService.removeItem(item.product.id!);
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Removed "${item.product.displayTitle}" from Cart'),
          backgroundColor: Colors.black,
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> clearCart(BuildContext context) async {
    await _cartService.clearCart();

    if (context.mounted) {
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
  }

  Future<void> checkout(BuildContext context) async {
    _isCheckingOut = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    await _cartService.clearCart();
    _isCheckingOut = false;
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
            'Thank you for your purchase. Your order is being processed.',
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

  @override
  void dispose() {
    _cartService.removeListener(_onCartChanged);
    super.dispose();
  }
}
