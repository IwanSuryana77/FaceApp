import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class LemburPage extends StatefulWidget {
  const LemburPage({super.key});

  @override
  State<LemburPage> createState() => _LemburPageState();
}

class _LemburPageState extends State<LemburPage> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  DateTime? tanggalLembur;
  TimeOfDay? jamMulai;
  TimeOfDay? jamSelesai;
  String alasan = '';
  List<PlatformFile> attachments = [];

  // For Firestore status & history
  DocumentReference? lastSubmissionRef;

  // ================= CLOUDINARY =================
  static const String cloudName = 'dv8zwl76d';
  static const String uploadPreset = 'facesign_unsigned';

  Future<String> uploadToCloudinary(PlatformFile file) async {
    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/$cloudName/raw/upload',
    );

    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(
        http.MultipartFile.fromBytes(
          'file',
          file.bytes!,
          filename: file.name,
        ),
      );

    final response = await request.send();

    if (response.statusCode == 200) {
      final resStr = await response.stream.bytesToString();
      final data = json.decode(resStr);
      return data['secure_url'];
    } else {
      throw Exception('Upload Cloudinary gagal');
    }
  }

  // ================= PICK FILE =================
  Future<void> pickFiles() async {
    if (attachments.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maksimal 5 file')),
      );
      return;
    }

    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: true,
    );

    if (result != null) {
      setState(() {
        attachments.addAll(
          result.files.take(5 - attachments.length),
        );
      });
    }
  }

  // ================= ESTIMASI JAM =================
  double get estimasiJam {
    if (jamMulai != null && jamSelesai != null) {
      final mulai = DateTime(0, 0, 0, jamMulai!.hour, jamMulai!.minute);
      final selesai = DateTime(0, 0, 0, jamSelesai!.hour, jamSelesai!.minute);
      final diff = selesai.difference(mulai);
      if (diff.inMinutes > 0) {
        return diff.inMinutes / 60.0;
      }
    }
    return 0.0;
  }

  // ================= SUBMIT =================
  Future<void> submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      List<String> uploadedUrls = [];

      for (final file in attachments) {
        final url = await uploadToCloudinary(file);
        uploadedUrls.add(url);
      }

      final newSubmission = {
        'tanggal_lembur': tanggalLembur?.toIso8601String(),
        'jam_mulai': jamMulai != null
            ? '${jamMulai!.hour.toString().padLeft(2, '0')}:${jamMulai!.minute.toString().padLeft(2, '0')}'
            : null,
        'jam_selesai': jamSelesai != null
            ? '${jamSelesai!.hour.toString().padLeft(2, '0')}:${jamSelesai!.minute.toString().padLeft(2, '0')}'
            : null,
        'estimasi_jam': estimasiJam,
        'alasan': alasan,
        'lampiran_urls': uploadedUrls,
        'created_at': FieldValue.serverTimestamp(),
        'status': 'Pengajuan dibuat',
        // bisa tambahkan field lain yang dibutuhkan
      };

      final ref = await FirebaseFirestore.instance.collection('lembur').add(newSubmission);

      setState(() {
        loading = false;
        lastSubmissionRef = ref;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Pengajuan lembur berhasil')),
      );

      // Jangan pop, update status di halaman
      // Navigator.pop(context);
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Gagal: $e')),
      );
    }
  }

  // ================== UI ===================
  @override
  Widget build(BuildContext context) {
    final textColor = Colors.grey[600];

    return Scaffold(
      appBar: AppBar(title: const Text('Lembur')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              children: [
                // Card: Form Pengajuan Lembur
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Form Pengajuan Lembur', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 16),

                          // Tanggal pick
                          Text('Tanggal', style: TextStyle(color: textColor)),
                          ListTile(
                            title: Text(
                              tanggalLembur == null
                                  ? 'Pilih Tanggal'
                                  : DateFormat('yyyy-MM-dd').format(tanggalLembur!),
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                            trailing: const Icon(Icons.calendar_today, size: 18),
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2030),
                                initialDate: tanggalLembur ?? DateTime.now(),
                              );
                              if (picked != null) {
                                setState(() => tanggalLembur = picked);
                              }
                            },
                          ),
                          const SizedBox(height: 8),

                          // Jam Mulai & Jam Selesai
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Jam Mulai', style: TextStyle(color: textColor)),
                                    GestureDetector(
                                      onTap: () async {
                                        final picked = await showTimePicker(
                                          context: context,
                                          initialTime: jamMulai ?? TimeOfDay(hour: 17, minute: 0),
                                        );
                                        if (picked != null) setState(() => jamMulai = picked);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey.shade300),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          jamMulai != null
                                              ? '${jamMulai!.format(context)}'
                                              : 'Pilih Jam',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Jam Selesai', style: TextStyle(color: textColor)),
                                    GestureDetector(
                                      onTap: () async {
                                        final picked = await showTimePicker(
                                          context: context,
                                          initialTime: jamSelesai ?? TimeOfDay(hour: 20, minute: 0),
                                        );
                                        if (picked != null) setState(() => jamSelesai = picked);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey.shade300),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          jamSelesai != null
                                              ? '${jamSelesai!.format(context)}'
                                              : 'Pilih Jam',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Alasan lembur
                          TextFormField(
                            maxLines: 3,
                            decoration: const InputDecoration(
                              labelText: 'Alasan Lembur',
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                            onChanged: (v) => alasan = v,
                          ),

                          const SizedBox(height: 12),

                          // Lampiran
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Lampiran (${attachments.length}/5)',
                                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                              ),
                              TextButton.icon(
                                onPressed: pickFiles,
                                icon: const Icon(Icons.attach_file, size: 18),
                                label: const Text('Tambah'),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero, minimumSize: Size(80, 28),
                                ),
                              )
                            ],
                          ),
                          Wrap(
                            spacing: 8,
                            children: attachments
                                .map(
                                  (f) => Chip(
                                    label: Text(f.name, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)),
                                    onDeleted: () { setState(() => attachments.remove(f)); },
                                  ),
                                )
                                .toList(),
                          ),
                          const SizedBox(height: 16),

                          // BUTTON
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: loading ? null : submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF3F7DF4),
                                foregroundColor: Colors.white,
                                minimumSize: const Size(0, 44),
                              ),
                              child: loading
                                  ? const CircularProgressIndicator(color: Colors.white)
                                  : const Text('Ajukan Lembur', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Card: PERHITUNGAN JAM
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        Text('Total Estimasi Jam Lembur:',
                            style: TextStyle(color: textColor)),
                        const SizedBox(width: 8),
                        Text(
                          '${estimasiJam.toStringAsFixed(1)} Jam',
                          style: const TextStyle(
                              color: Color(0xFF3F7DF4),
                              fontWeight: FontWeight.bold,
                              fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Card: STATUS PERSETUJUAN TERBARU (Jika ada)
                if (lastSubmissionRef != null)
                  FutureBuilder<DocumentSnapshot>(
                    future: lastSubmissionRef!.get(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || !snapshot.data!.exists) {
                        return Container();
                      }
                      final data = snapshot.data!.data() as Map<String, dynamic>;
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Status Persetujuan Terbaru', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Icon(Icons.access_time, size: 20, color: Colors.grey[600]),
                                  const SizedBox(width: 8),
                                  Text('Pengajuan Dibuat',
                                      style: const TextStyle(fontWeight: FontWeight.bold)),
                                  const SizedBox(width: 8),
                                  Chip(
                                    label: Text(data['status'], style: const TextStyle(fontSize: 12)),
                                    backgroundColor: Colors.blue[50],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 28.0, top: 2),
                                child: Text(
                                  data['alasan'] ?? "",
                                  style: TextStyle(color: textColor, fontSize: 13),
                                ),
                              ),
                              const SizedBox(height: 8),
                              if (data['created_at'] != null)
                                Padding(
                                  padding: const EdgeInsets.only(left: 28.0),
                                  child: Text(
                                    DateFormat("dd MMM yyyy, HH:mm").format(
                                      (data['created_at'] as Timestamp).toDate(),
                                    ),
                                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                const SizedBox(height: 16),

                // Card: RIWAYAT PENGAJUAN LEMBUR
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Riwayat Pengajuan Lembur', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 6),
                        StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('lembur')
                              .orderBy('created_at', descending: true)
                              .limit(10)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircularProgressIndicator(strokeWidth: 1.7),
                              );
                            }
                            final docs = snapshot.data!.docs;
                            if (docs.isEmpty) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Text('Belum ada pengajuan lembur.', style: TextStyle(color: Colors.grey)),
                              );
                            }
                            return ListView.builder(
                              shrinkWrap: true,
                              itemCount: docs.length,
                              itemBuilder: (c, i) {
                                final d = docs[i].data() as Map<String, dynamic>;
                                final tanggal =
                                    d['tanggal_lembur'] != null
                                        ? DateFormat('dd MMM yyyy').format(DateTime.parse(d['tanggal_lembur']))
                                        : '-';
                                final jam =
                                    d['estimasi_jam'] != null
                                        ? '${d['estimasi_jam'] ?? '-'} Jam'
                                        : '-';
                                final status = d['status'] ?? '-';
                                final Color statusColor =
                                    status == 'Disetujui'
                                        ? Colors.green
                                        : status == 'Ditolak'
                                            ? Colors.red
                                            : Colors.grey;
                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  minVerticalPadding: 4,
                                  leading: Icon(Icons.calendar_today, size: 20, color: Colors.indigo[200]),
                                  title: Text(tanggal, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
                                  subtitle: Text(jam, style: const TextStyle(fontSize: 13)),
                                  trailing: Chip(
                                    label: Text(status, style: TextStyle(color: statusColor)),
                                    backgroundColor: statusColor.withOpacity(0.09),
                                    visualDensity: VisualDensity.compact,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
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

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:file_picker/file_picker.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:http/http.dart' as http;

// class LemburPage extends StatefulWidget {
//   const LemburPage({super.key});

//   @override
//   State<LemburPage> createState() => _LemburPageState();
// }

// class _LemburPageState extends State<LemburPage> {
//   final _formKey = GlobalKey<FormState>();
//   bool loading = false;

//   DateTime? tanggalLembur;
//   String shift = '';
//   String sebelumLembur = '';
//   String sebelumIstirahat = '';
//   String sesudahLembur = '';
//   String sesudahIstirahat = '';
//   String kompensasi = '';
//   String alasan = '';

//   List<PlatformFile> attachments = [];

//   // ================= CLOUDINARY =================
//   static const String cloudName = 'dv8zwl76d'; // GANTI JIKA BEDA
//   static const String uploadPreset = 'facesign_unsigned';

//   Future<String> uploadToCloudinary(PlatformFile file) async {
//     final uri = Uri.parse(
//       'https://api.cloudinary.com/v1_1/$cloudName/raw/upload',
//     );

//     final request = http.MultipartRequest('POST', uri)
//       ..fields['upload_preset'] = uploadPreset
//       ..files.add(
//         http.MultipartFile.fromBytes(
//           'file',
//           file.bytes!,
//           filename: file.name,
//         ),
//       );

//     final response = await request.send();

//     if (response.statusCode == 200) {
//       final resStr = await response.stream.bytesToString();
//       final data = json.decode(resStr);
//       return data['secure_url'];
//     } else {
//       throw Exception('Upload Cloudinary gagal');
//     }
//   }

//   // ================= PICK FILE =================
//   Future<void> pickFiles() async {
//     if (attachments.length >= 5) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Maksimal 5 file')),
//       );
//       return;
//     }

//     final result = await FilePicker.platform.pickFiles(
//       allowMultiple: true,
//       withData: true,
//     );

//     if (result != null) {
//       setState(() {
//         attachments.addAll(
//           result.files.take(5 - attachments.length),
//         );
//       });
//     }
//   }

//   // ================= SUBMIT =================
//   Future<void> submit() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() => loading = true);

//     try {
//       List<String> uploadedUrls = [];

//       for (final file in attachments) {
//         final url = await uploadToCloudinary(file);
//         uploadedUrls.add(url);
//       }

//       await FirebaseFirestore.instance.collection('lembur').add({
//         'tanggal_lembur': tanggalLembur?.toIso8601String(),
//         'shift': shift,
//         'sebelum_lembur': sebelumLembur,
//         'sebelum_istirahat': sebelumIstirahat,
//         'sesudah_lembur': sesudahLembur,
//         'sesudah_istirahat': sesudahIstirahat,
//         'kompensasi': kompensasi,
//         'alasan': alasan,
//         'lampiran_urls': uploadedUrls,
//         'created_at': FieldValue.serverTimestamp(),
//       });

//       setState(() => loading = false);

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('✅ Pengajuan lembur berhasil')),
//       );

//       Navigator.pop(context);
//     } catch (e) {
//       setState(() => loading = false);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('❌ Gagal: $e')),
//       );
//     }
//   }

//   // ================= UI =================
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Pengajuan Lembur')),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               // TANGGAL
//               ListTile(
//                 title: Text(
//                   tanggalLembur == null
//                       ? 'Pilih Tanggal Lembur'
//                       : tanggalLembur!.toLocal().toString().split(' ')[0],
//                 ),
//                 trailing: const Icon(Icons.calendar_today),
//                 onTap: () async {
//                   final picked = await showDatePicker(
//                     context: context,
//                     firstDate: DateTime(2020),
//                     lastDate: DateTime(2030),
//                     initialDate: DateTime.now(),
//                   );
//                   if (picked != null) {
//                     setState(() => tanggalLembur = picked);
//                   }
//                 },
//               ),

//               textField('Shift', (v) => shift = v),
//               textField('Sebelum Lembur', (v) => sebelumLembur = v),
//               textField('Sebelum Istirahat', (v) => sebelumIstirahat = v),
//               textField('Sesudah Lembur', (v) => sesudahLembur = v),
//               textField('Sesudah Istirahat', (v) => sesudahIstirahat = v),
//               textField('Kompensasi', (v) => kompensasi = v),
//               textField('Alasan', (v) => alasan = v, maxLines: 3),

//               const SizedBox(height: 16),

//               // ATTACHMENTS
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   'Lampiran (${attachments.length}/5)',
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//               ),
//               const SizedBox(height: 8),

//               Wrap(
//                 spacing: 8,
//                 children: attachments
//                     .map(
//                       (f) => Chip(
//                         label: Text(
//                           f.name,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                         onDeleted: () {
//                           setState(() => attachments.remove(f));
//                         },
//                       ),
//                     )
//                     .toList(),
//               ),

//               const SizedBox(height: 8),

//               ElevatedButton.icon(
//                 onPressed: pickFiles,
//                 icon: const Icon(Icons.attach_file),
//                 label: const Text('Tambah Lampiran'),
//               ),

//               const SizedBox(height: 24),

//               loading
//                   ? const CircularProgressIndicator()
//                   : SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: submit,
//                         child: const Text('KIRIM'),
//                       ),
//                     ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget textField(
//     String label,
//     Function(String) onChanged, {
//     int maxLines = 1,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 12),
//       child: TextFormField(
//         maxLines: maxLines,
//         decoration: InputDecoration(
//           labelText: label,
//           border: const OutlineInputBorder(),
//         ),
//         validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
//         onChanged: onChanged,
//       ),
//     );
//   }
// }
