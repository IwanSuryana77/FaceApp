/// 📌 Leave Request Model - Data untuk permintaan cuti
/// 💾 FIREBASE: Disimpan di collection 'leave_requests'
class LeaveRequest {
  final String? id;
  final String employeeId;
  final String employeeName;
  final DateTime startDate;
  final DateTime endDate;
  final String reason;
  final String status; // "Proses", "Disetujui", "Ditolak"
  final DateTime createdAt;
  final DateTime? approvedAt;
  final String? approvedBy;
  final int daysCount;

  LeaveRequest({
    this.id,
    required this.employeeId,
    required this.employeeName,
    required this.startDate,
    required this.endDate,
    required this.reason,
    this.status = "Proses",
    required this.createdAt,
    this.approvedAt,
    this.approvedBy,
    required this.daysCount,
  });

  /// 🔄 Convert Model ke Map untuk Firebase
  /// 💾 FIREBASE: Gunakan untuk menyimpan ke Firestore
  Map<String, dynamic> toMap() {
    return {
      'employeeId': employeeId,
      'employeeName': employeeName,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'reason': reason,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
      'approvedAt': approvedAt?.toIso8601String(),
      'approvedBy': approvedBy,
      'daysCount': daysCount,
    };
  }

  /// 🔄 Convert Map dari Firebase ke Model
  /// 💾 FIREBASE: Gunakan untuk membaca dari Firestore
  factory LeaveRequest.fromMap(Map<String, dynamic> map, String docId) {
    return LeaveRequest(
      id: docId,
      employeeId: map['employeeId'] ?? '',
      employeeName: map['employeeName'] ?? '',
      startDate: DateTime.parse(map['startDate'] ?? ''),
      endDate: DateTime.parse(map['endDate'] ?? ''),
      reason: map['reason'] ?? '',
      status: map['status'] ?? 'Proses',
      createdAt: DateTime.parse(map['createdAt'] ?? ''),
      approvedAt: map['approvedAt'] != null
          ? DateTime.parse(map['approvedAt'])
          : null,
      approvedBy: map['approvedBy'],
      daysCount: map['daysCount'] ?? 0,
    );
  }

  /// 📋 Create copy with modifications
  LeaveRequest copyWith({
    String? id,
    String? employeeId,
    String? employeeName,
    DateTime? startDate,
    DateTime? endDate,
    String? reason,
    String? status,
    DateTime? createdAt,
    DateTime? approvedAt,
    String? approvedBy,
    int? daysCount,
  }) {
    return LeaveRequest(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      reason: reason ?? this.reason,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      approvedAt: approvedAt ?? this.approvedAt,
      approvedBy: approvedBy ?? this.approvedBy,
      daysCount: daysCount ?? this.daysCount,
    );
  }
}
