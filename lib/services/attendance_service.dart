import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/attendance.dart';

// Firebase Service untuk Attendance (Kehadiran)
// Mengelola CRUD operations di collection 'attendance'
class AttendanceService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String _collectionName = 'attendance';

  // ================= CREATE =================
  // Catat kehadiran baru
  Future<String> recordAttendance(Attendance attendance) async {
    try {
      final docRef = await _firestore
          .collection(_collectionName)
          .add(attendance.toMap());

      print('Attendance recorded with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('Error recording attendance: $e');
      rethrow;
    }
  }

  // ================= READ =================
  // Ambil semua kehadiran user
  Future<List<Attendance>> getUserAttendance(
    String employeeId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      Query query = _firestore
          .collection(_collectionName)
          .where('employeeId', isEqualTo: employeeId);

      if (startDate != null) {
        query = query.where(
          'date',
          isGreaterThanOrEqualTo: startDate.toIso8601String(),
        );
      }

      if (endDate != null) {
        query = query.where(
          'date',
          isLessThanOrEqualTo: endDate.toIso8601String(),
        );
      }

      final snapshot = await query.orderBy('date', descending: true).get();

      return snapshot.docs
          .map(
            (doc) =>
                Attendance.fromMap(doc.data() as Map<String, dynamic>, doc.id),
          )
          .toList();
    } catch (e) {
      print('Error fetching attendance: $e');
      return [];
    }
  }

  // Ambil kehadiran berdasarkan tanggal
  Future<Attendance?> getAttendanceByDate(
    String employeeId,
    DateTime date,
  ) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay
          .add(const Duration(days: 1))
          .subtract(const Duration(milliseconds: 1));

      final snapshot = await _firestore
          .collection(_collectionName)
          .where('employeeId', isEqualTo: employeeId)
          .where('date', isGreaterThanOrEqualTo: startOfDay.toIso8601String())
          .where('date', isLessThanOrEqualTo: endOfDay.toIso8601String())
          .get();

      if (snapshot.docs.isNotEmpty) {
        return Attendance.fromMap(
          snapshot.docs.first.data(),
          snapshot.docs.first.id,
        );
      }
      return null;
    } catch (e) {
      print('Error fetching attendance by date: $e');
      return null;
    }
  }

  // Ambil kehadiran berdasarkan ID
  Future<Attendance?> getAttendanceById(String id) async {
    try {
      final doc = await _firestore.collection(_collectionName).doc(id).get();

      if (doc.exists) {
        return Attendance.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      print('Error fetching attendance by ID: $e');
      return null;
    }
  }

  // ================= UPDATE =================
  // Update data kehadiran
  Future<void> updateAttendance(String id, Attendance updatedAttendance) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(id)
          .update(updatedAttendance.toMap());

      print('Attendance updated: $id');
    } catch (e) {
      print('Error updating attendance: $e');
      rethrow;
    }
  }

  // Update jam check-out saja
  Future<void> updateCheckOutTime(String id, String checkOutTime) async {
    try {
      await _firestore.collection(_collectionName).doc(id).update({
        'checkOutTime': checkOutTime,
      });

      print('Check-out time updated');
    } catch (e) {
      print('Error updating check-out time: $e');
      rethrow;
    }
  }

  // ================= DELETE =================
  // Hapus data kehadiran
  Future<void> deleteAttendance(String id) async {
    try {
      await _firestore.collection(_collectionName).doc(id).delete();

      print('Attendance deleted: $id');
    } catch (e) {
      print('Error deleting attendance: $e');
      rethrow;
    }
  }

  // ================= STATISTIC =================
  // Statistik kehadiran
  Future<Map<String, int>> getAttendanceStats(
    String employeeId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      Query query = _firestore
          .collection(_collectionName)
          .where('employeeId', isEqualTo: employeeId);

      if (startDate != null) {
        query = query.where(
          'date',
          isGreaterThanOrEqualTo: startDate.toIso8601String(),
        );
      }

      if (endDate != null) {
        query = query.where(
          'date',
          isLessThanOrEqualTo: endDate.toIso8601String(),
        );
      }

      final snapshot = await query.get();

      final stats = {'Hadir': 0, 'Izin': 0, 'Sakit': 0, 'Libur': 0, 'Alpa': 0};

      for (final doc in snapshot.docs) {
        final status = doc['status'] ?? 'Alpa';
        stats[status] = (stats[status] ?? 0) + 1;
      }

      return stats;
    } catch (e) {
      print('Error getting attendance stats: $e');
      return {};
    }
  }

  // ================= STREAM =================
  // Real-time attendance
  Stream<List<Attendance>> getUserAttendanceStream(String employeeId) {
    return _firestore
        .collection(_collectionName)
        .where('employeeId', isEqualTo: employeeId)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Attendance.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }
}
