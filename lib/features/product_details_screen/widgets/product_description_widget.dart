import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class ProductDescriptionWidget extends StatelessWidget {
  final String description;

  const ProductDescriptionWidget({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Description',
          style: AppTextStyles.titleMedium(color: AppColors.textPrimary).copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          description.isNotEmpty
              ? description
              : 'No detailed description available for this product.',
          style: AppTextStyles.bodyMedium(color: AppColors.textSecondary).copyWith(
            height: 1.6,
          ),
        ),
      ],
    );
  }
}
