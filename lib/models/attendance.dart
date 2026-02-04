/// 📌 Attendance Model - Data untuk kehadiran
/// 💾 FIREBASE: Disimpan di collection 'attendance'
class Attendance {
  final String? id;
  final String employeeId;
  final String employeeName;
  final DateTime date;
  final String? checkInTime;
  final String? checkOutTime;
  final String status; // "Hadir", "Izin", "Sakit", "Libur", "Alpa"
  final String? notes;
  final String? photoUrl; // Firebase Storage URL
  final double? latitude;
  final double? longitude;

  Attendance({
    this.id,
    required this.employeeId,
    required this.employeeName,
    required this.date,
    this.checkInTime,
    this.checkOutTime,
    this.status = "Hadir",
    this.notes,
    this.photoUrl,
    this.latitude,
    this.longitude,
  });

  /// 🔄 Convert Model ke Map untuk Firebase
  /// 💾 FIREBASE: Gunakan untuk menyimpan ke Firestore
  Map<String, dynamic> toMap() {
    return {
      'employeeId': employeeId,
      'employeeName': employeeName,
      'date': date.toIso8601String(),
      'checkInTime': checkInTime,
      'checkOutTime': checkOutTime,
      'status': status,
      'notes': notes,
      'photoUrl': photoUrl,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  /// 🔄 Convert Map dari Firebase ke Model
  /// 💾 FIREBASE: Gunakan untuk membaca dari Firestore
  factory Attendance.fromMap(Map<String, dynamic> map, String docId) {
    return Attendance(
      id: docId,
      employeeId: map['employeeId'] ?? '',
      employeeName: map['employeeName'] ?? '',
      date: DateTime.parse(map['date'] ?? ''),
      checkInTime: map['checkInTime'],
      checkOutTime: map['checkOutTime'],
      status: map['status'] ?? 'Hadir',
      notes: map['notes'],
      photoUrl: map['photoUrl'],
      latitude: (map['latitude'] as num?)?.toDouble(),
      longitude: (map['longitude'] as num?)?.toDouble(),
    );
  }

  /// 📋 Create copy with modifications
  Attendance copyWith({
    String? id,
    String? employeeId,
    String? employeeName,
    DateTime? date,
    String? checkInTime,
    String? checkOutTime,
    String? status,
    String? notes,
    String? photoUrl,
    double? latitude,
    double? longitude,
  }) {
    return Attendance(
      id: id ?? this.id,
      employeeId: employeeId ?? this.employeeId,
      employeeName: employeeName ?? this.employeeName,
      date: date ?? this.date,
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      photoUrl: photoUrl ?? this.photoUrl,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
