import 'package:flutter/material.dart';
import '../../../core/responsive/responsive.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controller/cart_controller.dart';
import '../widgets/cart_bottom_bar.dart';
import '../widgets/cart_empty_state.dart';
import '../widgets/cart_item_card.dart';
import '../widgets/cart_order_summary.dart';

class CartScreen extends StatelessWidget {
  final CartController controller;

  CartScreen({super.key, CartController? controller})
      : controller = controller ?? CartController();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.black, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'MY CART',
              style: AppTextStyles.titleMedium(color: AppColors.textPrimary).copyWith(
                letterSpacing: 2.0,
                fontWeight: FontWeight.w800,
              ),
            ),
            actions: [
              if (!controller.isEmpty)
                TextButton(
                  onPressed: () => controller.clearCart(context),
                  child: Text(
                    'Clear',
                    style: AppTextStyles.labelMedium(color: AppColors.textSecondary),
                  ),
                ),
              const SizedBox(width: 8),
            ],
          ),
          body: controller.isEmpty
              ? CartEmptyState(
                  onExploreTap: () => Navigator.pop(context),
                )
              : SafeArea(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 680),
                      child: ListView(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.isMobile ? 16.0 : 24.0,
                          vertical: 16.0,
                        ),
                        children: [
                          // Cart Items List
                          ...controller.items.map(
                            (item) => Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: CartItemCard(
                                item: item,
                                onIncrement: () => controller.incrementQuantity(item),
                                onDecrement: () => controller.decrementQuantity(item, context),
                                onRemove: () => controller.removeItem(item, context),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Order Summary
                          CartOrderSummary(
                            subtotal: controller.subtotal,
                            shipping: controller.shipping,
                            tax: controller.tax,
                            total: controller.total,
                          ),
                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                ),
          bottomNavigationBar: controller.isEmpty
              ? null
              : CartBottomBar(
                  total: controller.total,
                  isCheckingOut: controller.isCheckingOut,
                  onCheckout: () => controller.checkout(context),
                ),
        );
      },
    );
  }
}
