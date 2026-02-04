import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

const primaryPurple = Color(0xFF3F7DF4);

class FaceVerificationPage extends StatefulWidget {
  final String userId;
  final bool isCheckOut;
  final DateTime today;
  const FaceVerificationPage({
    required this.userId,
    required this.isCheckOut,
    required this.today,
    super.key,
  });
  @override
  State<FaceVerificationPage> createState() => _FaceVerificationPageState();
}

class _FaceVerificationPageState extends State<FaceVerificationPage> {
  CameraController? controller;
  bool _loading = false;
  String? _log;
  String? _error;

  @override
  void initState() {
    super.initState();
    _requestPermissionAndInitCamera();
  }

  Future<void> _requestPermissionAndInitCamera() async {
    try {
      if (!kIsWeb) {
        final status = await Permission.camera.request();
        if (!status.isGranted) {
          setState(() {
            _error = "Permission kamera ditolak. Aktifkan izin aplikasi!";
          });
          return;
        }
      }
      await _initCamera();
    } catch (e) {
      setState(() {
        _error = "Gagal menginisialisasi kamera: $e";
      });
    }
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) throw Exception("Tidak ditemukan kamera di device");
      final frontCam = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      final camController = CameraController(
        frontCam,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await camController.initialize();
      setState(() {
        controller = camController;
      });
    } on CameraException catch (e) {
      var message = e.description ?? e.code;
      if (e.code == 'cameraNotReadable') {
        message = kIsWeb
            ? 'Kamera tidak dapat diakses. Pastikan browser diberi izin akses kamera dan tidak ada tab/ aplikasi lain yang mengunci kamera.'
            : 'Kamera tidak dapat dibaca. Pastikan kamera tidak digunakan oleh aplikasi lain dan perangkat memiliki kamera yang berfungsi.';
      }
      setState(() {
        _error = "Kamera gagal: $message";
      });
    } catch (e) {
      setState(() {
        _error = "Kamera gagal: $e";
      });
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Future<void> _detectAndVerify(BuildContext context) async {
    setState(() {
      _loading = true;
      _log = null;
      _error = null;
    });

    try {
      if (controller == null || !controller!.value.isInitialized) {
        setState(() {
          _error =
              'Kamera belum siap. Coba lagi atau periksa izin akses kamera.';
          _loading = false;
        });
        return;
      }
      // 1. FOTO SELFIE
      final XFile photo = await controller!.takePicture();
      final File file = File(photo.path);
      setState(() => _log = "Memverifikasi wajah...");

      // 2. AMBIL URL ENROLL DARI FIRESTORE USER
      final userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();
      String enrollUrl;
      try {
        enrollUrl = userSnap.get('enrollUrl') as String;
      } catch (_) {
        enrollUrl =
            'https://res.cloudinary.com/dqu4sucua/image/upload/v1770211193/foto_mfelor.jpg';
      }

      // 3. KIRIM SELFIE + ENROLL URL ke REST API FACE VERIFICATION
      final apiEndpoint =
          "https://my-backend-api/face_verification"; // Ganti dengan endpoint backend face recognition
      final req = http.MultipartRequest('POST', Uri.parse(apiEndpoint));
      req.files.add(await http.MultipartFile.fromPath('selfie', file.path));
      req.fields['enrollUrl'] = enrollUrl;
      final resp = await req.send();

      if (resp.statusCode == 200) {
        final respBody = await resp.stream.bytesToString();
        final response = json.decode(respBody);
        if (response['match'] != true) {
          setState(() {
            _error = "Wajah tidak cocok! Absen gagal.";
            _loading = false;
          });
          return;
        }
      } else {
        setState(() {
          _error = "Verifikasi gagal (server).";
          _loading = false;
        });
        return;
      }

      // 4. Lokasi
      setState(() => _log = "Mengambil lokasi...");
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final waktu = DateTime.now();
      final lokasi = "${pos.latitude},${pos.longitude}";
      final dateKey =
          "${widget.today.year.toString().padLeft(4, '0')}-${widget.today.month.toString().padLeft(2, '0')}-${widget.today.day.toString().padLeft(2, '0')}";

      // 5. Simpan absen Firestore
      await FirebaseFirestore.instance
          .collection('absensi')
          .doc(widget.userId)
          .collection('hari')
          .doc(dateKey)
          .set({
            widget.isCheckOut ? 'checkOut' : 'checkIn': {
              'waktu':
                  "${waktu.hour.toString().padLeft(2, '0')}:${waktu.minute.toString().padLeft(2, '0')}",
              'lokasi': lokasi,
              'catatan': "Absensi Wajah",
              'status': "Absen Berhasil",
            },
          }, SetOptions(merge: true));
      setState(() {
        _loading = false;
        _log = "Absen berhasil!";
      });
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      setState(() {
        _error = "Gagal absen: $e";
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: controller == null || !controller!.value.isInitialized
            ? _error != null
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            _error!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  setState(() {
                                    _error = null;
                                    _loading = false;
                                  });
                                  await _requestPermissionAndInitCamera();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: primaryPurple,
                                ),
                                child: const Text('Coba lagi'),
                              ),
                              const SizedBox(width: 12),
                              OutlinedButton(
                                onPressed: () => Navigator.pop(context),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  side: const BorderSide(color: Colors.white24),
                                ),
                                child: const Text('Tutup'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    )
            : Stack(
                children: [
                  Positioned.fill(child: CameraPreview(controller!)),
                  Positioned(
                    top: height * 0.18,
                    left: 26,
                    right: 26,
                    child: AspectRatio(
                      aspectRatio: 4 / 5,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blueAccent,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 44,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black87,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.face_retouching_natural,
                              size: 20,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 9),
                            Text(
                              _loading
                                  ? (_log ?? "Memverifikasi...")
                                  : "Memindai Wajah...",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    left: 12,
                    child: IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 26,
                      ),
                      onPressed: _loading ? null : () => Navigator.pop(context),
                    ),
                  ),
                  if (!_loading)
                    Positioned(
                      bottom: 54,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: ElevatedButton(
                          onPressed: () => _detectAndVerify(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 42,
                              vertical: 16,
                            ),
                            elevation: 8,
                          ),
                          child: Text(
                            widget.isCheckOut ? "Absen Pulang" : "Absen Masuk",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: primaryPurple,
                            ),
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.location_on_outlined,
                            size: 16,
                            color: Colors.white70,
                          ),
                          SizedBox(width: 3),
                          Text(
                            'Mendeteksi lokasi...',
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_error != null)
                    Positioned(
                      top: 92,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Text(
                          _error!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
