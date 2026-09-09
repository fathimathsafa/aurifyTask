import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final String membershipTier;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.email,
    required this.membershipTier,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                color: AppColors.black,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border, width: 2),
              ),
              child: Center(
                child: Text(
                  name.isNotEmpty ? name.substring(0, 1).toUpperCase() : 'A',
                  style: AppTextStyles.displaySmall(color: AppColors.white).copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.black, width: 1.5),
                ),
                child: const Icon(
                  Icons.edit_outlined,
                  size: 14,
                  color: AppColors.black,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        Text(
          name,
          style: AppTextStyles.headlineMedium(color: AppColors.textPrimary).copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 4),

        Text(
          email,
          style: AppTextStyles.bodyMedium(color: AppColors.textSecondary),
        ),
        const SizedBox(height: 10),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.black,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            membershipTier.toUpperCase(),
            style: AppTextStyles.labelSmall(color: AppColors.white).copyWith(
              letterSpacing: 1.2,
              fontWeight: FontWeight.w700,
              fontSize: 10,
            ),
          ),
        ),
      ],
    );
  }
}
