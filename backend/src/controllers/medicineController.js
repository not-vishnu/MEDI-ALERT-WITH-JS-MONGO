const Medicine = require("../models/Medicine");

// ==========================
// CREATE MEDICINE
// ==========================
const createMedicine = async (req, res) => {
  try {
    const {
      name,
      dosage,
      time,
      status,
      reminderEnabled,
      notificationId,
      reminderDate,
      notes,
    } = req.body;

    if (!name || !dosage || !time) {
      return res.status(400).json({
        success: false,
        message: "Name, dosage and time are required",
      });
    }

    const medicine = await Medicine.create({
      userId: req.user._id,
      name,
      dosage,
      time,
      status: status || "Pending",
      reminderEnabled:
        reminderEnabled !== undefined ? reminderEnabled : true,
      notificationId: notificationId || 0,
      reminderDate: reminderDate || null,
      notes: notes || "",
    });

    res.status(201).json({
      success: true,
      message: "Medicine created successfully",
      medicine,
    });
  } catch (error) {
    console.error("Create medicine error:", error.message);

    res.status(500).json({
      success: false,
      message: "Server error while creating medicine",
    });
  }
};

// ==========================
// GET ALL MEDICINES
// ==========================
const getMedicines = async (req, res) => {
  try {
    const medicines = await Medicine.find({
      userId: req.user._id,
    }).sort({ createdAt: -1 });

    res.status(200).json({
      success: true,
      count: medicines.length,
      medicines,
    });
  } catch (error) {
    console.error("Get medicines error:", error.message);

    res.status(500).json({
      success: false,
      message: "Server error while fetching medicines",
    });
  }
};

// ==========================
// UPDATE MEDICINE
// ==========================
const updateMedicine = async (req, res) => {
  try {
    const medicine = await Medicine.findOne({
      _id: req.params.id,
      userId: req.user._id,
    });

    if (!medicine) {
      return res.status(404).json({
        success: false,
        message: "Medicine not found",
      });
    }

    const allowedFields = [
      "name",
      "dosage",
      "time",
      "status",
      "reminderEnabled",
      "notificationId",
      "reminderDate",
      "notes",
    ];

    allowedFields.forEach((field) => {
      if (req.body[field] !== undefined) {
        medicine[field] = req.body[field];
      }
    });

    await medicine.save();

    res.status(200).json({
      success: true,
      message: "Medicine updated successfully",
      medicine,
    });
  } catch (error) {
    console.error("Update medicine error:", error.message);

    res.status(500).json({
      success: false,
      message: "Server error while updating medicine",
    });
  }
};

// ==========================
// DELETE MEDICINE
// ==========================
const deleteMedicine = async (req, res) => {
  try {
    const medicine = await Medicine.findOneAndDelete({
      _id: req.params.id,
      userId: req.user._id,
    });

    if (!medicine) {
      return res.status(404).json({
        success: false,
        message: "Medicine not found",
      });
    }

    res.status(200).json({
      success: true,
      message: "Medicine deleted successfully",
    });
  } catch (error) {
    console.error("Delete medicine error:", error.message);

    res.status(500).json({
      success: false,
      message: "Server error while deleting medicine",
    });
  }
};

module.exports = {
  createMedicine,
  getMedicines,
  updateMedicine,
  deleteMedicine,
};
