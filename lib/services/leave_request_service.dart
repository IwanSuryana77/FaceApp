import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/leave_request.dart';

// Firebase Service untuk Leave Request (Permintaan Cuti)
// FIREBASE: Mengelola CRUD operations di collection 'leave_requests'
class LeaveRequestService {
  static final _firestore = FirebaseFirestore.instance;
  static const _collectionName = 'PengajuanCuti';

  // Tambah data permintaan cuti ke Firebase
  // FIREBASE WRITE: Menyimpan dokumen baru ke Firestore
  Future<String> createLeaveRequest(LeaveRequest request) async {
    try {
      final docRef = await _firestore
          .collection(_collectionName)
          .add(request.toMap());

      print(' Leave Request created with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print(' Error creating leave request: $e');
      rethrow;
    }
  }

  //  Ambil semua permintaan cuti untuk user tertentu
  // FIREBASE READ: Query dokumen berdasarkan employeeId
  Future<List<LeaveRequest>> getUserLeaveRequests(String employeeId) async {
    try {
      final snapshot = await _firestore
          .collection(_collectionName)
          .where('employeeId', isEqualTo: employeeId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => LeaveRequest.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error fetching leave requests: $e');
      return [];
    }
  }

  // Ambil semua permintaan cuti (untuk admin/approval)
  // FIREBASE READ: Query semua dokumen
  Future<List<LeaveRequest>> getAllLeaveRequests() async {
    try {
      final snapshot = await _firestore
          .collection(_collectionName)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => LeaveRequest.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error fetching all leave requests: $e');
      return [];
    }
  }

  /// Ambil permintaan cuti berdasarkan ID
  /// FIREBASE READ: Get dokumen spesifik
  Future<LeaveRequest?> getLeaveRequestById(String id) async {
    try {
      final doc = await _firestore.collection(_collectionName).doc(id).get();

      if (doc.exists) {
        return LeaveRequest.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      print('Error fetching leave request: $e');
      return null;
    }
  }

  /// Update status permintaan cuti
  /// FIREBASE UPDATE: Memperbarui dokumen yang ada
  Future<void> updateLeaveRequestStatus(
    String id,
    String newStatus, {
    String? approvedBy,
  }) async {
    try {
      await _firestore.collection(_collectionName).doc(id).update({
        'status': newStatus,
        'approvedAt': DateTime.now().toIso8601String(),
        'approvedBy': approvedBy,
      });

      print('Leave Request status updated to: $newStatus');
    } catch (e) {
      print('Error updating leave request: $e');
      rethrow;
    }
  }

  /// Hapus permintaan cuti
  /// IREBASE DELETE: Menghapus dokumen dari Firestore
  Future<void> deleteLeaveRequest(String id) async {
    try {
      await _firestore.collection(_collectionName).doc(id).delete();

      print('Leave Request deleted: $id');
    } catch (e) {
      print('Error deleting leave request: $e');
      rethrow;
    }
  }

  /// Stream untuk real-time updates dari Firebase
  /// FIREBASE STREAM: Listen ke perubahan data real-time
  Stream<List<LeaveRequest>> getUserLeaveRequestsStream(String employeeId) {
    return _firestore
        .collection(_collectionName)
        .where('employeeId', isEqualTo: employeeId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => LeaveRequest.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }
}
