import 'package:flutter/material.dart';
import '../../../core/responsive/responsive.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../controller/profile_controller.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_logout_button.dart';
import '../widgets/profile_menu_section.dart';

class ProfileScreen extends StatelessWidget {
  final ProfileController controller;

  ProfileScreen({super.key, ProfileController? controller})
      : controller = controller ?? ProfileController();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            elevation: 0,
            scrolledUnderElevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.black, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'MY PROFILE',
              style: AppTextStyles.titleMedium(color: AppColors.textPrimary).copyWith(
                letterSpacing: 2.0,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 680),
                child: ListView(
                  padding: EdgeInsets.symmetric(
                    horizontal: context.isMobile ? 20.0 : 32.0,
                    vertical: 16.0,
                  ),
                  children: [
                    ProfileHeader(
                      name: controller.name,
                      email: controller.email,
                      membershipTier: controller.membershipTier,
                    ),
                    const SizedBox(height: 24),

                   

                    const ProfileMenuSection(),
                    const SizedBox(height: 28),

                    ProfileLogoutButton(
                      onLogout: () => controller.logout(context),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
