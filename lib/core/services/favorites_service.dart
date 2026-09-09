import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/home_screen/model/product_model.dart';

class FavoritesService extends ChangeNotifier {
  FavoritesService._internal();
  static final FavoritesService instance = FavoritesService._internal();
  factory FavoritesService() => instance;

  static const String _storageKey = 'aurify_favorite_products';

  final List<Product> _favorites = [];
  final Set<int> _favoriteIds = {};
  bool _isInitialized = false;

  List<Product> get favorites => List.unmodifiable(_favorites);
  Set<int> get favoriteIds => Set.unmodifiable(_favoriteIds);
  int get count => _favorites.length;
  bool get isInitialized => _isInitialized;

  /// Initialize local storage and load favorites
  Future<void> init() async {
    if (_isInitialized) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? jsonString = prefs.getString(_storageKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        final List<dynamic> decoded = json.decode(jsonString);
        _favorites.clear();
        _favoriteIds.clear();
        for (final item in decoded) {
          if (item is Map<String, dynamic>) {
            final product = Product.fromJson(item);
            if (product.id != null) {
              _favorites.add(product);
              _favoriteIds.add(product.id!);
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading favorites from local storage: $e');
    } finally {
      _isInitialized = true;
      notifyListeners();
    }
  }

  /// Check if a product is marked as favorite
  bool isFavorite(int? productId) {
    if (productId == null) return false;
    return _favoriteIds.contains(productId);
  }

  /// Toggle favorite status of a product (persists locally)
  Future<bool> toggleFavorite(Product product) async {
    if (product.id == null) return false;

    if (isFavorite(product.id)) {
      await removeFavorite(product.id!);
      return false; // removed
    } else {
      await addFavorite(product);
      return true; // added
    }
  }

  /// Add a product to favorites and persist
  Future<void> addFavorite(Product product) async {
    if (product.id == null) return;
    if (!_favoriteIds.contains(product.id)) {
      _favorites.add(product);
      _favoriteIds.add(product.id!);
      await _persist();
      notifyListeners();
    }
  }

  /// Remove a product from favorites by ID and persist
  Future<void> removeFavorite(int productId) async {
    final removed = _favoriteIds.remove(productId);
    if (removed) {
      _favorites.removeWhere((p) => p.id == productId);
      await _persist();
      notifyListeners();
    }
  }

  /// Clear all favorites and persist
  Future<void> clearFavorites() async {
    _favorites.clear();
    _favoriteIds.clear();
    await _persist();
    notifyListeners();
  }

  /// Helper to write to SharedPreferences
  Future<void> _persist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<Map<String, dynamic>> rawList =
          _favorites.map((p) => p.toJson()).toList();
      final jsonString = json.encode(rawList);
      await prefs.setString(_storageKey, jsonString);
    } catch (e) {
      debugPrint('Error saving favorites to local storage: $e');
    }
  }
}
