import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/reimbursement_request.dart';

/// Firebase Service untuk Reimbursement Request (Pengembalian Dana)
/// Mengelola CRUD operations di collection 'reimbursement_requests'
class ReimbursementService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String _collectionName = 'reimbursement_requests';

  // ================= CREATE =================
  // Tambah data reimbursement
  static Future<String> createReimbursement(
    ReimbursementRequest request,
  ) async {
    try {
      final docRef = await _firestore
          .collection(_collectionName)
          .add(request.toMap());

      print('Reimbursement created with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('Error creating reimbursement: $e');
      rethrow;
    }
  }

  // ================= READ =================
  // Ambil reimbursement user tertentu
  static Future<List<ReimbursementRequest>> getUserReimbursements(
    String employeeId,
  ) async {
    try {
      final snapshot = await _firestore
          .collection(_collectionName)
          .where('employeeId', isEqualTo: employeeId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ReimbursementRequest.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error fetching reimbursements: $e');
      return [];
    }
  }

  // Ambil semua reimbursement (Admin)
  static Future<List<ReimbursementRequest>> getAllReimbursements() async {
    try {
      final snapshot = await _firestore
          .collection(_collectionName)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => ReimbursementRequest.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error fetching all reimbursements: $e');
      return [];
    }
  }

  // Ambil reimbursement berdasarkan ID
  static Future<ReimbursementRequest?> getReimbursementById(String id) async {
    try {
      final doc = await _firestore.collection(_collectionName).doc(id).get();

      if (doc.exists) {
        return ReimbursementRequest.fromMap(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }
      return null;
    } catch (e) {
      print('Error fetching reimbursement by ID: $e');
      return null;
    }
  }

  // Update status reimbursement
  static Future<void> updateReimbursementStatus(
    String id,
    String newStatus, {
    String? approvedBy,
    String? rejectionReason,
  }) async {
    try {
      final Map<String, dynamic> updateData = {
        'status': newStatus,
        'approvedAt': DateTime.now().toIso8601String(),
        'approvedBy': approvedBy,
      };

      if (rejectionReason != null) {
        updateData['rejectionReason'] = rejectionReason;
      }

      await _firestore.collection(_collectionName).doc(id).update(updateData);

      print('Reimbursement status updated to: $newStatus');
    } catch (e) {
      print('Error updating reimbursement status: $e');
      rethrow;
    }
  }

  // ================= DELETE =================
  // Hapus reimbursement
  static Future<void> deleteReimbursement(String id) async {
    try {
      await _firestore.collection(_collectionName).doc(id).delete();

      print('Reimbursement deleted: $id');
    } catch (e) {
      print('Error deleting reimbursement: $e');
      rethrow;
    }
  }

  // ================= STREAM =================
  // Real-time reimbursement user
  static Stream<List<ReimbursementRequest>> getUserReimbursementsStream(
    String employeeId,
  ) {
    return _firestore
        .collection(_collectionName)
        .where('employeeId', isEqualTo: employeeId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ReimbursementRequest.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }
}
