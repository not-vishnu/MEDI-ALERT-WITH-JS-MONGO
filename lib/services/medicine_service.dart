import '../models/medicine_model.dart';
import 'api_service.dart';

class MedicineService {
  /// Get all medicines from MongoDB
  Future<List<MedicineModel>> getMedicines() async {
    final response = await ApiService.getMedicines();

    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to load medicines');
    }

    final List medicines = response['medicines'] ?? [];

    return medicines.map((medicine) {
      final map = Map<String, dynamic>.from(medicine);

      return MedicineModel.fromMap(
        map,
        map['_id']?.toString() ?? '',
      );
    }).toList();
  }

  /// Add a new medicine
  Future<MedicineModel> addMedicine(MedicineModel medicine) async {
    final response = await ApiService.createMedicine(
      name: medicine.name,
      dosage: medicine.dosage,
      time: medicine.time,
      status: medicine.status,
      reminderEnabled: medicine.reminderEnabled,
      notificationId: medicine.notificationId,
      reminderDate: medicine.reminderDate,
      notes: medicine.notes,
    );

    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to add medicine');
    }

    final map = Map<String, dynamic>.from(response['medicine']);

    return MedicineModel.fromMap(
      map,
      map['_id']?.toString() ?? '',
    );
  }

  /// Delete medicine
  Future<void> deleteMedicine(String id) async {
    final response = await ApiService.deleteMedicine(id);

    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to delete medicine');
    }
  }

  /// Update medicine status
  Future<void> updateStatus(String id, String status) async {
    final response = await ApiService.updateMedicine(
      id,
      status: status,
    );

    if (response['success'] != true) {
      throw Exception(response['message'] ?? 'Failed to update status');
    }
  }

  /// Smart Reminder status update
  Future<void> updateMedicineStatus(String id, String status) async {
    await updateStatus(id, status);
  }

  /// Enable / Disable Reminder
  Future<void> updateReminderEnabled(
    String id,
    bool enabled,
  ) async {
    final response = await ApiService.updateMedicine(
      id,
      reminderEnabled: enabled,
    );

    if (response['success'] != true) {
      throw Exception(
        response['message'] ?? 'Failed to update reminder',
      );
    }
  }

  /// Update Notification ID
  Future<void> updateNotificationId(
    String id,
    int notificationId,
  ) async {
    final response = await ApiService.updateMedicine(
      id,
      notificationId: notificationId,
    );

    if (response['success'] != true) {
      throw Exception(
        response['message'] ?? 'Failed to update notification',
      );
    }
  }

  /// Update Reminder Date
  Future<void> updateReminderDate(
    String id,
    DateTime reminderDate,
  ) async {
    final response = await ApiService.updateMedicine(
      id,
      reminderDate: reminderDate,
    );

    if (response['success'] != true) {
      throw Exception(
        response['message'] ?? 'Failed to update reminder date',
      );
    }
  }

  /// Update medicine details
  Future<MedicineModel> updateMedicine(
    MedicineModel medicine,
  ) async {
    final response = await ApiService.updateMedicine(
      medicine.id,
      name: medicine.name,
      dosage: medicine.dosage,
      time: medicine.time,
      status: medicine.status,
      reminderEnabled: medicine.reminderEnabled,
      notificationId: medicine.notificationId,
      reminderDate: medicine.reminderDate,
      notes: medicine.notes,
    );

    if (response['success'] != true) {
      throw Exception(
        response['message'] ?? 'Failed to update medicine',
      );
    }

    final map = Map<String, dynamic>.from(response['medicine']);

    return MedicineModel.fromMap(
      map,
      map['_id']?.toString() ?? medicine.id,
    );
  }
}
