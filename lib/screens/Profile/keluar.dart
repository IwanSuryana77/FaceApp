import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart'; 
import 'package:peresenceapp/screens/auth/login_screen.dart';
import 'package:peresenceapp/services/auth_helper.dart';

class KeluarPage extends StatefulWidget {
  const KeluarPage({super.key});

  @override
  State<KeluarPage> createState() => _KeluarPageState();
}

class _KeluarPageState extends State<KeluarPage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Keluar Akun"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon Perhatian
            const Icon(
              Icons.warning,
              size: 100,
              color: Colors.orange,
            ),
            const SizedBox(height: 20),

            // Pesan Konfirmasi
            const Text(
              "Apakah Anda yakin ingin keluar?",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            Text(
              "Anda akan keluar dari akun ini dan perlu login kembali untuk mengakses aplikasi",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Pilihan Keluar
            Column(
              children: [
                // Keluar Akun
                _buildLogoutOption(
                  icon: Icons.logout,
                  title: "Keluar Akun",
                  subtitle: "Hanya logout dari aplikasi ini",
                  onTap: () {
                    _showLogoutConfirmation(context);
                  },
                ),
                const SizedBox(height: 16),

                // Hapus Akun
                _buildLogoutOption(
                  icon: Icons.delete_forever,
                  title: "Hapus Akun Permanen",
                  subtitle: "Hapus semua data akun Anda",
                  isDanger: true,
                  onTap: () {
                    _showDeleteAccountConfirmation(context);
                  },
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Tombol Batal
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  side: BorderSide(color: Colors.grey.shade400),
                ),
                child: const Text(
                  "Batal",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDanger = false,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDanger ? Colors.red.shade100 : Colors.grey.shade200,
          width: 1,
        ),
      ),
      color: isDanger ? Colors.red.shade50 : Colors.white,
      child: ListTile(
        leading: Icon(
          icon,
          color: isDanger ? Colors.red : Colors.blueAccent,
          size: 28,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDanger ? Colors.red : Colors.black87,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: isDanger ? Colors.red.shade600 : Colors.grey.shade600,
          ),
        ),
        trailing: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.chevron_right, color: Colors.grey),
        onTap: _isLoading ? null : onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Keluar Akun"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.logout,
              size: 50,
              color: Colors.blueAccent,
            ),
            const SizedBox(height: 16),
            const Text(
              "Anda akan keluar dari akun ini. Login kembali untuk mengakses aplikasi.",
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: _isLoading
                ? null
                : () {
                    Navigator.pop(context); // Tutup dialog konfirmasi
                    _performLogout(context);
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
            ),
            child: const Text("Keluar"),
          ),
        ],
      ),
    );
  }

  Future<void> _performLogout(BuildContext context) async {
    setState(() => _isLoading = true);

    try {
      // Gunakan AuthHelper untuk logout
      await AuthHelper.logout();

      // **PERBAIKAN: Navigasi ke LoginScreen dengan MaterialPageRoute**
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );

      if (kDebugMode) {
        print(' Logout berhasil');
      }

    } catch (e) {
      // Gunakan debug mode untuk print
      if (kDebugMode) {
        print(" Error saat logout: $e");
      }
      
      // **Fallback: Coba cara lain untuk navigasi**
      try {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      } catch (e2) {
        if (kDebugMode) {
          print(" Fallback juga gagal: $e2");
        }
      }
      
      // Tampilkan pesan error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Terjadi kesalahan saat logout: ${e.toString()}"),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showDeleteAccountConfirmation(BuildContext context) {
    final userEmail = FirebaseAuth.instance.currentUser?.email ?? "akun Anda";
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Akun Permanen"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.warning_amber,
              size: 60,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              "PERINGATAN!",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Tindakan ini akan menghapus semua data akun Anda secara permanen, termasuk:",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("• Data profil dan informasi pribadi"),
                  const Text("• Riwayat aktivitas"),
                  const Text("• Semua data yang tersimpan"),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              "Email yang akan dihapus:",
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            Text(
              userEmail,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: _isLoading
                ? null
                : () {
                    Navigator.pop(context);
                    _showFinalDeleteConfirmation(context);
                  },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Lanjutkan"),
          ),
        ],
      ),
    );
  }

  void _showFinalDeleteConfirmation(BuildContext context) {
    String confirmText = "";
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          bool canDelete = confirmText.toUpperCase() == "HAPUS";
          
          return AlertDialog(
            title: const Text("Konfirmasi Terakhir"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 60,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Apakah Anda benar-benar yakin?",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                const Text(
                  "Tindakan ini TIDAK DAPAT DIBATALKAN! Semua data akan dihapus selamanya.",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Ketik 'HAPUS' untuk konfirmasi",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.warning, color: Colors.red),
                  ),
                  onChanged: (value) {
                    setState(() {
                      confirmText = value;
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: _isLoading ? null : () => Navigator.pop(context),
                child: const Text("Tidak, Batal"),
              ),
              ElevatedButton(
                onPressed: (_isLoading || !canDelete)
                    ? null
                    : () {
                        Navigator.pop(context);
                        _performAccountDeletion(context);
                      },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("Ya, Hapus Permanen"),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _performAccountDeletion(BuildContext context) async {
    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      
      if (user != null) {
        // Hapus akun dari Firebase
        await user.delete();
        
        // **PERBAIKAN: Juga logout setelah hapus akun**
        await FirebaseAuth.instance.signOut();
      }

      // **PERBAIKAN: Navigasi ke LoginScreen dengan MaterialPageRoute**
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );

      // Tampilkan notifikasi berhasil
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Akun berhasil dihapus permanen"),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );
      
      if (kDebugMode) {
        print(' Akun berhasil dihapus permanen');
      }
      
    } on FirebaseAuthException catch (e) {
      setState(() => _isLoading = false);
      
      String errorMessage = "Gagal menghapus akun";
      
      if (e.code == 'requires-recent-login') {
        errorMessage = "Untuk menghapus akun, Anda perlu login ulang terlebih dahulu. Silakan logout dan login kembali, lalu coba hapus akun.";
        
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Perlu Login Ulang"),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"),
              ),
            ],
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("$errorMessage: ${e.message}"),
            backgroundColor: Colors.red,
          ),
        );
      }
      
      if (kDebugMode) {
        print('FirebaseAuthException: ${e.code} - ${e.message}');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Terjadi kesalahan: ${e.toString()}"),
          backgroundColor: Colors.red,
        ),
      );
      
      if (kDebugMode) {
        print(' Error saat menghapus akun: $e');
      }
    }
  }
}

// import 'package:flutter/material.dart';

// class KeluarPage extends StatefulWidget {
//   const KeluarPage({super.key});

//   @override
//   State<KeluarPage> createState() => _KeluarPageState();
// }

// class _KeluarPageState extends State<KeluarPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Keluar Akun"),
//         backgroundColor: Colors.blueAccent,
//         centerTitle: true,
//       ),
//       body: Container(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Icon Perhatian
//             const Icon(
//               Icons.warning,
//               size: 100,
//               color: Colors.orange,
//             ),
//             const SizedBox(height: 20),

//             // Pesan Konfirmasi
//             const Text(
//               "Apakah Anda yakin ingin keluar?",
//               style: TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black87,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 16),

//             Text(
//               "Anda akan keluar dari akun ini dan perlu login kembali untuk mengakses aplikasi",
//               style: TextStyle(
//                 fontSize: 16,
//                 color: Colors.grey.shade600,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 32),

//             // Pilihan Keluar
//             Column(
//               children: [
//                 // Keluar Akun
//                 _buildLogoutOption(
//                   icon: Icons.logout,
//                   title: "Keluar Akun",
//                   subtitle: "Hanya logout dari aplikasi ini",
//                   onTap: () {
//                     _showLogoutConfirmation(context, type: "logout");
//                   },
//                 ),
//                 const SizedBox(height: 16),

//                 // Keluar dari Semua Perangkat
//                 _buildLogoutOption(
//                   icon: Icons.devices,
//                   title: "Keluar dari Semua Perangkat",
//                   subtitle: "Logout dari semua perangkat yang terhubung",
//                   onTap: () {
//                     _showLogoutConfirmation(context, type: "all_devices");
//                   },
//                 ),
//                 const SizedBox(height: 16),

//                 // Hapus Akun
//                 _buildLogoutOption(
//                   icon: Icons.delete_forever,
//                   title: "Hapus Akun Permanen",
//                   subtitle: "Hapus semua data akun Anda",
//                   isDanger: true,
//                   onTap: () {
//                     _showDeleteAccountConfirmation(context);
//                   },
//                 ),
//               ],
//             ),

//             const SizedBox(height: 40),

//             // Tombol Batal
//             SizedBox(
//               width: double.infinity,
//               child: OutlinedButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                 },
//                 style: OutlinedButton.styleFrom(
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   side: BorderSide(color: Colors.grey.shade400),
//                 ),
//                 child: const Text(
//                   "Batal",
//                   style: TextStyle(fontSize: 16),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildLogoutOption({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required VoidCallback onTap,
//     bool isDanger = false,
//   }) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//         side: BorderSide(
//           color: isDanger ? Colors.red.shade100 : Colors.grey.shade200,
//           width: 1,
//         ),
//       ),
//       color: isDanger ? Colors.red.shade50 : Colors.white,
//       child: ListTile(
//         leading: Icon(
//           icon,
//           color: isDanger ? Colors.red : Colors.blueAccent,
//           size: 28,
//         ),
//         title: Text(
//           title,
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//             color: isDanger ? Colors.red : Colors.black87,
//           ),
//         ),
//         subtitle: Text(
//           subtitle,
//           style: TextStyle(
//             fontSize: 12,
//             color: isDanger ? Colors.red.shade600 : Colors.grey.shade600,
//           ),
//         ),
//         trailing: const Icon(Icons.chevron_right, color: Colors.grey),
//         onTap: onTap,
//         contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       ),
//     );
//   }

//   void _showLogoutConfirmation(BuildContext context, {required String type}) {
//     String message = type == "logout"
//         ? "Anda akan keluar dari akun ini. Login kembali untuk mengakses aplikasi."
//         : "Anda akan keluar dari semua perangkat yang terhubung ke akun ini. Anda perlu login ulang di setiap perangkat.";

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text(
//           type == "logout" ? "Keluar Akun" : "Keluar dari Semua Perangkat",
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Icon(
//               type == "logout" ? Icons.logout : Icons.devices,
//               size: 50,
//               color: Colors.blueAccent,
//             ),
//             const SizedBox(height: 16),
//             Text(
//               message,
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Batal"),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               _performLogout(context, type: type);
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: type == "logout" ? Colors.blueAccent : Colors.orange,
//             ),
//             child: Text(type == "logout" ? "Keluar" : "Keluar Semua"),
//           ),
//         ],
//       ),
//     );
//   }

//   void _performLogout(BuildContext context, {required String type}) {
//     // Simulasi proses logout
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(
//           type == "logout"
//               ? "Berhasil logout dari akun"
//               : "Berhasil logout dari semua perangkat",
//         ),
//         backgroundColor: Colors.green,
//       ),
//     );

//     // Delay sebelum kembali ke login
//     Future.delayed(const Duration(seconds: 2), () {
//       // Navigasi ke halaman login
//       Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
//     });
//   }

//   void _showDeleteAccountConfirmation(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Hapus Akun Permanen"),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Icon(
//               Icons.warning_amber,
//               size: 60,
//               color: Colors.red,
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               "PERINGATAN!",
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.red,
//               ),
//             ),
//             const SizedBox(height: 12),
//             const Text(
//               "Tindakan ini akan menghapus semua data akun Anda secara permanen, termasuk:",
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 8),
//             Padding(
//               padding: const EdgeInsets.only(left: 16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text("• Riwayat absensi"),
//                   const Text("• Data gaji dan tunjangan"),
//                   const Text("• Pengajuan izin dan lembur"),
//                   const Text("• Semua informasi pribadi"),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),
//             TextFormField(
//               decoration: const InputDecoration(
//                 labelText: "Ketik 'DELETE' untuk konfirmasi",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Batal"),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               _showFinalDeleteConfirmation(context);
//             },
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             child: const Text("Hapus Akun"),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showFinalDeleteConfirmation(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Konfirmasi Terakhir"),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Icon(
//               Icons.error_outline,
//               size: 60,
//               color: Colors.red,
//             ),
//             const SizedBox(height: 16),
//             const Text(
//               "Apakah Anda benar-benar yakin?",
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.red,
//               ),
//               textAlign: TextAlign.center,
//             ),
//             const SizedBox(height: 12),
//             const Text(
//               "Tindakan ini TIDAK DAPAT DIBATALKAN! Semua data akan dihapus selamanya.",
//               textAlign: TextAlign.center,
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Tidak, Batal"),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               _performAccountDeletion(context);
//             },
//             style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//             child: const Text("Ya, Hapus Permanen"),
//           ),
//         ],
//       ),
//     );
//   }

//   void _performAccountDeletion(BuildContext context) {
//     // Simulasi proses penghapusan akun
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text("Permintaan penghapusan akun telah dikirim"),
//         backgroundColor: Colors.red,
//         duration: Duration(seconds: 3),
//       ),
//     );

//     // Delay sebelum kembali ke register
//     Future.delayed(const Duration(seconds: 3), () {
//       // Navigasi ke halaman register/login
//       Navigator.pushNamedAndRemoveUntil(context, '/register', (route) => false);
//     });
//   }
// }