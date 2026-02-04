import 'package:flutter/material.dart';

class PusatBantuanPage extends StatelessWidget {
  const PusatBantuanPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<FAQItem> faqList = [
      FAQItem(
        question: "Bagaimana cara melakukan absensi?",
        answer:
            "Untuk melakukan absensi:\n1. Buka menu Beranda\n2. Tekan tombol 'Absen Masuk' atau 'Absen Pulang'\n3. Pastikan wajah terlihat jelas di kamera\n4. Tunggu konfirmasi berhasil",
        icon: Icons.fingerprint,
        gradient: [Colors.blueAccent, Colors.lightBlue],
      ),
      FAQItem(
        question: "Apa yang harus dilakukan jika terlambat absen?",
        answer:
            "Jika terlambat absen:\n1. Tetap lakukan absensi seperti biasa\n2. Sistem akan mencatat waktu aktual\n3. Laporkan ke atasan jika ada kendala teknis\n4. Isi form keterangan terlambat jika diperlukan",
        icon: Icons.access_time_filled,
        gradient: [Colors.orange, Colors.deepOrangeAccent],
      ),
      FAQItem(
        question: "Bagaimana mengajukan izin tidak masuk?",
        answer:
            "Mengajukan izin:\n1. Buka menu 'Izin'\n2. Isi tanggal dan alasan izin\n3. Upload surat izin (jika ada)\n4. Tekan 'Ajukan Izin' dan tunggu persetujuan",
        icon: Icons.how_to_reg,
        gradient: [Colors.green, Colors.lightGreen],
      ),
      FAQItem(
        question: "Bagaimana cara mengajukan lembur?",
        answer:
            "Mengajukan lembur:\n1. Buka menu 'Lembur'\n2. Isi tanggal, jam mulai, dan jam selesai\n3. Jelaskan alasan lembur\n4. Tekan 'Ajukan Lembur' dan tunggu persetujuan",
        icon: Icons.nightlight_round,
        gradient: [Colors.purple, Colors.deepPurple],
      ),
      FAQItem(
        question: "Bagaimana melihat slip gaji?",
        answer:
            "Melihat slip gaji:\n1. Buka menu 'Slip Gaji'\n2. Pilih bulan yang diinginkan\n3. Slip gaji akan ditampilkan\n4. Anda dapat menyimpan sebagai PDF",
        icon: Icons.payments,
        gradient: [Colors.teal, Colors.cyan],
      ),
      FAQItem(
        question: "Apa yang harus dilakukan jika lupa password?",
        answer:
            "Reset password:\n1. Tekan 'Lupa Password' di halaman login\n2. Masukkan email terdaftar\n3. Cek email untuk link reset password\n4. Buat password baru",
        icon: Icons.lock_reset,
        gradient: [Colors.redAccent, Colors.red],
      ),
      FAQItem(
        question: "Bagaimana cara mengubah data profil?",
        answer:
            "Mengubah profil:\n1. Buka halaman Profil\n2. Tekan 'Edit Profil'\n3. Ubah data yang diperlukan\n4. Tekan 'Simpan Perubahan'",
        icon: Icons.person_pin,
        gradient: [Colors.indigo, Colors.blue],
      ),
      FAQItem(
        question: "Apa yang harus dilakukan jika aplikasi error?",
        answer:
            "Jika aplikasi error:\n1. Coba restart aplikasi\n2. Periksa koneksi internet\n3. Update aplikasi ke versi terbaru\n4. Hubungi support jika masalah berlanjut",
        icon: Icons.bug_report,
        gradient: [Colors.brown, Colors.orange],
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pusat Bantuan"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
        elevation: 8,
        shadowColor: Colors.blueAccent.withOpacity(0.3),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
        ),
      ),
      body: Column(
        children: [
          // Header dengan efek gradient
          Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blueAccent.shade700, Colors.lightBlue.shade400],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.blueAccent.withOpacity(0.3),
                  blurRadius: 15,
                  spreadRadius: 2,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Icon(
                      Icons.help_center_outlined,
                      size: 70,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Pusat Bantuan & FAQ",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        blurRadius: 2,
                        color: Colors.black26,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Temukan solusi cepat untuk pertanyaan umum Anda",
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.2),
                        Colors.white.withOpacity(0.1),
                      ],
                    ),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showContactSupport(context);
                      },
                      icon: const Icon(Icons.support_agent_outlined, size: 22),
                      label: const Text(
                        "Hubungi Support Kami",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.white,
                        shadowColor: Colors.transparent,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Judul FAQ Section
          Padding(
            padding: const EdgeInsets.only(
              top: 24,
              left: 20,
              right: 20,
              bottom: 12,
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.question_answer_outlined,
                    color: Colors.blueAccent,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  "Pertanyaan yang Sering Diajukan",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
              ],
            ),
          ),

          // FAQ List
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(bottom: 20),
                itemCount: faqList.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return FAQCard(faqItem: faqList[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showContactSupport(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.support_agent,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Tim Support Siap Membantu",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        Text(
                          "Respon cepat dalam 1x24 jam",
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 25),
            _buildContactTile(
              icon: Icons.email_outlined,
              title: "Email Support",
              subtitle: "support@absenin.com",
              color: Colors.redAccent,
              onTap: () {},
            ),
            const SizedBox(height: 15),
            _buildContactTile(
              icon: Icons.phone_in_talk_outlined,
              title: "Telepon Support",
              subtitle: "(021) 1234-5678",
              color: Colors.green,
              onTap: () {},
            ),
            const SizedBox(height: 15),
            _buildContactTile(
              icon: Icons.chat_outlined,
              title: "Live Chat",
              subtitle: "Tersedia 24/7",
              color: Colors.purple,
              onTap: () {},
            ),
            const SizedBox(height: 15),
            _buildContactTile(
              icon: Icons.access_time_outlined,
              title: "Jam Operasional",
              subtitle: "Senin - Jumat, 08:00 - 17:00",
              color: Colors.orange,
              onTap: () {},
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    child: const Text(
                      "Tutup",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                    ),
                    child: const Text(
                      "Kirim Pesan",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildContactTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade100,
              blurRadius: 5,
              spreadRadius: 1,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String answer;
  final IconData icon;
  final List<Color> gradient;

  FAQItem({
    required this.question,
    required this.answer,
    required this.icon,
    required this.gradient,
  });
}

class FAQCard extends StatefulWidget {
  final FAQItem faqItem;

  const FAQCard({super.key, required this.faqItem});

  @override
  State<FAQCard> createState() => _FAQCardState();
}

class _FAQCardState extends State<FAQCard> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: widget.faqItem.gradient
              .map((color) => color.withOpacity(0.08))
              .toList(),
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: widget.faqItem.gradient[0].withOpacity(0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: _toggleExpanded,
          borderRadius: BorderRadius.circular(16),
          splashColor: widget.faqItem.gradient[0].withOpacity(0.1),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: widget.faqItem.gradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: widget.faqItem.gradient[0].withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 1,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        widget.faqItem.icon,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        widget.faqItem.question,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ),
                    AnimatedRotation(
                      turns: _isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        Icons.expand_more,
                        color: widget.faqItem.gradient[0],
                        size: 28,
                      ),
                    ),
                  ],
                ),
                SizeTransition(
                  sizeFactor: _animation,
                  child: Column(
                    children: [
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: widget.faqItem.gradient[0].withOpacity(0.2),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: widget.faqItem.gradient[0].withOpacity(0.1),
                          ),
                        ),
                        child: Text(
                          widget.faqItem.answer,
                          style: TextStyle(
                            fontSize: 14.5,
                            height: 1.6,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
