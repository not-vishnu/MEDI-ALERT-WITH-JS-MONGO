import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/medicine_model.dart';
import '../providers/medicine_provider.dart';
import 'edit_medicine_screen.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  static const Color _glassWhite = Color.fromRGBO(255, 255, 255, .18);
  static const Color _glassBorder = Color.fromRGBO(255, 255, 255, .30);
  static const Color _accent = Color(0xFF4DA3FF);

  String greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  Color statusColor(String status) {
    switch (status) {
      case "Taken":
        return Colors.greenAccent;
      case "Missed":
        return Colors.redAccent;
      default:
        return Colors.orangeAccent;
    }
  }

  Widget _glass({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.all(20),
    double radius = 26,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: _glassWhite,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: _glassBorder, width: 1.2),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget heroHeader({
    required BuildContext context,
    required int total,
    required int taken,
    required double adherence,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 22),
      child: _glass(
        radius: 30,
        padding: const EdgeInsets.fromLTRB(22, 26, 22, 26),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white.withValues(alpha: .30),
                  child:
                      const Icon(Icons.person, size: 34, color: Colors.white),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        greeting(),
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Stay Healthy 👋",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .18),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: .25),
                        ),
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.notifications_none,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Colors.redAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withValues(alpha: .18),
                ),
              ),
              child: Row(
                children: [
                  SizedBox(
                    height: 90,
                    width: 90,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CircularProgressIndicator(
                          value: adherence / 100,
                          strokeWidth: 8,
                          backgroundColor: Colors.white24,
                          valueColor:
                              const AlwaysStoppedAnimation(Colors.white),
                        ),
                        Center(
                          child: Text(
                            "${adherence.toStringAsFixed(0)}%",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Today's Progress",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "$taken of $total medicines completed",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "Keep following your medication schedule.",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget statCard(String title, String value, IconData icon, Color color) {
    return _glass(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: color.withValues(alpha: .25),
            child: Icon(icon, color: Colors.white),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(color: Colors.white70, fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget statisticsGrid({
    required int total,
    required int taken,
    required int pending,
    required int missed,
  }) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      childAspectRatio: 1.12,
      children: [
        statCard("Medicines", total.toString(), Icons.medication, Colors.blue),
        statCard("Taken", taken.toString(), Icons.check_circle, Colors.green),
        statCard("Pending", pending.toString(), Icons.schedule, Colors.orange),
        statCard("Missed", missed.toString(), Icons.cancel, Colors.red),
      ],
    );
  }

  Widget nextMedicineCard(List<MedicineModel> medicines) {
    if (medicines.isEmpty) return const SizedBox();

    final medicine = medicines.first;

    return Padding(
      padding: const EdgeInsets.only(top: 25),
      child: _glass(
        radius: 25,
        padding: const EdgeInsets.all(22),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: .18),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.white24),
              ),
              child: const Icon(
                Icons.medication,
                color: Colors.white,
                size: 34,
              ),
            ),
            const SizedBox(width: 18),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Next Medicine",
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    medicine.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    medicine.time,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget quickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 28),
        const Text(
          "Quick Actions",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(child: _glassButton("Reminders", Icons.alarm, () {})),
            const SizedBox(width: 12),
            Expanded(child: _glassButton("Ask AI", Icons.smart_toy, () {})),
          ],
        ),
      ],
    );
  }

  Widget _glassButton(String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: _glass(
        padding: const EdgeInsets.symmetric(vertical: 16),
        radius: 18,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget medicineCard(
    BuildContext context,
    MedicineProvider provider,
    MedicineModel medicine,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: _glass(
        radius: 22,
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor:
                      statusColor(medicine.status).withValues(alpha: .25),
                  child: Icon(
                    Icons.medication,
                    color: statusColor(medicine.status),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        medicine.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        medicine.dosage,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                Theme(
                  data: Theme.of(context).copyWith(
                    cardColor: const Color(0xff1B2436),
                  ),
                  child: PopupMenuButton<String>(
                    iconColor: Colors.white,
                    onSelected: (value) async {
                      switch (value) {
                        case "Taken":
                          await provider.markAsTaken(medicine.id);
                          break;
                        case "Missed":
                          await provider.markAsMissed(medicine.id);
                          break;
                        case "Edit":
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  EditMedicineScreen(medicine: medicine),
                            ),
                          );
                          break;
                        case "Delete":
                          await provider.deleteMedicine(medicine.id);
                          break;
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(
                        value: "Taken",
                        child: Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green),
                            SizedBox(width: 10),
                            Text(
                              "Mark as Taken",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: "Missed",
                        child: Row(
                          children: [
                            Icon(Icons.cancel, color: Colors.red),
                            SizedBox(width: 10),
                            Text(
                              "Mark as Missed",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: "Edit",
                        child: Row(
                          children: [
                            Icon(Icons.edit, color: Colors.white),
                            SizedBox(width: 10),
                            Text("Edit", style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: "Delete",
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 10),
                            Text("Delete",
                                style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                const Icon(
                  Icons.access_time_filled_rounded,
                  color: Colors.white70,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  medicine.time,
                  style: const TextStyle(color: Colors.white70, fontSize: 15),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor(medicine.status).withValues(alpha: .20),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: statusColor(medicine.status).withValues(alpha: .5),
                    ),
                  ),
                  child: Text(
                    medicine.status,
                    style: TextStyle(
                      color: statusColor(medicine.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: _actionBtn(
                    "Taken",
                    Icons.check,
                    Colors.green.withValues(alpha: .35),
                    () async => provider.markAsTaken(medicine.id),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _actionBtn(
                    "Missed",
                    Icons.close,
                    Colors.red.withValues(alpha: .35),
                    () async => provider.markAsMissed(medicine.id),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionBtn(
    String label,
    IconData icon,
    Color tint,
    Future<void> Function() onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: tint,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withValues(alpha: .30)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MedicineProvider>(context);

    if (provider.isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }

    final medicines = provider.medicines;
    final total = medicines.length;
    final taken = medicines.where((m) => m.status == "Taken").length;
    final missed = medicines.where((m) => m.status == "Missed").length;
    final pending = medicines.where((m) => m.status == "Pending").length;
    final double adherence = total == 0 ? 0 : (taken / total) * 100;

    return ListView(
      padding: const EdgeInsets.all(18),
      children: [
        heroHeader(
          context: context,
          total: total,
          taken: taken,
          adherence: adherence,
        ),
        statisticsGrid(
          total: total,
          taken: taken,
          pending: pending,
          missed: missed,
        ),
        nextMedicineCard(medicines),
        quickActions(context),
        const SizedBox(height: 30),
        const Text(
          "Today's Medicines",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 18),
        if (medicines.isEmpty)
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 50),
              child: Column(
                children: [
                  Icon(
                    Icons.medication_liquid,
                    size: 90,
                    color: Colors.white.withValues(alpha: .35),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "No medicines added yet",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Tap the Add Medicine button\nbelow to get started.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),
          )
        else
          ...medicines.map(
            (medicine) => medicineCard(context, provider, medicine),
          ),
        const SizedBox(height: 25),
        _glass(
          radius: 25,
          padding: const EdgeInsets.all(22),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: _accent.withValues(alpha: .35),
                child: const Icon(
                  Icons.smart_toy,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 18),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "MediAlert AI",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Ask questions about medicines, dosage, side effects and general health.",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 25),
        const Center(
          child: Text(
            "Stay healthy • Stay consistent 💙",
            style: TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 120),
      ],
    );
  }
}
