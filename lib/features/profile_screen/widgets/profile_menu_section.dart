import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class ProfileMenuSection extends StatelessWidget {
  const ProfileMenuSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          _buildTile(
            icon: Icons.receipt_long_outlined,
            title: 'Order History',
            subtitle: 'View active and past orders',
            onTap: () {},
          ),
          const Divider(height: 1, color: AppColors.divider),
          _buildTile(
            icon: Icons.location_on_outlined,
            title: 'Shipping Addresses',
            subtitle: 'Manage delivery addresses',
            onTap: () {},
          ),
          const Divider(height: 1, color: AppColors.divider),
          _buildTile(
            icon: Icons.credit_card_outlined,
            title: 'Payment Methods',
            subtitle: 'Credit cards and wallets',
            onTap: () {},
          ),
          const Divider(height: 1, color: AppColors.divider),
          _buildTile(
            icon: Icons.notifications_none_rounded,
            title: 'Notifications',
            subtitle: 'Order updates & offers',
            onTap: () {},
          ),
          const Divider(height: 1, color: AppColors.divider),
          _buildTile(
            icon: Icons.shield_outlined,
            title: 'Privacy & Security',
            subtitle: 'Password and account security',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.black, size: 20),
      ),
      title: Text(
        title,
        style: AppTextStyles.titleSmall(color: AppColors.textPrimary).copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.bodySmall(color: AppColors.textSecondary),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 14,
        color: AppColors.gray600,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
