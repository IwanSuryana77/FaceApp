import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const primaryBlue = Color(0xFF3F7DF4);
const cardBorder = Color(0xFFE6ECF5);
const extraLight = Color(0xFFF7F8FA);

class PengajuanCutiPage extends StatefulWidget {
  const PengajuanCutiPage({super.key});
  @override
  State<PengajuanCutiPage> createState() => _PengajuanCutiPageState();
}

class _PengajuanCutiPageState extends State<PengajuanCutiPage> {
  DateTime? _startDate, _endDate;
  final _reasonController = TextEditingController();
  bool _loading = false;

  // Filter Riwayat
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;

  // Sisa cuti (default, update via Firestore jika ada fitur profile)
  int _sisaCuti = 12;

  // Helper format
  static String _bulan(int m) => DateFormat('MMMM', 'id_ID').format(DateTime(0, m));
  String _formatRange(DateTime start, DateTime end) {
    final r1 = DateFormat('d MMMM yyyy', 'id_ID').format(start);
    final r2 = DateFormat('d MMMM yyyy', 'id_ID').format(end);
    return start == end ? r1 : "$r1 - $r2";
  }

  Future<void> _submitPengajuan() async {
    if (_startDate == null || _endDate == null || _reasonController.text.trim().isEmpty || _loading) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Silakan isi semua field terlebih dahulu"),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    setState(() => _loading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw 'Belum login.';
      final daysCount = _endDate!.difference(_startDate!).inDays + 1;

      await FirebaseFirestore.instance
          .collection('leave_requests')
          .add({
            'employeeId': user.uid,
            'employeeName': user.displayName ?? '-',
            'startDate': _startDate,
            'endDate': _endDate,
            'reason': _reasonController.text,
            'status': 'Proses',
            'createdAt': DateTime.now(),
            'daysCount': daysCount,
          });

      _reasonController.clear();
      setState(() {
        selectedMonth = _startDate!.month;
        selectedYear = _startDate!.year;
        _startDate = null;
        _endDate = null;
        _loading = false;
        // Dummy sisa cuti
        _sisaCuti = (_sisaCuti - daysCount).clamp(0, 1000);
      });
      FocusScope.of(context).unfocus();

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Pengajuan cuti berhasil dikirim!"),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ));
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Gagal mengirim pengajuan: $e"),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(15);

    return Scaffold(
      backgroundColor: extraLight,
      appBar: AppBar(
        title: const Text('Pengajuan Cuti'),
        centerTitle: true,
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
        children: [
          // ==== SISA CUTI ====
          Container(
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: borderRadius,
              boxShadow: [
                BoxShadow(
                  blurRadius: 12,
                  color: Colors.black.withOpacity(.06),
                  offset: const Offset(0, 2.5),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: primaryBlue.withOpacity(.09),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Icon(
                    Icons.calendar_month,
                    color: primaryBlue,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 18),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Sisa Cuti Tahunan",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16.2,
                      ),
                    ),
                    Text(
                      "$_sisaCuti Hari",
                      style: const TextStyle(
                        color: primaryBlue,
                        fontWeight: FontWeight.bold,
                        fontSize: 27,
                        letterSpacing: 0.1,
                      ),
                    ),
                    Text(
                      "Tersedia hingga 31 Desember ${DateTime.now().year}",
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // ==== FORM PENGAJUAN ====
          Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: borderRadius,
              boxShadow: [
                BoxShadow(
                  blurRadius: 12,
                  color: Colors.black.withOpacity(.07),
                  offset: const Offset(0, 2.0),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Ajukan Cuti Baru", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.5)),
                const SizedBox(height: 13),

                // Tanggal Mulai
                GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _startDate ?? DateTime.now(),
                      firstDate: DateTime(DateTime.now().year - 5),
                      lastDate: DateTime(DateTime.now().year + 2),
                    );
                    if (picked != null) {
                      setState(() {
                        _startDate = picked;
                        if (_endDate != null && _endDate!.isBefore(picked)) _endDate = null;
                      });
                    }
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Tanggal Mulai',
                        prefixIcon: const Icon(Icons.calendar_today_outlined, size: 21),
                        fillColor: extraLight,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      controller: TextEditingController(
                        text: _startDate == null
                            ? ""
                            : DateFormat('dd MMMM yyyy', 'id_ID').format(_startDate!)
                      ),
                      style: const TextStyle(fontSize: 14.5),
                    ),
                  ),
                ),
                const SizedBox(height: 9),
                // Tanggal Selesai
                GestureDetector(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: _endDate ?? (_startDate ?? DateTime.now()),
                      firstDate: _startDate ?? DateTime.now(),
                      lastDate: DateTime(DateTime.now().year + 2),
                    );
                    if (picked != null) {
                      setState(() => _endDate = picked);
                    }
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Tanggal Berakhir',
                        prefixIcon: const Icon(Icons.calendar_today_outlined, size: 21),
                        fillColor: extraLight,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      controller: TextEditingController(
                        text: _endDate == null
                            ? ""
                            : DateFormat('dd MMMM yyyy', 'id_ID').format(_endDate!)
                      ),
                      style: const TextStyle(fontSize: 14.5),
                    ),
                  ),
                ),
                const SizedBox(height: 9),
                TextFormField(
                  controller: _reasonController,
                  minLines: 2,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Misalnya: Liburan keluarga, acara pribadi',
                    fillColor: extraLight,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(11),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  style: const TextStyle(fontSize: 14.5),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _submitPengajuan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15.5),
                    ),
                    child: _loading
                        ? const SizedBox(
                            width: 26,
                            height: 26,
                            child: CircularProgressIndicator(strokeWidth: 2.1, color: Colors.white),
                          )
                        : const Text("Kirim Pengajuan"),
                  ),
                ),
              ],
            ),
          ),
          // ==== RIWAYAT FILTER DAN LIST ====
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: borderRadius,
              boxShadow: [
                BoxShadow(
                  blurRadius: 8,
                  color: Colors.black.withOpacity(.045),
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bulan tahun filter
                Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded, color: primaryBlue, size: 19),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButton<int>(
                        isExpanded: true,
                        value: selectedMonth,
                        underline: const SizedBox(),
                        borderRadius: BorderRadius.circular(10),
                        items: List.generate(12, (i) => DropdownMenuItem(
                          value: i + 1,
                          child: Text(_bulan(i + 1)),
                        )),
                        onChanged: (val) {
                          if (val != null) setState(() => selectedMonth = val);
                        },
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: DropdownButton<int>(
                        isExpanded: true,
                        value: selectedYear,
                        underline: const SizedBox(),
                        borderRadius: BorderRadius.circular(10),
                        items: List.generate(5, (i) => DropdownMenuItem(
                          value: DateTime.now().year - i,
                          child: Text('${DateTime.now().year - i}'),
                        )),
                        onChanged: (val) {
                          if (val != null) setState(() => selectedYear = val);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 13),
                const Text("Riwayat Pengajuan Cuti", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 13),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('leave_requests')
                      .where('startDate', isGreaterThanOrEqualTo: DateTime(selectedYear, selectedMonth, 1))
                      .where('startDate', isLessThan: DateTime(selectedMonth==12?selectedYear+1:selectedYear, selectedMonth%12+1, 1))
                      .orderBy('startDate', descending: true)
                      .snapshots(),
                  builder: (context, snap) {
                    if (!snap.hasData) {
                      return const Padding(
                        padding: EdgeInsets.all(14.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    final docs = snap.data!.docs;
                    if (docs.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 13),
                        child: Text('Belum ada pengajuan cuti bulan ini.', style: TextStyle(color: Colors.grey)),
                      );
                    }
                    return Column(
                      children: docs.map((d) {
                        final data = d.data() as Map<String, dynamic>;
                        final tawal = (data['startDate'] as Timestamp).toDate();
                        final takhir = (data['endDate'] as Timestamp).toDate();
                        final lama = takhir.difference(tawal).inDays + 1;
                        Color warna;
                        switch (data['status']) {
                          case 'Disetujui':
                            warna = Colors.green;
                            break;
                          case 'Ditolak':
                            warna = Colors.red;
                            break;
                          default:
                            warna = Colors.amber.shade800;
                        }
                        return Container(
                          margin: const EdgeInsets.only(bottom: 9),
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
                          decoration: BoxDecoration(
                            border: Border(left: BorderSide(color: warna, width: 3)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      '${_formatRange(tawal, takhir)} ($lama Hari)',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.2,
                                        color: Colors.grey[900],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: warna.withOpacity(0.12),
                                      borderRadius: BorderRadius.circular(13),
                                      border: Border.all(color: warna.withOpacity(.28)),
                                    ),
                                    child: Text(
                                      data['status'],
                                      style: TextStyle(
                                          color: warna,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                data['reason'],
                                style: const TextStyle(fontSize: 13, color: Colors.black54),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }
}