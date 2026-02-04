import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class InboxPage extends StatelessWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Simulasi daftar pesan masuk
    final List<_MessageInbox> messages = [
      _MessageInbox(
        title: "Pesan Baru dari Admin",
        desc:
            "Hai, ada informasi penting mengenai akun Anda. Mohon segera periksa pesan sebelum jatuh tempo.",
        icon: Icons.mail_outline,
        isImportant: true,
        isUnread: true,
        time: "5 menit yang lalu",
      ),
      _MessageInbox(
        title: "Promo Spesial Minggu Ini",
        desc:
            "Dapatkan diskon 20% untuk semua produk kepegawaian tahun. Promo berlaku hingga 1 minggu lagi.",
        icon: Icons.local_offer_outlined,
        isUnread: true,
        time: "1 jam yang lalu",
      ),
      _MessageInbox(
        title: "Pemeliharaan Sistem Terjadwal",
        desc: "Akan ada pemeliharaan perangkat antara 15 Agustus pukul 01:00.",
        icon: Icons.schedule_rounded,
        isInfo: true,
        time: "3 jam yang lalu",
      ),
      _MessageInbox(
        title: "Saldo Akun Anda Rendah",
        desc: "Saldo akun Anda di bawah batas minimum. Segera lakukan top up.",
        icon: Icons.error_outline,
        isWarning: true,
        time: "5 jam yang lalu",
      ),
      _MessageInbox(
        title: "Konfirmasi Pesanan #123456",
        desc:
            "Pesanan Anda dengan nomor #123456 sudah dikonfirmasi, silahkan cek detail di riwayat.",
        icon: Icons.receipt_long_rounded,
        time: "Kemarin",
      ),
      _MessageInbox(
        title: "Balasan Komentar Anda",
        desc: "Admin kami telah membalas komentar Anda di forum kepegawaian.",
        icon: Icons.reply_rounded,
        isUnread: true,
        time: "2 hari yang lalu",
      ),
      _MessageInbox(
        title: "Penawaran Eksklusif untuk Anda!",
        desc:
            "Nikmati penawaran khusus untuk akun anda, klik untuk melihat promo terbaru.",
        icon: Icons.volunteer_activism,
        time: "2 hari yang lalu",
      ),
      _MessageInbox(
        title: "Pembaruan Kebijakan Privasi",
        desc:
            "Kami telah memperbarui kebijakan privasi kami. Mohon baca untuk mengetahui info baru.",
        icon: Icons.privacy_tip_outlined,
        time: "4 hari yang lalu",
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.extraLight,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF3F7DF4),
        automaticallyImplyLeading: false,
        // Back button otomatis
        centerTitle: true,
        title: const Text(
          'Kotak Masuk',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 19,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.inbox_rounded,
              color: AppColors.primary,
              size: 27,
            ),
            tooltip: "Inbox",
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: messages.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.inbox_rounded,
                        size: 50,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Inbox Kosong',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppColors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Anda tidak memiliki pesan saat ini',
                      style: TextStyle(fontSize: 14, color: AppColors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            : ListView.separated(
                padding: const EdgeInsets.symmetric(
                  horizontal: 13,
                  vertical: 8,
                ),
                itemCount: messages.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, i) {
                  final msg = messages[i];
                  Color border = Colors.transparent,
                      iconClr = AppColors.primary;
                  if (msg.isUnread) border = AppColors.primary.withOpacity(.19);
                  if (msg.isWarning) iconClr = Colors.redAccent;
                  if (msg.isInfo) iconClr = Colors.orange;
                  if (msg.isImportant) iconClr = Colors.purple;
                  return Material(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    elevation: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: border, width: 2),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.04),
                            blurRadius: 9,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.primaryLight,
                              radius: 23,
                              child: Icon(msg.icon, color: iconClr, size: 26),
                            ),
                            if (msg.isUnread)
                              const Positioned(
                                right: -2,
                                top: -2,
                                child: CircleAvatar(
                                  radius: 8,
                                  backgroundColor: Colors.white,
                                  child: CircleAvatar(
                                    radius: 6,
                                    backgroundColor: Color(0xFF3F7DF4),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        title: Text(
                          msg.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppColors.black,
                            fontWeight: msg.isUnread
                                ? FontWeight.bold
                                : FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              msg.desc,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.black.withOpacity(0.75),
                                fontSize: 13.6,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                if (msg.isWarning)
                                  const Icon(
                                    Icons.error_outline,
                                    color: Colors.redAccent,
                                    size: 16,
                                  ),
                                Text(
                                  msg.time,
                                  style: TextStyle(
                                    color: AppColors.grey,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 12.7,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: null,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 9,
                          horizontal: 11,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        onTap: () {}, // Atur ke detail jika diperlukan
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class _MessageInbox {
  final String title;
  final String desc;
  final IconData icon;
  final String time;
  final bool isUnread;
  final bool isImportant;
  final bool isWarning;
  final bool isInfo;
  const _MessageInbox({
    required this.title,
    required this.desc,
    required this.icon,
    required this.time,
    this.isUnread = false,
    this.isImportant = false,
    this.isWarning = false,
    this.isInfo = false,
  });
}

// import 'package:flutter/material.dart';
// import '../../theme/app_theme.dart';

// class InboxPage extends StatelessWidget {
//   const InboxPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.extraLight,
//       appBar: AppBar(
//         title: const Text('Pesan Masuk'),
//         backgroundColor: AppColors.primary,
//         elevation: 0,
//       ),
//       body: SafeArea(
//         child: ListView(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//           children: [
//             // Header Card
//             Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     AppColors.primary,
//                     AppColors.primary.withOpacity(0.7),
//                   ],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: BorderRadius.circular(16),
//                 boxShadow: [
//                   BoxShadow(
//                     color: AppColors.primary.withOpacity(0.2),
//                     blurRadius: 12,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Icon(
//                     Icons.mail_outline_rounded,
//                     size: 32,
//                     color: Colors.white,
//                   ),
//                   const SizedBox(height: 12),
//                   const Text(
//                     'Inbox Anda',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   const Text(
//                     'Tidak ada pesan baru saat ini',
//                     style: TextStyle(fontSize: 14, color: Colors.white70),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 24),
//             // Empty State
//             Center(
//               child: Column(
//                 children: [
//                   Container(
//                     width: 100,
//                     height: 100,
//                     decoration: BoxDecoration(
//                       color: AppColors.primaryLight,
//                       shape: BoxShape.circle,
//                     ),
//                     child: const Icon(
//                       Icons.inbox_rounded,
//                       size: 50,
//                       color: AppColors.primary,
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   const Text(
//                     'Inbox Kosong',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.w600,
//                       color: AppColors.black,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   const Text(
//                     'Anda tidak memiliki pesan saat ini',
//                     style: TextStyle(fontSize: 14, color: AppColors.grey),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
