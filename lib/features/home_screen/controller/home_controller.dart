import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/services/cart_service.dart';
import '../../../core/services/favorites_service.dart';
import '../model/category_model.dart';
import '../model/product_model.dart';
import '../service/home_product_service.dart';

class HomeController extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();
  final HomeProductService _homeService = HomeProductService.instance;
  final FavoritesService _favoritesService = FavoritesService.instance;
  final CartService _cartService = CartService.instance;

  Timer? _searchDebounce;

  bool _isLoading = false;
  bool _isCategoriesLoading = false;
  String? _errorMessage;
  ProductModel? _productModel;
  List<Product> _allProducts = [];
  List<ProductCategoryModel> _categoryModels = [];
  List<String> _categories = ['All'];
  String _selectedCategory = 'All';
  String _searchQuery = '';

  bool get isLoading => _isLoading;
  bool get isCategoriesLoading => _isCategoriesLoading;
  String? get errorMessage => _errorMessage;
  ProductModel? get productModel => _productModel;
  List<Product> get allProducts => _allProducts;
  List<ProductCategoryModel> get categoryModels => _categoryModels;
  List<String> get categories => _categories;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  int get cartCount => _cartService.itemCount;
  int get wishlistCount => _favoritesService.count;

  HomeController() {
    _favoritesService.addListener(_onServiceChanged);
    _cartService.addListener(_onServiceChanged);
    fetchProducts();
    fetchCategories();
  }

  void _onServiceChanged() {
    notifyListeners();
  }

  Future<void> fetchProducts() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _homeService.getProducts(limit: 50);
      _productModel = result;
      _allProducts = result.products ?? [];
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCategories() async {
    _isCategoriesLoading = true;
    notifyListeners();

    try {
      final result = await _homeService.getCategories();
      _categoryModels = result;
      if (result.isNotEmpty) {
        _categories = [
          'All',
          ...result.map((c) => c.name ?? _capitalize(c.slug ?? '')),
        ];
      }
    } catch (_) {
      // Fallback default categories if network fails
      _categories = const [
        'All',
        'Beauty',
        'Fragrances',
        'Furniture',
        'Groceries',
      ];
    } finally {
      _isCategoriesLoading = false;
      notifyListeners();
    }
  }

  String _capitalize(String s) {
    if (s.isEmpty) return s;
    return s[0].toUpperCase() + s.substring(1);
  }

  Future<void> searchProductsApi(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      fetchProducts();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final searchResult = await _homeService.searchProducts(trimmed);
      final searchList = searchResult.products ?? [];
      _allProducts = searchList.map((p) => Product.fromJson(p.toJson())).toList();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void onSearchChanged(String query) {
    _searchQuery = query;
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      searchProductsApi(query);
    });
  }

  void clearSearch() {
    searchController.clear();
    _searchQuery = '';
    _searchDebounce?.cancel();
    fetchProducts();
  }

  List<Product> get filteredProducts {
    if (_selectedCategory == 'All') {
      return _allProducts;
    }
    return _allProducts.where((product) {
      final productCat = product.displayCategory.toLowerCase();
      final selCat = _selectedCategory.toLowerCase();
      return productCat == selCat || productCat.contains(selCat) || selCat.contains(productCat);
    }).toList();
  }

  void selectCategory(String category) {
    if (_selectedCategory != category) {
      _selectedCategory = category;
      notifyListeners();
    }
  }

  bool isWishlisted(int? productId) => _favoritesService.isFavorite(productId);

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

  bool isInCart(int? productId) => _cartService.isInCart(productId);

  Future<void> toggleCart(Product product, BuildContext context) async {
    if (product.id == null) return;
    final inCart = _cartService.isInCart(product.id);
    if (inCart) {
      await _cartService.removeItem(product.id!);
    } else {
      await _cartService.addToCart(product);
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            !inCart
                ? 'Added "${product.displayTitle}" to Cart'
                : 'Removed "${product.displayTitle}" from Cart',
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  void dispose() {
    _favoritesService.removeListener(_onServiceChanged);
    _cartService.removeListener(_onServiceChanged);
    _searchDebounce?.cancel();
    searchController.dispose();
    super.dispose();
  }
}
