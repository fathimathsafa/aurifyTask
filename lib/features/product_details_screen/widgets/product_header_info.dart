import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../model/product_details_model.dart';

class ProductHeaderInfo extends StatelessWidget {
  final ProductDetailsModel product;

  const ProductHeaderInfo({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final stock = product.safeStock;
    final rating = product.safeRating;
    final price = product.safePrice;
    final discount = product.discountPercentage ?? 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              product.displayBrand.toUpperCase(),
              style: AppTextStyles.labelMedium(color: AppColors.textSecondary).copyWith(
                letterSpacing: 1.5,
                fontWeight: FontWeight.w700,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: stock > 0 ? AppColors.surface : AppColors.gray200,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: stock > 0 ? AppColors.border : AppColors.gray400,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: AppColors.black,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    stock > 0 ? 'In Stock ($stock left)' : 'Out of Stock',
                    style: AppTextStyles.labelSmall(color: AppColors.textPrimary).copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        Text(
          product.displayTitle,
          style: AppTextStyles.headlineLarge(color: AppColors.textPrimary).copyWith(
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 10),

        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.black,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: AppColors.white,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '$rating',
                    style: AppTextStyles.labelMedium(color: AppColors.white).copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${product.reviewCount} customer reviews',
              style: AppTextStyles.bodyMedium(color: AppColors.textSecondary),
            ),
          ],
        ),
        const SizedBox(height: 16),

        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              '\$${price.toStringAsFixed(2)}',
              style: AppTextStyles.displaySmall(color: AppColors.textPrimary).copyWith(
                fontWeight: FontWeight.w900,
              ),
            ),
            if (product.hasDiscount) ...[
              const SizedBox(width: 10),
              Text(
                '\$${product.originalPrice.toStringAsFixed(2)}',
                style: AppTextStyles.titleMedium(color: AppColors.textMuted).copyWith(
                  decoration: TextDecoration.lineThrough,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.black,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${discount.toInt()}% OFF',
                  style: AppTextStyles.labelSmall(color: AppColors.white).copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
