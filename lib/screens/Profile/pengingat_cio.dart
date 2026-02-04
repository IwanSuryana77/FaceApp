import 'package:flutter/material.dart';

class PengingatCIOPage extends StatefulWidget {
  const PengingatCIOPage({super.key});

  @override
  State<PengingatCIOPage> createState() => _PengingatCIOPageState();
}

class _PengingatCIOPageState extends State<PengingatCIOPage> {
  bool _reminderMasukAktif = true;
  bool _reminderPulangAktif = true;
  bool _reminderIstirahatAktif = false;
  bool _getarAktif = true;
  bool _suaraAktif = true;

  TimeOfDay _waktuReminderMasuk = const TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _waktuReminderPulang = const TimeOfDay(hour: 17, minute: 0);
  TimeOfDay _waktuReminderIstirahat = const TimeOfDay(hour: 12, minute: 0);

  Future<void> _pilihWaktu(
    BuildContext context,
    Function(TimeOfDay) onTimeSelected,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF7C3AED),
              onPrimary: Colors.white,
            ),
            buttonTheme: const ButtonThemeData(
              textTheme: ButtonTextTheme.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onTimeSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: [
          // HEADER MODERN, ANTI-TUMPANG-TINDIH
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: MediaQuery.of(context).padding.top + 24,
                bottom: 24,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF7C3AED),
                    Color(0xFF5B21B6),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Stack(
                children: [
                  // Pattern overlay
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.08,
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/pattern.png'),
                            repeat: ImageRepeat.repeat,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back button dan judul center
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back_ios_new_rounded,
                                color: Colors.white),
                            onPressed: () => Navigator.of(context).maybePop(),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                'Pengingat Absensi',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isSmallScreen ? 19 : 22,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: .2,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 8,
                                      color: Colors.black.withOpacity(0.15),
                                      offset: Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 46),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.14),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: EdgeInsets.all(14),
                            child: Icon(Icons.access_time_filled,
                                size: 34, color: Colors.white),
                          ),
                          SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Atur pengingat waktu absensi',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.96),
                                  fontSize: isSmallScreen ? 13 : 15,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // JARAK DARI HEADER KE CARD INTRO
          SliverToBoxAdapter(child: SizedBox(height: 12)),

          // INTI KONTEN
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20), // padding seluruh isi
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER CARD MENGAMBANG
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    margin: const EdgeInsets.only(bottom: 30),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.white, Color(0xFFF5F3FF)],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7C3AED).withOpacity(0.10),
                          blurRadius: 24,
                          spreadRadius: 2,
                          offset: const Offset(0, 6),
                        ),
                      ],
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF7C3AED).withOpacity(0.12),
                                const Color(0xFF5B21B6).withOpacity(0.10),
                              ],
                            ),
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.notifications_active_rounded,
                              size: 30,
                              color: Color(0xFF7C3AED),
                            ),
                          ),
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Pengingat Waktu Absensi',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Tetap ingat untuk absensi tepat waktu dengan pengingat yang sesuai',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                  height: 1.45,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // --------- JADWAL PENGINGAT ---------
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      'Jadwal Pengingat',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E293B),
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  _buildReminderCard(
                    title: 'Clock In',
                    subtitle: 'Pengingat untuk absensi masuk',
                    aktif: _reminderMasukAktif,
                    waktu: _waktuReminderMasuk,
                    onToggle: (value) {
                      setState(() {
                        _reminderMasukAktif = value;
                      });
                    },
                    onTimeTap: () {
                      _pilihWaktu(context, (time) {
                        setState(() {
                          _waktuReminderMasuk = time;
                        });
                      });
                    },
                    icon: Icons.login_rounded,
                    gradient: const [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                  ),
                  const SizedBox(height: 16),
                  _buildReminderCard(
                    title: 'Clock Out',
                    subtitle: 'Pengingat untuk absensi pulang',
                    aktif: _reminderPulangAktif,
                    waktu: _waktuReminderPulang,
                    onToggle: (value) {
                      setState(() {
                        _reminderPulangAktif = value;
                      });
                    },
                    onTimeTap: () {
                      _pilihWaktu(context, (time) {
                        setState(() {
                          _waktuReminderPulang = time;
                        });
                      });
                    },
                    icon: Icons.logout_rounded,
                    gradient: const [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                  ),
                  const SizedBox(height: 16),
                  _buildReminderCard(
                    title: 'Istirahat',
                    subtitle: 'Pengingat untuk istirahat makan siang',
                    aktif: _reminderIstirahatAktif,
                    waktu: _waktuReminderIstirahat,
                    onToggle: (value) {
                      setState(() {
                        _reminderIstirahatAktif = value;
                      });
                    },
                    onTimeTap: () {
                      _pilihWaktu(context, (time) {
                        setState(() {
                          _waktuReminderIstirahat = time;
                        });
                      });
                    },
                    icon: Icons.restaurant_rounded,
                    gradient: const [Color(0xFF10B981), Color(0xFF059669)],
                  ),
                  const SizedBox(height: 32),
                  // --------- PENGATURAN NOTIFIKASI ---------
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F3FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.settings_suggest_rounded,
                            size: 24,
                            color: Color(0xFF7C3AED),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Pengaturan Notifikasi',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1E293B),
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.white, Color(0xFFF8FAFC)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.10),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Column(
                      children: [
                        _buildNotificationSetting(
                          title: 'Getar',
                          subtitle: 'Aktifkan getar saat notifikasi',
                          value: _getarAktif,
                          onChanged: (value) {
                            setState(() {
                              _getarAktif = value;
                            });
                          },
                          icon: Icons.vibration_rounded,
                          color: const Color(0xFFF59E0B),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          child: Divider(
                            height: 1,
                            color: Colors.grey.shade200,
                          ),
                        ),
                        _buildNotificationSetting(
                          title: 'Suara',
                          subtitle: 'Aktifkan suara notifikasi',
                          value: _suaraAktif,
                          onChanged: (value) {
                            setState(() {
                              _suaraAktif = value;
                            });
                          },
                          icon: Icons.volume_up_rounded,
                          color: const Color(0xFF3B82F6),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  // --------- FREKUENSI PENGULANGAN ---------
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFFF5F3FF),
                          const Color(0xFFEDE9FE).withOpacity(0.5),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFDDD6FE),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF7C3AED).withOpacity(0.11),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.repeat_rounded,
                            size: 28,
                            color: Color(0xFF7C3AED),
                          ),
                        ),
                        const SizedBox(width: 17),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Frekuensi Pengulangan',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Notifikasi akan diulang setiap 5 menit sampai Anda melakukan absensi',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade700,
                                  height: 1.47,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  // --------- BUTTON SIMPAN ---------
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7C3AED).withOpacity(0.21),
                          blurRadius: 18,
                          spreadRadius: 1,
                          offset: const Offset(0, 7),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {});
                        Future.delayed(const Duration(milliseconds: 200), () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Expanded(
                                    child: Text(
                                      'Pengaturan pengingat berhasil disimpan',
                                      style: TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                              backgroundColor: const Color(0xFF10B981),
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              margin: const EdgeInsets.all(20),
                              elevation: 10,
                            ),
                          );
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF7C3AED),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.save_rounded, size: 22),
                          const SizedBox(width: 12),
                          const Text(
                            'Simpan Pengaturan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  // --------- INFO TAMBAHAN ---------
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '💡 Tips:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Aktifkan pengingat untuk memastikan Anda tidak lupa melakukan absensi tepat waktu.',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade700,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderCard({
    required String title,
    required String subtitle,
    required bool aktif,
    required TimeOfDay waktu,
    required Function(bool) onToggle,
    required VoidCallback onTimeTap,
    required IconData icon,
    required List<Color> gradient,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.white.withOpacity(0.9)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.10),
            blurRadius: 18,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.9),
            blurRadius: 9,
            spreadRadius: 1,
            offset: const Offset(-2, -2),
          ),
        ],
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: gradient,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: gradient[0].withOpacity(0.19),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Icon(icon, color: Colors.white, size: 24),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                Transform.scale(
                  scale: 1.2,
                  child: Switch.adaptive(
                    value: aktif,
                    onChanged: onToggle,
                    activeColor: gradient[0],
                    activeTrackColor: gradient[0].withOpacity(0.27),
                    inactiveThumbColor: Colors.grey.shade400,
                    inactiveTrackColor: Colors.grey.shade300,
                  ),
                ),
              ],
            ),
            if (aktif) ...[
              const SizedBox(height: 16),
              GestureDetector(
                onTap: onTimeTap,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        gradient[0].withOpacity(0.10),
                        gradient[1].withOpacity(0.06),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: gradient[0].withOpacity(0.20),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Waktu Pengingat',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${waktu.hour.toString().padLeft(2, '0')}:${waktu.minute.toString().padLeft(2, '0')}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: gradient[0],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: gradient[0].withOpacity(0.13),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.edit_calendar_rounded,
                          color: gradient[0],
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSetting({
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
    required IconData icon,
    required Color color,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: value ? color.withOpacity(0.06) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 22, color: color),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Transform.scale(
              scale: 1.1,
              child: Switch.adaptive(
                value: value,
                onChanged: onChanged,
                activeColor: color,
                activeTrackColor: color.withOpacity(0.23),
                inactiveThumbColor: Colors.grey.shade400,
                inactiveTrackColor: Colors.grey.shade300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// class PengingatCIOPage extends StatefulWidget {
//   const PengingatCIOPage({super.key});

//   @override
//   State<PengingatCIOPage> createState() => _PengingatCIOPageState();
// }

// class _PengingatCIOPageState extends State<PengingatCIOPage> {
//   bool _reminderMasukAktif = true;
//   bool _reminderPulangAktif = true;
//   bool _reminderIstirahatAktif = false;
//   bool _getarAktif = true;
//   bool _suaraAktif = true;

//   TimeOfDay _waktuReminderMasuk = const TimeOfDay(hour: 8, minute: 0);
//   TimeOfDay _waktuReminderPulang = const TimeOfDay(hour: 17, minute: 0);
//   TimeOfDay _waktuReminderIstirahat = const TimeOfDay(hour: 12, minute: 0);

//   Future<void> _pilihWaktu(
//     BuildContext context,
//     Function(TimeOfDay) onTimeSelected,
//   ) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//       builder: (context, child) {
//         return Theme(
//           data: ThemeData.light().copyWith(
//             colorScheme: const ColorScheme.light(
//               primary: Color(0xFF7C3AED),
//               onPrimary: Colors.white,
//             ),
//             buttonTheme: const ButtonThemeData(
//               textTheme: ButtonTextTheme.primary,
//             ),
//           ),
//           child: child!,
//         );
//       },
//     );

//     if (picked != null) {
//       onTimeSelected(picked);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isSmallScreen = screenWidth < 360;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC),
//       body: CustomScrollView(
//         slivers: [
//           // AppBar dengan efek blur dan gradient
//           SliverAppBar(
//             expandedHeight: 150,
//             floating: false,
//             pinned: true,
//             flexibleSpace: FlexibleSpaceBar(
//               title: Text(
//                 'Pengingat Absensi',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: isSmallScreen ? 18 : 20,
//                   fontWeight: FontWeight.bold,
//                   shadows: [
//                     Shadow(
//                       blurRadius: 4,
//                       color: Colors.black.withOpacity(0.3),
//                       offset: const Offset(1, 1),
//                     ),
//                   ],
//                 ),
//               ),
//               centerTitle: true,
//               background: Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [const Color(0xFF7C3AED), const Color(0xFF5B21B6)],
//                   ),
//                 ),
//                 child: Stack(
//                   children: [
//                     // Pattern overlay
//                     Positioned.fill(
//                       child: Opacity(
//                         opacity: 0.1,
//                         child: Container(
//                           decoration: const BoxDecoration(
//                             image: DecorationImage(
//                               image: AssetImage(
//                                 'assets/images/pattern.png',
//                               ), // Ganti dengan pattern Anda
//                               repeat: ImageRepeat.repeat,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     // Content
//                     Padding(
//                       padding: const EdgeInsets.all(20),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Icon(
//                             Icons.access_time_filled,
//                             size: 40,
//                             color: Colors.white,
//                           ),
//                           const SizedBox(height: 10),
//                           Text(
//                             'Atur pengingat waktu absensi',
//                             style: TextStyle(
//                               color: Colors.white.withOpacity(0.9),
//                               fontSize: 14,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),

//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Header Card
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.all(24),
//                     margin: const EdgeInsets.only(bottom: 30),
//                     decoration: BoxDecoration(
//                       gradient: const LinearGradient(
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                         colors: [Colors.white, Color(0xFFF5F3FF)],
//                       ),
//                       borderRadius: BorderRadius.circular(24),
//                       boxShadow: [
//                         BoxShadow(
//                           color: const Color(0xFF7C3AED).withOpacity(0.1),
//                           blurRadius: 25,
//                           spreadRadius: 2,
//                           offset: const Offset(0, 8),
//                         ),
//                       ],
//                       border: Border.all(color: Colors.white, width: 2),
//                     ),
//                     child: Row(
//                       children: [
//                         Container(
//                           width: 60,
//                           height: 60,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             gradient: LinearGradient(
//                               colors: [
//                                 const Color(0xFF7C3AED).withOpacity(0.1),
//                                 const Color(0xFF5B21B6).withOpacity(0.1),
//                               ],
//                             ),
//                           ),
//                           child: const Center(
//                             child: Icon(
//                               Icons.notifications_active_rounded,
//                               size: 30,
//                               color: Color(0xFF7C3AED),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(width: 20),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text(
//                                 'Pengingat Waktu Absensi',
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   color: Color(0xFF1E293B),
//                                 ),
//                               ),
//                               const SizedBox(height: 8),
//                               Text(
//                                 'Tetap ingat untuk absensi tepat waktu dengan pengingat yang sesuai',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.grey.shade600,
//                                   height: 1.4,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   // Judul Section
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 16),
//                     child: Text(
//                       'Jadwal Pengingat',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         color: const Color(0xFF1E293B),
//                         letterSpacing: -0.5,
//                       ),
//                     ),
//                   ),

//                   // Pengingat Clock In
//                   _buildReminderCard(
//                     title: 'Clock In',
//                     subtitle: 'Pengingat untuk absensi masuk',
//                     aktif: _reminderMasukAktif,
//                     waktu: _waktuReminderMasuk,
//                     onToggle: (value) {
//                       setState(() {
//                         _reminderMasukAktif = value;
//                       });
//                     },
//                     onTimeTap: () {
//                       _pilihWaktu(context, (time) {
//                         setState(() {
//                           _waktuReminderMasuk = time;
//                         });
//                       });
//                     },
//                     icon: Icons.login_rounded,
//                     gradient: const [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
//                   ),

//                   const SizedBox(height: 16),

//                   // Pengingat Clock Out
//                   _buildReminderCard(
//                     title: 'Clock Out',
//                     subtitle: 'Pengingat untuk absensi pulang',
//                     aktif: _reminderPulangAktif,
//                     waktu: _waktuReminderPulang,
//                     onToggle: (value) {
//                       setState(() {
//                         _reminderPulangAktif = value;
//                       });
//                     },
//                     onTimeTap: () {
//                       _pilihWaktu(context, (time) {
//                         setState(() {
//                           _waktuReminderPulang = time;
//                         });
//                       });
//                     },
//                     icon: Icons.logout_rounded,
//                     gradient: const [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
//                   ),

//                   const SizedBox(height: 16),

//                   // Pengingat Istirahat
//                   _buildReminderCard(
//                     title: 'Istirahat',
//                     subtitle: 'Pengingat untuk istirahat makan siang',
//                     aktif: _reminderIstirahatAktif,
//                     waktu: _waktuReminderIstirahat,
//                     onToggle: (value) {
//                       setState(() {
//                         _reminderIstirahatAktif = value;
//                       });
//                     },
//                     onTimeTap: () {
//                       _pilihWaktu(context, (time) {
//                         setState(() {
//                           _waktuReminderIstirahat = time;
//                         });
//                       });
//                     },
//                     icon: Icons.restaurant_rounded,
//                     gradient: const [Color(0xFF10B981), Color(0xFF059669)],
//                   ),

//                   const SizedBox(height: 32),

//                   // Pengaturan Notifikasi
//                   Padding(
//                     padding: const EdgeInsets.only(bottom: 16),
//                     child: Row(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(8),
//                           decoration: BoxDecoration(
//                             color: const Color(0xFFF5F3FF),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: const Icon(
//                             Icons.settings_suggest_rounded,
//                             size: 24,
//                             color: Color(0xFF7C3AED),
//                           ),
//                         ),
//                         const SizedBox(width: 12),
//                         Text(
//                           'Pengaturan Notifikasi',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: const Color(0xFF1E293B),
//                             letterSpacing: -0.5,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   Container(
//                     padding: const EdgeInsets.all(24),
//                     decoration: BoxDecoration(
//                       gradient: const LinearGradient(
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                         colors: [Colors.white, Color(0xFFF8FAFC)],
//                       ),
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.1),
//                           blurRadius: 20,
//                           spreadRadius: 2,
//                         ),
//                       ],
//                       border: Border.all(color: Colors.white, width: 2),
//                     ),
//                     child: Column(
//                       children: [
//                         _buildNotificationSetting(
//                           title: 'Getar',
//                           subtitle: 'Aktifkan getar saat notifikasi',
//                           value: _getarAktif,
//                           onChanged: (value) {
//                             setState(() {
//                               _getarAktif = value;
//                             });
//                           },
//                           icon: Icons.vibration_rounded,
//                           color: const Color(0xFFF59E0B),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                           child: Divider(
//                             height: 1,
//                             color: Colors.grey.shade200,
//                           ),
//                         ),
//                         _buildNotificationSetting(
//                           title: 'Suara',
//                           subtitle: 'Aktifkan suara notifikasi',
//                           value: _suaraAktif,
//                           onChanged: (value) {
//                             setState(() {
//                               _suaraAktif = value;
//                             });
//                           },
//                           icon: Icons.volume_up_rounded,
//                           color: const Color(0xFF3B82F6),
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 32),

//                   // Frekuensi Pengulangan
//                   Container(
//                     padding: const EdgeInsets.all(24),
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                         colors: [
//                           const Color(0xFFF5F3FF),
//                           const Color(0xFFEDE9FE).withOpacity(0.5),
//                         ],
//                       ),
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(
//                         color: const Color(0xFFDDD6FE),
//                         width: 1,
//                       ),
//                     ),
//                     child: Row(
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             color: const Color(0xFF7C3AED).withOpacity(0.1),
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           child: const Icon(
//                             Icons.repeat_rounded,
//                             size: 28,
//                             color: Color(0xFF7C3AED),
//                           ),
//                         ),
//                         const SizedBox(width: 16),
//                         Expanded(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Text(
//                                 'Frekuensi Pengulangan',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16,
//                                   color: Color(0xFF1E293B),
//                                 ),
//                               ),
//                               const SizedBox(height: 6),
//                               Text(
//                                 'Notifikasi akan diulang setiap 5 menit sampai Anda melakukan absensi',
//                                 style: TextStyle(
//                                   fontSize: 14,
//                                   color: Colors.grey.shade700,
//                                   height: 1.5,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 40),

//                   // Tombol Simpan
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [
//                         BoxShadow(
//                           color: const Color(0xFF7C3AED).withOpacity(0.3),
//                           blurRadius: 20,
//                           spreadRadius: 3,
//                           offset: const Offset(0, 8),
//                         ),
//                       ],
//                     ),
//                     child: ElevatedButton(
//                       onPressed: () {
//                         // Animasi feedback
//                         setState(() {});
//                         Future.delayed(const Duration(milliseconds: 200), () {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Row(
//                                 children: [
//                                   Container(
//                                     padding: const EdgeInsets.all(6),
//                                     decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius: BorderRadius.circular(20),
//                                     ),
//                                     child: const Icon(
//                                       Icons.check_circle,
//                                       color: Colors.green,
//                                       size: 20,
//                                     ),
//                                   ),
//                                   const SizedBox(width: 12),
//                                   const Expanded(
//                                     child: Text(
//                                       'Pengaturan pengingat berhasil disimpan',
//                                       style: TextStyle(fontSize: 14),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               backgroundColor: const Color(0xFF10B981),
//                               behavior: SnackBarBehavior.floating,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               margin: const EdgeInsets.all(20),
//                               elevation: 10,
//                             ),
//                           );
//                         });
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF7C3AED),
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(vertical: 18),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         elevation: 0,
//                         shadowColor: Colors.transparent,
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Icon(Icons.save_rounded, size: 22),
//                           const SizedBox(width: 12),
//                           const Text(
//                             'Simpan Pengaturan',
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 40),

//                   // Info tambahan
//                   Container(
//                     padding: const EdgeInsets.all(20),
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade50,
//                       borderRadius: BorderRadius.circular(16),
//                       border: Border.all(color: Colors.grey.shade200),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const Text(
//                           '💡 Tips:',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14,
//                             color: Color(0xFF1E293B),
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           'Aktifkan pengingat untuk memastikan Anda tidak lupa melakukan absensi tepat waktu.',
//                           style: TextStyle(
//                             fontSize: 13,
//                             color: Colors.grey.shade700,
//                             height: 1.5,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 60),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildReminderCard({
//     required String title,
//     required String subtitle,
//     required bool aktif,
//     required TimeOfDay waktu,
//     required Function(bool) onToggle,
//     required VoidCallback onTimeTap,
//     required IconData icon,
//     required List<Color> gradient,
//   }) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [Colors.white, Colors.white.withOpacity(0.9)],
//         ),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 20,
//             spreadRadius: 2,
//             offset: const Offset(0, 4),
//           ),
//           BoxShadow(
//             color: Colors.white.withOpacity(0.9),
//             blurRadius: 10,
//             spreadRadius: 2,
//             offset: const Offset(-2, -2),
//           ),
//         ],
//         border: Border.all(color: Colors.white, width: 2),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Container(
//                   width: 50,
//                   height: 50,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                       colors: gradient,
//                     ),
//                     borderRadius: BorderRadius.circular(12),
//                     boxShadow: [
//                       BoxShadow(
//                         color: gradient[0].withOpacity(0.3),
//                         blurRadius: 10,
//                         spreadRadius: 1,
//                       ),
//                     ],
//                   ),
//                   child: Center(
//                     child: Icon(icon, color: Colors.white, size: 24),
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         title,
//                         style: const TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF1E293B),
//                         ),
//                       ),
//                       const SizedBox(height: 4),
//                       Text(
//                         subtitle,
//                         style: TextStyle(
//                           fontSize: 13,
//                           color: Colors.grey.shade600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Transform.scale(
//                   scale: 1.2,
//                   child: Switch.adaptive(
//                     value: aktif,
//                     onChanged: onToggle,
//                     activeColor: gradient[0],
//                     activeTrackColor: gradient[0].withOpacity(0.3),
//                     inactiveThumbColor: Colors.grey.shade400,
//                     inactiveTrackColor: Colors.grey.shade300,
//                   ),
//                 ),
//               ],
//             ),
//             if (aktif) ...[
//               const SizedBox(height: 16),
//               GestureDetector(
//                 onTap: onTimeTap,
//                 child: Container(
//                   padding: const EdgeInsets.all(16),
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                       colors: [
//                         gradient[0].withOpacity(0.1),
//                         gradient[1].withOpacity(0.05),
//                       ],
//                     ),
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(
//                       color: gradient[0].withOpacity(0.2),
//                       width: 1,
//                     ),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Waktu Pengingat',
//                             style: TextStyle(
//                               fontSize: 14,
//                               color: Colors.grey.shade600,
//                             ),
//                           ),
//                           const SizedBox(height: 4),
//                           Text(
//                             '${waktu.hour.toString().padLeft(2, '0')}:${waktu.minute.toString().padLeft(2, '0')}',
//                             style: TextStyle(
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                               color: gradient[0],
//                             ),
//                           ),
//                         ],
//                       ),
//                       Container(
//                         padding: const EdgeInsets.all(8),
//                         decoration: BoxDecoration(
//                           color: gradient[0].withOpacity(0.1),
//                           shape: BoxShape.circle,
//                         ),
//                         child: Icon(
//                           Icons.edit_calendar_rounded,
//                           color: gradient[0],
//                           size: 22,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildNotificationSetting({
//     required String title,
//     required String subtitle,
//     required bool value,
//     required Function(bool) onChanged,
//     required IconData icon,
//     required Color color,
//   }) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       decoration: BoxDecoration(
//         color: value ? color.withOpacity(0.05) : Colors.transparent,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(8),
//         child: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: color.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Icon(icon, size: 22, color: color),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w600,
//                       color: const Color(0xFF1E293B),
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     subtitle,
//                     style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
//                   ),
//                 ],
//               ),
//             ),
//             Transform.scale(
//               scale: 1.1,
//               child: Switch.adaptive(
//                 value: value,
//                 onChanged: onChanged,
//                 activeColor: color,
//                 activeTrackColor: color.withOpacity(0.3),
//                 inactiveThumbColor: Colors.grey.shade400,
//                 inactiveTrackColor: Colors.grey.shade300,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
