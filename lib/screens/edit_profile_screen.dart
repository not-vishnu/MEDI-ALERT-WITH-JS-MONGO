import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth_provider.dart' as app_auth;
import '../services/api_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with TickerProviderStateMixin {
  static const Color _accent = Color(0xFF4DA3FF);

  final _name = TextEditingController();
  final _phone = TextEditingController();

  bool loading = true;
  bool saving = false;

  late final AnimationController _bgController;
  late final Animation<double> _bgAnimation;

  @override
  void initState() {
    super.initState();

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat(reverse: true);

    _bgAnimation = CurvedAnimation(
      parent: _bgController,
      curve: Curves.easeInOut,
    );

    loadProfile();
  }

  @override
  void dispose() {
    _bgController.dispose();
    _name.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> loadProfile() async {
    try {
      final response = await ApiService.getProfile();

      if (!mounted) return;

      if (response['success'] == true) {
        final user = Map<String, dynamic>.from(
          response['user'] ?? {},
        );

        _name.text = user["name"]?.toString() ?? "";
        _phone.text = user["phone"]?.toString() ?? "";
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Failed to load profile: $e",
          ),
        ),
      );
    }

    if (!mounted) return;

    setState(() {
      loading = false;
    });
  }

  Future<void> save() async {
    if (saving) return;

    setState(() {
      saving = true;
    });

    try {
      final response = await ApiService.updateProfile(
        name: _name.text.trim(),
        phone: _phone.text.trim(),
      );

      if (!mounted) return;

      if (response['success'] == true) {
        await Provider.of<app_auth.AuthProvider>(
          context,
          listen: false,
        ).refreshProfile();

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profile Updated"),
          ),
        );

        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              response['message'] ??
                  "Failed to update profile",
            ),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Failed to update profile: $e",
          ),
        ),
      );
    } finally {
      if (!mounted) return;

      setState(() {
        saving = false;
      });
    }
  }

  Widget _blob(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }

  Widget _glassField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 20,
          sigmaY: 20,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .18),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: Colors.white.withValues(alpha: .30),
              width: 1.2,
            ),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(
                color: Colors.white54,
                fontSize: 15,
              ),
              prefixIcon: Icon(
                icon,
                color: Colors.white70,
              ),
              contentPadding:
                  const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 18,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0F172A),
      body: AnimatedBuilder(
        animation: _bgAnimation,
        builder: (context, _) {
          return Stack(
            children: [
              Positioned(
                top: -120 +
                    (_bgAnimation.value * 40),
                left: -80,
                child: _blob(
                  260,
                  Colors.cyan.withValues(alpha: .22),
                ),
              ),
              Positioned(
                right: -110,
                top: 140 -
                    (_bgAnimation.value * 30),
                child: _blob(
                  230,
                  Colors.blue.withValues(alpha: .20),
                ),
              ),
              Positioned(
                bottom: -100,
                left: 40 +
                    (_bgAnimation.value * 25),
                child: _blob(
                  270,
                  Colors.purple.withValues(alpha: .18),
                ),
              ),
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 90,
                    sigmaY: 90,
                  ),
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),
              SafeArea(
                child: loading
                    ? const Center(
                        child:
                            CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      )
                    : SingleChildScrollView(
                        padding:
                            const EdgeInsets.fromLTRB(
                          24,
                          12,
                          24,
                          32,
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () =>
                                      Navigator.pop(
                                    context,
                                  ),
                                  icon: const Icon(
                                    CupertinoIcons.back,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  "Edit Profile",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 26),

                            const Text(
                              "Update your info",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 15,
                              ),
                            ),

                            const SizedBox(height: 24),

                            _glassField(
                              controller: _name,
                              hint: "Name",
                              icon: Icons
                                  .person_outline_rounded,
                            ),

                            const SizedBox(height: 16),

                            _glassField(
                              controller: _phone,
                              hint: "Phone",
                              icon: Icons.phone_outlined,
                              keyboardType:
                                  TextInputType.phone,
                            ),

                            const SizedBox(height: 36),

                            SizedBox(
                              width: double.infinity,
                              height: 58,
                              child: GestureDetector(
                                onTap: saving ? null : save,
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(
                                    28,
                                  ),
                                  child: BackdropFilter(
                                    filter:
                                        ImageFilter.blur(
                                      sigmaX: 25,
                                      sigmaY: 25,
                                    ),
                                    child: Container(
                                      decoration:
                                          BoxDecoration(
                                        borderRadius:
                                            BorderRadius
                                                .circular(
                                          28,
                                        ),
                                        gradient:
                                            LinearGradient(
                                          colors: [
                                            _accent.withValues(
                                              alpha: .85,
                                            ),
                                            _accent.withValues(
                                              alpha: .55,
                                            ),
                                          ],
                                        ),
                                        border:
                                            Border.all(
                                          color: Colors
                                              .white
                                              .withValues(
                                            alpha: .35,
                                          ),
                                        ),
                                      ),
                                      child: Center(
                                        child: saving
                                            ? const SizedBox(
                                                height: 24,
                                                width: 24,
                                                child:
                                                    CircularProgressIndicator(
                                                  color:
                                                      Colors
                                                          .white,
                                                  strokeWidth:
                                                      2.5,
                                                ),
                                              )
                                            : const Text(
                                                "Save",
                                                style:
                                                    TextStyle(
                                                  color: Colors
                                                      .white,
                                                  fontSize: 17,
                                                  fontWeight:
                                                      FontWeight
                                                          .w700,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}