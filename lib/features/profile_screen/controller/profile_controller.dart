import 'package:flutter/material.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/auth_service.dart';

class ProfileController extends ChangeNotifier {
  ProfileController() {
    _loadUserData();
  }

  String name = 'Alex Morgan';
  String email = 'alex.morgan@aurify.com';
  String phone = '+1 (555) 234-5678';
  String membershipTier = 'Aurify Black Member';

  int ordersCount = 8;
  int wishlistCount = 5;
  int addressCount = 2;

  void _loadUserData() {
    final user = AuthService.instance.currentUser;
    if (user != null) {
      if (user.displayName != null && user.displayName!.trim().isNotEmpty) {
        name = user.displayName!;
      }
      if (user.email != null && user.email!.trim().isNotEmpty) {
        email = user.email!;
      }
      if (user.phoneNumber != null && user.phoneNumber!.trim().isNotEmpty) {
        phone = user.phoneNumber!;
      }
      notifyListeners();
    }
  }

  void logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text(
          'Log Out',
          style: TextStyle(fontWeight: FontWeight.w800, color: Colors.black),
        ),
        content: const Text(
          'Are you sure you want to log out of your account?',
          style: TextStyle(color: Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.black54)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await AuthService.instance.signOut();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (route) => false,
                );
              }
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}
