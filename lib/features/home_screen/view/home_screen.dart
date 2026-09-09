import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (context, controller, _) {
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
            child: RefreshIndicator(
              color: AppColors.black,
              onRefresh: () => controller.fetchProducts(),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
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
                            controller.isLoading
                                ? 'Fetching products...'
                                : '${products.length} Products Found',
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

                  if (controller.isLoading && products.isEmpty)
                    const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.black,
                        ),
                      ),
                    )
                  else if (controller.errorMessage != null && products.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.cloud_off_rounded,
                                size: 56,
                                color: AppColors.gray500,
                              ),
                              const SizedBox(height: 14),
                              Text(
                                'Unable to Load Products',
                                style: AppTextStyles.titleMedium(color: AppColors.textPrimary),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                controller.errorMessage!,
                                textAlign: TextAlign.center,
                                style: AppTextStyles.bodySmall(color: AppColors.textSecondary),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.black,
                                  foregroundColor: AppColors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                onPressed: controller.fetchProducts,
                                icon: const Icon(Icons.refresh_rounded, size: 18),
                                label: const Text('Try Again'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else if (products.isEmpty)
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
                              onWishlistTap: () => controller.toggleWishlist(product, context),
                              onCartTap: () => controller.toggleCart(product, context),
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
          ),
        );
      },
    );
  }
}
