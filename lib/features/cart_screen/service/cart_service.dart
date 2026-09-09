import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../home_screen/model/product_model.dart';
import '../model/cart_item_model.dart';

class CartService extends ChangeNotifier {
  CartService._internal();
  static final CartService instance = CartService._internal();
  factory CartService() => instance;

  static const String _storageKey = 'aurify_cart_items';

  final List<CartItemModel> _items = [];
  bool _isInitialized = false;

  List<CartItemModel> get items => List.unmodifiable(_items);
  int get itemCount => _items.fold(0, (sum, item) => sum + item.quantity);
  bool get isEmpty => _items.isEmpty;
  bool get isInitialized => _isInitialized;

  double get subtotal => _items.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get shipping => subtotal > 150 ? 0.0 : (subtotal > 0 ? 15.0 : 0.0);
  double get tax => subtotal * 0.08;
  double get total => subtotal > 0 ? (subtotal + shipping + tax) : 0.0;

  /// Check if product is in cart
  bool isInCart(int? productId) {
    if (productId == null) return false;
    return _items.any((item) => item.product.id == productId);
  }

  /// Get quantity of a product in cart
  int getQuantity(int? productId) {
    if (productId == null) return 0;
    final index = _items.indexWhere((item) => item.product.id == productId);
    return index != -1 ? _items[index].quantity : 0;
  }

  /// Initialize local storage and load cart items
  Future<void> init() async {
    if (_isInitialized) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonString = prefs.getString(_storageKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> decoded = json.decode(jsonString);
        _items.clear();
        for (final item in decoded) {
          if (item is Map<String, dynamic>) {
            final cartItem = CartItemModel.fromJson(item);
            if (cartItem.product.id != null) {
              _items.add(cartItem);
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading cart from local storage: $e');
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  /// Add product to cart with specified quantity and persist
  Future<void> addToCart(Product product, {int quantity = 1}) async {
    if (product.id == null || quantity <= 0) return;

    final existingIndex = _items.indexWhere((item) => item.product.id == product.id);
    if (existingIndex != -1) {
      _items[existingIndex].quantity += quantity;
    } else {
      _items.add(CartItemModel(product: product, quantity: quantity));
    }
    await _persist();
    notifyListeners();
  }

  /// Increment quantity of a product
  Future<void> incrementQuantity(int productId) async {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      final item = _items[index];
      final maxStock = item.product.safeStock > 0 ? item.product.safeStock : 999;
      if (item.quantity < maxStock) {
        item.quantity++;
        await _persist();
        notifyListeners();
      }
    }
  }

  /// Decrement quantity of a product
  Future<void> decrementQuantity(int productId) async {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
        await _persist();
        notifyListeners();
      } else {
        await removeItem(productId);
      }
    }
  }

  /// Set exact quantity for a product
  Future<void> updateQuantity(int productId, int quantity) async {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index != -1) {
      if (quantity <= 0) {
        await removeItem(productId);
      } else {
        _items[index].quantity = quantity;
        await _persist();
        notifyListeners();
      }
    }
  }

  /// Remove a product from cart and persist
  Future<void> removeItem(int productId) async {
    final initialLength = _items.length;
    _items.removeWhere((item) => item.product.id == productId);
    if (_items.length != initialLength) {
      await _persist();
      notifyListeners();
    }
  }

  /// Clear entire cart and persist
  Future<void> clearCart() async {
    _items.clear();
    await _persist();
    notifyListeners();
  }

  /// Helper to write cart items to SharedPreferences
  Future<void> _persist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> rawList =
          _items.map((item) => item.toJson()).toList();
      final jsonString = json.encode(rawList);
      await prefs.setString(_storageKey, jsonString);
    } catch (e) {
      debugPrint('Error saving cart to local storage: $e');
    }
  }
}
