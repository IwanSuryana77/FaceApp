import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

import 'package:peresenceapp/screens/home/clockin_page.dart';

const primaryPurple =  Color(0xFF3F7DF4);

class AbsensiDashboardPage extends StatefulWidget {
  final String userId;
  const AbsensiDashboardPage({required this.userId, super.key});

  @override
  State<AbsensiDashboardPage> createState() => _AbsensiDashboardPageState();
}

class _AbsensiDashboardPageState extends State<AbsensiDashboardPage> {
  // Untuk jam real time digital
  late Timer _timer;
  String _timeNow = DateFormat('HH.mm.ss').format(DateTime.now());
  DateTime _today = DateTime.now();

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() => _timeNow = DateFormat('HH.mm.ss').format(DateTime.now()));
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // Get status absen hari ini dari Firebase
  Stream<DocumentSnapshot> getTodayAbsence() {
    final todayKey = DateFormat('yyyy-MM-dd').format(_today);
    return FirebaseFirestore.instance
        .collection('absensi')
        .doc(widget.userId)
        .collection('hari')
        .doc(todayKey)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hadir'),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color:  Color(0xFF3F7DF4)),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          // Kartu jam digital & status absen
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(_today),
                  style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _timeNow,
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color:  Color(0xFF3F7DF4),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Jam Normal: 08:00 - 17:00',
                  style: TextStyle(color: Colors.black54),
                ),
                // Status hari ini
                StreamBuilder<DocumentSnapshot>(
                  stream: getTodayAbsence(),
                  builder: (ctx, snap) {
                    final data =
                        snap.data?.data() as Map<String, dynamic>? ?? {};
                    final checkIn = data['checkIn'] as Map<String, dynamic>?;
                    final checkOut = data['checkOut'] as Map<String, dynamic>?;
                    return Row(
                      children: [
                        Expanded(
                          child: AbsenceButton(
                            label: 'Jam Masuk',
                            filled: checkIn == null,
                            onTap: checkIn == null
                                ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ClockInPage(
                                          userId: widget.userId,
                                          isCheckOut: false,
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
                        const SizedBox(width: 8),
                        Expanded(
                          child: AbsenceButton(
                            label: 'Jam Pulang',
                            filled: checkOut == null,
                            onTap: checkOut == null
                                ? () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ClockInPage(
                                          userId: widget.userId,
                                          isCheckOut: true,
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

          // Statistik harian
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Statistik Harian',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text('Total Jam Kerja: 0 Jam'),
                const SizedBox(height: 2),
                Text('Status Hari Ini: Tidak Ada Data'),
              ],
            ),
          ),

          // Riwayat hari ini
          const SizedBox(height: 16),
          Text(
            'Riwayat Hari Ini',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          StreamBuilder<DocumentSnapshot>(
            stream: getTodayAbsence(),
            builder: (ctx, snap) {
              final data = snap.data?.data() as Map<String, dynamic>? ?? {};
              final checkIn = data['checkIn'] as Map<String, dynamic>?;
              final checkOut = data['checkOut'] as Map<String, dynamic>?;
              return Column(
                children: [
                  if (checkIn != null) ...[
                    _AbsenceHistoryCard(
                      title: 'Check-in',
                      icon: Icons.login_rounded,
                      time: checkIn['waktu'],
                      lokasi: checkIn['lokasi'],
                      note: checkIn['catatan'] ?? '-',
                    ),
                  ],
                  if (checkOut != null) ...[
                    _AbsenceHistoryCard(
                      title: 'Check-out',
                      icon: Icons.logout_rounded,
                      time: checkOut['waktu'],
                      lokasi: checkOut['lokasi'],
                      note: checkOut['catatan'] ?? '-',
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

// Tombol absen modern
class AbsenceButton extends StatelessWidget {
  final String label;
  final bool filled;
  final VoidCallback? onTap;
  final String info;
  const AbsenceButton({
    required this.label,
    required this.filled,
    this.onTap,
    this.info = '',
  });
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: filled ?  Color(0xFF3F7DF4) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
        side: filled ? null : BorderSide(color:  Color(0xFF3F7DF4), width: 1.1),
        padding: const EdgeInsets.symmetric(vertical: 20),
      ),
      onPressed: onTap,
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: filled ? Colors.white : Color(0xFF3F7DF4),
            ),
          ),
          Text(
            info,
            style: TextStyle(
              fontSize: 13,
              color: filled ? Colors.white :  Color(0xFF3F7DF4),
            ),
          ),
        ],
      ),
    );
  }
}

// Card riwayat
class _AbsenceHistoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? time;
  final String? lokasi;
  final String? note;
  const _AbsenceHistoryCard({
    required this.title,
    required this.icon,
    this.time,
    this.lokasi,
    this.note,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 7),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3)],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blueAccent, size: 31),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                Text(
                  time ?? '-',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Lokasi: ${lokasi ?? '-'}',
                  style: TextStyle(fontSize: 13),
                ),
                Text('Catatan: ${note ?? ''}', style: TextStyle(fontSize: 13)),
              ],
            ),
          ),
          Icon(Icons.refresh, size: 18),
        ],
      ),
    );
  }
}
