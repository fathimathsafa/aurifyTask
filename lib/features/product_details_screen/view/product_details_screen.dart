import 'package:flutter/material.dart';
import '../../../core/responsive/responsive.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../home_screen/model/product_model.dart';
import '../controller/product_details_controller.dart';
import '../widgets/product_bottom_bar.dart';
import '../widgets/product_description_widget.dart';
import '../widgets/product_header_info.dart';
import '../widgets/product_image_carousel.dart';
import '../widgets/product_tags_widget.dart';

class ProductDetailsScreen extends StatelessWidget {
  final ProductDetailsController controller;

  ProductDetailsScreen({
    super.key,
    required ProductModel product,
    bool initialWishlisted = false,
    bool initialInCart = false,
    ProductDetailsController? controller,
  }) : controller = controller ??
            ProductDetailsController(
              product: product,
              initialWishlisted: initialWishlisted,
              initialInCart: initialInCart,
            );

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final product = controller.product;

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
          body: Center(
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

                    ProductDescriptionWidget(description: product.description),
                    const SizedBox(height: 24),
                    const Divider(color: AppColors.divider),
                    const SizedBox(height: 20),

                    ProductTagsWidget(
                      category: product.category,
                      tags: product.tags,
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: ProductBottomBar(
            isWishlisted: controller.isWishlisted,
            isInCart: controller.isInCart,
            onWishlistTap: () => controller.toggleWishlist(context),
            onAddToCart: () => controller.addToCart(context),
          ),
        );
      },
    );
  }
}
