import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class AuthHelper {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  
  // Mendapatkan user yang sedang login
  
  static User? get currentUser => _auth.currentUser;

  
  // Mendapatkan UID dari user yang sedang login

  static String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }


  // Mendapatkan email dari user yang sedang login

  static String? getCurrentUserEmail() {
    return _auth.currentUser?.email;
  }

  
  // Mendapatkan nama user dari Firestore (prioritas: fullName > name)

  static Future<String> getCurrentUserName() async {
    final uid = getCurrentUserId();
    
    // Jika user tidak login
    if (uid == null) {
      return 'Guest';
    }

    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        
        // Prioritas 1: fullName
        if (data['fullName'] != null && data['fullName'].toString().trim().isNotEmpty) {
          return data['fullName'].toString().trim();
        }
        
        // Prioritas 2: name
        if (data['name'] != null && data['name'].toString().trim().isNotEmpty) {
          return data['name'].toString().trim();
        }
        
        // Prioritas 3: displayName dari Firebase Auth
        if (_auth.currentUser?.displayName != null && 
            _auth.currentUser!.displayName!.trim().isNotEmpty) {
          return _auth.currentUser!.displayName!.trim();
        }
        
        // Prioritas 4: email (jika ada di data)
        if (data['email'] != null && data['email'].toString().trim().isNotEmpty) {
          return data['email'].toString().split('@').first;
        }
      }
    } catch (e) {
      print(' Error getting user name from Firestore: $e');
    }

    // Fallback: email dari Firebase Auth
    final email = getCurrentUserEmail();
    if (email != null && email.trim().isNotEmpty) {
      return email.split('@').first;
    }

    return 'User';
  }

  // Mendapatkan nama perusahaan dari Firestore

  static Future<String> getCurrentUserCompanyName() async {
    final uid = getCurrentUserId();
    
    if (uid == null) {
      return 'Company';
    }

    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        
        // Cek field companyName
        if (data['companyName'] != null && data['companyName'].toString().trim().isNotEmpty) {
          return data['companyName'].toString().trim();
        }
        
        // Cek field company (alternatif)
        if (data['company'] != null && data['company'].toString().trim().isNotEmpty) {
          return data['company'].toString().trim();
        }
        
        // Cek field perusahaan (alternatif bahasa Indonesia)
        if (data['perusahaan'] != null && data['perusahaan'].toString().trim().isNotEmpty) {
          return data['perusahaan'].toString().trim();
        }
      }
    } catch (e) {
      print('❌ Error getting company name: $e');
    }

    return 'Company';
  }

  
  // Mendapatkan nomor telepon dari Firestore

  static Future<String?> getCurrentUserPhone() async {
    final uid = getCurrentUserId();
    
    if (uid == null) {
      return null;
    }

    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        final phone = data['phone']?.toString();
        if (phone != null && phone.trim().isNotEmpty) {
          return phone.trim();
        }
        
        // Cek alternatif field names
        final phoneNumber = data['phoneNumber']?.toString();
        if (phoneNumber != null && phoneNumber.trim().isNotEmpty) {
          return phoneNumber.trim();
        }
      }
    } catch (e) {
      print(' Error getting user phone: $e');
    }

    return null;
  }

 
  // Mendapatkan semua data user dari Firestore

  static Future<Map<String, dynamic>?> getCompleteUserData() async {
    final uid = getCurrentUserId();
    
    if (uid == null) {
      return null;
    }

    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      
      if (doc.exists && doc.data() != null) {
        return doc.data();
      }
    } catch (e) {
      print('❌ Error getting complete user data: $e');
    }

    return null;
  }

 
  ///Menyimpan/update profil user ke Firestore

  static Future<void> saveUserProfile({
    required String name,
    required String email,
    String? phone,
    String? companyName,
    String? companyId,
    String? position,
    String? department,
  }) async {
    final uid = getCurrentUserId();
    
    if (uid == null) {
      throw Exception('User not authenticated');
    }

    try {
      final userData = <String, dynamic>{
        'uid': uid,
        'name': name.trim(),
        'email': email.trim(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Tambahkan field opsional jika ada
      if (phone != null && phone.trim().isNotEmpty) {
        userData['phone'] = phone.trim();
      }
      
      if (companyName != null && companyName.trim().isNotEmpty) {
        userData['companyName'] = companyName.trim();
      }
      
      if (companyId != null && companyId.trim().isNotEmpty) {
        userData['companyId'] = companyId.trim();
      }
      
      if (position != null && position.trim().isNotEmpty) {
        userData['position'] = position.trim();
      }
      
      if (department != null && department.trim().isNotEmpty) {
        userData['department'] = department.trim();
      }

      await _firestore.collection('users').doc(uid).set(
        userData,
        SetOptions(merge: true),
      );
      
      print(' User profile saved successfully');
    } catch (e) {
      print(' Error saving user profile: $e');
      throw Exception('Failed to save user profile: $e');
    }
  }

  // Mengecek apakah user sudah login
  static bool isUserLoggedIn() {
    return _auth.currentUser != null;
  }

  
  // Logout user dari Firebase Auth
  static Future<void> logout() async {
    try {
      await _auth.signOut();
      print(' User logged out successfully');
    } catch (e) {
      print(' Error during logout: $e');
     
    }
  }

  
  // Menghapus akun user dari Firebase Auth dan Firestore

  static Future<void> deleteUserAccount() async {
    final user = _auth.currentUser;
    
    if (user == null) {
      throw Exception('No user is currently logged in');
    }

    try {
      final uid = user.uid;
      
      // Hapus data dari Firestore (tidak wajib, tapi baik dilakukan)
      try {
        await _firestore.collection('users').doc(uid).delete();
        print(' User data deleted from Firestore');
      } catch (e) {
        print(' Could not delete Firestore data: $e');
       
      }
      
      //  Hapus akun dari Firebase Auth
      await user.delete();
      print(' User account deleted from Firebase Auth');
      
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        throw Exception(
          'Untuk menghapus akun, Anda perlu login ulang terlebih dahulu. '
          'Silakan logout dan login kembali, lalu coba hapus akun.'
        );
      }
      throw Exception('Failed to delete account: ${e.message}');
    } catch (e) {
      print(' Error deleting user account: $e');
      throw Exception('Failed to delete account: $e');
    }
  }

  
  // Mendapatkan stream perubahan status auth
  
  static Stream<User?> get authStateChanges => _auth.authStateChanges();


  // Mengirim email reset password

  static Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      print(' Password reset email sent to: $email');
    } on FirebaseAuthException catch (e) {
      print(' Error sending password reset email: ${e.code}');
      throw Exception('Gagal mengirim email reset password: ${e.message}');
    } catch (e) {
      print(' Error sending password reset email: $e');
      throw Exception('Terjadi kesalahan: $e');
    }
  }

  
  // Update data profil user di Firestore
  
  static Future<void> updateUserProfile({
    String? fullName,
    String? phone,
    String? companyName,
    String? companyId,
    String? position,
    String? department,
  }) async {
    final uid = getCurrentUserId();
    
    if (uid == null) {
      throw Exception('User not authenticated');
    }

    try {
      final updateData = <String, dynamic>{
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Tambahkan field yang ingin diupdate
      if (fullName != null && fullName.trim().isNotEmpty) {
        updateData['fullName'] = fullName.trim();
      }
      
      if (phone != null && phone.trim().isNotEmpty) {
        updateData['phone'] = phone.trim();
      }
      
      if (companyName != null && companyName.trim().isNotEmpty) {
        updateData['companyName'] = companyName.trim();
      }
      
      if (companyId != null && companyId.trim().isNotEmpty) {
        updateData['companyId'] = companyId.trim();
      }
      
      if (position != null && position.trim().isNotEmpty) {
        updateData['position'] = position.trim();
      }
      
      if (department != null && department.trim().isNotEmpty) {
        updateData['department'] = department.trim();
      }

      await _firestore.collection('users').doc(uid).update(updateData);
      print(' User profile updated successfully');
    } catch (e) {
      print(' Error updating user profile: $e');
      throw Exception('Failed to update profile: $e');
    }
  }

  
  // Mengirim email verifikasi
  static Future<void> verifyUserEmail() async {
    final user = _auth.currentUser;
    
    if (user == null) {
      throw Exception('User not authenticated');
    }

    try {
      await user.sendEmailVerification();
      print(' Verification email sent to: ${user.email}');
    } catch (e) {
      print(' Error sending verification email: $e');
      throw Exception('Gagal mengirim email verifikasi');
    }
  }

  // Mengecek apakah email sudah diverifikasi
 
  static bool isEmailVerified() {
    return _auth.currentUser?.emailVerified ?? false;
  }

 
  // Memuat ulang data user (untuk update emailVerified)
  
  static Future<void> reloadUser() async {
    final user = _auth.currentUser;
    
    if (user != null) {
      await user.reload();
    }
  }

  
  // Mendapatkan inisial dari nama user
 
  static String getUserInitials(String? name) {
    if (name == null || name.trim().isEmpty) return 'U';
    
    final cleanName = name.trim();
    final parts = cleanName.split(' ').where((p) => p.isNotEmpty).toList();
    
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    
    return (parts[0][0] + parts.last[0]).toUpperCase();
  }


  //Mendapatkan URL foto profil
 
  static String? getUserPhotoUrl() {
    return _auth.currentUser?.photoURL;
  }

 
  // Update display name di Firebase Auth
 
  static Future<void> updateDisplayName(String displayName) async {
    final user = _auth.currentUser;
    
    if (user == null) {
      throw Exception('User not authenticated');
    }

    try {
      await user.updateDisplayName(displayName.trim());
      await user.reload();
      print('✅ Display name updated in Firebase Auth');
    } catch (e) {
      print('❌ Error updating display name: $e');
      throw Exception('Failed to update display name');
    }
  }

  
  // Update photo URL di Firebase Auth
  static Future<void> updatePhotoUrl(String photoUrl) async {
    final user = _auth.currentUser;
    
    if (user == null) {
      throw Exception('User not authenticated');
    }

    try {
      await user.updatePhotoURL(photoUrl);
      await user.reload();
      print(' Photo URL updated in Firebase Auth');
    } catch (e) {
      print(' Error updating photo URL: $e');
      throw Exception('Failed to update photo URL');
    }
  }

  
  // Mengubah password user
 
  static Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _auth.currentUser;
    final email = user?.email;
    
    if (user == null || email == null) {
      throw Exception('User not authenticated');
    }

    try {
      // Re-authenticate user
      final credential = EmailAuthProvider.credential(
        email: email,
        password: currentPassword,
      );
      
      await user.reauthenticateWithCredential(credential);
      
      // Update password
      await user.updatePassword(newPassword);
      
      print('✅ Password changed successfully');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        throw Exception('Password lama salah');
      } else if (e.code == 'weak-password') {
        throw Exception('Password baru terlalu lemah. Minimal 6 karakter');
      }
      throw Exception('Gagal mengubah password: ${e.message}');
    } catch (e) {
      print('❌ Error changing password: $e');
      throw Exception('Terjadi kesalahan: $e');
    }
  }
}


// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// /// ===============================
// /// AUTH HELPER (STATIC)
// /// ===============================
// class AuthHelper {
//   static final FirebaseAuth _auth = FirebaseAuth.instance;
//   static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   static String? getCurrentUserId() {
//     return _auth.currentUser?.uid;
//   }

//   static String? getCurrentUserEmail() {
//     return _auth.currentUser?.email;
//   }

//   static Future<String> getCurrentUserName() async {
//     final uid = getCurrentUserId();
//     if (uid == null) return 'Unknown';

//     try {
//       final doc = await _firestore.collection('users').doc(uid).get();
//       if (doc.exists) {
//         final data = doc.data();
//         if (data?['fullName'] != null) return data!['fullName'];
//         if (data?['name'] != null) return data!['name'];
//       }
//     } catch (e) {
//       print('Error getting user name: $e');
//     }

//     return getCurrentUserEmail() ?? 'Unknown User';
//   }

//   static Future<String> getCurrentUserCompanyName() async {
//     final uid = getCurrentUserId();
//     if (uid == null) return 'Unknown Company';

//     try {
//       final doc = await _firestore.collection('users').doc(uid).get();
//       if (doc.exists) {
//         final data = doc.data();
//         if (data?['companyName'] != null) return data!['companyName'];
//       }
//     } catch (e) {
//       print('Error getting company name: $e');
//     }

//     return 'Unknown Company';
//   }

//   static Future<void> saveUserProfile({
//     required String name,
//     required String email,
//   }) async {
//     final uid = getCurrentUserId();
//     if (uid == null) throw Exception('User not authenticated');

//     await _firestore.collection('users').doc(uid).set({
//       'uid': uid,
//       'name': name,
//       'email': email,
//       'updatedAt': FieldValue.serverTimestamp(),
//     }, SetOptions(merge: true));
//   }

//   static bool isUserLoggedIn() {
//     return _auth.currentUser != null;
//   }

//   static Future<void> logout() async {
//     await _auth.signOut();
//   }
// }

// /// ===============================
// /// FIREBASE SERVICE (INSTANCE)
// /// ===============================
// class FirebaseService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // REGISTER
//   Future<UserCredential> createUserWithEmailAndPassword(
//     String email,
//     String password,
//   ) async {
//     return await _auth.createUserWithEmailAndPassword(
//       email: email,
//       password: password,
//     );
//   }

//   // LOGIN
//   Future<UserCredential> signInWithEmailAndPassword(
//     String email,
//     String password,
//   ) async {
//     return await _auth.signInWithEmailAndPassword(
//       email: email,
//       password: password,
//     );
//   }

//   // SIMPAN USER DATA
//   Future<void> saveUserData(
//     String userId,
//     Map<String, dynamic> userData,
//   ) async {
//     await _firestore.collection('users').doc(userId).set(
//       userData,
//       SetOptions(merge: true),
//     );
//   }

//   // AMBIL USER DATA
//   Future<Map<String, dynamic>?> getUserData(String userId) async {
//     final doc = await _firestore.collection('users').doc(userId).get();
//     return doc.data();
//   }

//   // LOGOUT
//   Future<void> signOut() async {
//     await _auth.signOut();
//   }

//   // CURRENT USER
//   User? get currentUser => _auth.currentUser;
// }


// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class AuthHelper {
//   static final FirebaseAuth _auth = FirebaseAuth.instance;
//   static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   /// Dapatkan user ID dari user yang sedang login
//   static String? getCurrentUserId() {
//     return _auth.currentUser?.uid;
//   }

//   /// Dapatkan email user yang sedang login
//   static String? getCurrentUserEmail() {
//     return _auth.currentUser?.email;
//   }

//   /// Dapatkan nama user dari Firestore atau email
//   static Future<String> getCurrentUserName() async {
//     final uid = getCurrentUserId();
//     if (uid == null) return 'Unknown';

//     try {
//       // Coba ambil dari Firestore
//       final doc = await _firestore.collection('users').doc(uid).get();
//       if (doc.exists && doc.data()?['name'] != null) {
//         return doc.data()!['name'];
//       }
//     } catch (e) {
//       print('Error getting user name from Firestore: $e');
//     }

//     // Fallback ke email
//     return getCurrentUserEmail() ?? 'Unknown User';
//   }

//   /// Simpan profile user ke Firestore
//   static Future<void> saveUserProfile({
//     required String name,
//     required String email,
//   }) async {
//     final uid = getCurrentUserId();
//     if (uid == null) throw Exception('User not authenticated');

//     await _firestore.collection('users').doc(uid).set({
//       'uid': uid,
//       'name': name,
//       'email': email,
//       'createdAt': DateTime.now().toIso8601String(),
//     }, SetOptions(merge: true));
//   }

//   // Cek apakah user sudah login
//   static bool isUserLoggedIn() {
//     return _auth.currentUser != null;
//   }

//   // Logout user
//   static Future<void> logout() {
//     return _auth.signOut();
//   }
// }
