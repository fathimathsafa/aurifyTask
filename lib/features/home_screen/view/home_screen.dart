import 'package:flutter/material.dart';
import '../../../core/responsive/responsive.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controller/home_controller.dart';
import '../widgets/category_selector.dart';
import '../widgets/home_app_bar.dart';
import '../widgets/home_search_bar.dart';
import '../widgets/product_card.dart';
import '../../../core/routes/app_routes.dart';

class HomeScreen extends StatelessWidget {
  final HomeController controller;

  HomeScreen({super.key, HomeController? controller})
      : controller = controller ?? HomeController();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final products = controller.filteredProducts;

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: HomeAppBar(
            cartCount: controller.cartCount,
            wishlistCount: controller.wishlistCount,
            onCartTap: () => Navigator.pushNamed(context, AppRoutes.cart),
            onWishlistTap: () => Navigator.pushNamed(context, AppRoutes.wishlist),
            onProfileTap: () => Navigator.pushNamed(context, AppRoutes.profile),
          ),
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.isMobile ? 16.0 : 24.0,
                      vertical: 12.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HomeSearchBar(
                          controller: controller.searchController,
                          onChanged: controller.onSearchChanged,
                          onClear: controller.clearSearch,
                        ),
                        const SizedBox(height: 16),

                        CategorySelector(
                          categories: controller.categories,
                          selectedCategory: controller.selectedCategory,
                          onSelectCategory: controller.selectCategory,
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.isMobile ? 16.0 : 24.0,
                      vertical: 8.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${products.length} Products Found',
                          style: AppTextStyles.labelMedium(color: AppColors.textSecondary),
                        ),
                        Text(
                          controller.selectedCategory,
                          style: AppTextStyles.titleSmall(color: AppColors.textPrimary).copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                if (products.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.search_off_rounded,
                            size: 64,
                            color: AppColors.gray500,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No Products Found',
                            style: AppTextStyles.headlineSmall(color: AppColors.textPrimary),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Try adjusting your search or category filter.',
                            style: AppTextStyles.bodyMedium(color: AppColors.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: context.isMobile ? 16.0 : 24.0,
                      vertical: 12.0,
                    ),
                    sliver: SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: context.isDesktop ? 4 : (context.isTablet ? 3 : 2),
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.64,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final product = products[index];
                          return ProductCard(
                            product: product,
                            isWishlisted: controller.isWishlisted(product.id),
                            isInCart: controller.isInCart(product.id),
                            onWishlistTap: () => controller.toggleWishlist(product.id, context),
                            onCartTap: () => controller.toggleCart(product.id, context),
                            onTap: () => Navigator.pushNamed(
                              context,
                              AppRoutes.productDetails,
                              arguments: product,
                            ),
                          );
                        },
                        childCount: products.length,
                      ),
                    ),
                  ),

                const SliverToBoxAdapter(
                  child: SizedBox(height: 24),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
