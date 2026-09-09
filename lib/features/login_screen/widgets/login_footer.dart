import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class LoginFooter extends StatelessWidget {
  final VoidCallback? onRegisterTap;

  const LoginFooter({
    super.key,
    this.onRegisterTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: AppTextStyles.bodyMedium(color: AppColors.textSecondary),
        ),
        GestureDetector(
          onTap: onRegisterTap,
          child: Text(
            'Register',
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
