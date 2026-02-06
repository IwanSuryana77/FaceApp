import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'face_verification_page.dart';

const primaryPurple = Color(0xFF3F7DF4);

class AbsensiDashboardPage extends StatelessWidget {
  final String userId;
  const AbsensiDashboardPage({required this.userId, super.key});

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    String todayKey = DateFormat('yyyy-MM-dd').format(today);
    Stream<DocumentSnapshot> todayAbsenceStream = FirebaseFirestore.instance
        .collection('absensi')
        .doc(userId)
        .collection('hari')
        .doc(todayKey)
        .snapshots();

    return Scaffold(
      backgroundColor: Color(0xFFF7F8FA),
      appBar: AppBar(
        title: const Text('Absensi'),
        backgroundColor: primaryPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(19),
        children: [
          Text(
            "Ketuk tombol untuk absen masuk atau pulang.",
            style: TextStyle(fontSize: 15.2, color: Colors.grey[800]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 13),
          // Card waktu & tombol absen
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            color: Colors.white,
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 19, horizontal: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(today),
                    style: const TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 10),
                  StreamBuilder<DateTime>(
                    stream: Stream.periodic(
                      const Duration(seconds: 1),
                      (_) => DateTime.now(),
                    ),
                    builder: (context, snapshot) => Text(
                      DateFormat(
                        'HH:mm:ss',
                      ).format(snapshot.data ?? DateTime.now()),
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: primaryPurple,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Jam Normal: 08:00 - 17:00',
                    style: TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                  const SizedBox(height: 13),

                  StreamBuilder<DocumentSnapshot>(
                    stream: todayAbsenceStream,
                    builder: (ctx, snap) {
                      final data =
                          snap.data?.data() as Map<String, dynamic>? ?? {};
                      final checkIn = data['checkIn'];
                      final checkOut = data['checkOut'];
                      return Row(
                        children: [
                          Expanded(
                            child: AbsButton(
                              label: 'Jam Masuk',
                              filled: checkIn == null,
                              onTap: checkIn == null
                                  ? () async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => FaceVerificationPage(
                                            userId: userId,
                                            isCheckOut: false,
                                            today: today, userName: '',
                                          ),
                                        ),
                                      );
                                    }
                                  : null,
                              info: checkIn == null
                                  ? 'Belum Absen'
                                  : 'Sudah Absen',
                            ),
                          ),
                          const SizedBox(width: 13),
                          Expanded(
                            child: AbsButton(
                              label: 'Jam Pulang',
                              filled: checkOut == null,
                              onTap: checkOut == null
                                  ? () async {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => FaceVerificationPage(
                                            userId: userId,
                                            isCheckOut: true,
                                            today: today, userName: '',
                                          ),
                                        ),
                                      );
                                    }
                                  : null,
                              info: checkOut == null
                                  ? 'Belum Absen'
                                  : 'Sudah Pulang',
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // Statistik dan riwayat absen (tambahkan sesuai kebutuhan)
        ],
      ),
    );
  }
}

class AbsButton extends StatelessWidget {
  final String label;
  final bool filled;
  final VoidCallback? onTap;
  final String info;
  const AbsButton({
    required this.label,
    required this.filled,
    this.onTap,
    this.info = '',
  });
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: filled ? primaryPurple : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
        side: filled
            ? null
            : const BorderSide(color: primaryPurple, width: 1.25),
        padding: const EdgeInsets.symmetric(vertical: 18),
      ),
      onPressed: onTap,
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: filled ? Colors.white : primaryPurple,
            ),
          ),
          Text(
            info,
            style: TextStyle(
              fontSize: 13,
              color: filled ? Colors.white : primaryPurple,
            ),
          ),
        ],
      ),
    );
  }
}
