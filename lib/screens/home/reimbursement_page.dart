import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'reimbursement_form_page.dart';

const primaryBlue = Color(0xFF3F7DF4);
const lightGrey = Color(0xFFF7F8FA);
const cardBorder = Color(0xFFE6ECF5);

class ReimbursementRequest {
  final String id;
  final DateTime startDate;
  final double amount;
  final String status;
  final String refCode;
  final String description;

  ReimbursementRequest({
    required this.id,
    required this.startDate,
    required this.amount,
    required this.status,
    required this.refCode,
    required this.description,
  });

  factory ReimbursementRequest.fromMap(Map<String, dynamic> map, String id) {
    return ReimbursementRequest(
      id: id,
      startDate: (map['startDate'] as Timestamp).toDate(),
      amount: (map['amount'] as num).toDouble(),
      status: map['status'] ?? 'Menunggu',
      refCode: map['refCode'] ?? '-',
      description: map['description'] ?? "-",
    );
  }
}

class ReimbursementPage extends StatefulWidget {
  const ReimbursementPage({super.key});
  @override
  State<ReimbursementPage> createState() => _ReimbursementPageState();
}

class _ReimbursementPageState extends State<ReimbursementPage> {
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;
  bool _loading = false;
  List<ReimbursementRequest> _history = [];
  StreamSubscription<QuerySnapshot>? _historySub;

  Future<void> _fetchHistory() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    setState(() => _loading = true);

    // cancel previous subscription if any
    await _historySub?.cancel();

    final firstDay = DateTime(_selectedYear, _selectedMonth, 1);
    final lastDay = DateTime(_selectedYear, _selectedMonth + 1, 0, 23, 59, 59);

    try {
      final query = FirebaseFirestore.instance
          .collection('reimbursement_requests')
          .where('employeeId', isEqualTo: user.uid)
          .where(
            'startDate',
            isGreaterThanOrEqualTo: Timestamp.fromDate(firstDay),
          )
          .where('startDate', isLessThanOrEqualTo: Timestamp.fromDate(lastDay))
          .orderBy('startDate', descending: true)
          .limit(50);

      // listen to realtime updates so new submissions appear immediately
      _historySub = query.snapshots().listen(
        (snap) {
          setState(() {
            _history = snap.docs
                .map((d) => ReimbursementRequest.fromMap(d.data(), d.id))
                .toList();
            _loading = false;
          });
        },
        onError: (e) {
          setState(() {
            _history = [];
            _loading = false;
          });
        },
      );
    } catch (e) {
      setState(() {
        _history = [];
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _historySub?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  List<DropdownMenuItem<int>> get _bulanItems => List.generate(
    12,
    (i) => DropdownMenuItem(
      value: i + 1,
      child: Text(DateFormat('MMMM', 'id_ID').format(DateTime(2020, i + 1, 1))),
    ),
  );
  List<DropdownMenuItem<int>> get _tahunItems => List.generate(
    5,
    (i) => DropdownMenuItem(
      value: DateTime.now().year - i,
      child: Text("${DateTime.now().year - i}"),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
      appBar: AppBar(
        title: const Text('Reimbursement'),
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Kartu saldo & status
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
                side: const BorderSide(color: cardBorder),
              ),
              margin: const EdgeInsets.only(bottom: 8),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 22,
                  horizontal: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      'Saldo Saya',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 18),
                    Container(
                      decoration: BoxDecoration(
                        color: lightGrey,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Icon(
                            Icons.description_rounded,
                            color: primaryBlue,
                            size: 50,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'Tidak ada kebijakan yang dibuat',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Kebijakan reimbursement akan muncul jika Anda telah membuatnya.',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              "Reimbursement Status",
                              style: TextStyle(
                                color: primaryBlue,
                                fontSize: 13,
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
            const SizedBox(height: 6),
            // Filter bulan (dropdown)
            Row(
              children: [
                DropdownButton<int>(
                  value: _selectedMonth,
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                  underline: const SizedBox(),
                  items: _bulanItems,
                  onChanged: (v) {
                    setState(() => _selectedMonth = v!);
                    _fetchHistory();
                  },
                ),
                const SizedBox(width: 4),
                DropdownButton<int>(
                  value: _selectedYear,
                  underline: const SizedBox(),
                  style: const TextStyle(fontSize: 14, color: Colors.black),
                  items: _tahunItems,
                  onChanged: (v) {
                    setState(() => _selectedYear = v!);
                    _fetchHistory();
                  },
                ),
                const Spacer(),
                Icon(
                  Icons.filter_alt_outlined,
                  size: 22,
                  color: Colors.black.withOpacity(.6),
                ),
              ],
            ),
            const SizedBox(height: 4),
            // Daftar pengajuan reimbursement: GANTI tampilannya pakai ListTile sesuai gambar
            Expanded(
              child: Card(
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: const BorderSide(color: cardBorder),
                ),
                clipBehavior: Clip.hardEdge,
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: EdgeInsets.zero,
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : _history.isEmpty
                      ? const Center(child: Text('Belum ada pengajuan'))
                      : ListView.separated(
                          itemCount: _history.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (_, i) {
                            final h = _history[i];
                            return ListTile(
                              minLeadingWidth: 0,
                              dense: true,
                              leading: Icon(
                                Icons.receipt_long,
                                color: primaryBlue,
                                size: 24,
                              ),
                              title: Text(
                                h.description,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15,
                                ),
                              ),
                              subtitle: Text(
                                DateFormat(
                                  'dd MMM yyyy',
                                  'id_ID',
                                ).format(h.startDate),
                                style: const TextStyle(
                                  color: Colors.black45,
                                  fontSize: 13,
                                ),
                              ),
                              trailing: Text(
                                NumberFormat.currency(
                                  locale: 'id_ID',
                                  symbol: 'Rp',
                                  decimalDigits: 0,
                                ).format(h.amount),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            // Ajukan reimbursement tombol
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryBlue,
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  final res = await Navigator.push<bool?>(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ReimbursementFormPage(),
                    ),
                  );
                  if (res == true) await _fetchHistory();
                },
                child: const Text('Ajukan reimburse'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
