import 'package:dio/dio.dart';
import '../../../core/constants/api_endpoints.dart';
import '../model/category_model.dart';
import '../model/product_model.dart';
import '../model/product_search_model.dart';

class HomeProductService {
  HomeProductService._internal();
  static final HomeProductService instance = HomeProductService._internal();
  factory HomeProductService() => instance;

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: ApiEndpoints.baseUrl,
      connectTimeout: ApiEndpoints.connectTimeout,
      receiveTimeout: ApiEndpoints.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  /// Fetch products from ApiEndpoints.products
  Future<ProductModel> getProducts({int limit = 30, int skip = 0}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.products,
        queryParameters: {
          'limit': limit,
          'skip': skip,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        if (response.data is Map<String, dynamic>) {
          return ProductModel.fromJson(response.data as Map<String, dynamic>);
        } else if (response.data is String) {
          return productModelFromJson(response.data as String);
        }
      }
      throw 'Failed to load products (status: ${response.statusCode})';
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw 'An unexpected error occurred while fetching products: $e';
    }
  }

  /// Search products from ApiEndpoints.searchProducts
  Future<ProductSearchDetailsModel> searchProducts(String query) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.searchProducts,
        queryParameters: {
          'q': query,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        if (response.data is Map<String, dynamic>) {
          return ProductSearchDetailsModel.fromJson(response.data as Map<String, dynamic>);
        } else if (response.data is String) {
          return productSearchDetailsModelFromJson(response.data as String);
        }
      }
      throw 'Failed to search products';
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw 'Error searching products: $e';
    }
  }

  /// Fetch categories from ApiEndpoints.categories
  Future<List<ProductCategoryModel>> getCategories() async {
    try {
      final response = await _dio.get(ApiEndpoints.categories);

      if (response.statusCode == 200 && response.data != null) {
        if (response.data is List) {
          return List<ProductCategoryModel>.from(
            (response.data as List).map((x) => ProductCategoryModel.fromJson(x)),
          );
        } else if (response.data is String) {
          return productCategoryModelFromJson(response.data as String);
        }
      }
      return [];
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw 'Error loading categories: $e';
    }
  }

  /// Fetch products by category slug from ApiEndpoints.productsByCategory
  Future<ProductModel> getProductsByCategory(String categorySlug) async {
    try {
      final response = await _dio.get(ApiEndpoints.productsByCategory(categorySlug));

      if (response.statusCode == 200 && response.data != null) {
        if (response.data is Map<String, dynamic>) {
          return ProductModel.fromJson(response.data as Map<String, dynamic>);
        } else if (response.data is String) {
          return productModelFromJson(response.data as String);
        }
      }
      throw 'Failed to load category products';
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw 'Error loading category products: $e';
    }
  }

  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out. Please check your network connection.';
      case DioExceptionType.badResponse:
        return 'Server error (${e.response?.statusCode ?? 'unknown'}). Please try again later.';
      case DioExceptionType.connectionError:
        return 'No internet connection. Please verify your network settings.';
      default:
        return e.message ?? 'An unexpected network error occurred.';
    }
  }
}
