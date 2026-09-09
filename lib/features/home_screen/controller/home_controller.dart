import 'package:flutter/material.dart';
import '../model/product_model.dart';

class HomeController extends ChangeNotifier {
  final TextEditingController searchController = TextEditingController();

  String _selectedCategory = 'All';
  String _searchQuery = '';
  final Set<String> _cartItemIds = {};
  final Set<String> _wishlistItemIds = {};

  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  int get cartCount => _cartItemIds.length;
  int get wishlistCount => _wishlistItemIds.length;

  final List<String> categories = const [
    'All',
    'Watches',
    'Footwear',
    'Bags',
    'Audio',
    'Eyewear',
  ];

  final List<ProductModel> _allProducts = const [
    ProductModel(
      id: '1',
      title: 'Minimalist Chrono Watch',
      description:
          'Engineered with premium surgical-grade stainless steel and sapphire crystal glass. Features Japanese quartz movement with precision chronometer sub-dials. Water-resistant up to 5 ATM, designed for everyday luxury.',
      category: 'Watches',
      brand: 'AURIFY TIMEPIECES',
      price: 249.00,
      originalPrice: 299.00,
      discountPercentage: 17.0,
      rating: 4.8,
      reviewCount: 128,
      stock: 14,
      tags: ['Bestseller', 'Waterproof', 'Sapphire Glass', 'Limited Edition'],
      imageUrl:
          'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600&auto=format&fit=crop&q=80',
      images: [
        'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=600&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1522335789203-aabd1fc54bc9?w=600&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1524805444758-089113d48a6d?w=600&auto=format&fit=crop&q=80',
      ],
    ),
    ProductModel(
      id: '2',
      title: 'Monochrome Runner Sneakers',
      description:
          'Ultra-breathable engineered knit upper paired with high-rebound cushioning foam. Lightweight, aerodynamic silhouette tailored for urban running and effortless streetwear style.',
      category: 'Footwear',
      brand: 'AURIFY ATHLETICS',
      price: 189.50,
      originalPrice: 220.00,
      discountPercentage: 14.0,
      rating: 4.9,
      reviewCount: 254,
      stock: 22,
      tags: ['Lightweight', 'High Cushion', 'Breathable', 'Trending'],
      imageUrl:
          'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=600&auto=format&fit=crop&q=80',
      images: [
        'https://images.unsplash.com/photo-1549298916-b41d501d3772?w=600&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1600185365926-3a2ce3cdb9eb?w=600&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1595950653106-6c9ebd614d3a?w=600&auto=format&fit=crop&q=80',
      ],
    ),
    ProductModel(
      id: '3',
      title: 'Matte Black Studio Headphones',
      description:
          'Equipped with custom 45mm neodymium dynamic drivers delivering pristine high-fidelity acoustics. Hybrid active noise cancellation blocks up to 98% of ambient sound. Up to 40 hours of battery life on a single charge.',
      category: 'Audio',
      brand: 'AURIFY ACOUSTICS',
      price: 329.00,
      originalPrice: 389.00,
      discountPercentage: 15.0,
      rating: 4.7,
      reviewCount: 96,
      stock: 8,
      tags: ['Noise Cancelling', 'Hi-Res Audio', 'Bluetooth 5.3', '40H Battery'],
      imageUrl:
          'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600&auto=format&fit=crop&q=80',
      images: [
        'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=600&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1583394838336-acd977736f90?w=600&auto=format&fit=crop&q=80',
      ],
    ),
    ProductModel(
      id: '4',
      title: 'Leather Minimalist Backpack',
      description:
          'Handcrafted from premium full-grain waterproof leather. Features a dedicated 16-inch padded laptop compartment, discreet anti-theft pockets, and ergonomic breathable back panel.',
      category: 'Bags',
      brand: 'AURIFY LEATHER',
      price: 159.00,
      originalPrice: 199.00,
      discountPercentage: 20.0,
      rating: 4.6,
      reviewCount: 84,
      stock: 18,
      tags: ['Full-Grain Leather', '16" Laptop Slot', 'Waterproof', 'Travel Ready'],
      imageUrl:
          'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=600&auto=format&fit=crop&q=80',
      images: [
        'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=600&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1622560480605-d83c853bc5c3?w=600&auto=format&fit=crop&q=80',
      ],
    ),
    ProductModel(
      id: '5',
      title: 'Titanium Polarized Sunglasses',
      description:
          'Ultralight aerospace-grade Japanese titanium frame with scratch-resistant polarized TAC lenses. Provides 100% UV400 protection with glare-reduction coating.',
      category: 'Eyewear',
      brand: 'AURIFY OPTICS',
      price: 135.00,
      originalPrice: 160.00,
      discountPercentage: 15.0,
      rating: 4.9,
      reviewCount: 172,
      stock: 30,
      tags: ['Titanium Frame', 'Polarized', 'UV400', 'Featherlight'],
      imageUrl:
          'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=600&auto=format&fit=crop&q=80',
      images: [
        'https://images.unsplash.com/photo-1511499767150-a48a237f0083?w=600&auto=format&fit=crop&q=80',
        'https://images.unsplash.com/photo-1572635196237-14b3f281503f?w=600&auto=format&fit=crop&q=80',
      ],
    ),
    ProductModel(
      id: '6',
      title: 'Classic Ceramic Analog',
      description:
          'Scratch-proof high-tech ceramic case and bracelet with deployment clasp. Minimalist dial with Swiss luminous hands, built for elegance and timeless durability.',
      category: 'Watches',
      brand: 'AURIFY TIMEPIECES',
      price: 299.00,
      originalPrice: 350.00,
      discountPercentage: 14.0,
      rating: 4.8,
      reviewCount: 65,
      stock: 5,
      tags: ['High-Tech Ceramic', 'Swiss Hands', 'Sapphire Crystal'],
      imageUrl:
          'https://images.unsplash.com/photo-1524805444758-089113d48a6d?w=600&auto=format&fit=crop&q=80',
      images: [
        'https://images.unsplash.com/photo-1524805444758-089113d48a6d?w=600&auto=format&fit=crop&q=80',
      ],
    ),
    ProductModel(
      id: '7',
      title: 'Urban Canvas Tote Bag',
      description:
          'Heavyweight 16oz organic cotton canvas with reinforced dual-stitched handles and interior zip organizer pocket. Perfect for daily commute, grocery runs, and weekend getaways.',
      category: 'Bags',
      brand: 'AURIFY ESSENTIALS',
      price: 79.00,
      rating: 4.5,
      reviewCount: 42,
      stock: 40,
      tags: ['Organic Cotton', 'Reinforced', 'Eco-Friendly'],
      imageUrl:
          'https://images.unsplash.com/photo-1544816155-12df9643f363?w=600&auto=format&fit=crop&q=80',
      images: [
        'https://images.unsplash.com/photo-1544816155-12df9643f363?w=600&auto=format&fit=crop&q=80',
      ],
    ),
    ProductModel(
      id: '8',
      title: 'Wireless Earbuds Pro',
      description:
          'True wireless in-ear earbuds with spatial audio tracking, transparency mode, and IPX7 water resistance. Wireless fast-charging case provides up to 32 hours total playback.',
      category: 'Audio',
      brand: 'AURIFY ACOUSTICS',
      price: 199.00,
      originalPrice: 229.00,
      discountPercentage: 13.0,
      rating: 4.8,
      reviewCount: 310,
      stock: 19,
      tags: ['Spatial Audio', 'IPX7 Waterproof', 'Wireless Charging'],
      imageUrl:
          'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=600&auto=format&fit=crop&q=80',
      images: [
        'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=600&auto=format&fit=crop&q=80',
      ],
    ),
  ];

  List<ProductModel> get filteredProducts {
    return _allProducts.where((product) {
      final matchesCategory = _selectedCategory == 'All' ||
          product.category.toLowerCase() == _selectedCategory.toLowerCase();
      final matchesSearch = _searchQuery.isEmpty ||
          product.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.category.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  void selectCategory(String category) {
    if (_selectedCategory != category) {
      _selectedCategory = category;
      notifyListeners();
    }
  }

  void onSearchChanged(String query) {
    _searchQuery = query.trim();
    notifyListeners();
  }

  void clearSearch() {
    searchController.clear();
    _searchQuery = '';
    notifyListeners();
  }

  bool isWishlisted(String productId) => _wishlistItemIds.contains(productId);

  bool isInCart(String productId) => _cartItemIds.contains(productId);

  void toggleWishlist(String productId, BuildContext context) {
    final willAdd = !_wishlistItemIds.contains(productId);
    if (willAdd) {
      _wishlistItemIds.add(productId);
    } else {
      _wishlistItemIds.remove(productId);
    }
    notifyListeners();

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          willAdd ? 'Added to Wishlist' : 'Removed from Wishlist',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void toggleCart(String productId, BuildContext context) {
    final willAdd = !_cartItemIds.contains(productId);
    if (willAdd) {
      _cartItemIds.add(productId);
    } else {
      _cartItemIds.remove(productId);
    }
    notifyListeners();

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          willAdd ? 'Added to Cart' : 'Removed from Cart',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
