import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class RegistrationFooter extends StatelessWidget {
  final VoidCallback? onLoginTap;

  const RegistrationFooter({
    super.key,
    this.onLoginTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: AppTextStyles.bodyMedium(color: AppColors.textSecondary),
        ),
        GestureDetector(
          onTap: onLoginTap,
          child: Text(
            'Log In',
            style: AppTextStyles.titleSmall(color: AppColors.textPrimary).copyWith(
              fontWeight: FontWeight.w700,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
