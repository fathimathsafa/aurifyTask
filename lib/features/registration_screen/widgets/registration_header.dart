import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class RegistrationHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const RegistrationHeader({
    super.key,
    this.title = 'Create Account',
    this.subtitle = 'Please fill in the details below to register',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.headlineLarge(color: AppColors.textPrimary),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: AppTextStyles.bodyMedium(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
