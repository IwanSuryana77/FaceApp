import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:peresenceapp/models/attendance.dart';
import 'package:peresenceapp/models/leave_request.dart';
import 'package:peresenceapp/models/message.dart';
// import 'package:peresenceapp/models/reimbursement_request.dart';
import 'package:peresenceapp/services/api_service.dart';
import 'package:peresenceapp/services/attendance_service.dart';
import 'package:peresenceapp/services/leave_request_service.dart';
import 'package:peresenceapp/services/message_service.dart';
import 'package:peresenceapp/services/reimbursement_service.dart';

/// Fake (tiruan/mock) AttendanceService untuk uji/test unit API service absensi.
class FakeAttendanceService extends AttendanceService {
  Attendance? lastRecorded;
  String recordReturnId = 'att-1';

  List<Attendance> getUserAttendanceReturn = const [];
  String? lastGetUserAttendanceEmployeeId;
  DateTime? lastStartDate;
  DateTime? lastEndDate;

  String? lastUpdateCheckOutId;
  String? lastCheckOutTime;

  Map<String, int> attendanceStatsReturn = const {'Hadir': 3, 'Izin': 1};
  String? lastStatsEmployeeId;

  final _attendanceStreamController =
      StreamController<List<Attendance>>.broadcast();
  String? lastAttendanceStreamEmployeeId;

  // Untuk scenario pengujian tambahan
  Attendance? getByDateReturn;
  String? lastGetByDateEmployeeId;
  DateTime? lastGetByDateDate;

  Attendance? getByIdReturn;
  String? lastGetById;

  String? lastUpdateAttendanceId;
  Attendance? lastUpdatedAttendance;

  String? lastDeletedAttendanceId;

  /// Meniru perekaman absensi baru, simpan input & kembalikan id tiruan.
  @override
  Future<String> recordAttendance(Attendance attendance) async {
    lastRecorded = attendance;
    return recordReturnId;
  }

  /// Ambil daftar absensi user (pakai filter tanggal jika ada).
  @override
  Future<List<Attendance>> getUserAttendance(
    String employeeId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    lastGetUserAttendanceEmployeeId = employeeId;
    lastStartDate = startDate;
    lastEndDate = endDate;
    return getUserAttendanceReturn;
  }

  /// Ambil absensi berdasarkan tanggal.
  @override
  Future<Attendance?> getAttendanceByDate(
    String employeeId,
    DateTime date,
  ) async {
    lastGetByDateEmployeeId = employeeId;
    lastGetByDateDate = date;
    return getByDateReturn;
  }

  /// Ambil absensi berdasarkan id.
  @override
  Future<Attendance?> getAttendanceById(String id) async {
    lastGetById = id;
    return getByIdReturn;
  }

  /// Update absensi berdasar id & data baru.
  @override
  Future<void> updateAttendance(String id, Attendance updatedAttendance) async {
    lastUpdateAttendanceId = id;
    lastUpdatedAttendance = updatedAttendance;
  }

  /// Ubah waktu check out.
  @override
  Future<void> updateCheckOutTime(String id, String checkOutTime) async {
    lastUpdateCheckOutId = id;
    lastCheckOutTime = checkOutTime;
  }

  /// Hapus absensi berdasar id.
  @override
  Future<void> deleteAttendance(String id) async {
    lastDeletedAttendanceId = id;
  }

  /// Hitung statistik absensi user.
  @override
  Future<Map<String, int>> getAttendanceStats(
    String employeeId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    lastStatsEmployeeId = employeeId;
    return attendanceStatsReturn;
  }

  /// Stream data absensi real-time (misal untuk notifikasi, auto refresh UI).
  @override
  Stream<List<Attendance>> getUserAttendanceStream(String employeeId) {
    lastAttendanceStreamEmployeeId = employeeId;
    return _attendanceStreamController.stream;
  }

  /// Emit data stream absensi ke subscriber.
  void emitAttendanceStream(List<Attendance> data) {
    _attendanceStreamController.add(data);
  }

  /// Tutup stream jika selesai test.
  Future<void> close() async {
    await _attendanceStreamController.close();
  }
}

/// Fake (tiruan/mock) LeaveRequestService untuk uji unit API service cuti.
class FakeLeaveRequestService extends LeaveRequestService {
  String? lastUpdateId;
  String? lastNewStatus;
  String? lastApprovedBy;

  String createReturnId = 'lr-1';
  LeaveRequest? lastCreatedLeave;

  /// Update status permohonan cuti (dan bisa dengan approvedBy).
  @override
  Future<void> updateLeaveRequestStatus(
    String id,
    String newStatus, {
    String? approvedBy,
  }) async {
    lastUpdateId = id;
    lastNewStatus = newStatus;
    lastApprovedBy = approvedBy;
  }

  /// Catat permohonan cuti baru.
  @override
  Future<String> createLeaveRequest(LeaveRequest request) async {
    lastCreatedLeave = request;
    return createReturnId;
  }
}

/// Fake (tiruan/mock) MessageService untuk uji unit API service pesan.
class FakeMessageService extends MessageService {
  String? lastMarkAllRecipientId;
  int unreadCountReturn = 5;

  final _messagesStreamController = StreamController<List<Message>>.broadcast();
  String? lastMessagesStreamRecipientId;

  final _unreadMessagesStreamController =
      StreamController<List<Message>>.broadcast();
  String? lastUnreadMessagesStreamRecipientId;
  String sendReturnId = 'msg-1';
  Message? lastSentMessage;
  String? lastMarkMessageId;

  /// Tandai semua pesan user sebagai sudah dibaca.
  @override
  Future<void> markAllMessagesAsRead(String recipientId) async {
    lastMarkAllRecipientId = recipientId;
  }

  /// Ambil jumlah pesan belum dibaca.
  @override
  Future<int> getUnreadMessageCount(String recipientId) async {
    return unreadCountReturn;
  }

  /// Stream pesan masuk real-time.
  @override
  Stream<List<Message>> getUserMessagesStream(String recipientId) {
    lastMessagesStreamRecipientId = recipientId;
    return _messagesStreamController.stream;
  }

  /// Stream pesan belum dibaca real-time.
  @override
  Stream<List<Message>> getUnreadMessagesStream(String recipientId) {
    lastUnreadMessagesStreamRecipientId = recipientId;
    return _unreadMessagesStreamController.stream;
  }

  /// Kirim pesan baru.
  @override
  Future<String> sendMessage(Message message) async {
    lastSentMessage = message;
    return sendReturnId;
  }

  /// Tandai pesan tertentu sebagai sudah dibaca.
  @override
  Future<void> markMessageAsRead(String messageId) async {
    lastMarkMessageId = messageId;
  }

  /// Kirim event ke stream pesan biasa.
  void emitMessagesStream(List<Message> data) {
    _messagesStreamController.add(data);
  }

  /// Kirim event ke stream pesan belum dibaca.
  void emitUnreadMessagesStream(List<Message> data) {
    _unreadMessagesStreamController.add(data);
  }

  /// Tutup seluruh stream.
  Future<void> close() async {
    await _messagesStreamController.close();
    await _unreadMessagesStreamController.close();
  }
}

/// Fake (tiruan/mock) ReimbursementService untuk uji unit service reimbursement.
class FakeReimbursementService extends ReimbursementService {
  String? lastUpdateId;
  String? lastNewStatus;
  String? lastApprovedBy;
  String? lastRejectionReason;
  String? lastDeletedId;

  /// Update status reimbursement (disetujui/ditolak, dsb).
  Future<void> updateReimbursementStatus(
    String id,
    String newStatus, {
    String? approvedBy,
    String? rejectionReason,
  }) async {
    lastUpdateId = id;
    lastNewStatus = newStatus;
    lastApprovedBy = approvedBy;
    lastRejectionReason = rejectionReason;
  }

  /// Hapus reimbursement berdasarkan id.
  Future<void> deleteReimbursement(String id) async {
    lastDeletedId = id;
  }
}

void main() {
  // Deklarasi instance fake-service.
  late FakeAttendanceService fakeAttendance;
  late FakeLeaveRequestService fakeLeave;
  late FakeMessageService fakeMessage;
  late FakeReimbursementService fakeReimb;

  setUpAll(() async {
    // Inisialisasi Firebase pada testing pertama kali (jika belum).
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
    }
  });

  setUp(() {
    // Buat instance baru setiap test
    fakeAttendance = FakeAttendanceService();
    fakeLeave = FakeLeaveRequestService();
    fakeMessage = FakeMessageService();
    fakeReimb = FakeReimbursementService();
  });

  tearDown(() async {
    // Tutup stream setelah tiap test selesai (supaya tidak terjadi memory leak).
    await fakeAttendance.close();
    await fakeMessage.close();
  });

  // ---------------------------
  group('ApiService - Attendance', () {
    test('createAttendance delegates to service and returns id', () async {
      // Test: pencatatan absensi (create)
      final attendance = Attendance(
        employeeId: 'emp1',
        employeeName: 'Alice',
        date: DateTime(2024, 1, 1),
        checkInTime: '08:00',
      );
      fakeAttendance.recordReturnId = 'new-att-42';

      final id = await ApiService.instance.createAttendance(attendance);

      expect(id, 'new-att-42');
      expect(fakeAttendance.lastRecorded, isNotNull);
      expect(fakeAttendance.lastRecorded!.employeeId, 'emp1');
    });

    test('getUserAttendance forwards filters and returns list', () async {
      // Test: ambil data absensi user dengan filter tanggal.
      final a1 = Attendance(
        id: 'a1',
        employeeId: 'emp2',
        employeeName: 'Bob',
        date: DateTime(2024, 2, 10),
      );
      fakeAttendance.getUserAttendanceReturn = [a1];

      final start = DateTime(2024, 2, 1);
      final end = DateTime(2024, 2, 28);

      final list = await ApiService.instance.getUserAttendance(
        'emp2',
        startDate: start,
        endDate: end,
      );

      expect(list, hasLength(1));
      expect(list.first.id, 'a1');
      expect(fakeAttendance.lastGetUserAttendanceEmployeeId, 'emp2');
      expect(fakeAttendance.lastStartDate, start);
      expect(fakeAttendance.lastEndDate, end);
    });

    test('updateCheckOutTime delegates with correct parameters', () async {
      // Test: update waktu check-out absen.
      await ApiService.instance.updateCheckOutTime('att-9', '17:30');
      expect(fakeAttendance.lastUpdateCheckOutId, 'att-9');
      expect(fakeAttendance.lastCheckOutTime, '17:30');
    });

    test('getAttendanceStats returns computed stats from service', () async {
      // Test: ambil statistik absensi user.
      fakeAttendance.attendanceStatsReturn = {'Hadir': 2, 'Sakit': 1};
      final stats = await ApiService.instance.getAttendanceStats('emp3');
      expect(stats, containsPair('Hadir', 2));
      expect(stats, containsPair('Sakit', 1));
      expect(fakeAttendance.lastStatsEmployeeId, 'emp3');
    });

    test('getUserAttendanceStream yields real-time updates', () async {
      // Test: mendapatkan stream absensi secara real-time.
      final stream = ApiService.instance.getUserAttendanceStream('emp4');

      final futureExpectation = expectLater(
        stream,
        emitsInOrder([
          predicate<List<Attendance>>((list) => list.isEmpty),
          predicate<List<Attendance>>(
            (list) => list.length == 1 && list.first.employeeId == 'emp4',
          ),
        ]),
      );

      fakeAttendance.emitAttendanceStream([]);
      fakeAttendance.emitAttendanceStream([
        Attendance(
          id: 's1',
          employeeId: 'emp4',
          employeeName: 'Cara',
          date: DateTime(2024, 3, 5),
        ),
      ]);

      await futureExpectation;
      expect(fakeAttendance.lastAttendanceStreamEmployeeId, 'emp4');
    });

    test('getAttendanceByDate returns value and forwards parameters', () async {
      // Test: cari absensi berdasarkan tanggal
      final date = DateTime(2024, 4, 10);
      fakeAttendance.getByDateReturn = Attendance(
        id: 'ad-1',
        employeeId: 'emp5',
        employeeName: 'Dina',
        date: date,
      );

      final res = await ApiService.instance.getAttendanceByDate('emp5', date);

      expect(res, isNotNull);
      expect(res!.id, 'ad-1');
      expect(fakeAttendance.lastGetByDateEmployeeId, 'emp5');
      expect(fakeAttendance.lastGetByDateDate, date);
    });

    test('updateAttendance delegates with correct id and data', () async {
      // Test: update absensi tertentu
      final updated = Attendance(
        employeeId: 'emp6',
        employeeName: 'Evan',
        date: DateTime(2024, 5, 1),
        checkInTime: '09:00',
        checkOutTime: '17:00',
      );

      await ApiService.instance.updateAttendance('att-55', updated);

      expect(fakeAttendance.lastUpdateAttendanceId, 'att-55');
      expect(fakeAttendance.lastUpdatedAttendance, isNotNull);
      expect(fakeAttendance.lastUpdatedAttendance!.employeeName, 'Evan');
    });
  });

  group('ApiService - Leave Requests', () {
    test('updateLeaveRequestStatus delegates with approvedBy', () async {
      // Test: update status cuti
      await ApiService.instance.updateLeaveRequestStatus(
        'lr-10',
        'Disetujui',
        approvedBy: 'manager1',
      );
      expect(fakeLeave.lastUpdateId, 'lr-10');
      expect(fakeLeave.lastNewStatus, 'Disetujui');
      expect(fakeLeave.lastApprovedBy, 'manager1');
    });

    test('createLeaveRequest delegates and returns id', () async {
      // Test: buat permohonan cuti baru
      final request = LeaveRequest(
        employeeId: 'emp7',
        employeeName: 'Fina',
        startDate: DateTime(2024, 6, 1),
        endDate: DateTime(2024, 6, 5),
        reason: 'Vacation',
        status: 'Menunggu',
        createdAt: DateTime(2024, 5, 20),
        daysCount: 5,
      );
      fakeLeave.createReturnId = 'lr-77';

      final id = await ApiService.instance.createLeaveRequest(request);

      expect(id, 'lr-77');
      expect(fakeLeave.lastCreatedLeave, isNotNull);
      expect(fakeLeave.lastCreatedLeave!.employeeId, 'emp7');
    });
  });

  group('ApiService - Messages', () {
    test('markAllMessagesAsRead delegates to service', () async {
      // Test: tandai semua pesan telah dibaca
      await ApiService.instance.markAllMessagesAsRead('u-100');
      expect(fakeMessage.lastMarkAllRecipientId, 'u-100');
    });

    test('getUnreadMessageCount returns value from service', () async {
      // Test: hitung pesan belum dibaca
      fakeMessage.unreadCountReturn = 7;
      final count = await ApiService.instance.getUnreadMessageCount('u-200');
      expect(count, 7);
    });

    test('getUserMessagesStream emits lists of messages', () async {
      // Test: stream pesan masuk ke user
      final stream = ApiService.instance.getUserMessagesStream('u-300');

      final futureExpectation = expectLater(
        stream,
        emitsInOrder([
          predicate<List<Message>>((list) => list.isEmpty),
          predicate<List<Message>>(
            (list) => list.length == 2 && list[0].title == 'Hello',
          ),
        ]),
      );

      fakeMessage.emitMessagesStream([]);
      fakeMessage.emitMessagesStream([
        Message(
          id: 'm1',
          senderId: 's1',
          senderName: 'Sender',
          recipientId: 'u-300',
          title: 'Hello',
          body: 'World',
          sentAt: DateTime(2024, 1, 1),
        ),
        Message(
          id: 'm2',
          senderId: 's2',
          senderName: 'Sender2',
          recipientId: 'u-300',
          title: 'Hi',
          body: 'Again',
          sentAt: DateTime(2024, 1, 2),
        ),
      ]);

      await futureExpectation;
      expect(fakeMessage.lastMessagesStreamRecipientId, 'u-300');
    });

    test('sendMessage delegates to service and returns id', () async {
      // Test: mengirim pesan
      final msg = Message(
        senderId: 's1',
        senderName: 'Alice',
        recipientId: 'u-500',
        title: 'Greetings',
        body: 'Hello there',
        sentAt: DateTime(2024, 7, 1),
      );
      fakeMessage.sendReturnId = 'msg-999';

      final id = await ApiService.instance.sendMessage(msg);

      expect(id, 'msg-999');
      expect(fakeMessage.lastSentMessage, isNotNull);
      expect(fakeMessage.lastSentMessage!.recipientId, 'u-500');
    });

    test('getUnreadMessagesStream emits real-time unread lists', () async {
      // Test: stream pesan belum dibaca
      final stream = ApiService.instance.getUnreadMessagesStream('u-600');

      final futureExpectation = expectLater(
        stream,
        emitsInOrder([
          predicate<List<Message>>((list) => list.isEmpty),
          predicate<List<Message>>(
            (list) => list.length == 1 && list.first.isRead == false,
          ),
        ]),
      );

      fakeMessage.emitUnreadMessagesStream([]);
      fakeMessage.emitUnreadMessagesStream([
        Message(
          id: 'um1',
          senderId: 's9',
          senderName: 'Notifier',
          recipientId: 'u-600',
          title: 'Alert',
          body: 'Please read',
          isRead: false,
          sentAt: DateTime(2024, 7, 2),
        ),
      ]);

      await futureExpectation;
      expect(fakeMessage.lastUnreadMessagesStreamRecipientId, 'u-600');
    });
  });

  group('ApiService - Reimbursements', () {
    test('updateReimbursementStatus delegates with rejectionReason', () async {
      // Test: update status reimbursement
      await ApiService.instance.updateReimbursementStatus(
        'rb-10',
        'Ditolak',
        approvedBy: 'manager2',
        rejectionReason: 'Incomplete docs',
      );
      expect(fakeReimb.lastUpdateId, 'rb-10');
      expect(fakeReimb.lastNewStatus, 'Ditolak');
      expect(fakeReimb.lastApprovedBy, 'manager2');
      expect(fakeReimb.lastRejectionReason, 'Incomplete docs');
    });

    test('deleteReimbursement delegates to service', () async {
      // Test: hapus reimbursement
      await ApiService.instance.deleteReimbursement('rb-99');
      expect(fakeReimb.lastDeletedId, 'rb-99');
    });
  });
}