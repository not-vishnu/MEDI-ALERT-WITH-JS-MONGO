const mongoose = require("mongoose");

const connectDatabase = async () => {
  try {
    const mongoURI =
      process.env.MONGODB_URI ||
      "mongodb://127.0.0.1:27017/medialert_ai";

    await mongoose.connect(mongoURI);

    console.log("✅ MongoDB connected successfully");
    console.log(`📦 Database: ${mongoose.connection.name}`);
  } catch (error) {
    console.error("❌ MongoDB connection failed");
    console.error(error.message);
    process.exit(1);
  }
};

module.exports = connectDatabase;