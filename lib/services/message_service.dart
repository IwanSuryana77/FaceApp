import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/message.dart';

//Firebase Service untuk Messages (Pesan/Inbox)
//FIREBASE: Mengelola CRUD operations di collection 'messages'
class MessageService {
  static final _firestore = FirebaseFirestore.instance;
  static const _collectionName = 'messages';

  //Kirim pesan baru ke Firebase
  //FIREBASE WRITE: Menyimpan dokumen baru ke Firestore
  Future<String> sendMessage(Message message) async {
    try {
      final docRef = await _firestore
          .collection(_collectionName)
          .add(message.toMap());

      print('Message sent with ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('Error sending message: $e');
      rethrow;
    }
  }

  //Ambil semua pesan untuk user tertentu (sebagai penerima)
  //FIREBASE READ: Query dokumen berdasarkan recipientId
  Future<List<Message>> getUserMessages(String recipientId) async {
    try {
      final snapshot = await _firestore
          .collection(_collectionName)
          .where('recipientId', isEqualTo: recipientId)
          .orderBy('sentAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Message.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print(' Error fetching messages: $e');
      return [];
    }
  }

  //Ambil pesan yang belum dibaca
  //FIREBASE READ: Query dokumen dengan kondisi isRead = false
  Future<List<Message>> getUnreadMessages(String recipientId) async {
    try {
      final snapshot = await _firestore
          .collection(_collectionName)
          .where('recipientId', isEqualTo: recipientId)
          .where('isRead', isEqualTo: false)
          .orderBy('sentAt', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => Message.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      print('Error fetching unread messages: $e');
      return [];
    }
  }

  //Ambil pesan berdasarkan ID
  //FIREBASE READ: Get dokumen spesifik
  Future<Message?> getMessageById(String id) async {
    try {
      final doc = await _firestore.collection(_collectionName).doc(id).get();

      if (doc.exists) {
        return Message.fromMap(doc.data() as Map<String, dynamic>, doc.id);
      }
      return null;
    } catch (e) {
      print('Error fetching message: $e');
      return null;
    }
  }

  //Tandai pesan sebagai sudah dibaca
  //IREBASE UPDATE: Memperbarui field isRead
  Future<void> markMessageAsRead(String messageId) async {
    try {
      await _firestore.collection(_collectionName).doc(messageId).update({
        'isRead': true,
        'readAt': DateTime.now().toIso8601String(),
      });

      print('Message marked as read');
    } catch (e) {
      print('Error marking message as read: $e');
      rethrow;
    }
  }

  //Tandai semua pesan sebagai sudah dibaca
  //FIREBASE BATCH UPDATE: Memperbarui multiple dokumen
  Future<void> markAllMessagesAsRead(String recipientId) async {
    try {
      final unreadMessages = await getUnreadMessages(recipientId);

      final batch = _firestore.batch();
      for (final message in unreadMessages) {
        batch.update(_firestore.collection(_collectionName).doc(message.id), {
          'isRead': true,
          'readAt': DateTime.now().toIso8601String(),
        });
      }

      await batch.commit();
      print('All messages marked as read');
    } catch (e) {
      print('Error marking all messages as read: $e');
      rethrow;
    }
  }

  //Hapus pesan
  //FIREBASE DELETE: Menghapus dokumen dari Firestore
  Future<void> deleteMessage(String messageId) async {
    try {
      await _firestore.collection(_collectionName).doc(messageId).delete();

      print('Message deleted: $messageId');
    } catch (e) {
      print('Error deleting message: $e');
      rethrow;
    }
  }

  //Stream untuk real-time messages
  //FIREBASE STREAM: Listen ke pesan baru secara real-time
  Stream<List<Message>> getUserMessagesStream(String recipientId) {
    return _firestore
        .collection(_collectionName)
        .where('recipientId', isEqualTo: recipientId)
        .orderBy('sentAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Message.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  // Stream untuk pesan yang belum dibaca
  //FIREBASE STREAM: Listen ke unread messages real-time
  Stream<List<Message>> getUnreadMessagesStream(String recipientId) {
    return _firestore
        .collection(_collectionName)
        .where('recipientId', isEqualTo: recipientId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Message.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  //Hitung jumlah pesan yang belum dibaca
  //FIREBASE READ: Count dokumen dengan kondisi tertentu
  Future<int> getUnreadMessageCount(String recipientId) async {
    try {
      final snapshot = await _firestore
          .collection(_collectionName)
          .where('recipientId', isEqualTo: recipientId)
          .where('isRead', isEqualTo: false)
          .count()
          .get();

      return snapshot.count ?? 0;
    } catch (e) {
      print('Error counting unread messages: $e');
      return 0;
    }
  }
}
