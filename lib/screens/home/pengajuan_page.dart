import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../theme/app_theme.dart';
import '../../models/leave_request.dart';
import '../../services/api_service.dart';
import '../../services/auth_helper.dart';

class PengajuanPage extends StatefulWidget {
  const PengajuanPage({super.key});
  @override
  State<PengajuanPage> createState() => _PengajuanPageState();
}

class _PengajuanPageState extends State<PengajuanPage> {
  DateTime? _startDate;
  DateTime? _endDate;
  final TextEditingController _reasonController = TextEditingController();

  /// FIREBASE: akses API dan list request
  final ApiService _api = ApiService.instance;
  List<LeaveRequest> _leaveRequests = [];
  bool _isLoading = false;

  late int selectedMonth;
  late int selectedYear;

  // --- SISA CUTI (default, harusnya dari user profile) ---
  int _sisaCuti = 12;

  @override
  void initState() {
    super.initState();
    selectedMonth = DateTime.now().month;
    selectedYear = DateTime.now().year;
    _loadLeaveRequests();
  }

  Future<void> _loadLeaveRequests() async {
    setState(() => _isLoading = true);
    try {
      final requests = await _api.getAllLeaveRequests();
      setState(() {
        _leaveRequests = requests;
        _isLoading = false;
      });

      final approved = requests.where((e) => e.status == 'Disetujui');
      int pakai = approved.fold(0, (n, e) => n + e.daysCount);
      setState(() {
        _sisaCuti = (12 - pakai).clamp(0, 1000);
      });
    } catch (e) {
      setState(() => _isLoading = false);
      print('Error loading leave requests: $e');
    }
  }

  // Format nama bulan Indonesia
  String _bln(int month) =>
      DateFormat('MMMM', 'id_ID').format(DateTime(0, month));

  String _formatRange(DateTime start, DateTime end) {
    final r1 = DateFormat('d MMMM yyyy', 'id_ID').format(start);
    final r2 = DateFormat('d MMMM yyyy', 'id_ID').format(end);
    if (start == end) return r1;
    return "$r1 - $r2";
  }

  List<int> _availableMonths() =>
      _leaveRequests.map((r) => r.startDate.month).toSet().toList()..sort();

  List<int> _availableYears() =>
      _leaveRequests.map((r) => r.startDate.year).toSet().toList()..sort();

  List<LeaveRequest> get _filteredRiwayat => _leaveRequests
      .where(
        (r) =>
            r.startDate.month == selectedMonth &&
            r.startDate.year == selectedYear,
      )
      .toList();

  Future<void> _selectDate(bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: (isStart ? _startDate : _endDate) ?? DateTime.now(),
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 2),
      builder: (context, child) => Theme(
        data: ThemeData(
          colorScheme: ColorScheme.light(
            primary: AppColors.primary,
            onPrimary: Colors.white,
            onSurface: Colors.black,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(picked)) _endDate = null;
        } else {
          _endDate = picked;
        }
      });
    }
  }

  void _submitPengajuan() async {
    if (_startDate != null &&
        _endDate != null &&
        _reasonController.text.trim().isNotEmpty) {
      try {
        setState(() => _isLoading = true);
        final daysCount = _endDate!.difference(_startDate!).inDays + 1;
        final userId = FirebaseAuth.instance.currentUser?.uid ?? 'unknown';
        final userName = await AuthHelper.getCurrentUserName();

        final leaveRequest = LeaveRequest(
          employeeId: userId,
          employeeName: userName,
          startDate: _startDate!,
          endDate: _endDate!,
          reason: _reasonController.text,
          status: 'Proses',
          createdAt: DateTime.now(),
          daysCount: daysCount,
        );

        await _api.createLeaveRequest(leaveRequest);

        // Kurangi sisa cuti sementara
        setState(() {
          _sisaCuti = (_sisaCuti - daysCount).clamp(0, 1000);
        });

        await _loadLeaveRequests();

        setState(() {
          selectedMonth = _startDate!.month;
          selectedYear = _startDate!.year;
          _startDate = null;
          _endDate = null;
          _reasonController.clear();
          _isLoading = false;
        });

        FocusScope.of(context).unfocus();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Pengajuan cuti berhasil dikirim!"),
              duration: Duration(seconds: 3),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        setState(() => _isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Gagal mengirim pengajuan: $e"),
              duration: const Duration(seconds: 3),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Silakan isi semua field terlebih dahulu"),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(15);

    return Scaffold(
      backgroundColor: AppColors.extraLight,
      appBar: AppBar(
        title: const Text('Pengajuan Cuti'),
        centerTitle: true,
        backgroundColor: Color(0xFF3F7DF4),
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          // IconButton(icon: Icon(Icons.more_vert, color: Colors.grey[700]), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 11),
        children: [
          // ==== SISA CUTI ====
          Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: borderRadius,
              boxShadow: [
                BoxShadow(
                  blurRadius: 14,
                  color: Colors.black.withOpacity(.07),
                  offset: const Offset(0, 3.3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(.09),
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: const Icon(
                    Icons.calendar_month,
                    color: Color(0xFF3F7DF4),
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
                        fontSize: 15.7,
                      ),
                    ),
                    Text(
                      "$_sisaCuti Hari",
                      style: const TextStyle(
                        color: Color(0xFF3936B5),
                        fontWeight: FontWeight.bold,
                        fontSize: 26.7,
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
            margin: const EdgeInsets.only(bottom: 15),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: borderRadius,
              boxShadow: [
                BoxShadow(
                  blurRadius: 13,
                  color: Colors.black.withOpacity(.06),
                  offset: const Offset(0, 2.5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Ajukan Cuti Baru",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15.5),
                ),
                const SizedBox(height: 13),
                // Tanggal mulai
                GestureDetector(
                  onTap: () => _selectDate(true),
                  child: AbsorbPointer(
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Tanggal Mulai',
                        prefixIcon: const Icon(
                          Icons.calendar_today_outlined,
                          size: 21,
                        ),
                        fillColor: const Color(0xFFF7F8FB),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                      ),
                      controller: TextEditingController(
                        text: _startDate != null
                            ? DateFormat(
                                'dd MMMM yyyy',
                                'id_ID',
                              ).format(_startDate!)
                            : "",
                      ),
                      style: const TextStyle(fontSize: 14.5),
                    ),
                  ),
                ),
                const SizedBox(height: 9),
                // Tanggal akhir
                GestureDetector(
                  onTap: () => _selectDate(false),
                  child: AbsorbPointer(
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Tanggal Berakhir',
                        prefixIcon: const Icon(
                          Icons.calendar_today_outlined,
                          size: 21,
                        ),
                        fillColor: const Color(0xFFF7F8FB),
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(11),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                      ),
                      controller: TextEditingController(
                        text: _endDate != null
                            ? DateFormat(
                                'dd MMMM yyyy',
                                'id_ID',
                              ).format(_endDate!)
                            : "",
                      ),
                      style: const TextStyle(fontSize: 14.5),
                    ),
                  ),
                ),
                const SizedBox(height: 9),
                // Alasan cuti
                TextFormField(
                  controller: _reasonController,
                  minLines: 2,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Misalnya: Liburan keluarga, acara pribadi',
                    fillColor: const Color(0xFFF7F8FB),
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
                    onPressed: _isLoading ? null : _submitPengajuan,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF3936B5),
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(9),
                      ),
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.5,
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 26,
                            height: 26,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.3,
                            ),
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
                  color: Colors.black.withOpacity(.04),
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Filter bulan/tahun
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      color: AppColors.primary,
                      size: 19,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButton<int>(
                        isExpanded: true,
                        value: selectedMonth,
                        underline: SizedBox(),
                        borderRadius: BorderRadius.circular(10),
                        items: _availableMonths().isEmpty
                            ? [
                                DropdownMenuItem(
                                  value: DateTime.now().month,
                                  child: Text(_bln(DateTime.now().month)),
                                ),
                              ]
                            : _availableMonths()
                                  .map(
                                    (b) => DropdownMenuItem(
                                      value: b,
                                      child: Text(_bln(b)),
                                    ),
                                  )
                                  .toList(),
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
                        underline: SizedBox(),
                        borderRadius: BorderRadius.circular(10),
                        items: _availableYears().isEmpty
                            ? [
                                DropdownMenuItem(
                                  value: DateTime.now().year,
                                  child: Text('${DateTime.now().year}'),
                                ),
                              ]
                            : _availableYears()
                                  .map(
                                    (t) => DropdownMenuItem(
                                      value: t,
                                      child: Text('$t'),
                                    ),
                                  )
                                  .toList(),
                        onChanged: (val) {
                          if (val != null) setState(() => selectedYear = val);
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 13),
                const Text(
                  "Riwayat Pengajuan Cuti",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 13),
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                if (!_isLoading && _filteredRiwayat.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 13),
                    child: Text(
                      'Belum ada pengajuan cuti bulan ini.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                if (!_isLoading)
                  ..._filteredRiwayat.map((req) {
                    final lama =
                        req.endDate.difference(req.startDate).inDays + 1;
                    Color warna;
                    switch (req.status) {
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
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 2,
                      ),
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(color: warna, width: 3.5),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${_formatRange(req.startDate, req.endDate)} ($lama Hari)',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.2,
                                    color: Colors.grey[900],
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 13,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: warna.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: warna.withOpacity(.3),
                                  ),
                                ),
                                child: Text(
                                  req.status,
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
                            req.reason,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
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
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import '../../theme/app_theme.dart';
// import '../../models/leave_request.dart';
// import '../../services/api_service.dart';
// import '../../services/auth_helper.dart';

// class PengajuanPage extends StatefulWidget {
//   const PengajuanPage({super.key});
//   @override
//   State<PengajuanPage> createState() => _PengajuanPageState();
// }

// class _PengajuanPageState extends State<PengajuanPage> {
//   DateTime? _startDate;
//   DateTime? _endDate;
//   final TextEditingController _reasonController = TextEditingController();

//   /// 💾 FIREBASE: Akses API terpusat untuk leave requests (UI -> API -> FIREBASE)
//   final ApiService _api = ApiService.instance;

//   /// 💾 FIREBASE: List untuk menyimpan data dari Firestore
//   List<LeaveRequest> _leaveRequests = [];
//   bool _isLoading = false;

//   late int selectedMonth;
//   late int selectedYear;

//   @override
//   void initState() {
//     super.initState();
//     selectedMonth = DateTime.now().month;
//     selectedYear = DateTime.now().year;

//     /// 💾 FIREBASE: Load leave requests ketika page terbuka
//     _loadLeaveRequests();
//   }

//   /// 💾 FIREBASE READ: Load leave requests dari Firestore
//   Future<void> _loadLeaveRequests() async {
//     setState(() => _isLoading = true);
//     try {
//       /// 💾 FIREBASE READ: Ambil semua leave requests via ApiService
//       final requests = await _api.getAllLeaveRequests();
//       setState(() {
//         _leaveRequests = requests;
//         _isLoading = false;
//       });
//       print('✅ Leave requests loaded from Firebase');
//     } catch (e) {
//       setState(() => _isLoading = false);
//       print('❌ Error loading leave requests: $e');
//     }
//   }

//   String _formatDate(DateTime d) {
//     const monthNames = [
//       'Jan',
//       'Feb',
//       'Mar',
//       'Apr',
//       'Mei',
//       'Jun',
//       'Jul',
//       'Agu',
//       'Sep',
//       'Okt',
//       'Nov',
//       'Des',
//     ];
//     return '${d.day} ${monthNames[d.month - 1]} ${d.year}';
//   }

//   List<int> _availableMonths() {
//     /// 💾 FIREBASE: Get available months dari Firestore data
//     return _leaveRequests.map((r) => r.startDate.month).toSet().toList()
//       ..sort();
//   }

//   List<int> _availableYears() {
//     /// 💾 FIREBASE: Get available years dari Firestore data
//     return _leaveRequests.map((r) => r.startDate.year).toSet().toList()..sort();
//   }

//   List<LeaveRequest> get _filteredRiwayat {
//     /// 💾 FIREBASE: Filter leave requests berdasarkan bulan dan tahun yang dipilih
//     return _leaveRequests
//         .where(
//           (r) =>
//               r.startDate.month == selectedMonth &&
//               r.startDate.year == selectedYear,
//         )
//         .toList();
//   }

//   Future<void> _selectDate(bool isStart) async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: (isStart ? _startDate : _endDate) ?? DateTime.now(),
//       firstDate: DateTime(DateTime.now().year - 5),
//       lastDate: DateTime(DateTime.now().year + 2),
//       builder: (context, child) => Theme(
//         data: ThemeData(
//           colorScheme: ColorScheme.light(
//             primary: AppColors.primary,
//             onPrimary: Colors.white,
//             onSurface: Colors.black,
//           ),
//         ),
//         child: child!,
//       ),
//     );
//     if (picked != null) {
//       setState(() {
//         if (isStart) {
//           _startDate = picked;
//           if (_endDate != null && _endDate!.isBefore(picked)) _endDate = null;
//         } else {
//           _endDate = picked;
//         }
//       });
//     }
//   }

//   void _submitPengajuan() async {
//     if (_startDate != null &&
//         _endDate != null &&
//         _reasonController.text.trim().isNotEmpty) {
//       try {
//         setState(() => _isLoading = true);

//         final daysCount = _endDate!.difference(_startDate!).inDays + 1;

//         // 🔐 Ambil data user dari Firebase Auth
//         final userId = FirebaseAuth.instance.currentUser?.uid ?? 'unknown';
//         final userName = await AuthHelper.getCurrentUserName();

//         /// 💾 FIREBASE WRITE: Buat LeaveRequest object dengan data user real
//         final leaveRequest = LeaveRequest(
//           employeeId: userId,
//           employeeName: userName,
//           startDate: _startDate!,
//           endDate: _endDate!,
//           reason: _reasonController.text,
//           status: 'Proses',
//           createdAt: DateTime.now(),
//           daysCount: daysCount,
//         );

//         /// 💾 FIREBASE WRITE: Simpan ke Firestore collection 'leave_requests' via ApiService
//         await _api.createLeaveRequest(leaveRequest);
//         print('✅ Leave Request berhasil disimpan ke Firebase!');

//         /// 💾 FIREBASE READ: Refresh data dari Firestore
//         await _loadLeaveRequests();

//         /// Reset form
//         setState(() {
//           selectedMonth = _startDate!.month;
//           selectedYear = _startDate!.year;
//           _startDate = null;
//           _endDate = null;
//           _reasonController.clear();
//           _isLoading = false;
//         });

//         FocusScope.of(context).unfocus();

//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text("✅ Pengajuan cuti berhasil dikirim ke Firebase!"),
//               duration: Duration(seconds: 3),
//               backgroundColor: Colors.green,
//             ),
//           );
//         }
//       } catch (e) {
//         print('❌ Error submitting leave request: $e');
//         setState(() => _isLoading = false);

//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text("❌ Gagal mengirim pengajuan: $e"),
//               duration: const Duration(seconds: 3),
//               backgroundColor: Colors.red,
//             ),
//           );
//         }
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("⚠️ Silakan isi semua field terlebih dahulu"),
//           duration: Duration(seconds: 2),
//           backgroundColor: Colors.orange,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final borderRadius = BorderRadius.circular(16);

//     return Scaffold(
//       backgroundColor: AppColors.extraLight,
//       appBar: AppBar(
//         title: const Text('Pengajuan Cuti'),
//         backgroundColor: AppColors.primary,
//         elevation: 0,
//       ),
//       body: SafeArea(
//         child: ListView(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//           children: [
//             // Form Card with Gradient
//             Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     AppColors.primary,
//                     AppColors.primary.withOpacity(0.75),
//                   ],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: borderRadius,
//                 boxShadow: [
//                   BoxShadow(
//                     color: AppColors.primary.withOpacity(0.3),
//                     blurRadius: 16,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Ajukan Cuti",
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(height: 18),

//                   // Tanggal Mulai
//                   GestureDetector(
//                     onTap: () => _selectDate(true),
//                     child: AbsorbPointer(
//                       child: TextFormField(
//                         decoration: InputDecoration(
//                           hintText: 'Tanggal Mulai ',
//                           hintStyle: const TextStyle(color: Colors.black54),
//                           prefixIcon: const Icon(
//                             Icons.calendar_month_rounded,
//                             color: Colors.black54,
//                           ),
//                           filled: true,
//                           fillColor: Colors.white,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: BorderSide.none,
//                           ),
//                         ),
//                         controller: TextEditingController(
//                           text: _startDate != null
//                               ? DateFormat('dd MMM yyyy').format(_startDate!)
//                               : '',
//                         ),
//                         style: const TextStyle(color: Colors.black87),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 12),

//                   // Tanggal Akhir
//                   GestureDetector(
//                     onTap: () => _selectDate(false),
//                     child: AbsorbPointer(
//                       child: TextFormField(
//                         decoration: InputDecoration(
//                           hintText: 'Tanggal Akhir ',
//                           hintStyle: const TextStyle(color: Colors.black54),
//                           prefixIcon: const Icon(
//                             Icons.calendar_month_rounded,
//                             color: Colors.black54,
//                           ),
//                           filled: true,
//                           fillColor: Colors.white,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: BorderSide.none,
//                           ),
//                         ),
//                         controller: TextEditingController(
//                           text: _endDate != null
//                               ? DateFormat('dd MMM yyyy').format(_endDate!)
//                               : '',
//                         ),
//                         style: const TextStyle(color: Colors.black87),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 12),

//                   // Alasan Cuti
//                   TextFormField(
//                     controller: _reasonController,
//                     minLines: 3,
//                     maxLines: 4,
//                     decoration: InputDecoration(
//                       hintText: 'Misal: acara keluarga',
//                       hintStyle: const TextStyle(color: Colors.black54),
//                       filled: true,
//                       fillColor: Colors.white,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide.none,
//                       ),
//                     ),
//                     style: const TextStyle(color: Colors.black87),
//                   ),
//                   const SizedBox(height: 18),

//                   // Tombol Kirim
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       onPressed: _isLoading ? null : _submitPengajuan,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.white,
//                         disabledBackgroundColor: Colors.grey[400],
//                         padding: const EdgeInsets.symmetric(vertical: 12),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: _isLoading
//                           ? const SizedBox(
//                               height: 20,
//                               width: 20,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                                 valueColor: AlwaysStoppedAnimation<Color>(
//                                   AppColors.primary,
//                                 ),
//                               ),
//                             )
//                           : const Text(
//                               'Kirim Pengajuan',
//                               style: TextStyle(
//                                 color: AppColors.primary,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 14,
//                               ),
//                             ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 26),

//             // Filter & Riwayat with Gradient
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: borderRadius,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     blurRadius: 10,
//                     offset: const Offset(0, 3),
//                   ),
//                 ],
//               ),
//               padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Riwayat Pengajuan Cuti",
//                     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                   ),
//                   const SizedBox(height: 16),

//                   // Filter Bulan & Tahun
//                   Row(
//                     children: [
//                       Expanded(
//                         child: DropdownButton<int>(
//                           isExpanded: true,
//                           value: selectedMonth,
//                           items: _availableMonths().isEmpty
//                               ? [
//                                   DropdownMenuItem(
//                                     value: DateTime.now().month,
//                                     child: Text(
//                                       'Bulan ${DateTime.now().month}',
//                                     ),
//                                   ),
//                                 ]
//                               : _availableMonths()
//                                     .map(
//                                       (month) => DropdownMenuItem(
//                                         value: month,
//                                         child: Text('Bulan $month'),
//                                       ),
//                                     )
//                                     .toList(),
//                           onChanged: (value) {
//                             if (value != null) {
//                               setState(() => selectedMonth = value);
//                             }
//                           },
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: DropdownButton<int>(
//                           isExpanded: true,
//                           value: selectedYear,
//                           items: _availableYears().isEmpty
//                               ? [
//                                   DropdownMenuItem(
//                                     value: DateTime.now().year,
//                                     child: Text('Tahun ${DateTime.now().year}'),
//                                   ),
//                                 ]
//                               : _availableYears()
//                                     .map(
//                                       (year) => DropdownMenuItem(
//                                         value: year,
//                                         child: Text('Tahun $year'),
//                                       ),
//                                     )
//                                     .toList(),
//                           onChanged: (value) {
//                             if (value != null) {
//                               setState(() => selectedYear = value);
//                             }
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),

//                   // Loading Indicator
//                   if (_isLoading)
//                     Center(
//                       child: Padding(
//                         padding: const EdgeInsets.all(20.0),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             CircularProgressIndicator(color: AppColors.primary),
//                             const SizedBox(height: 12),
//                             const Text(
//                               'Memuat data...',
//                               style: TextStyle(
//                                 color: Colors.grey,
//                                 fontSize: 14,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),

//                   // List Riwayat
//                   if (!_isLoading && _filteredRiwayat.isEmpty)
//                     Center(
//                       child: Padding(
//                         padding: const EdgeInsets.all(20.0),
//                         child: Text(
//                           'Tidak ada data pengajuan untuk bulan ${_formatDate(DateTime(selectedYear, selectedMonth))}',
//                           textAlign: TextAlign.center,
//                           style: const TextStyle(
//                             color: Colors.grey,
//                             fontSize: 14,
//                           ),
//                         ),
//                       ),
//                     ),

//                   if (!_isLoading && _filteredRiwayat.isNotEmpty)
//                     ListView.builder(
//                       shrinkWrap: true,
//                       physics: const NeverScrollableScrollPhysics(),
//                       itemCount: _filteredRiwayat.length,
//                       itemBuilder: (context, index) {
//                         final request = _filteredRiwayat[index];
//                         return Container(
//                           margin: const EdgeInsets.only(bottom: 12),
//                           padding: const EdgeInsets.all(12),
//                           decoration: BoxDecoration(
//                             border: Border.all(
//                               color: Colors.grey[300]!,
//                               width: 1,
//                             ),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 mainAxisAlignment:
//                                     MainAxisAlignment.spaceBetween,
//                                 children: [
//                                   Text(
//                                     request.employeeName,
//                                     style: const TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                       fontSize: 14,
//                                     ),
//                                   ),
//                                   Container(
//                                     padding: const EdgeInsets.symmetric(
//                                       horizontal: 8,
//                                       vertical: 4,
//                                     ),
//                                     decoration: BoxDecoration(
//                                       color: request.status == 'Disetujui'
//                                           ? Colors.green[100]
//                                           : request.status == 'Ditolak'
//                                           ? Colors.red[100]
//                                           : Colors.orange[100],
//                                       borderRadius: BorderRadius.circular(4),
//                                     ),
//                                     child: Text(
//                                       request.status,
//                                       style: TextStyle(
//                                         fontSize: 12,
//                                         fontWeight: FontWeight.bold,
//                                         color: request.status == 'Disetujui'
//                                             ? Colors.green
//                                             : request.status == 'Ditolak'
//                                             ? Colors.red
//                                             : Colors.orange,
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(height: 8),
//                               Text(
//                                 '${_formatDate(request.startDate)} - ${_formatDate(request.endDate)}',
//                                 style: const TextStyle(
//                                   fontSize: 12,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                               const SizedBox(height: 6),
//                               Text(
//                                 'Alasan: ${request.reason}',
//                                 style: const TextStyle(fontSize: 12),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _reasonController.dispose();
//     super.dispose();
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import '../../theme/app_theme.dart';
// import '../../models/leave_request.dart';
// import '../../services/api_service.dart';

// class PengajuanPage extends StatefulWidget {
//   const PengajuanPage({super.key});
//   @override
//   State<PengajuanPage> createState() => _PengajuanPageState();
// }

// class _PengajuanPageState extends State<PengajuanPage> {
//   DateTime? _startDate;
//   DateTime? _endDate;
//   final TextEditingController _reasonController = TextEditingController();

//   /// 💾 FIREBASE: Akses API terpusat untuk leave requests (UI -> API -> FIREBASE)
//   final ApiService _api = ApiService.instance;

//   /// 💾 FIREBASE: List untuk menyimpan data dari Firestore
//   List<LeaveRequest> _leaveRequests = [];
//   bool _isLoading = false;

//   late int selectedMonth;
//   late int selectedYear;

//   @override
//   void initState() {
//     super.initState();
//     selectedMonth = DateTime.now().month;
//     selectedYear = DateTime.now().year;

//     /// 💾 FIREBASE: Load leave requests ketika page terbuka
//     _loadLeaveRequests();
//   }

//   /// 💾 FIREBASE READ: Load leave requests dari Firestore
//   Future<void> _loadLeaveRequests() async {
//     setState(() => _isLoading = true);
//     try {
//       /// 💾 FIREBASE READ: Ambil semua leave requests via ApiService
//       final requests = await _api.getAllLeaveRequests();
//       setState(() {
//         _leaveRequests = requests;
//         _isLoading = false;
//       });
//       print('✅ Leave requests loaded from Firebase');
//     } catch (e) {
//       setState(() => _isLoading = false);
//       print('❌ Error loading leave requests: $e');
//     }
//   }

//   String _formatDate(DateTime d) {
//     const monthNames = [
//       'Jan',
//       'Feb',
//       'Mar',
//       'Apr',
//       'Mei',
//       'Jun',
//       'Jul',
//       'Agu',
//       'Sep',
//       'Okt',
//       'Nov',
//       'Des',
//     ];
//     return '${d.day} ${monthNames[d.month - 1]} ${d.year}';
//   }

//   List<int> _availableMonths() {
//     /// 💾 FIREBASE: Get available months dari Firestore data
//     return _leaveRequests.map((r) => r.startDate.month).toSet().toList()
//       ..sort();
//   }

//   List<int> _availableYears() {
//     /// 💾 FIREBASE: Get available years dari Firestore data
//     return _leaveRequests.map((r) => r.startDate.year).toSet().toList()..sort();
//   }

//   List<LeaveRequest> get _filteredRiwayat {
//     /// 💾 FIREBASE: Filter leave requests berdasarkan bulan dan tahun yang dipilih
//     return _leaveRequests
//         .where(
//           (r) =>
//               r.startDate.month == selectedMonth &&
//               r.startDate.year == selectedYear,
//         )
//         .toList();
//   }

//   Future<void> _selectDate(bool isStart) async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: (isStart ? _startDate : _endDate) ?? DateTime.now(),
//       firstDate: DateTime(DateTime.now().year - 5),
//       lastDate: DateTime(DateTime.now().year + 2),
//       builder: (context, child) => Theme(
//         data: ThemeData(
//           colorScheme: ColorScheme.light(
//             primary: AppColors.primary,
//             onPrimary: Colors.white,
//             onSurface: Colors.black,
//           ),
//         ),
//         child: child!,
//       ),
//     );
//     if (picked != null) {
//       setState(() {
//         if (isStart) {
//           _startDate = picked;
//           if (_endDate != null && _endDate!.isBefore(picked)) _endDate = null;
//         } else {
//           _endDate = picked;
//         }
//       });
//     }
//   }

//   void _submitPengajuan() async {
//     if (_startDate != null &&
//         _endDate != null &&
//         _reasonController.text.trim().isNotEmpty) {
//       try {
//         final daysCount = _endDate!.difference(_startDate!).inDays + 1;

//         /// 💾 FIREBASE WRITE: Buat LeaveRequest object
//         final leaveRequest = LeaveRequest(
//           employeeId: 'emp_001', // TODO: Get dari logged in user
//           employeeName: 'Ramadhani Hibban', // TODO: Get dari logged in user
//           startDate: _startDate!,
//           endDate: _endDate!,
//           reason: _reasonController.text,
//           status: 'Proses',
//           createdAt: DateTime.now(),
//           daysCount: daysCount,
//         );

//         /// 💾 FIREBASE WRITE: Simpan ke Firestore collection 'leave_requests' via ApiService
//         await _api.createLeaveRequest(leaveRequest);

//         /// 💾 FIREBASE READ: Refresh data dari Firestore
//         await _loadLeaveRequests();

//         /// Reset form
//         setState(() {
//           selectedMonth = _startDate!.month;
//           selectedYear = _startDate!.year;
//           _startDate = null;
//           _endDate = null;
//           _reasonController.clear();
//         });

//         FocusScope.of(context).unfocus();

//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text("✅ Pengajuan cuti berhasil dikirim ke Firebase!"),
//               duration: Duration(seconds: 2),
//               backgroundColor: Colors.green,
//             ),
//           );
//         }
//       } catch (e) {
//         print('❌ Error submitting leave request: $e');
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text("❌ Gagal mengirim pengajuan: $e"),
//               duration: const Duration(seconds: 2),
//               backgroundColor: Colors.red,
//             ),
//           );
//         }
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final colorPrimary = AppColors.primary;
//     final colorAccent = AppColors.primaryLight;
//     final borderRadius = BorderRadius.circular(16);

//     return Scaffold(
//       backgroundColor: AppColors.extraLight,
//       appBar: AppBar(
//         title: const Text('Pengajuan Cuti'),
//         backgroundColor: AppColors.primary,
//         elevation: 0,
//       ),
//       body: SafeArea(
//         child: ListView(
//           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//           children: [
//             // Form Card with Gradient
//             Container(
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   colors: [
//                     AppColors.primary,
//                     AppColors.primary.withOpacity(0.75),
//                   ],
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                 ),
//                 borderRadius: borderRadius,
//                 boxShadow: [
//                   BoxShadow(
//                     color: AppColors.primary.withOpacity(0.3),
//                     blurRadius: 16,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Ajukan Cuti",
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 18,
//                       color: Colors.white,
//                     ),
//                   ),
//                   const SizedBox(height: 18),

//                   // Tanggal Mulai
//                   GestureDetector(
//                     onTap: () => _selectDate(true),
//                     child: AbsorbPointer(
//                       child: TextFormField(
//                         decoration: InputDecoration(
//                           hintText: 'Tanggal Mulai ',
//                           hintStyle: const TextStyle(color: Colors.black54),
//                           prefixIcon: const Icon(
//                             Icons.calendar_month_rounded,
//                             color: Colors.black54,
//                           ),
//                           filled: true,
//                           fillColor: Colors.white,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: BorderSide.none,
//                           ),
//                         ),
//                         controller: TextEditingController(
//                           text: _startDate != null
//                               ? DateFormat('dd MMM yyyy').format(_startDate!)
//                               : '',
//                         ),
//                         style: const TextStyle(color: Colors.black87),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 12),

//                   // Tanggal Akhir
//                   GestureDetector(
//                     onTap: () => _selectDate(false),
//                     child: AbsorbPointer(
//                       child: TextFormField(
//                         decoration: InputDecoration(
//                           hintText: 'Tanggal Akhir ',
//                           hintStyle: const TextStyle(color: Colors.black54),
//                           prefixIcon: const Icon(
//                             Icons.calendar_today,
//                             color: Colors.black54,
//                           ),
//                           filled: true,
//                           fillColor: Colors.white,
//                           border: OutlineInputBorder(
//                             borderRadius: BorderRadius.circular(12),
//                             borderSide: BorderSide.none,
//                           ),
//                         ),
//                         controller: TextEditingController(
//                           text: _endDate != null
//                               ? DateFormat('dd MMM yyyy').format(_endDate!)
//                               : '',
//                         ),
//                         style: const TextStyle(color: Colors.black87),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 12),

//                   // Alasan Cuti
//                   TextFormField(
//                     controller: _reasonController,
//                     minLines: 3,
//                     maxLines: 4,
//                     decoration: InputDecoration(
//                       hintText: 'Misal: acara keluarga',
//                       hintStyle: const TextStyle(color: Colors.black54),
//                       filled: true,
//                       fillColor: Colors.white,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(12),
//                         borderSide: BorderSide.none,
//                       ),
//                     ),
//                     style: const TextStyle(color: Colors.black87),
//                   ),
//                   const SizedBox(height: 18),

//                   // Tombol Kirim
//                   SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.white,
//                         elevation: 0,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                       ),
//                       onPressed: _submitPengajuan,
//                       child: const Text(
//                         'Kirim Pengajuan',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           letterSpacing: 0.5,
//                           color: Colors.black87,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             const SizedBox(height: 26),

//             // Filter & Riwayat with Gradient
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: borderRadius,
//                 boxShadow: [
//                   BoxShadow(
//                     color: colorPrimary.withOpacity(0.1),
//                     blurRadius: 12,
//                     offset: const Offset(0, 3),
//                   ),
//                 ],
//               ),
//               padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "Riwayat Pengajuan Cuti",
//                     style: TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 17,
//                       color: AppColors.primary,
//                     ),
//                   ),
//                   const SizedBox(height: 14),

//                   // Dropdown Filter
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.calendar_today_rounded,
//                         color: AppColors.primary,
//                       ),
//                       const SizedBox(width: 10),
//                       DropdownButton<int>(
//                         value: selectedMonth,
//                         style: const TextStyle(
//                           fontSize: 15,
//                           color: Colors.black,
//                         ),
//                         dropdownColor: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                         underline: SizedBox(),
//                         items: _availableMonths().map((m) {
//                           return DropdownMenuItem<int>(
//                             value: m,
//                             child: Text(
//                               [
//                                 'Jan',
//                                 'Feb',
//                                 'Mar',
//                                 'Apr',
//                                 'Mei',
//                                 'Jun',
//                                 'Jul',
//                                 'Agu',
//                                 'Sep',
//                                 'Okt',
//                                 'Nov',
//                                 'Des',
//                               ][m - 1],
//                             ),
//                           );
//                         }).toList(),
//                         onChanged: (val) {
//                           if (val != null) setState(() => selectedMonth = val);
//                         },
//                       ),
//                       const SizedBox(width: 7),
//                       DropdownButton<int>(
//                         value: selectedYear,
//                         style: const TextStyle(
//                           fontSize: 15,
//                           color: Colors.black,
//                         ),
//                         dropdownColor: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                         underline: SizedBox(),
//                         items: _availableYears().map((y) {
//                           return DropdownMenuItem<int>(
//                             value: y,
//                             child: Text('$y'),
//                           );
//                         }).toList(),
//                         onChanged: (val) {
//                           if (val != null) setState(() => selectedYear = val);
//                         },
//                       ),
//                       const Spacer(),
//                       Container(
//                         decoration: BoxDecoration(
//                           color: AppColors.primaryLight,
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Icon(
//                             Icons.filter_list_rounded,
//                             color: AppColors.primary,
//                             size: 20,
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),

//                   // List Riwayat
//                   if (_filteredRiwayat.isEmpty)
//                     Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: Colors.grey[100],
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Text(
//                         'Tidak ada riwayat pengajuan di bulan dan tahun ini.',
//                         style: TextStyle(
//                           color: Colors.grey[600],
//                           fontStyle: FontStyle.italic,
//                         ),
//                       ),
//                     ),
//                   ..._filteredRiwayat.map(
//                     (r) => Container(
//                       margin: const EdgeInsets.only(bottom: 16),
//                       decoration: BoxDecoration(
//                         color: colorAccent,
//                         borderRadius: BorderRadius.circular(12),
//                         boxShadow: [
//                           BoxShadow(color: Colors.black12, blurRadius: 2),
//                         ],
//                       ),
//                       child: ListTile(
//                         contentPadding: const EdgeInsets.symmetric(
//                           vertical: 10,
//                           horizontal: 14,
//                         ),
//                         title: Text(
//                           '${_formatDate(r.startDate)} - ${_formatDate(r.endDate)}',
//                           style: const TextStyle(
//                             fontWeight: FontWeight.w800,
//                             fontSize: 15,
//                             color: Colors.black87,
//                           ),
//                         ),
//                         subtitle: Padding(
//                           padding: const EdgeInsets.only(top: 6),
//                           child: Text(
//                             '• Alasan: ${r.reason}',
//                             style: TextStyle(
//                               color: Colors.black.withOpacity(0.7),
//                               fontSize: 14,
//                             ),
//                           ),
//                         ),
//                         trailing: Container(
//                           padding: const EdgeInsets.symmetric(
//                             vertical: 5,
//                             horizontal: 18,
//                           ),
//                           decoration: BoxDecoration(
//                             color: r.status == "Proses"
//                                 ? Colors.red.shade400
//                                 : Colors.green,
//                             borderRadius: BorderRadius.circular(15),
//                           ),
//                           child: Text(
//                             r.status,
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontWeight: FontWeight.w600,
//                               fontSize: 14,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
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
