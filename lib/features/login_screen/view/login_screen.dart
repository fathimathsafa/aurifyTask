import 'package:flutter/material.dart';
import '../../../core/responsive/responsive.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/routes/app_routes.dart';
import '../controller/login_controller.dart';
import '../widgets/login_button.dart';
import '../widgets/login_footer.dart';
import '../widgets/login_header.dart';
import '../widgets/login_text_field.dart';

class LoginScreen extends StatelessWidget {
  final LoginController controller;

  LoginScreen({super.key, LoginController? controller})
      : controller = controller ?? LoginController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: context.isMobile ? 24.0 : 36.0,
              vertical: 24.0,
            ),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: ListenableBuilder(
                listenable: controller,
                builder: (context, _) {
                  return Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const LoginHeader(
                          title: 'Welcome Back',
                          subtitle: 'Enter your email and password to sign in',
                        ),
                        SizedBox(height: context.hp(4.0)),

                        LoginTextField(
                          label: 'Email Address',
                          hintText: 'name@example.com',
                          controller: controller.emailController,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.email_outlined,
                          validator: controller.validateEmail,
                        ),
                        const SizedBox(height: 18),

                        LoginTextField(
                          label: 'Password',
                          hintText: '••••••••',
                          controller: controller.passwordController,
                          obscureText: controller.isPasswordObscured,
                          keyboardType: TextInputType.visiblePassword,
                          prefixIcon: Icons.lock_outline_rounded,
                          validator: controller.validatePassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.isPasswordObscured
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.gray700,
                              size: 20,
                            ),
                            onPressed: controller.togglePasswordVisibility,
                          ),
                        ),
                        const SizedBox(height: 12),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => controller.forgotPassword(context),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Forgot Password?',
                              style: AppTextStyles.bodySmall(
                                color: AppColors.textPrimary,
                              ).copyWith(fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                        SizedBox(height: context.hp(4.0)),

                        LoginButton(
                          text: 'Log In',
                          isLoading: controller.isLoading,
                          onPressed: () => controller.login(context),
                        ),
                        const SizedBox(height: 24),

                        LoginFooter(
                          onRegisterTap: () {
                            Navigator.pushNamed(context, AppRoutes.register);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
