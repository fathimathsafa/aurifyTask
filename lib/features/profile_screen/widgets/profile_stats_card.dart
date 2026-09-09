import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class ProfileStatsCard extends StatelessWidget {
  final int ordersCount;
  final int wishlistCount;
  final int addressCount;
  final VoidCallback? onOrdersTap;
  final VoidCallback? onWishlistTap;

  const ProfileStatsCard({
    super.key,
    required this.ordersCount,
    required this.wishlistCount,
    required this.addressCount,
    this.onOrdersTap,
    this.onWishlistTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStat('Orders', '$ordersCount', onTap: onOrdersTap),
          Container(height: 32, width: 1, color: AppColors.divider),
          _buildStat('Wishlist', '$wishlistCount', onTap: onWishlistTap),
          Container(height: 32, width: 1, color: AppColors.divider),
          _buildStat('Addresses', '$addressCount'),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.headlineSmall(color: AppColors.textPrimary).copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: AppTextStyles.labelSmall(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}
