import 'package:flutter/material.dart';
import '../../home_screen/model/product_model.dart';

class ProductDetailsController extends ChangeNotifier {
  final ProductModel product;

  int _selectedImageIndex = 0;
  int _quantity = 1;
  bool _isWishlisted = false;
  bool _isInCart = false;

  ProductDetailsController({
    required this.product,
    bool initialWishlisted = false,
    bool initialInCart = false,
  })  : _isWishlisted = initialWishlisted,
        _isInCart = initialInCart;

  int get selectedImageIndex => _selectedImageIndex;
  int get quantity => _quantity;
  bool get isWishlisted => _isWishlisted;
  bool get isInCart => _isInCart;

  double get totalPrice => product.price * _quantity;

  void setImageIndex(int index) {
    if (_selectedImageIndex != index) {
      _selectedImageIndex = index;
      notifyListeners();
    }
  }

  void incrementQuantity() {
    if (_quantity < product.stock) {
      _quantity++;
      notifyListeners();
    }
  }

  void decrementQuantity() {
    if (_quantity > 1) {
      _quantity--;
      notifyListeners();
    }
  }

  void toggleWishlist(BuildContext context) {
    _isWishlisted = !_isWishlisted;
    notifyListeners();

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isWishlisted ? 'Added to Wishlist' : 'Removed from Wishlist',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void addToCart(BuildContext context) {
    _isInCart = true;
    notifyListeners();

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added $_quantity x "${product.title}" to Cart!'),
        backgroundColor: Colors.black,
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
