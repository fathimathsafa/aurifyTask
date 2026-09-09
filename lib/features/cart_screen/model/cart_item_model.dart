import '../../home_screen/model/product_model.dart';

class CartItemModel {
  final Product product;
  int quantity;

  CartItemModel({
    required this.product,
    this.quantity = 1,
  });

  double get totalPrice => product.safePrice * quantity;

  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
        product: Product.fromJson(json['product'] as Map<String, dynamic>),
        quantity: (json['quantity'] as num?)?.toInt() ?? 1,
      );

  Map<String, dynamic> toJson() => {
        'product': product.toJson(),
        'quantity': quantity,
      };
}
