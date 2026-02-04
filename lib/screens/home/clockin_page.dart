import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const primaryPurple = Color(0xFF242484);

class ClockInPage extends StatefulWidget {
  final String userId;
  final bool isCheckOut;

  const ClockInPage({
    required this.userId,
    required this.isCheckOut,
    super.key,
  });

  @override
  State<ClockInPage> createState() => _ClockInPageState();
}

class _ClockInPageState extends State<ClockInPage> {
  String? namaLokasi;
  double? latitude;
  double? longitude;
  XFile? fotoWajah;
  final TextEditingController _catatanCtrl = TextEditingController();
  bool _loading = false;
  DateTime now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _ambilLokasi();
  }

  // ================== LOKASI ==================
  Future<void> _ambilLokasi() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _snack('Aktifkan GPS');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _snack('Izin lokasi ditolak');
          return;
        }
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final placemarks =
          await placemarkFromCoordinates(pos.latitude, pos.longitude);

      setState(() {
        latitude = pos.latitude;
        longitude = pos.longitude;
        namaLokasi = placemarks.isNotEmpty
            ? '${placemarks.first.street}, ${placemarks.first.locality}'
            : 'Lokasi tidak diketahui';
      });
    } catch (e) {
      _snack('Lokasi error: $e');
    }
  }

  // ================== FOTO ==================
  Future<void> _ambilFoto() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => CameraFaceDialog(
        onConfirm: (file) {
          setState(() => fotoWajah = file);
        },
      ),
    );
  }

  // ================== FACE DETECT ==================
  Future<bool> _cekAdaWajah(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final faceDetector =
        FaceDetector(options: FaceDetectorOptions(enableContours: false));
    final faces = await faceDetector.processImage(inputImage);
    await faceDetector.close();
    return faces.isNotEmpty;
  }

  // ================== CLOUDINARY ==================
  Future<String?> uploadToCloudinary(File imageFile) async {
    const uploadPreset = 'facesign_unsigned';

    final uri =
        Uri.parse('https://api.cloudinary.com/v1_1/dv8zwl76d/image/upload');

    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', imageFile.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final resStr = await response.stream.bytesToString();
      return json.decode(resStr)['secure_url'];
    }
    return null;
  }

  // ================== KIRIM ==================
  Future<void> _kirimAbsensi() async {
    if (fotoWajah == null) {
      _snack('Foto wajib diambil');
      return;
    }

    setState(() => _loading = true);

    try {
      final adaWajah = await _cekAdaWajah(File(fotoWajah!.path));
      if (!adaWajah) {
        _snack('Wajah tidak terdeteksi');
        return;
      }

      final fotoUrl =
          await uploadToCloudinary(File(fotoWajah!.path));

      if (fotoUrl == null) {
        _snack('Upload gagal');
        return;
      }

      final hariKey = DateFormat('yyyy-MM-dd').format(now);
      final waktu = DateFormat('HH:mm:ss').format(now);

      await FirebaseFirestore.instance
          .collection('absensi')
          .doc(widget.userId)
          .collection('hari')
          .doc(hariKey)
          .set({
        widget.isCheckOut ? 'checkOut' : 'checkIn': {
          'waktu': waktu,
          'lokasi': namaLokasi,
          'lat': latitude,
          'lng': longitude,
          'fotoUrl': fotoUrl,
          'catatan': _catatanCtrl.text,
          'timestamp': FieldValue.serverTimestamp(),
        }
      }, SetOptions(merge: true));

      _snack('Absensi berhasil');
      Navigator.pop(context);
    } catch (e) {
      _snack('Error: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isCheckOut ? 'Jam Pulang' : 'Jam Masuk'),
        backgroundColor: primaryPurple,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          ElevatedButton(
            onPressed: _ambilFoto,
            child: const Text('Ambil Foto Wajah'),
          ),
          if (fotoWajah != null)
            Image.file(File(fotoWajah!.path), height: 200),
          TextField(
            controller: _catatanCtrl,
            decoration: const InputDecoration(labelText: 'Catatan'),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _loading ? null : _kirimAbsensi,
            child: _loading
                ? const CircularProgressIndicator()
                : const Text('Kirim Absensi'),
          ),
        ],
      ),
    );
  }
}

// ================== CAMERA DIALOG ==================
class CameraFaceDialog extends StatefulWidget {
  final Function(XFile) onConfirm;
  const CameraFaceDialog({required this.onConfirm, super.key});

  @override
  State<CameraFaceDialog> createState() => _CameraFaceDialogState();
}

class _CameraFaceDialogState extends State<CameraFaceDialog> {
  CameraController? controller;
  XFile? file;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();

      final frontCamera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      controller = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await controller!.initialize();

      if (mounted) setState(() {});
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kamera tidak tersedia')),
      );
    }
  }

  Future<void> _takePicture() async {
    if (controller == null || !controller!.value.isInitialized) return;

    file = await controller!.takePicture();
    setState(() {});
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        height: 400,
        child: Column(
          children: [
            Expanded(
              child: controller == null ||
                      !controller!.value.isInitialized
                  ? const Center(child: CircularProgressIndicator())
                  : file == null
                      ? CameraPreview(controller!)
                      : Image.file(File(file!.path)),
            ),
            ElevatedButton(
              onPressed: file == null
                  ? _takePicture
                  : () {
                      widget.onConfirm(file!);
                      Navigator.pop(context);
                    },
              child: Text(file == null ? 'Foto' : 'Konfirmasi'),
            )
          ],
        ),
      ),
    );
  }
}
