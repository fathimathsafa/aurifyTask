class ApiEndpoints {
  ApiEndpoints._();

  static const String baseUrl = 'https://dummyjson.com';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);

  static const String products = '/products';
  static const String searchProducts = '/products/search';
  static const String categories = '/products/categories';

  static String productDetails(int id) => '/products/$id';
  static String productsByCategory(String categorySlug) => '/products/category/$categorySlug';
}
