const express = require("express");

const {
  createMedicine,
  getMedicines,
  updateMedicine,
  deleteMedicine,
} = require("../controllers/medicineController");

const protect = require("../middleware/authMiddleware");

const router = express.Router();

// All medicine routes require authentication
router.use(protect);

// Create
router.post("/", createMedicine);

// Get all
router.get("/", getMedicines);

// Update
router.put("/:id", updateMedicine);

// Delete
router.delete("/:id", deleteMedicine);

module.exports = router;