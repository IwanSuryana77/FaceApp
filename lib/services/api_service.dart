import 'attendance_service.dart';
import 'leave_request_service.dart';
import 'message_service.dart';
import 'reimbursement_service.dart';
import '../models/attendance.dart';
import '../models/leave_request.dart';
import '../models/message.dart';
import '../models/reimbursement_request.dart';

class ApiService {
  // Singleton pattern supaya hanya ada satu instance ApiService di aplikasi.
  static final ApiService _instance = ApiService._internal();

  ApiService._internal() {
    _attendanceService = AttendanceService();
    _leaveRequestService = LeaveRequestService();
    _messageService = MessageService();
  }

  static ApiService get instance => _instance;

  // Instansiasi service layer spesifik modul
  late final AttendanceService _attendanceService;
  late final LeaveRequestService _leaveRequestService;
  late final MessageService _messageService;

  
  /// Mencatat absensi/kehadiran baru ke Firebase melalui AttendanceService.
  /// Digunakan ketika user check-in/check-out.
  Future<String> createAttendance(Attendance attendance) {
    return _attendanceService.recordAttendance(attendance);
  }

  /// Mengambil daftar absensi berdasarkan ID karyawan dan rentang tanggal.
  /// melihat riwayat absensi pada suatu periode.
  /// [API -> FIREBASE READ]
  Future<List<Attendance>> getUserAttendance(
    String employeeId, {
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return _attendanceService.getUserAttendance(
      employeeId,
      startDate: startDate,
      endDate: endDate,
    );
  }

  /// Mendapat absensi user pada tanggal tertentu (misal: cek sudah absen hari ini).
  /// [API -> FIREBASE READ]
  Future<Attendance?> getAttendanceByDate(String employeeId, DateTime date) {
    return _attendanceService.getAttendanceByDate(employeeId, date);
  }

  /// Mendapatkan absensi user berdasarkan dokumen ID.
  /// [API -> FIREBASE READ]
  Future<Attendance?> getAttendanceById(String id) {
    return _attendanceService.getAttendanceById(id);
  }

  /// Memperbarui data absensi tertentu (edit absensi).
  /// [API -> FIREBASE UPDATE]
  Future<void> updateAttendance(String id, Attendance updatedAttendance) {
    return _attendanceService.updateAttendance(id, updatedAttendance);
  }

  /// Memperbarui jam check-out absensi tertentu (user pulang).
  /// [API -> FIREBASE UPDATE]
  Future<void> updateCheckOutTime(String id, String checkOutTime) {
    return _attendanceService.updateCheckOutTime(id, checkOutTime);
  }

  /// Menghapus data absensi pada ID tertentu.
  /// [API -> FIREBASE DELETE]
  Future<void> deleteAttendance(String id) {
    return _attendanceService.deleteAttendance(id);
  }

  /// Mendapatkan statistik absensi (hadir, izin, sakit, dsb) karyawan.
  /// Digunakan untuk dashboard dan laporan.
  /// [API -> FIREBASE READ]
  Future<Map<String, int>> getAttendanceStats(
    String employeeId, {
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return _attendanceService.getAttendanceStats(
      employeeId,
      startDate: startDate,
      endDate: endDate,
    );
  }

  /// Stream real-time: perubahan data absensi milik user.
  /// Untuk dashboard yang auto update/monitoring supervisor.
  /// [API -> FIREBASE STREAM]
  Stream<List<Attendance>> getUserAttendanceStream(String employeeId) {
    return _attendanceService.getUserAttendanceStream(employeeId);
  }


  /// Membuat permintaan cuti baru oleh user ke database.
  /// [API -> FIREBASE WRITE]
  Future<String> createLeaveRequest(LeaveRequest request) {
    return _leaveRequestService.createLeaveRequest(request);
  }

  /// Mengembalikan semua permintaan cuti milik user tersebut.
  /// Untuk menampilkan riwayat pengajuan cuti user di aplikasi.
  /// [API -> FIREBASE READ]
  Future<List<LeaveRequest>> getUserLeaveRequests(String employeeId) {
    return _leaveRequestService.getUserLeaveRequests(employeeId);
  }

  /// Mendapat daftar permintaan cuti seluruh user (untuk admin/HRD).
  /// [API -> FIREBASE READ]
  Future<List<LeaveRequest>> getAllLeaveRequests() {
    return _leaveRequestService.getAllLeaveRequests();
  }

  /// Mengambil detail permintaan cuti berdasarkan ID dokumen.
  /// [API -> FIREBASE READ]
  Future<LeaveRequest?> getLeaveRequestById(String id) {
    return _leaveRequestService.getLeaveRequestById(id);
  }

  /// Update status pengajuan cuti (approve, reject, dsb.).
  /// Digunakan oleh atasan/admin saat memproses cuti.
  /// [API -> FIREBASE UPDATE]
  Future<void> updateLeaveRequestStatus(
    String id,
    String newStatus, {
    String? approvedBy,
  }) {
    return _leaveRequestService.updateLeaveRequestStatus(
      id,
      newStatus,
      approvedBy: approvedBy,
    );
  }

  /// Menghapus permintaan cuti berdasarkan ID (misal membatalkan).
  /// [API -> FIREBASE DELETE]
  Future<void> deleteLeaveRequest(String id) {
    return _leaveRequestService.deleteLeaveRequest(id);
  }

  /// Mendapatkan stream perubahan data permintaan cuti user (real-time).
  /// [API -> FIREBASE STREAM]
  Stream<List<LeaveRequest>> getUserLeaveRequestsStream(String employeeId) {
    return _leaveRequestService.getUserLeaveRequestsStream(employeeId);
  }



  /// Mengirim pesan dari user ke user/admin lain.
  /// [API -> FIREBASE WRITE]
  Future<String> sendMessage(Message message) {
    return _messageService.sendMessage(message);
  }

  /// Mengambil pesan masuk user (inbox).
  /// [API -> FIREBASE READ]
  Future<List<Message>> getUserMessages(String recipientId) {
    return _messageService.getUserMessages(recipientId);
  }

  /// Mengambil daftar pesan yang belum dibaca.
  /// [API -> FIREBASE READ]
  Future<List<Message>> getUnreadMessages(String recipientId) {
    return _messageService.getUnreadMessages(recipientId);
  }

  /// Mengambil detail pesan berdasarkan ID.
  /// [API -> FIREBASE READ]
  Future<Message?> getMessageById(String id) {
    return _messageService.getMessageById(id);
  }

  /// Menandai satu pesan sebagai sudah dibaca oleh user.
  /// [API -> FIREBASE UPDATE]
  Future<void> markMessageAsRead(String messageId) {
    return _messageService.markMessageAsRead(messageId);
  }

  /// Menandai seluruh pesan user sebagai sudah dibaca.
  /// [API -> FIREBASE UPDATE]
  Future<void> markAllMessagesAsRead(String recipientId) {
    return _messageService.markAllMessagesAsRead(recipientId);
  }

  /// Menghapus sebuah pesan berdasarkan ID.
  /// [API -> FIREBASE DELETE]
  Future<void> deleteMessage(String messageId) {
    return _messageService.deleteMessage(messageId);
  }

  /// Stream real-time untuk inbox user (pesan masuk).
  /// [API -> FIREBASE STREAM]
  Stream<List<Message>> getUserMessagesStream(String recipientId) {
    return _messageService.getUserMessagesStream(recipientId);
  }

  /// Stream real-time untuk pesan yang belum dibaca user.
  /// [API -> FIREBASE STREAM]
  Stream<List<Message>> getUnreadMessagesStream(String recipientId) {
    return _messageService.getUnreadMessagesStream(recipientId);
  }

  /// Menghitung jumlah pesan belum dibaca oleh user (untuk badge/unread indicator).
  /// [API -> FIREBASE READ]
  Future<int> getUnreadMessageCount(String recipientId) {
    return _messageService.getUnreadMessageCount(recipientId);
  }

 

  /// Membuat reimbursement baru (pengajuan penggantian biaya).
  /// [API -> FIREBASE WRITE]
  Future<String> createReimbursement(ReimbursementRequest request) {
    return ReimbursementService.createReimbursement(request);
  }

  /// Mengambil daftar reimbursement milik user.
  /// [API -> FIREBASE READ]
  Future<List<ReimbursementRequest>> getUserReimbursements(String employeeId) {
    return ReimbursementService.getUserReimbursements(employeeId);
  }

  /// Mengambil seluruh reimbursement (untuk admin/keuangan).
  /// [API -> FIREBASE READ]
  Future<List<ReimbursementRequest>> getAllReimbursements() {
    return ReimbursementService.getAllReimbursements();
  }

  /// Mengambil detail satu reimbursement berdasarkan ID.
  /// [API -> FIREBASE READ]
  Future<ReimbursementRequest?> getReimbursementById(String id) {
    return ReimbursementService.getReimbursementById(id);
  }

  /// Memperbarui status reimbursement (diproses, ditolak, disetujui).
  /// [API -> FIREBASE UPDATE]
  Future<void> updateReimbursementStatus(
    String id,
    String newStatus, {
    String? approvedBy,
    String? rejectionReason,
  }) {
    return ReimbursementService.updateReimbursementStatus(
      id,
      newStatus,
      approvedBy: approvedBy,
      rejectionReason: rejectionReason,
    );
  }

  /// Menghapus reimbursement tertentu dari database.
  /// [API -> FIREBASE DELETE]
  Future<void> deleteReimbursement(String id) {
    return ReimbursementService.deleteReimbursement(id);
  }

  /// Stream real-time reimbursement milik user (status pembayaran, dsb).
  /// [API -> FIREBASE STREAM]
  Stream<List<ReimbursementRequest>> getUserReimbursementsStream(
    String employeeId,
  ) {
    return ReimbursementService.getUserReimbursementsStream(employeeId);
  }
}