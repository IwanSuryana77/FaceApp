/// 📌 Message/Inbox Model - Data untuk pesan
/// 💾 FIREBASE: Disimpan di collection 'messages'
class Message {
  final String? id;
  final String senderId;
  final String senderName;
  final String recipientId;
  final String title;
  final String body;
  final bool isRead;
  final DateTime sentAt;
  final DateTime? readAt;
  final String? attachmentUrl;

  Message({
    this.id,
    required this.senderId,
    required this.senderName,
    required this.recipientId,
    required this.title,
    required this.body,
    this.isRead = false,
    required this.sentAt,
    this.readAt,
    this.attachmentUrl,
  });

  /// 🔄 Convert Model ke Map untuk Firebase
  /// 💾 FIREBASE: Gunakan untuk menyimpan ke Firestore
  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'senderName': senderName,
      'recipientId': recipientId,
      'title': title,
      'body': body,
      'isRead': isRead,
      'sentAt': sentAt.toIso8601String(),
      'readAt': readAt?.toIso8601String(),
      'attachmentUrl': attachmentUrl,
    };
  }

  /// 🔄 Convert Map dari Firebase ke Model
  /// 💾 FIREBASE: Gunakan untuk membaca dari Firestore
  factory Message.fromMap(Map<String, dynamic> map, String docId) {
    return Message(
      id: docId,
      senderId: map['senderId'] ?? '',
      senderName: map['senderName'] ?? '',
      recipientId: map['recipientId'] ?? '',
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      isRead: map['isRead'] ?? false,
      sentAt: DateTime.parse(map['sentAt'] ?? ''),
      readAt: map['readAt'] != null ? DateTime.parse(map['readAt']) : null,
      attachmentUrl: map['attachmentUrl'],
    );
  }

  /// 📋 Create copy with modifications
  Message copyWith({
    String? id,
    String? senderId,
    String? senderName,
    String? recipientId,
    String? title,
    String? body,
    bool? isRead,
    DateTime? sentAt,
    DateTime? readAt,
    String? attachmentUrl,
  }) {
    return Message(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      recipientId: recipientId ?? this.recipientId,
      title: title ?? this.title,
      body: body ?? this.body,
      isRead: isRead ?? this.isRead,
      sentAt: sentAt ?? this.sentAt,
      readAt: readAt ?? this.readAt,
      attachmentUrl: attachmentUrl ?? this.attachmentUrl,
    );
  }
}
