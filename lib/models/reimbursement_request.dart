/// 📌 Reimbursement Request Model - Data untuk pengembalian dana
/// 💾 FIREBASE: Disimpan di collection 'reimbursement_requests'
class ReimbursementRequest {
  final String? id;
  final String employeeId;
  final String employeeName;
  final DateTime startDate;
  final DateTime endDate;
  final String description;
  final double amount;
  final String status; // "Proses", "Disetujui", "Ditolak"
  final List<String>? attachmentUrls; // Firebase Storage URLs
  final DateTime createdAt;
  final DateTime? approvedAt;
  final String? approvedBy;
  final String? rejectionReason;

  ReimbursementRequest({
    this.id,
    required this.employeeId,
    required this.employeeName,
    required this.startDate,
    required this.endDate,
    required this.description,
    required this.amount,
    this.status = "Proses",
    this.attachmentUrls,
    required this.createdAt,
    this.approvedAt,
    this.approvedBy,
    this.rejectionReason,
  });

  /// 🔄 Convert Model ke Map untuk Firebase
  /// 💾 FIREBASE: Gunakan untuk menyimpan ke Firestore
  Map<String, dynamic> toMap() {
    return {
      'employeeId': employeeId,
      'employeeName': employeeName,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'description': description,
      'amount': amount,
      'status': status,
      'attachmentUrls': attachmentUrls ?? [],
      'createdAt': createdAt.toIso8601String(),
      'approvedAt': approvedAt?.toIso8601String(),
      'approvedBy': approvedBy,
      'rejectionReason': rejectionReason,
    };
  }

  /// 🔄 Convert Map dari Firebase ke Model
  /// 💾 FIREBASE: Gunakan untuk membaca dari Firestore
  factory ReimbursementRequest.fromMap(Map<String, dynamic> map, String docId) {
    return ReimbursementRequest(
      id: docId,
      employeeId: map['employeeId'] ?? '',
      employeeName: map['employeeName'] ?? '',
      startDate: DateTime.parse(map['startDate'] ?? ''),
      endDate: DateTime.parse(map['endDate'] ?? ''),
      description: map['description'] ?? '',
      amount: (map['amount'] ?? 0).toDouble(),
      status: map['status'] ?? 'Proses',
      attachmentUrls: List<String>.from(map['attachmentUrls'] ?? []),
      createdAt: DateTime.parse(map['createdAt'] ?? ''),
      approvedAt: map['approvedAt'] != null
          ? DateTime.parse(map['approvedAt'])
          : null,
      approvedBy: map['approvedBy'],
      rejectionReason: map['rejectionReason'],
    );
  }

  /// 📋 Create copy with modifications
  ReimbursementRequest copyWith({
    String? id,
    String? employeeId,
    String? employeeName,
    DateTime? startDate,
    DateTime? endDate,
    String? description,
    double? amount,
    String? status,
    List<String>? attachmentUrls,
    DateTime? createdAt,
    DateTime? approvedAt,
    String? approvedBy,
    String? rejectionReason,
  }) {
    return ReimbursementRequest(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      status: status ?? this.status,
      attachmentUrls: attachmentUrls ?? this.attachmentUrls,
      createdAt: createdAt ?? this.createdAt,
      approvedAt: approvedAt ?? this.approvedAt,
      approvedBy: approvedBy ?? this.approvedBy,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }
}
