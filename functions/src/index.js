/**
 * ============================================================================
 * 🌐 PRESENCE APP - FIREBASE CLOUD FUNCTIONS API
 * ============================================================================
 *
 * Backend API untuk aplikasi Flutter Presence App
 * Menggunakan Firebase Cloud Functions + Express.js
 * Data disimpan di Firestore & Firebase Storage
 *
 */

const functions = require("firebase-functions");
const admin = require("firebase-admin");
const express = require("express");
const cors = require("cors");

// Inisialisasi Firebase Admin
admin.initializeApp();
const db = admin.firestore();
const storage = admin.storage();

// Buat Express app
const app = express();

// Middleware
app.use(cors({ origin: true }));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// ============================================================================
// 📌 ATTENDANCE (KEHADIRAN) ENDPOINTS
// ============================================================================

/**
 * POST /api/attendance/check-in
 * 📝 Fungsi: Mencatat kehadiran masuk (check-in) karyawan
 * 🔗 Simpan ke Firestore collection 'attendance'
 */
app.post("/api/attendance/check-in", async (req, res) => {
  try {
    const {
      employeeId,
      employeeName,
      date,
      checkInTime,
      notes,
      latitude,
      longitude,
      photoUrl,
    } = req.body;

    // Validasi data wajib
    if (!employeeId || !employeeName || !date || !checkInTime) {
      return res.status(400).json({
        success: false,
        message: "Data wajib: employeeId, employeeName, date, checkInTime",
      });
    }

    // 💾 Simpan ke Firestore
    const docRef = await db.collection("attendance").add({
      employeeId,
      employeeName,
      date: new Date(date),
      checkInTime,
      checkOutTime: null, // Belum ada check-out
      status: "Hadir",
      latitude: latitude || null,
      longitude: longitude || null,
      photoUrl: photoUrl || null,
      notes: notes || null,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    res.status(201).json({
      success: true,
      data: {
        id: docRef.id,
        employeeId,
        checkInTime,
        date,
      },
      message: "✅ Check-in berhasil dicatat",
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "❌ Error check-in",
      error: error.message,
    });
  }
});

/**
 * PUT /api/attendance/check-out/:attendanceId
 * 📝 Fungsi: Update waktu pulang (check-out) dari attendance
 * 🔗 Update di Firestore collection 'attendance'
 */
app.put("/api/attendance/check-out/:attendanceId", async (req, res) => {
  try {
    const { attendanceId } = req.params;
    const { checkOutTime } = req.body;

    if (!checkOutTime) {
      return res.status(400).json({
        success: false,
        message: "checkOutTime wajib diisi",
      });
    }

    // 💾 Update di Firestore
    const docRef = db.collection("attendance").doc(attendanceId);
    const doc = await docRef.get();

    if (!doc.exists) {
      return res.status(404).json({
        success: false,
        message: "Attendance tidak ditemukan",
      });
    }

    await docRef.update({
      checkOutTime,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    res.status(200).json({
      success: true,
      message: "✅ Check-out berhasil diperbarui",
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "❌ Error check-out",
      error: error.message,
    });
  }
});

/**
 * GET /api/attendance/user/:employeeId
 * 📝 Fungsi: Ambil daftar kehadiran berdasarkan employee ID
 * 🔗 Baca dari Firestore collection 'attendance'
 * 📊 Bisa filter berdasarkan tanggal
 */
app.get("/api/attendance/user/:employeeId", async (req, res) => {
  try {
    const { employeeId } = req.params;
    const { startDate, endDate, limit = 30 } = req.query;

    let query = db
      .collection("attendance")
      .where("employeeId", "==", employeeId);

    // 🔍 Filter tanggal jika ada
    if (startDate) {
      query = query.where("date", ">=", new Date(startDate));
    }
    if (endDate) {
      query = query.where("date", "<=", new Date(endDate));
    }

    // 💾 Ambil data dari Firestore
    query = query.orderBy("date", "desc").limit(parseInt(limit));
    const snapshot = await query.get();

    const data = snapshot.docs.map((doc) => ({
      id: doc.id,
      ...doc.data(),
      date: doc.data().date.toDate().toISOString(),
    }));

    res.status(200).json({
      success: true,
      data,
      count: data.length,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "❌ Error ambil data kehadiran",
      error: error.message,
    });
  }
});

/**
 * GET /api/attendance/date/:employeeId/:date
 * 📝 Fungsi: Ambil kehadiran berdasarkan tanggal spesifik
 * 🔗 Baca dari Firestore collection 'attendance'
 */
app.get("/api/attendance/date/:employeeId/:date", async (req, res) => {
  try {
    const { employeeId, date } = req.params;
    const dateObj = new Date(date);

    // 💾 Cari di Firestore
    const snapshot = await db
      .collection("attendance")
      .where("employeeId", "==", employeeId)
      .where("date", "==", dateObj)
      .limit(1)
      .get();

    if (snapshot.empty) {
      return res.status(404).json({
        success: false,
        message: "Kehadiran pada tanggal ini tidak ditemukan",
      });
    }

    const doc = snapshot.docs[0];
    res.status(200).json({
      success: true,
      data: {
        id: doc.id,
        ...doc.data(),
        date: doc.data().date.toDate().toISOString(),
      },
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "❌ Error ambil data",
      error: error.message,
    });
  }
});

/**
 * DELETE /api/attendance/:attendanceId
 * 📝 Fungsi: Hapus data kehadiran (untuk admin)
 * 🔗 Hapus dari Firestore collection 'attendance'
 */
app.delete("/api/attendance/:attendanceId", async (req, res) => {
  try {
    const { attendanceId } = req.params;

    // 💾 Hapus dari Firestore
    const docRef = db.collection("attendance").doc(attendanceId);
    const doc = await docRef.get();

    if (!doc.exists) {
      return res.status(404).json({
        success: false,
        message: "Attendance tidak ditemukan",
      });
    }

    await docRef.delete();

    res.status(200).json({
      success: true,
      message: "✅ Data kehadiran berhasil dihapus",
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "❌ Error hapus data",
      error: error.message,
    });
  }
});

// ============================================================================
// 📋 LEAVE REQUESTS (PERMINTAAN CUTI) ENDPOINTS
// ============================================================================

/**
 * POST /api/leave-requests
 * 📝 Fungsi: Buat permintaan cuti baru
 * 🔗 Simpan ke Firestore collection 'leave_requests'
 */
app.post("/api/leave-requests", async (req, res) => {
  try {
    const { employeeId, employeeName, startDate, endDate, reason, daysCount } =
      req.body;

    if (
      !employeeId ||
      !employeeName ||
      !startDate ||
      !endDate ||
      !reason ||
      !daysCount
    ) {
      return res.status(400).json({
        success: false,
        message: "Data tidak lengkap",
      });
    }

    // 💾 Simpan ke Firestore
    const docRef = await db.collection("leave_requests").add({
      employeeId,
      employeeName,
      startDate: new Date(startDate),
      endDate: new Date(endDate),
      reason,
      daysCount,
      status: "Proses", // Status awal: menunggu approval
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      approvedAt: null,
      approvedBy: null,
      rejectionReason: null,
    });

    res.status(201).json({
      success: true,
      data: {
        id: docRef.id,
        employeeId,
        status: "Proses",
        startDate,
        endDate,
      },
      message: "✅ Permintaan cuti berhasil dibuat",
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "❌ Error buat permintaan cuti",
      error: error.message,
    });
  }
});

/**
 * GET /api/leave-requests/user/:employeeId
 * 📝 Fungsi: Ambil daftar permintaan cuti user
 * 🔗 Baca dari Firestore collection 'leave_requests'
 */
app.get("/api/leave-requests/user/:employeeId", async (req, res) => {
  try {
    const { employeeId } = req.params;
    const { status, limit = 20 } = req.query;

    let query = db
      .collection("leave_requests")
      .where("employeeId", "==", employeeId);

    // 🔍 Filter berdasarkan status jika ada
    if (status) {
      query = query.where("status", "==", status);
    }

    // 💾 Ambil dari Firestore
    query = query.orderBy("createdAt", "desc").limit(parseInt(limit));
    const snapshot = await query.get();

    const data = snapshot.docs.map((doc) => ({
      id: doc.id,
      ...doc.data(),
      startDate: doc.data().startDate.toDate().toISOString(),
      endDate: doc.data().endDate.toDate().toISOString(),
      createdAt: doc.data().createdAt?.toDate().toISOString(),
    }));

    res.status(200).json({
      success: true,
      data,
      count: data.length,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "❌ Error ambil data cuti",
      error: error.message,
    });
  }
});

/**
 * PUT /api/leave-requests/:requestId/approve
 * 📝 Fungsi: Approve permintaan cuti (untuk manager/admin)
 * 🔗 Update di Firestore collection 'leave_requests'
 */
app.put("/api/leave-requests/:requestId/approve", async (req, res) => {
  try {
    const { requestId } = req.params;
    const { approvedBy } = req.body;

    if (!approvedBy) {
      return res.status(400).json({
        success: false,
        message: "approvedBy wajib diisi",
      });
    }

    // 💾 Update status menjadi Disetujui
    const docRef = db.collection("leave_requests").doc(requestId);
    const doc = await docRef.get();

    if (!doc.exists) {
      return res.status(404).json({
        success: false,
        message: "Permintaan cuti tidak ditemukan",
      });
    }

    await docRef.update({
      status: "Disetujui",
      approvedAt: admin.firestore.FieldValue.serverTimestamp(),
      approvedBy,
    });

    res.status(200).json({
      success: true,
      message: "✅ Permintaan cuti disetujui",
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "❌ Error approve cuti",
      error: error.message,
    });
  }
});

/**
 * PUT /api/leave-requests/:requestId/reject
 * 📝 Fungsi: Reject permintaan cuti (untuk manager/admin)
 * 🔗 Update di Firestore collection 'leave_requests'
 */
app.put("/api/leave-requests/:requestId/reject", async (req, res) => {
  try {
    const { requestId } = req.params;
    const { rejectionReason, approvedBy } = req.body;

    // 💾 Update status menjadi Ditolak
    const docRef = db.collection("leave_requests").doc(requestId);
    const doc = await docRef.get();

    if (!doc.exists) {
      return res.status(404).json({
        success: false,
        message: "Permintaan cuti tidak ditemukan",
      });
    }

    await docRef.update({
      status: "Ditolak",
      approvedAt: admin.firestore.FieldValue.serverTimestamp(),
      approvedBy,
      rejectionReason: rejectionReason || null,
    });

    res.status(200).json({
      success: true,
      message: "✅ Permintaan cuti ditolak",
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "❌ Error reject cuti",
      error: error.message,
    });
  }
});

// ============================================================================
// 💰 REIMBURSEMENT (PENGEMBALIAN DANA) ENDPOINTS
// ============================================================================

/**
 * POST /api/reimbursement-requests
 * 📝 Fungsi: Buat permintaan reimbursement baru
 * 🔗 Simpan ke Firestore collection 'reimbursement_requests'
 */
app.post("/api/reimbursement-requests", async (req, res) => {
  try {
    const {
      employeeId,
      employeeName,
      startDate,
      endDate,
      description,
      amount,
      attachmentUrls,
    } = req.body;

    if (
      !employeeId ||
      !employeeName ||
      !startDate ||
      !endDate ||
      !description ||
      !amount
    ) {
      return res.status(400).json({
        success: false,
        message: "Data tidak lengkap",
      });
    }

    // 💾 Simpan ke Firestore
    const docRef = await db.collection("reimbursement_requests").add({
      employeeId,
      employeeName,
      startDate: new Date(startDate),
      endDate: new Date(endDate),
      description,
      amount: parseFloat(amount),
      attachmentUrls: attachmentUrls || [],
      status: "Proses", // Status awal: menunggu approval
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      approvedAt: null,
      approvedBy: null,
      rejectionReason: null,
    });

    res.status(201).json({
      success: true,
      data: {
        id: docRef.id,
        employeeId,
        amount,
        status: "Proses",
      },
      message: "✅ Permintaan reimbursement berhasil dibuat",
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "❌ Error buat reimbursement",
      error: error.message,
    });
  }
});

/**
 * GET /api/reimbursement-requests/user/:employeeId
 * 📝 Fungsi: Ambil daftar reimbursement user
 * 🔗 Baca dari Firestore collection 'reimbursement_requests'
 */
app.get("/api/reimbursement-requests/user/:employeeId", async (req, res) => {
  try {
    const { employeeId } = req.params;
    const { status, limit = 20 } = req.query;

    let query = db
      .collection("reimbursement_requests")
      .where("employeeId", "==", employeeId);

    // 🔍 Filter berdasarkan status jika ada
    if (status) {
      query = query.where("status", "==", status);
    }

    // 💾 Ambil dari Firestore
    query = query.orderBy("createdAt", "desc").limit(parseInt(limit));
    const snapshot = await query.get();

    const data = snapshot.docs.map((doc) => ({
      id: doc.id,
      ...doc.data(),
      startDate: doc.data().startDate.toDate().toISOString(),
      endDate: doc.data().endDate.toDate().toISOString(),
      createdAt: doc.data().createdAt?.toDate().toISOString(),
    }));

    // 📊 Hitung total amount
    const totalAmount = data.reduce((sum, item) => sum + (item.amount || 0), 0);

    res.status(200).json({
      success: true,
      data,
      count: data.length,
      totalAmount,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "❌ Error ambil data reimbursement",
      error: error.message,
    });
  }
});

/**
 * PUT /api/reimbursement-requests/:requestId/approve
 * 📝 Fungsi: Approve permintaan reimbursement (untuk manager/admin)
 * 🔗 Update di Firestore collection 'reimbursement_requests'
 */
app.put("/api/reimbursement-requests/:requestId/approve", async (req, res) => {
  try {
    const { requestId } = req.params;
    const { approvedBy } = req.body;

    if (!approvedBy) {
      return res.status(400).json({
        success: false,
        message: "approvedBy wajib diisi",
      });
    }

    // 💾 Update status menjadi Disetujui
    const docRef = db.collection("reimbursement_requests").doc(requestId);
    const doc = await docRef.get();

    if (!doc.exists) {
      return res.status(404).json({
        success: false,
        message: "Permintaan reimbursement tidak ditemukan",
      });
    }

    await docRef.update({
      status: "Disetujui",
      approvedAt: admin.firestore.FieldValue.serverTimestamp(),
      approvedBy,
    });

    res.status(200).json({
      success: true,
      message: "✅ Permintaan reimbursement disetujui",
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "❌ Error approve reimbursement",
      error: error.message,
    });
  }
});

/**
 * PUT /api/reimbursement-requests/:requestId/reject
 * 📝 Fungsi: Reject permintaan reimbursement (untuk manager/admin)
 * 🔗 Update di Firestore collection 'reimbursement_requests'
 */
app.put("/api/reimbursement-requests/:requestId/reject", async (req, res) => {
  try {
    const { requestId } = req.params;
    const { rejectionReason, approvedBy } = req.body;

    // 💾 Update status menjadi Ditolak
    const docRef = db.collection("reimbursement_requests").doc(requestId);
    const doc = await docRef.get();

    if (!doc.exists) {
      return res.status(404).json({
        success: false,
        message: "Permintaan reimbursement tidak ditemukan",
      });
    }

    await docRef.update({
      status: "Ditolak",
      approvedAt: admin.firestore.FieldValue.serverTimestamp(),
      approvedBy,
      rejectionReason: rejectionReason || null,
    });

    res.status(200).json({
      success: true,
      message: "✅ Permintaan reimbursement ditolak",
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "❌ Error reject reimbursement",
      error: error.message,
    });
  }
});

// ============================================================================
// 💬 MESSAGES (PESAN) ENDPOINTS
// ============================================================================

/**
 * POST /api/messages
 * 📝 Fungsi: Kirim pesan baru (1-on-1 atau group chat)
 * 🔗 Simpan ke Firestore collection 'messages'
 */
app.post("/api/messages", async (req, res) => {
  try {
    const {
      senderId,
      senderName,
      recipientId,
      recipientName,
      groupId,
      content,
      messageType,
      attachmentUrl,
    } = req.body;

    // Validasi data wajib
    if (!senderId || !senderName || !content) {
      return res.status(400).json({
        success: false,
        message: "Data wajib: senderId, senderName, content",
      });
    }

    // Minimal ada recipientId atau groupId
    if ((!recipientId || recipientId === "") && (!groupId || groupId === "")) {
      return res.status(400).json({
        success: false,
        message: "Harus ada recipientId atau groupId",
      });
    }

    // 💾 Simpan ke Firestore
    const docRef = await db.collection("messages").add({
      senderId,
      senderName,
      recipientId: recipientId || null,
      recipientName: recipientName || null,
      groupId: groupId || null,
      content,
      messageType: messageType || "text",
      attachmentUrl: attachmentUrl || null,
      isRead: false,
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    res.status(201).json({
      success: true,
      data: {
        id: docRef.id,
        content,
        timestamp: new Date().toISOString(),
      },
      message: "✅ Pesan berhasil dikirim",
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "❌ Error kirim pesan",
      error: error.message,
    });
  }
});

/**
 * GET /api/messages/conversation/:userId/:otherId
 * 📝 Fungsi: Ambil percakapan 1-on-1 antara dua user
 * 🔗 Baca dari Firestore collection 'messages'
 */
app.get("/api/messages/conversation/:userId/:otherId", async (req, res) => {
  try {
    const { userId, otherId } = req.params;
    const { limit = 50 } = req.query;

    // 💾 Ambil semua pesan dari kedua user
    const snapshot = await db
      .collection("messages")
      .where("senderId", "in", [userId, otherId])
      .orderBy("createdAt", "desc")
      .limit(parseInt(limit))
      .get();

    const allMessages = snapshot.docs.map((doc) => ({
      id: doc.id,
      ...doc.data(),
      createdAt: doc.data().createdAt?.toDate().toISOString(),
    }));

    // Filter hanya pesan antara userId dan otherId
    const conversation = allMessages.filter(
      (msg) =>
        (msg.senderId === userId && msg.recipientId === otherId) ||
        (msg.senderId === otherId && msg.recipientId === userId)
    );

    res.status(200).json({
      success: true,
      data: conversation.reverse(),
      count: conversation.length,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "❌ Error ambil percakapan",
      error: error.message,
    });
  }
});

/**
 * GET /api/messages/group/:groupId
 * 📝 Fungsi: Ambil pesan dalam group chat
 * 🔗 Baca dari Firestore collection 'messages'
 */
app.get("/api/messages/group/:groupId", async (req, res) => {
  try {
    const { groupId } = req.params;
    const { limit = 50 } = req.query;

    // 💾 Ambil pesan group dari Firestore
    const snapshot = await db
      .collection("messages")
      .where("groupId", "==", groupId)
      .orderBy("createdAt", "desc")
      .limit(parseInt(limit))
      .get();

    const data = snapshot.docs.map((doc) => ({
      id: doc.id,
      ...doc.data(),
      createdAt: doc.data().createdAt?.toDate().toISOString(),
    }));

    res.status(200).json({
      success: true,
      data: data.reverse(),
      count: data.length,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "❌ Error ambil pesan group",
      error: error.message,
    });
  }
});

/**
 * PUT /api/messages/:messageId/read
 * 📝 Fungsi: Tandai pesan sebagai sudah dibaca
 * 🔗 Update di Firestore collection 'messages'
 */
app.put("/api/messages/:messageId/read", async (req, res) => {
  try {
    const { messageId } = req.params;

    // 💾 Update status isRead
    const docRef = db.collection("messages").doc(messageId);
    const doc = await docRef.get();

    if (!doc.exists) {
      return res.status(404).json({
        success: false,
        message: "Pesan tidak ditemukan",
      });
    }

    await docRef.update({
      isRead: true,
    });

    res.status(200).json({
      success: true,
      message: "✅ Pesan ditandai sudah dibaca",
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "❌ Error update pesan",
      error: error.message,
    });
  }
});

/**
 * DELETE /api/messages/:messageId
 * 📝 Fungsi: Hapus pesan
 * 🔗 Hapus dari Firestore collection 'messages'
 */
app.delete("/api/messages/:messageId", async (req, res) => {
  try {
    const { messageId } = req.params;

    // 💾 Hapus dari Firestore
    const docRef = db.collection("messages").doc(messageId);
    const doc = await docRef.get();

    if (!doc.exists) {
      return res.status(404).json({
        success: false,
        message: "Pesan tidak ditemukan",
      });
    }

    await docRef.delete();

    res.status(200).json({
      success: true,
      message: "✅ Pesan berhasil dihapus",
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "❌ Error hapus pesan",
      error: error.message,
    });
  }
});

// ============================================================================
// 🔧 UTILITY ENDPOINTS
// ============================================================================

/**
 * GET /api/health
 * 📝 Fungsi: Health check - cek status API
 */
app.get("/api/health", (req, res) => {
  res.status(200).json({
    status: "✅ API berjalan lancar",
    timestamp: new Date().toISOString(),
    version: "1.0.0",
  });
});

/**
 * GET /api/stats/:employeeId
 * 📝 Fungsi: Dapatkan statistik karyawan per bulan
 * 🔗 Baca dari Firestore semua collections
 */
app.get("/api/stats/:employeeId", async (req, res) => {
  try {
    const { employeeId } = req.params;
    const { month = new Date().getMonth(), year = new Date().getFullYear() } =
      req.query;

    // Tentukan range tanggal bulan
    const startDate = new Date(year, month, 1);
    const endDate = new Date(year, parseInt(month) + 1, 0);

    // 💾 Ambil data dari Firestore
    const attendanceSnapshot = await db
      .collection("attendance")
      .where("employeeId", "==", employeeId)
      .where("date", ">=", startDate)
      .where("date", "<=", endDate)
      .get();

    const leaveSnapshot = await db
      .collection("leave_requests")
      .where("employeeId", "==", employeeId)
      .get();

    const reimbursementSnapshot = await db
      .collection("reimbursement_requests")
      .where("employeeId", "==", employeeId)
      .get();

    // 📊 Hitung statistik
    const attendanceData = attendanceSnapshot.docs.map((doc) => doc.data());
    const leaveData = leaveSnapshot.docs.map((doc) => doc.data());
    const reimbursementData = reimbursementSnapshot.docs.map((doc) =>
      doc.data()
    );

    const stats = {
      totalAttendance: attendanceData.length,
      totalPresent: attendanceData.filter((a) => a.status === "Hadir").length,
      totalSick: attendanceData.filter((a) => a.status === "Sakit").length,
      totalLeave: attendanceData.filter((a) => a.status === "Izin").length,
      totalAbsent: attendanceData.filter((a) => a.status === "Alpa").length,
      pendingLeaveRequests: leaveData.filter((l) => l.status === "Proses")
        .length,
      approvedLeaveRequests: leaveData.filter((l) => l.status === "Disetujui")
        .length,
      pendingReimbursement: reimbursementData.filter(
        (r) => r.status === "Proses"
      ).length,
      totalReimbursement: reimbursementData.reduce(
        (sum, r) => sum + (r.amount || 0),
        0
      ),
    };

    res.status(200).json({
      success: true,
      data: stats,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: "❌ Error ambil statistik",
      error: error.message,
    });
  }
});

// ============================================================================
// Export Cloud Functions
// ============================================================================

exports.api = functions.https.onRequest(app);
