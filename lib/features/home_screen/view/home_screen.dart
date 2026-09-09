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
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(
                              color: AppColors.black,
                              strokeWidth: 2.5,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Loading curated collection...',
                              style: AppTextStyles.bodyMedium(color: AppColors.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    )
                  else if (controller.errorMessage != null && products.isEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
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
                                    Icons.cloud_off_rounded,
                                    size: 40,
                                    color: AppColors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Unable to Load Products',
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
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.black,
                                  foregroundColor: AppColors.white,
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: controller.fetchProducts,
                                icon: const Icon(Icons.refresh_rounded, size: 18),
                                label: const Text('Retry'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  else if (products.isEmpty && controller.searchQuery.isNotEmpty)
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
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
                                    Icons.search_off_rounded,
                                    size: 40,
                                    color: AppColors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'No Results for "${controller.searchQuery}"',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.headlineSmall(color: AppColors.textPrimary)
                                    .copyWith(fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'We couldn\'t find any products matching your search. Try checking your spelling or use different keywords.',
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
                                onPressed: controller.clearSearch,
                                child: const Text('Clear Search'),
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
                                controller.selectedCategory != 'All'
                                    ? 'No Products in ${controller.selectedCategory}'
                                    : 'No Products Available',
                                textAlign: TextAlign.center,
                                style: AppTextStyles.headlineSmall(color: AppColors.textPrimary)
                                    .copyWith(fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'There are currently no items available in this category. Explore all products or refresh.',
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
                                onPressed: () {
                                  if (controller.selectedCategory != 'All') {
                                    controller.selectCategory('All');
                                  } else {
                                    controller.fetchProducts();
                                  }
                                },
                                child: Text(
                                  controller.selectedCategory != 'All'
                                      ? 'View All Products'
                                      : 'Refresh Products',
                                ),
                              ),
                            ],
                          ),
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
