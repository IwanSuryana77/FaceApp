import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AbsensiData {
  final DateTime tanggal;
  final DateTime jamMasuk;
  final DateTime jamPulang;

  AbsensiData({
    required this.tanggal,
    required this.jamMasuk,
    required this.jamPulang,
  });
}

class DaftarAbsenPage extends StatefulWidget {
  final ValueNotifier<List<AbsensiData>> absensiNotifier;
  const DaftarAbsenPage({super.key, required this.absensiNotifier, required List absensi});

  @override
  State<DaftarAbsenPage> createState() => _DaftarAbsenPageState();
}

class _DaftarAbsenPageState extends State<DaftarAbsenPage> {
  DateTime selectedMonth = DateTime.now();

  List<AbsensiData> _filterForMonth(List<AbsensiData> all) => all
      .where(
        (a) =>
            a.tanggal.month == selectedMonth.month &&
            a.tanggal.year == selectedMonth.year,
      )
      .toList();

  Future<void> _pickMonth() async {
    int year = selectedMonth.year, month = selectedMonth.month;
    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(
          'Pilih Bulan & Tahun',
          style: TextStyle(color: Color(0xFF1B1E6D)),
        ),
        content: Row(
          children: [
            Expanded(
              child: DropdownButton<int>(
                value: month,
                items: List.generate(
                  12,
                  (i) => DropdownMenuItem(
                    value: i + 1,
                    child: Text(
                      DateFormat('MMMM', 'id_ID').format(DateTime(0, i + 1)),
                    ),
                  ),
                ),
                onChanged: (val) => setState(() => month = val!),
              ),
            ),
            Expanded(
              child: DropdownButton<int>(
                value: year,
                items: List.generate(
                  6,
                  (i) => DropdownMenuItem(
                    value: DateTime.now().year - 2 + i,
                    child: Text('${DateTime.now().year - 2 + i}'),
                  ),
                ),
                onChanged: (val) => setState(() => year = val!),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => selectedMonth = DateTime(year, month));
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1B1E6D),
            ),
            child: const Text('Pilih', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const biruAppbar = Color(0xFF3F7DF4);
    const surface = Color(0xFFF6F7FB);

    return Scaffold(
      backgroundColor: surface,
      body: Column(
        children: [
          // HEADER BIRU PENUH
          Container(
            width: double.infinity,
            height: 62,
            color: biruAppbar,
            padding: const EdgeInsets.only(left: 5, right: 15, top: 6),
            child: SafeArea(
              bottom: false,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'Daftar Absen',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 20.5,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // === FILTER BULAN / TAHUN ===
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 9),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(
                      () => selectedMonth = DateTime(
                        selectedMonth.year,
                        selectedMonth.month - 1,
                      ),
                    );
                  },
                  icon: const Icon(Icons.chevron_left, color: biruAppbar),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: _pickMonth,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(13),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 5,
                          ),
                        ],
                        border: Border.all(color: surface, width: 1.2),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat(
                              'MMMM yyyy',
                              'id_ID',
                            ).format(selectedMonth),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 5),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: biruAppbar,
                            size: 22,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(
                      () => selectedMonth = DateTime(
                        selectedMonth.year,
                        selectedMonth.month + 1,
                      ),
                    );
                  },
                  icon: const Icon(Icons.chevron_right, color: biruAppbar),
                ),
              ],
            ),
          ),
          // == RIWAYAT ABSEN CARD LIST ==
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 11),
              child: ValueListenableBuilder<List<AbsensiData>>(
                valueListenable: widget.absensiNotifier,
                builder: (context, allAbsensi, _) {
                  final filtered = _filterForMonth(allAbsensi);
                  if (filtered.isEmpty) {
                    return Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 9,
                          ),
                        ],
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 19),
                        child: Center(
                          child: Text(
                            "Belum ada data absen bulan ini.",
                            style: TextStyle(
                              color: Color(0xFF3F7DF4),
                              fontWeight: FontWeight.w500,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 11),
                    itemBuilder: (context, i) {
                      final absen = filtered[i];
                      final duration = absen.jamPulang.difference(
                        absen.jamMasuk,
                      );
                      final totalTime =
                          "${duration.inHours}j ${duration.inMinutes % 60}m";
                      final hari = DateFormat(
                        'EEEE',
                        'id_ID',
                      ).format(absen.tanggal);
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 6,
                            ),
                          ],
                          border: Border.all(color: surface, width: 1),
                        ),
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 13,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hari,
                              style: const TextStyle(
                                color: Color(0xFF3F7DF4),
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Row(
                              children: [
                                const Text(
                                  "Masuk: ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF3F7DF4),
                                  ),
                                ),
                                Text(
                                  DateFormat('HH:mm').format(absen.jamMasuk),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF3F7DF4).withOpacity(0.74),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                const Text(
                                  "Pulang: ",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF3F7DF4),
                                  ),
                                ),
                                Text(
                                  DateFormat('HH:mm').format(absen.jamPulang),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF3F7DF4).withOpacity(0.74),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              DateFormat(
                                'd MMMM yyyy',
                                'id_ID',
                              ).format(absen.tanggal),
                              style: TextStyle(
                                color: Color(0xFF3F7DF4).withOpacity(0.75),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Divider(
                              height: 7,
                              thickness: 1,
                              color: surface,
                              endIndent: 100,
                            ),
                            Row(
                              children: [
                                const Text(
                                  "Total Jam Kerja: ",
                                  style: TextStyle(
                                    color: Color(0xFF3F7DF4),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  totalTime,
                                  style: const TextStyle(
                                    color: Color(0xFF3F7DF4),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}