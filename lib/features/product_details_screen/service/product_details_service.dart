import 'package:dio/dio.dart';
import '../../../core/constants/api_endpoints.dart';
import '../model/product_details_model.dart';

class ProductDetailsService {
  ProductDetailsService._internal();
  static final ProductDetailsService instance = ProductDetailsService._internal();
  factory ProductDetailsService() => instance;

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

  /// Fetch product details by ID from ApiEndpoints.productDetails
  Future<ProductDetailsModel> getProductDetails(int id) async {
    try {
      final response = await _dio.get(ApiEndpoints.productDetails(id));

      if (response.statusCode == 200 && response.data != null) {
        if (response.data is Map<String, dynamic>) {
          return ProductDetailsModel.fromJson(response.data as Map<String, dynamic>);
        } else if (response.data is String) {
          return productDetailsModelFromJson(response.data as String);
        }
      }
      throw 'Failed to load product details (status: ${response.statusCode})';
    } on DioException catch (e) {
      throw _handleDioError(e);
    } catch (e) {
      throw 'An unexpected error occurred: $e';
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
