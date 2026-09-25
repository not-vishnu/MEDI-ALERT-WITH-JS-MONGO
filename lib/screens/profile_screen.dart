import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'login_screen.dart';
import '../providers/auth_provider.dart' as app_auth;
import '../providers/theme_provider.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static const Color _accent = Color(0xFF4DA3FF);

  Widget _glass({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(4),
    double radius = 22,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 20,
          sigmaY: 20,
        ),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(255, 255, 255, .18),
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: const Color.fromRGBO(255, 255, 255, .30),
              width: 1.2,
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _tile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return _glass(
      radius: 20,
      padding: EdgeInsets.zero,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 6,
        ),
        leading: CircleAvatar(
          backgroundColor: Colors.white.withValues(alpha: .20),
          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: subtitle == null
            ? null
            : Text(
                subtitle,
                style: const TextStyle(
                  color: Colors.white70,
                ),
              ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<app_auth.AuthProvider>(context);
    final profile = auth.user ?? {};

    final String name =
        profile["name"]?.toString().trim().isNotEmpty == true
            ? profile["name"].toString()
            : "MediAlert User";

    final String email =
        profile["email"]?.toString().trim().isNotEmpty == true
            ? profile["email"].toString()
            : "No Email";

    final String phone =
        profile["phone"]?.toString().trim().isNotEmpty == true
            ? profile["phone"].toString()
            : "Not Added";

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SizedBox(height: 10),

        Center(
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white.withValues(alpha: .35),
                width: 2,
              ),
            ),
            child: CircleAvatar(
              radius: 55,
              backgroundColor: _accent.withValues(alpha: .45),
              child: Text(
                name.isNotEmpty
                    ? name[0].toUpperCase()
                    : "U",
                style: const TextStyle(
                  fontSize: 40,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        Center(
          child: Text(
            name,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),

        const SizedBox(height: 5),

        Center(
          child: Text(
            email,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
            ),
          ),
        ),

        const SizedBox(height: 30),

        const Text(
          "Account",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),

        const SizedBox(height: 14),

        _tile(
          icon: Icons.person,
          title: "Edit Profile",
          subtitle: "Update your information",
          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.white70,
            size: 16,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const EditProfileScreen(),
              ),
            );
          },
        ),

        const SizedBox(height: 12),

        _tile(
          icon: Icons.email,
          title: "Email",
          subtitle: email,
        ),

        const SizedBox(height: 12),

        _tile(
          icon: Icons.phone,
          title: "Phone",
          subtitle: phone,
        ),

        const SizedBox(height: 12),

        _glass(
          radius: 20,
          padding: EdgeInsets.zero,
          child: Consumer<ThemeProvider>(
            builder: (context, theme, child) {
              return SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 6,
                ),
                activeTrackColor: _accent,
                secondary: CircleAvatar(
                  backgroundColor:
                      Colors.white.withValues(alpha: .20),
                  child: const Icon(
                    Icons.dark_mode,
                    color: Colors.white,
                  ),
                ),
                title: const Text(
                  "Dark Mode",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: const Text(
                  "Enable Dark Theme",
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
                value: theme.themeMode == ThemeMode.dark,
                onChanged: (value) {
                  theme.toggleTheme(value);
                },
              );
            },
          ),
        ),

        const SizedBox(height: 12),

        _tile(
          icon: Icons.health_and_safety,
          title: "Health Summary",
          subtitle: "Coming Soon",
        ),

        const SizedBox(height: 30),

        GestureDetector(
          onTap: () async {
            final bool? logout = await showDialog<bool>(
              context: context,
              builder: (dialogContext) {
                return AlertDialog(
                  backgroundColor: const Color(0xff1B2436),
                  title: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.white),
                  ),
                  content: const Text(
                    "Are you sure you want to logout?",
                    style: TextStyle(color: Colors.white70),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () =>
                          Navigator.pop(dialogContext, false),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
                    FilledButton(
                      onPressed: () =>
                          Navigator.pop(dialogContext, true),
                      child: const Text("Logout"),
                    ),
                  ],
                );
              },
            );

            if (logout == true) {
              await Provider.of<app_auth.AuthProvider>(
                context,
                listen: false,
              ).logout();

              if (!context.mounted) return;

              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => const LoginScreen(),
                ),
                (route) => false,
              );
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 20,
                sigmaY: 20,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: .35),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.red.withValues(alpha: .55),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    SizedBox(width: 10),
                    Text(
                      "Logout",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 30),

        const Center(
          child: Text(
            "MediAlert AI v1.0",
            style: TextStyle(
              color: Colors.white54,
            ),
          ),
        ),

        const SizedBox(height: 100),
      ],
    );
  }
}