import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aurify_task/core/services/favorites_service.dart';
import 'package:aurify_task/features/home_screen/model/product_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await FavoritesService.instance.init();
    await FavoritesService.instance.clearFavorites();
  });

  final sampleProduct = Product(
    id: 1,
    title: 'Essence Mascara Lash Princess',
    description: 'The Essence Mascara Lash Princess is a popular mascara.',
    category: Category.BEAUTY,
    price: 9.99,
    discountPercentage: 7.17,
    rating: 4.94,
    stock: 5,
    tags: ['beauty', 'mascara'],
    brand: 'Essence',
    sku: 'RCH45Q1A',
    weight: 2,
    warrantyInformation: '1 month warranty',
    shippingInformation: 'Ships in 1 month',
    availabilityStatus: AvailabilityStatus.LOW_STOCK,
    returnPolicy: ReturnPolicy.THE_30_DAYS_RETURN_POLICY,
    minimumOrderQuantity: 24,
    thumbnail: 'https://cdn.dummyjson.com/products/images/beauty/Essence%20Mascara%20Lash%20Princess/thumbnail.png',
    images: ['https://cdn.dummyjson.com/products/images/beauty/Essence%20Mascara%20Lash%20Princess/1.png'],
  );

  test('FavoritesService adds product to favorites and persists locally', () async {
    expect(FavoritesService.instance.isFavorite(1), false);
    expect(FavoritesService.instance.favorites.isEmpty, true);

    await FavoritesService.instance.addFavorite(sampleProduct);

    expect(FavoritesService.instance.isFavorite(1), true);
    expect(FavoritesService.instance.favorites.length, 1);
    expect(FavoritesService.instance.favorites.first.title, 'Essence Mascara Lash Princess');
  });

  test('FavoritesService removes product from favorites', () async {
    await FavoritesService.instance.addFavorite(sampleProduct);
    expect(FavoritesService.instance.isFavorite(1), true);

    await FavoritesService.instance.removeFavorite(1);
    expect(FavoritesService.instance.isFavorite(1), false);
    expect(FavoritesService.instance.favorites.isEmpty, true);
  });

  test('FavoritesService toggles favorite status', () async {
    await FavoritesService.instance.toggleFavorite(sampleProduct);
    expect(FavoritesService.instance.isFavorite(1), true);

    await FavoritesService.instance.toggleFavorite(sampleProduct);
    expect(FavoritesService.instance.isFavorite(1), false);
  });

  test('FavoritesService persists across re-initialization', () async {
    await FavoritesService.instance.addFavorite(sampleProduct);

    // Re-initialize service to simulate app restart
    await FavoritesService.instance.init();
    expect(FavoritesService.instance.isFavorite(1), true);
    expect(FavoritesService.instance.favorites.length, 1);
  });
}
