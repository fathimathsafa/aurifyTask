import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class ProductBottomBar extends StatelessWidget {
  final bool isWishlisted;
  final bool isInCart;
  final VoidCallback onWishlistTap;
  final VoidCallback onAddToCart;

  const ProductBottomBar({
    super.key,
    required this.isWishlisted,
    required this.isInCart,
    required this.onWishlistTap,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.background,
        border: const Border(
          top: BorderSide(color: AppColors.border),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 52,
                child: OutlinedButton(
                  onPressed: onWishlistTap,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.black,
                    backgroundColor: isWishlisted ? AppColors.surface : AppColors.white,
                    side: const BorderSide(color: AppColors.black, width: 1.5),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    isWishlisted ? 'Wishlisted' : 'Wishlist',
                    style: AppTextStyles.labelLarge(color: AppColors.black).copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),

            Expanded(
              child: SizedBox(
                height: 52,
                child: ElevatedButton(
                  onPressed: onAddToCart,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.black,
                    foregroundColor: AppColors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    isInCart ? 'In Cart' : 'Add to Cart',
                    style: AppTextStyles.labelLarge(color: AppColors.white).copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
