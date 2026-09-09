import 'package:flutter/material.dart';
import '../../../core/services/cart_service.dart';
import '../../../core/services/favorites_service.dart';
import '../../home_screen/model/product_model.dart';
import '../model/product_details_model.dart';
import '../service/product_details_service.dart';

class ProductDetailsController extends ChangeNotifier {
  final ProductDetailsService _service = ProductDetailsService.instance;
  final FavoritesService _favoritesService = FavoritesService.instance;
  final CartService _cartService = CartService.instance;

  int? _productId;
  ProductDetailsModel? _productDetails;
  bool _isLoading = false;
  String? _errorMessage;

  int _selectedImageIndex = 0;
  int _quantity = 1;

  ProductDetailsController({
    int? productId,
    Product? initialProduct,
    ProductDetailsModel? initialDetails,
    bool initialInCart = false,
  }) {
    _favoritesService.addListener(_onServiceChanged);
    _cartService.addListener(_onServiceChanged);

    if (initialDetails != null) {
      _productDetails = initialDetails;
      _productId = initialDetails.id;
    } else if (initialProduct != null) {
      _productId = initialProduct.id;
      _productDetails = ProductDetailsModel(
        id: initialProduct.id,
        title: initialProduct.title,
        description: initialProduct.description,
        category: initialProduct.displayCategory,
        price: initialProduct.price,
        discountPercentage: initialProduct.discountPercentage,
        rating: initialProduct.rating,
        stock: initialProduct.stock,
        tags: initialProduct.tags,
        brand: initialProduct.brand,
        images: initialProduct.images,
        thumbnail: initialProduct.thumbnail,
      );
    } else if (productId != null) {
      _productId = productId;
    }

    if (_productId != null) {
      fetchProductDetails(_productId!);
    }
  }

  void _onServiceChanged() {
    notifyListeners();
  }

  int? get productId => _productId;
  ProductDetailsModel? get productDetails => _productDetails;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  int get selectedImageIndex => _selectedImageIndex;
  int get quantity => _quantity;
  bool get isWishlisted => _favoritesService.isFavorite(_productId);
  bool get isInCart => _cartService.isInCart(_productId);

  double get totalPrice => (_productDetails?.safePrice ?? 0.0) * _quantity;

  Future<void> fetchProductDetails(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final details = await _service.getProductDetails(id);
      _productDetails = details;
      _errorMessage = null;
    } catch (e) {
      if (_productDetails == null) {
        _errorMessage = e.toString();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void setImageIndex(int index) {
    if (_selectedImageIndex != index) {
      _selectedImageIndex = index;
      notifyListeners();
    }
  }

  void incrementQuantity() {
    final stock = _productDetails?.safeStock ?? 10;
    if (_quantity < stock) {
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

  Future<void> toggleWishlist(BuildContext context) async {
    if (_productDetails == null || _productDetails!.id == null) return;

    final product = Product.fromJson(_productDetails!.toJson());
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

  Future<void> addToCart(BuildContext context) async {
    if (_productDetails == null || _productDetails!.id == null) return;

    final product = Product.fromJson(_productDetails!.toJson());
    await _cartService.addToCart(product, quantity: _quantity);

    final title = _productDetails?.displayTitle ?? 'Product';
    if (context.mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added $_quantity x "$title" to Cart!'),
          backgroundColor: Colors.black,
          duration: const Duration(seconds: 2),
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
