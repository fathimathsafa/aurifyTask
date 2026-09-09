import 'package:flutter/material.dart';
import '../../../core/responsive/responsive.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../home_screen/model/product_model.dart';
import '../controller/product_details_controller.dart';
import '../model/product_details_model.dart';
import '../widgets/product_bottom_bar.dart';
import '../widgets/product_description_widget.dart';
import '../widgets/product_header_info.dart';
import '../widgets/product_image_carousel.dart';
import '../widgets/product_tags_widget.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductDetailsController controller;

  ProductDetailsScreen({
    super.key,
    int? productId,
    Product? product,
    ProductDetailsModel? productDetails,
    bool initialInCart = false,
    ProductDetailsController? controller,
  }) : controller = controller ??
            ProductDetailsController(
              productId: productId ?? product?.id ?? productDetails?.id,
              initialProduct: product,
              initialDetails: productDetails,
              initialInCart: initialInCart,
            );

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final product = controller.productDetails;

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
              'DETAILS',
              style: AppTextStyles.titleMedium(color: AppColors.textPrimary).copyWith(
                letterSpacing: 2.0,
                fontWeight: FontWeight.w800,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  controller.isWishlisted
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  color: controller.isWishlisted ? AppColors.black : AppColors.gray700,
                ),
                onPressed: () => controller.toggleWishlist(context),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: controller.isLoading && product == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(
                        color: AppColors.black,
                        strokeWidth: 2.5,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Loading product details...',
                        style: AppTextStyles.bodyMedium(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                )
              : controller.errorMessage != null && product == null
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.border),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.error_outline_rounded,
                                  size: 40,
                                  color: AppColors.black,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Failed to Load Details',
                              style: AppTextStyles.headlineSmall(color: AppColors.textPrimary)
                                  .copyWith(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              controller.errorMessage!,
                              textAlign: TextAlign.center,
                              style: AppTextStyles.bodyMedium(color: AppColors.textSecondary),
                            ),
                            const SizedBox(height: 24),
                            if (controller.productId != null)
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.black,
                                  foregroundColor: AppColors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: () =>
                                    controller.fetchProductDetails(controller.productId!),
                                icon: const Icon(Icons.refresh_rounded, size: 18),
                                label: const Text('Retry'),
                              ),
                          ],
                        ),
                      ),
                    )
                  : product == null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppColors.border),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.inventory_2_outlined,
                                      size: 40,
                                      color: AppColors.black,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'Product Not Found',
                                  style: AppTextStyles.headlineSmall(color: AppColors.textPrimary)
                                      .copyWith(fontWeight: FontWeight.w800),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'The requested product could not be found or has been removed.',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.bodyMedium(color: AppColors.textSecondary),
                                ),
                                const SizedBox(height: 24),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.black,
                                    foregroundColor: AppColors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Go Back'),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 680),
                            child: SingleChildScrollView(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.isMobile ? 20.0 : 32.0,
                                vertical: 16.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ProductImageCarousel(
                                    images: product.allImages,
                                    selectedIndex: controller.selectedImageIndex,
                                    onImageChanged: controller.setImageIndex,
                                  ),
                                  const SizedBox(height: 24),

                                  ProductHeaderInfo(product: product),
                                  const SizedBox(height: 24),
                                  const Divider(color: AppColors.divider),
                                  const SizedBox(height: 20),

                                  ProductDescriptionWidget(
                                    description: product.description ?? '',
                                  ),
                                  const SizedBox(height: 24),
                                  const Divider(color: AppColors.divider),
                                  const SizedBox(height: 20),

                                  ProductTagsWidget(
                                    category: product.displayCategory,
                                    tags: product.tags ?? [],
                                  ),
                                  const SizedBox(height: 32),
                                ],
                              ),
                            ),
                          ),
                        ),
          bottomNavigationBar: product != null
              ? ProductBottomBar(
                  isWishlisted: controller.isWishlisted,
                  isInCart: controller.isInCart,
                  onWishlistTap: () => controller.toggleWishlist(context),
                  onAddToCart: () => controller.addToCart(context),
                )
              : null,
        );
      },
    );
  }
}
