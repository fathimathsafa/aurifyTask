import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../model/product_model.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final bool isWishlisted;
  final bool isInCart;
  final VoidCallback onWishlistTap;
  final VoidCallback onCartTap;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    required this.isWishlisted,
    required this.isInCart,
    required this.onWishlistTap,
    required this.onCartTap,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final image = product.imageUrl;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                    child: Container(
                      width: double.infinity,
                      color: AppColors.surface,
                      child: image.isNotEmpty
                          ? Image.network(
                              image,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: AppColors.surface,
                                child: const Center(
                                  child: Icon(
                                    Icons.image_not_supported_outlined,
                                    color: AppColors.gray500,
                                    size: 32,
                                  ),
                                ),
                              ),
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  color: AppColors.surface,
                                  child: const Center(
                                    child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.black),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            )
                          : const Center(
                              child: Icon(
                                Icons.image_not_supported_outlined,
                                color: AppColors.gray500,
                                size: 32,
                              ),
                            ),
                    ),
                  ),

                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.black.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        product.displayCategory.toUpperCase(),
                        style: AppTextStyles.labelSmall(color: AppColors.white).copyWith(
                          fontSize: 9,
                          letterSpacing: 0.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: onWishlistTap,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black.withValues(alpha: 0.08),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          isWishlisted ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          color: isWishlisted ? AppColors.black : AppColors.gray700,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.displayTitle,
                    style: AppTextStyles.titleSmall(color: AppColors.textPrimary).copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: AppColors.black,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${product.safeRating}',
                        style: AppTextStyles.labelSmall(color: AppColors.textPrimary).copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${product.reviewCount})',
                        style: AppTextStyles.bodySmall(color: AppColors.textMuted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product.safePrice.toStringAsFixed(2)}',
                        style: AppTextStyles.titleMedium(color: AppColors.textPrimary).copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      InkWell(
                        onTap: onCartTap,
                        borderRadius: BorderRadius.circular(10),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isInCart ? AppColors.white : AppColors.black,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.black,
                              width: 1.2,
                            ),
                          ),
                          child: Icon(
                            isInCart ? Icons.check_rounded : Icons.add_shopping_cart_rounded,
                            color: isInCart ? AppColors.black : AppColors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
