import 'package:flutter/material.dart';
import '../../../core/responsive/responsive.dart';
import '../../../core/theme/app_colors.dart';
import '../controller/registration_controller.dart';
import '../widgets/registration_button.dart';
import '../widgets/registration_footer.dart';
import '../widgets/registration_header.dart';
import '../widgets/registration_text_field.dart';
import '../../../core/routes/app_routes.dart';

class RegistrationScreen extends StatelessWidget {
  final RegistrationController controller;

  RegistrationScreen({super.key, RegistrationController? controller})
      : controller = controller ?? RegistrationController();

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
                        const RegistrationHeader(
                          title: 'Create Account',
                          subtitle: 'Fill in the information below to sign up',
                        ),
                        SizedBox(height: context.hp(3.5)),

                        RegistrationTextField(
                          label: 'Full Name',
                          hintText: 'Enter your name',
                          controller: controller.nameController,
                          keyboardType: TextInputType.name,
                          prefixIcon: Icons.person_outline_rounded,
                          validator: controller.validateName,
                        ),
                        const SizedBox(height: 18),

                        RegistrationTextField(
                          label: 'Email Address',
                          hintText: 'name@example.com',
                          controller: controller.emailController,
                          keyboardType: TextInputType.emailAddress,
                          prefixIcon: Icons.email_outlined,
                          validator: controller.validateEmail,
                        ),
                        const SizedBox(height: 18),

                        RegistrationTextField(
                          label: 'Phone Number',
                          hintText: '+1 234 567 8900',
                          controller: controller.phoneController,
                          keyboardType: TextInputType.phone,
                          prefixIcon: Icons.phone_outlined,
                          validator: controller.validatePhone,
                        ),
                        const SizedBox(height: 18),

                        RegistrationTextField(
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
                        SizedBox(height: context.hp(4.0)),

                        RegistrationButton(
                          text: 'Register',
                          isLoading: controller.isLoading,
                          onPressed: () => controller.register(context),
                        ),
                        const SizedBox(height: 24),

                        RegistrationFooter(
                          onLoginTap: () {
                            if (Navigator.canPop(context)) {
                              Navigator.pop(context);
                            } else {
                              Navigator.pushReplacementNamed(context, AppRoutes.login);
                            }
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
