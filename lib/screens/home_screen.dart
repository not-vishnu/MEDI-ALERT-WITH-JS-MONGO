import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../providers/medicine_provider.dart';

import 'add_medicine_screen.dart';
import 'analytics_screen.dart';
import 'history_screen.dart';
import 'profile_screen.dart';
import 'ai_chat_screen.dart';
import 'dashboard_page.dart';

/// Glassmorphism HomeScreen.
/// Paints a shared dark background with animated blobs behind an IndexedStack
/// so every child page (Dashboard / History / Analytics / AI / Profile) sits
/// on the same glassy backdrop.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  static const Color _accent = Color(0xFF4DA3FF);
  static const Color _iconMuted = Color(0xB3FFFFFF);
  static const Color _textPrimary = Colors.white;

  int selectedIndex = 0;

  late final AnimationController _bgController;
  late final Animation<double> _bgAnimation;

  final List<Widget> pages = const [
    DashboardPage(),
    HistoryScreen(),
    AnalyticsScreen(),
    AIChatScreen(),
    ProfileScreen(),
  ];

  static const _tabs = <_TabItem>[
    _TabItem("Home", Icons.home_outlined, Icons.home_rounded),
    _TabItem("History", Icons.history_rounded, Icons.history_rounded),
    _TabItem("Stats", Icons.insights_outlined, Icons.insights_rounded),
    _TabItem("AI", Icons.auto_awesome_outlined, Icons.auto_awesome_rounded),
    _TabItem("Me", Icons.person_outline_rounded, Icons.person_rounded),
  ];

  @override
  void initState() {
    super.initState();

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 14),
    )..repeat(reverse: true);

    _bgAnimation = CurvedAnimation(
      parent: _bgController,
      curve: Curves.easeInOut,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      Provider.of<MedicineProvider>(
        context,
        listen: false,
      ).loadMedicines();
    });
  }

  @override
  void dispose() {
    _bgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0F172A),
      extendBody: true,
      body: AnimatedBuilder(
        animation: _bgAnimation,
        builder: (context, _) {
          return Stack(
            children: [
              // Animated background blobs
              Positioned(
                top: -120 + (_bgAnimation.value * 40),
                left: -80,
                child: _blob(260, Colors.cyan.withValues(alpha: .22)),
              ),
              Positioned(
                top: 140 - (_bgAnimation.value * 30),
                right: -110,
                child: _blob(230, Colors.blue.withValues(alpha: .20)),
              ),
              Positioned(
                bottom: -100,
                left: 40 + (_bgAnimation.value * 25),
                child: _blob(270, Colors.purple.withValues(alpha: .18)),
              ),
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 90, sigmaY: 90),
                  child: Container(color: Colors.transparent),
                ),
              ),

              // Page content
              SafeArea(
                bottom: false,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 280),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeIn,
                  child: IndexedStack(
                    key: ValueKey(selectedIndex),
                    index: selectedIndex,
                    children: pages,
                  ),
                ),
              ),
            ],
          );
        },
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: selectedIndex == 0
          ? Padding(
              padding: const EdgeInsets.only(bottom: 76),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                  child: FloatingActionButton(
                    heroTag: "addMedicine",
                    elevation: 0,
                    backgroundColor: _accent.withValues(alpha: .85),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: .35),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddMedicineScreen(),
                        ),
                      );
                    },
                    child: const Icon(Icons.add_rounded, size: 28),
                  ),
                ),
              ),
            )
          : null,

      // Glass bottom nav
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: .28),
                    width: 1.2,
                  ),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 6,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(_tabs.length, (i) {
                    final tab = _tabs[i];
                    final selected = i == selectedIndex;
                    return Expanded(
                      child: InkWell(
                        onTap: () => setState(() => selectedIndex = i),
                        borderRadius: BorderRadius.circular(20),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 220),
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 220),
                                height: 32,
                                width: selected ? 56 : 32,
                                decoration: BoxDecoration(
                                  color: selected
                                      ? _accent.withValues(alpha: .28)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Icon(
                                  selected ? tab.activeIcon : tab.icon,
                                  size: 22,
                                  color: selected ? Colors.white : _iconMuted,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                tab.label,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: selected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                  color: selected ? _textPrimary : _iconMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _blob(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}

class _TabItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;
  const _TabItem(this.label, this.icon, this.activeIcon);
}
