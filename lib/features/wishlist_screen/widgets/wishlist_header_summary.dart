import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class WishlistHeaderSummary extends StatelessWidget {
  final int itemCount;
  final VoidCallback onMoveAllToCart;
  final VoidCallback onClear;

  const WishlistHeaderSummary({
    super.key,
    required this.itemCount,
    required this.onMoveAllToCart,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$itemCount ${itemCount == 1 ? 'Item' : 'Items'} Saved',
          style: AppTextStyles.titleSmall(color: AppColors.textPrimary).copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        Row(
          children: [
            TextButton(
              onPressed: onClear,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'Clear',
                style: AppTextStyles.labelMedium(color: AppColors.textSecondary),
              ),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: onMoveAllToCart,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                backgroundColor: AppColors.black,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Move All to Cart',
                style: AppTextStyles.labelSmall(color: AppColors.white).copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
