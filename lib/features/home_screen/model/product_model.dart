class ProductModel {
  final String id;
  final String title;
  final String description;
  final String category;
  final String brand;
  final double price;
  final double? originalPrice;
  final double discountPercentage;
  final double rating;
  final int reviewCount;
  final int stock;
  final List<String> tags;
  final String imageUrl;
  final List<String> images;
  final bool isFavorite;

  const ProductModel({
    required this.id,
    required this.title,
    this.description = '',
    required this.category,
    this.brand = 'Aurify Edition',
    required this.price,
    this.originalPrice,
    this.discountPercentage = 0.0,
    required this.rating,
    required this.reviewCount,
    this.stock = 25,
    this.tags = const [],
    required this.imageUrl,
    this.images = const [],
    this.isFavorite = false,
  });

  List<String> get allImages => images.isNotEmpty ? images : [imageUrl];

  bool get hasDiscount => discountPercentage > 0 || (originalPrice != null && originalPrice! > price);

  ProductModel copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? brand,
    double? price,
    double? originalPrice,
    double? discountPercentage,
    double? rating,
    int? reviewCount,
    int? stock,
    List<String>? tags,
    String? imageUrl,
    List<String>? images,
    bool? isFavorite,
  }) {
    return ProductModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      brand: brand ?? this.brand,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      stock: stock ?? this.stock,
      tags: tags ?? this.tags,
      imageUrl: imageUrl ?? this.imageUrl,
      images: images ?? this.images,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
