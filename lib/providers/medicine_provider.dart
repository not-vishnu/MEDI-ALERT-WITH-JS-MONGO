import 'package:flutter/material.dart';

import '../models/medicine_model.dart';
import '../services/medicine_service.dart';

class MedicineProvider extends ChangeNotifier {
  final MedicineService _service = MedicineService();

  List<MedicineModel> _medicines = [];

  bool _isLoading = false;

  String? _error;

  /// Current medicines
  List<MedicineModel> get medicines => _medicines;

  /// Loading state
  bool get isLoading => _isLoading;

  /// Error message
  String? get error => _error;

  /// Load medicines from MongoDB
  Future<void> loadMedicines() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _medicines = await _service.getMedicines();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Add Medicine
  Future<void> addMedicine(MedicineModel medicine) async {
    try {
      _error = null;

      final createdMedicine = await _service.addMedicine(medicine);

      _medicines.insert(0, createdMedicine);

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  /// Delete Medicine
  Future<void> deleteMedicine(String id) async {
    try {
      _error = null;

      await _service.deleteMedicine(id);

      _medicines.removeWhere((medicine) => medicine.id == id);

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  /// Mark as Taken
  Future<void> markAsTaken(String id) async {
    await _updateStatus(id, 'Taken');
  }

  /// Mark as Missed
  Future<void> markAsMissed(String id) async {
    await _updateStatus(id, 'Missed');
  }

  /// Update medicine status
  Future<void> _updateStatus(String id, String status) async {
    try {
      _error = null;

      await _service.updateStatus(id, status);

      final index = _medicines.indexWhere(
        (medicine) => medicine.id == id,
      );

      if (index != -1) {
        _medicines[index] = _medicines[index].copyWith(
          status: status,
        );
      }

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  /// Update Medicine
  Future<void> updateMedicine(MedicineModel medicine) async {
    try {
      _error = null;

      final updatedMedicine = await _service.updateMedicine(medicine);

      final index = _medicines.indexWhere(
        (item) => item.id == medicine.id,
      );

      if (index != -1) {
        _medicines[index] = updatedMedicine;
      }

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  /// Enable / Disable Reminder
  Future<void> updateReminderEnabled(
    String id,
    bool enabled,
  ) async {
    try {
      await _service.updateReminderEnabled(id, enabled);

      final index = _medicines.indexWhere(
        (medicine) => medicine.id == id,
      );

      if (index != -1) {
        _medicines[index] = _medicines[index].copyWith(
          reminderEnabled: enabled,
        );
      }

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  /// Update Notification ID
  Future<void> updateNotificationId(
    String id,
    int notificationId,
  ) async {
    try {
      await _service.updateNotificationId(
        id,
        notificationId,
      );

      final index = _medicines.indexWhere(
        (medicine) => medicine.id == id,
      );

      if (index != -1) {
        _medicines[index] = _medicines[index].copyWith(
          notificationId: notificationId,
        );
      }

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  /// Update Reminder Date
  Future<void> updateReminderDate(
    String id,
    DateTime reminderDate,
  ) async {
    try {
      await _service.updateReminderDate(
        id,
        reminderDate,
      );

      final index = _medicines.indexWhere(
        (medicine) => medicine.id == id,
      );

      if (index != -1) {
        _medicines[index] = _medicines[index].copyWith(
          reminderDate: reminderDate,
        );
      }

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }
}
