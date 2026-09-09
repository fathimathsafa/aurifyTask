import 'package:flutter/material.dart';
import '../../../core/responsive/responsive.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controller/wishlist_controller.dart';
import '../widgets/wishlist_empty_state.dart';
import '../widgets/wishlist_header_summary.dart';
import '../widgets/wishlist_item_card.dart';

class WishlistScreen extends StatelessWidget {
  final WishlistController controller;

  WishlistScreen({
    super.key,
    WishlistController? controller,
  }) : controller = controller ?? WishlistController();

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
              'WISHLIST',
              style: AppTextStyles.titleMedium(color: AppColors.textPrimary).copyWith(
                letterSpacing: 2.0,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          body: controller.isEmpty
              ? WishlistEmptyState(
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
                          WishlistHeaderSummary(
                            itemCount: controller.itemCount,
                            onMoveAllToCart: () => controller.moveAllToCart(context),
                            onClear: () => controller.clearWishlist(context),
                          ),
                          const SizedBox(height: 16),

                          ...controller.items.map(
                            (product) => Padding(
                              padding: const EdgeInsets.only(bottom: 12.0),
                              child: WishlistItemCard(
                                product: product,
                                onRemove: () => controller.removeItem(product, context),
                                onMoveToCart: () => controller.moveToCart(product, context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
        );
      },
    );
  }
}
