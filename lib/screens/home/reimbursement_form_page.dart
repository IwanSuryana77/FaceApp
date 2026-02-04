import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

const primaryBlue = Color(0xFF3F7DF4);
const lightGrey = Color(0xFFF7F8FA);
const darkGrey = Color(0xFF8E8E93);
const lightBlue = Color(0xFFE8F4FD);

class _BenefitItem {
  String name;
  int amount;
  String? notes;
  _BenefitItem(this.name, this.amount, {this.notes});
}

const cloudinaryUploadPreset = "facesign_unsigned";

class ReimbursementFormPage extends StatefulWidget {
  const ReimbursementFormPage({super.key});
  @override
  State<ReimbursementFormPage> createState() => _ReimbursementFormPageState();
}

class _ReimbursementFormPageState extends State<ReimbursementFormPage> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate = DateTime.now();
  bool _loading = false;

  final _descCtrl = TextEditingController();
  String? _selectedPolicy;
  final List<String> _policies = [
    'Standar Reimbursement',
    'Transportasi',
    'Uang Makan',
  ];

  final List<PlatformFile> _files = [];
  final List<_BenefitItem> _items = [];
  int get _totalAmount => _items.fold(0, (sum, e) => sum + e.amount);

  Future<void> _pickFiles() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png', 'xlsx', 'docx', 'doc', 'txt', 'ppt'],
    );
    if (result != null) {
      setState(() {
        if (_files.length + result.files.length > 5) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Maksimal 5 file')));
        } else {
          _files.addAll(result.files.where((f) => f.bytes != null && f.size <= 10 * 1024 * 1024));
        }
      });
    }
  }

  Future<List<String>> _uploadFiles() async {
    List<String> urls = [];
    for (final file in _files) {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.cloudinary.com/v1_1/dv8zwl76d/auto/upload'),
      )
        ..fields['upload_preset'] = cloudinaryUploadPreset
        ..files.add(http.MultipartFile.fromBytes('file', file.bytes!, filename: file.name));

      final response = await request.send();
      final body = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        urls.add(json.decode(body)['secure_url']);
      } else {
        throw Exception('Upload gagal');
      }
    }
    return urls;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pilih tanggal transaksi')));
      return;
    }
    if (_items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tambahkan item benefit')));
      return;
    }

    setState(() => _loading = true);
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User belum login');

      final urls = await _uploadFiles();
      final refCode = 'REF-${DateFormat('yyyyMMdd').format(DateTime.now())}-${user.uid.substring(0, 3)}';

      await FirebaseFirestore.instance.collection('reimbursement_requests').add({
        'employeeId': user.uid,
        'description': _descCtrl.text.trim(),
        'policy': _selectedPolicy,
        'startDate': Timestamp.fromDate(_selectedDate!),
        'amount': _totalAmount.toDouble(),
        'attachmentUrls': urls,
        'createdAt': Timestamp.now(),
        'status': 'Menunggu',
        'refCode': refCode,
        'items': _items.map((e) => {'name': e.name, 'amount': e.amount, 'notes': e.notes ?? ''}).toList(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pengajuan berhasil'), backgroundColor: Colors.green));
      }
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
    setState(() => _loading = false);
  }

  void _addBenefitItem() async {
    final nameCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    final notesCtrl = TextEditingController();

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Tambah Item Benefit'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nama')),
            TextField(controller: amountCtrl, decoration: const InputDecoration(labelText: 'Jumlah'), keyboardType: TextInputType.number),
            TextField(controller: notesCtrl, decoration: const InputDecoration(labelText: 'Catatan')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: primaryBlue),
            onPressed: () {
              if (nameCtrl.text.isNotEmpty && int.tryParse(amountCtrl.text) != null) {
                setState(() {
                  _items.add(_BenefitItem(nameCtrl.text, int.parse(amountCtrl.text), notes: notesCtrl.text));
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Tambah'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightGrey,
      appBar: AppBar(
        title: const Text('Pengajuan Reimbursement'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Form field utama dalam Card
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical:24, horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButtonFormField<String>(
                          decoration: const InputDecoration(labelText: 'Kebijakan reimbursement *', border: OutlineInputBorder()),
                          value: _selectedPolicy,
                          items: _policies.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                          onChanged: (v) => setState(()=> _selectedPolicy = v),
                          validator: (v) => v==null ? 'Pilih kebijakan' : null,
                        ),
                        const SizedBox(height: 16),
                        // Datepicker custom tampilan flat
                        InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () async {
                            final picked = await showDatePicker(
                              context: context,
                              initialDate: _selectedDate!,
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now().add(const Duration(days: 366)),
                            );
                            if (picked != null) setState(() => _selectedDate = picked);
                          },
                          child: InputDecorator(
                            decoration: const InputDecoration(
                              labelText: 'Tanggal transaksi *',
                              border: OutlineInputBorder(),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _selectedDate == null
                                    ? '-' 
                                    : DateFormat('dd MMMM yyyy', 'id_ID').format(_selectedDate!),
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const Icon(Icons.calendar_today, size: 20, color: darkGrey),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Lampiran
                        Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Lampiran",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              const SizedBox(height: 4),
                              Text(
                                "Anda dapat mengunggah maksimal 5 file dan harus berupa PDF, JPG, PNG, XLS, DOCX, DOC, TXT, atau PPT.",
                                style: TextStyle(fontSize: 12, color: darkGrey),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _descCtrl,
                                minLines: 2,
                                maxLines: 4,
                                decoration: const InputDecoration(
                                  labelText: 'Deskripsi',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: _pickFiles,
                                    child: const Text('Tambah Lampiran'),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(_files.isEmpty ? 'Belum ada file' : '${_files.length} file dipilih')
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),

                // Item benefit
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical:20, horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Item benefit", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                        const SizedBox(height: 8),
                        ..._items.map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(item.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
                                    if(item.notes != null && item.notes!.isNotEmpty)
                                      Text(item.notes!, style: const TextStyle(color: Colors.black54, fontSize: 13),),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(item.amount),
                                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red, size: 22),
                                    onPressed: () {
                                      setState(()=> _items.remove(item));
                                    })
                                ],
                              )
                            ],
                          ),
                        )),
                        if(_items.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text("Belum ada item benefit", style: TextStyle(color: Colors.grey[400])),
                          ),
                        const Divider(height: 24),
                        // Tombol tambah item + total
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                icon: const Icon(Icons.add, size: 18),
                                label: const Text("Tambahkan Item", style: TextStyle(fontWeight: FontWeight.bold)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: lightBlue,
                                  foregroundColor: primaryBlue,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                ),
                                onPressed: _addBenefitItem,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Total Jumlah pengajuan', style: TextStyle(fontWeight: FontWeight.w500)),
                            Text(
                              NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(_totalAmount),
                              style: TextStyle(color: primaryBlue, fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Tombol kirim
                SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryBlue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    onPressed: _loading ? null : _submit,
                    child: _loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Kirim'),
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