import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aurify_task/core/services/cart_service.dart';
import 'package:aurify_task/features/home_screen/model/product_model.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await CartService.instance.init();
    await CartService.instance.clearCart();
  });

  final sampleProduct1 = Product(
    id: 1,
    title: 'Essence Mascara Lash Princess',
    price: 10.0,
    discountPercentage: 0,
    stock: 10,
    category: Category.BEAUTY,
    thumbnail: 'https://example.com/mascara.png',
  );

  final sampleProduct2 = Product(
    id: 2,
    title: 'Eyeshadow Palette',
    price: 20.0,
    discountPercentage: 0,
    stock: 5,
    category: Category.BEAUTY,
    thumbnail: 'https://example.com/palette.png',
  );

  test('CartService adds products to cart and calculates subtotal/total', () async {
    expect(CartService.instance.isEmpty, true);
    expect(CartService.instance.itemCount, 0);

    await CartService.instance.addToCart(sampleProduct1, quantity: 2);
    expect(CartService.instance.itemCount, 2);
    expect(CartService.instance.isInCart(1), true);
    expect(CartService.instance.subtotal, 20.0);

    await CartService.instance.addToCart(sampleProduct2, quantity: 1);
    expect(CartService.instance.itemCount, 3);
    expect(CartService.instance.items.length, 2);
    expect(CartService.instance.subtotal, 40.0);
  });

  test('CartService increments and decrements quantity properly', () async {
    await CartService.instance.addToCart(sampleProduct1, quantity: 1);
    expect(CartService.instance.getQuantity(1), 1);

    await CartService.instance.incrementQuantity(1);
    expect(CartService.instance.getQuantity(1), 2);

    await CartService.instance.decrementQuantity(1);
    expect(CartService.instance.getQuantity(1), 1);

    // Decrementing when quantity is 1 removes the item
    await CartService.instance.decrementQuantity(1);
    expect(CartService.instance.isInCart(1), false);
    expect(CartService.instance.isEmpty, true);
  });

  test('CartService removes item and clears cart', () async {
    await CartService.instance.addToCart(sampleProduct1, quantity: 2);
    await CartService.instance.addToCart(sampleProduct2, quantity: 1);
    expect(CartService.instance.items.length, 2);

    await CartService.instance.removeItem(1);
    expect(CartService.instance.items.length, 1);
    expect(CartService.instance.isInCart(1), false);

    await CartService.instance.clearCart();
    expect(CartService.instance.isEmpty, true);
  });

  test('CartService persists cart across re-initialization', () async {
    await CartService.instance.addToCart(sampleProduct1, quantity: 3);

    // Simulate app restart by re-initializing service
    await CartService.instance.init();
    expect(CartService.instance.isInCart(1), true);
    expect(CartService.instance.getQuantity(1), 3);
    expect(CartService.instance.items.first.product.title, 'Essence Mascara Lash Princess');
  });
}
