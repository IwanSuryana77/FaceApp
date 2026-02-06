import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';

const faceVerificationApiEndpoint =
    'https://amare-homochrome-gamogenetically.ngrok-free.dev/face_verification';
const cloudinaryPhotoUrl =
    'https://res.cloudinary.com/dqu4sucua/image/upload/v1770353703/pic_haudi_p4s3u1.jpg';
const primaryPurple = Color(0xFF3F7DF4);

class FaceVerificationPage extends StatefulWidget {
  final String userId;
  final String userName; // Boleh dikosongkan jika ingin auto-firestore
  final bool isCheckOut;
  const FaceVerificationPage({
    required this.userId,
    required this.userName,
    required this.isCheckOut,
    Key? key,
    required DateTime today,
  }) : super(key: key);

  @override
  State<FaceVerificationPage> createState() => _FaceVerificationPageState();
}

class _FaceVerificationPageState extends State<FaceVerificationPage> {
  CameraController? _controller;
  bool _loading = false;
  bool _userLoading = true;
  String? _log;
  String? _error;
  bool _cameraInitialized = false;
  String? userName;
  String? userEmail;
  Map<String, dynamic>? userData; // Data lengkap user dari Firestore
  String? _absenLokasiString;
  String? _alamatLengkap; // Alamat lengkap dari reverse geocoding

  @override
  void initState() {
    super.initState();
    _getUserData(); // Ambil semua data user
    _requestPermissionAndInitCamera();
  }

  /// Get semua data user dari Firestore
  Future<void> _getUserData() async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();
      
      if (userDoc.exists) {
        setState(() {
          userData = userDoc.data()!;
          userName = userData!['nama'] ?? userData!['name'] ?? '';
          userEmail = userData!['email'] ?? '';
          _userLoading = false;
        });
      } else {
        // Fallback ke data yang dikirim dari widget
        setState(() {
          userName = widget.userName.isNotEmpty ? widget.userName : '';
          _userLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        userName = widget.userName.isNotEmpty ? widget.userName : '';
        _userLoading = false;
      });
    }
  }

  Future<void> _requestPermissionAndInitCamera() async {
    try {
      final PermissionStatus status = await Permission.camera.request();
      if (!status.isGranted) {
        setState(() {
          _error = "Izin kamera ditolak.";
          _loading = false;
        });
        return;
      }
      await _initCamera();
    } catch (e) {
      setState(() {
        _error = "Gagal inisialisasi kamera: $e";
        _loading = false;
      });
    }
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) throw Exception("Tidak ada kamera di device");
      final frontCam = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );
      final camController = CameraController(
        frontCam,
        ResolutionPreset.low,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );
      await camController.initialize();
      setState(() {
        _controller = camController;
        _cameraInitialized = true;
        _loading = false;
      });
    } on CameraException catch (e) {
      setState(() {
        _error = "Kamera gagal: ${e.description ?? e.code}";
        _loading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  bool _isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.isAbsolute && (uri.scheme == "https" || uri.scheme == "http");
    } catch (_) {
      return false;
    }
  }

  /// Fungsi untuk mendapatkan alamat dari koordinat (reverse geocoding)
  Future<String?> _getAddressFromCoordinates(double lat, double lng) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        
        // Format alamat: Jalan, Kota, Provinsi, Kode Pos
        String address = '';
        if (place.street != null && place.street!.isNotEmpty) {
          address += place.street!;
        }
        if (place.subLocality != null && place.subLocality!.isNotEmpty) {
          address += ', ${place.subLocality}';
        }
        if (place.locality != null && place.locality!.isNotEmpty) {
          address += ', ${place.locality}';
        }
        if (place.subAdministrativeArea != null && place.subAdministrativeArea!.isNotEmpty) {
          address += ', ${place.subAdministrativeArea}';
        }
        if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) {
          address += ', ${place.administrativeArea}';
        }
        if (place.country != null && place.country!.isNotEmpty) {
          address += ', ${place.country}';
        }
        if (place.postalCode != null && place.postalCode!.isNotEmpty) {
          address += ' ${place.postalCode}';
        }
        
        return address.isNotEmpty ? address : null;
      }
    } catch (e) {
      print('Error getting address: $e');
    }
    return null;
  }

  Future<void> _getLiveLocation() async {
    setState(() {
      _absenLokasiString = null;
      _alamatLengkap = null;
    });
    try {
      // Check permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever ||
          permission == LocationPermission.denied) {
        throw Exception('Lokasi tidak diizinkan oleh user');
      }
      
      // Get position
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      );
      
      // Get address from coordinates
      final alamat = await _getAddressFromCoordinates(pos.latitude, pos.longitude);
      
      setState(() {
        _absenLokasiString = "${pos.latitude.toStringAsFixed(6)},${pos.longitude.toStringAsFixed(6)}";
        _alamatLengkap = alamat ?? "Alamat tidak dapat ditemukan";
      });
    } catch (e) {
      setState(() {
        _absenLokasiString = "Lokasi tidak tersedia";
        _alamatLengkap = "Gagal mendapatkan alamat";
      });
    }
  }

  Future<void> _detectAndVerify(BuildContext context) async {
    if (!mounted) return;
    setState(() {
      _loading = true;
      _log = "Mengambil foto...";
      _error = null;
    });
    
    // Validasi user data
    if (userName == null || userName!.isEmpty) {
      setState(() {
        _error = "Data user tidak ditemukan. Silakan login ulang atau hubungi admin.";
        _loading = false;
      });
      return;
    }

    // Validasi URL
    if (!_isValidUrl(faceVerificationApiEndpoint)) {
      setState(() {
        _error = "URL backend tidak valid!";
        _loading = false;
      });
      return;
    }
    if (!_isValidUrl(cloudinaryPhotoUrl)) {
      setState(() {
        _error = "URL enroll Cloudinary tidak valid!";
        _loading = false;
      });
      return;
    }

    // Ambil lokasi dengan alamat
    await _getLiveLocation();

    try {
      if (_controller == null || !_cameraInitialized) {
        setState(() {
          _error = 'Kamera belum siap.';
          _loading = false;
        });
        return;
      }

      final XFile photo = await _controller!.takePicture();
      setState(() => _log = "Mohon di tunggu...");

      final imageBytes = await photo.readAsBytes();
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(faceVerificationApiEndpoint),
      );
      request.fields['nama'] = userName!;
      request.fields['enroll_url'] = cloudinaryPhotoUrl;
      request.files.add(
        http.MultipartFile.fromBytes(
          'selfie',
          imageBytes,
          filename: 'selfie.jpg',
        ),
      );

      final http.StreamedResponse streamedResponse = await request.send();
      final String responseBody = await streamedResponse.stream.bytesToString();
      Map<String, dynamic> responseData;
      try {
        responseData = json.decode(responseBody);
      } catch (_) {
        responseData = {};
      }

      if (streamedResponse.statusCode == 200 && responseData['match'] == true) {
        await _handleSuccessResponse(responseData);
      } else {
        String msg;
        if (responseData['message'] != null) {
          msg = responseData['message'];
        } else if (responseData['error'] != null) {
          msg = responseData['error'];
        } else {
          msg = "Verifikasi gagal.";
        }
        setState(() {
          _error = msg;
          _loading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = "Terjadi kesalahan: ${e.toString().split('\n').first}";
        _loading = false;
      });
    }
  }

  Future<void> _handleSuccessResponse(Map<String, dynamic> responseData) async {
    setState(() => _log = "Menyimpan data absen...");
    try {
      final waktu = DateTime.now();
      final dateKey = DateFormat('yyyy-MM-dd').format(waktu);
      
      // Siapkan data untuk disimpan
      final absenData = {
        widget.isCheckOut ? 'checkOut' : 'checkIn': {
          'waktu': waktu.toIso8601String(),
          'jam': DateFormat('HH:mm').format(waktu),
          'tanggal': dateKey,
          'lokasi_koordinat': _absenLokasiString ?? "Tidak tersedia",
          'lokasi_alamat': _alamatLengkap ?? "Alamat tidak tersedia",
          'status': "Berhasil",
          'verifikasi': 'wajah',
          'similarity': (1 - (responseData['distance'] as double? ?? 0)) * 100,
          'distance': responseData['distance'],
          'nama': userName,
          'email': userEmail,
          'user_id': widget.userId,
          // Tambahkan data user lainnya jika diperlukan
          'divisi': userData?['divisi'] ?? '',
          'jabatan': userData?['jabatan'] ?? '',
        },
        'last_update': FieldValue.serverTimestamp(),
      };

      // Simpan ke Firestore
      await FirebaseFirestore.instance
          .collection('absensi')
          .doc(widget.userId)
          .collection('hari')
          .doc(dateKey)
          .set(absenData, SetOptions(merge: true));

      setState(() {
        _loading = false;
        _log = null;
      });
      
      _showSuccessDialog(responseData);
    } catch (e) {
      setState(() {
        _error = "Absen tersimpan gagal: $e";
        _loading = false;
      });
    }
  }

  void _showSuccessDialog(Map<String, dynamic> responseData) {
    final similarity = (1 - (responseData['distance'] as double? ?? 0)) * 100;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        title: Row(
          children: const [
            Icon(Icons.verified, color: Colors.green, size: 28),
            SizedBox(width: 10),
            Text(
              "Absen Berhasil",
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (userName != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text("Nama: $userName", 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            
            Text(
              widget.isCheckOut ? "Absen Pulang" : "Absen Masuk",
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            
            const SizedBox(height: 10),
            
            if (_alamatLengkap != null)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Lokasi Absen:",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(_alamatLengkap!,
                      style: const TextStyle(fontSize: 12)),
                    const SizedBox(height: 4),
                    if (_absenLokasiString != null)
                      Text("Koordinat: $_absenLokasiString",
                        style: const TextStyle(fontSize: 10, color: Colors.grey)),
                  ],
                ),
              ),
            
            const SizedBox(height: 10),
            
            Row(
              children: [
                const Icon(Icons.score, size: 16, color: Colors.blue),
                const SizedBox(width: 8),
                Text("Similarity: ${similarity.toStringAsFixed(1)}%",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            
            // Tampilkan data user lainnya jika ada
            if (userData?['divisi'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text("Divisi: ${userData!['divisi']}",
                  style: const TextStyle(fontSize: 12, color: Colors.black54)),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () =>
                Navigator.of(context).popUntil((route) => route.isFirst),
            style: TextButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text(
              "Selesai",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final timeText = DateFormat('HH.mm').format(now);
    final dateLabel = DateFormat('d MMM y', "en_US").format(now);
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // AppBar custom
            Container(
              width: double.infinity,
              color: primaryPurple,
              padding: const EdgeInsets.only(top: 8, left: 0, right: 0, bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: _loading ? null : () => Navigator.of(context).pop(),
                      ),
                      const Spacer(),
                      Container(
                        margin: const EdgeInsets.only(right: 14, top: 4),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(16)
                        ),
                        child: Text(
                          timeText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 22.0, bottom: 4),
                    child: Text(
                      widget.isCheckOut ? "Clock out" : "Clock in",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Padding(
                    padding: const EdgeInsets.only(left: 22, right: 22, bottom: 4, top: 2),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.event, color: primaryPurple, size: 19),
                          const SizedBox(width: 8),
                          Text(
                            "$dateLabel (08:00 - 16:00)",
                            style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          if (userData?['divisi'] != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: primaryPurple.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                userData!['divisi'],
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: primaryPurple,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Loading user dari firestore dulu
            if (_userLoading)
              const Padding(
                padding: EdgeInsets.only(top: 30),
                child: CircularProgressIndicator(color: primaryPurple),
              ),
            
            if (!_userLoading)
              Expanded(
                child: Stack(
                  children: [
                    if (_cameraInitialized && _controller != null && _controller!.value.isInitialized)
                      Positioned.fill(
                        child: Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CameraPreview(_controller!),
                              _DashedCircleOverlay(),
                              if (_loading)
                                Container(
                                  color: Colors.black38,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const CircularProgressIndicator(color: Colors.white, strokeWidth: 4),
                                        const SizedBox(height: 20),
                                        Text(
                                          _log ?? "Memverifikasi wajah...",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              if (_error != null && !_loading)
                                Positioned(
                                  top: 60,
                                  left: 40,
                                  right: 40,
                                  child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.9),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.error_outline, color: Colors.white, size: 23),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(_error!, textAlign: TextAlign.center,
                                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                        ),
                                        IconButton(
                                          onPressed: () { setState((){ _error = null; }); },
                                          icon: const Icon(Icons.close, color: Colors.white),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      )
                    else
                      Center(
                        child: _error == null
                            ? const CircularProgressIndicator(color: primaryPurple)
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.error_outline, color: primaryPurple, size: 48),
                                  const SizedBox(height: 12),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 20),
                                    child: Text(_error!, 
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(color: primaryPurple, fontWeight: FontWeight.bold)),
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: primaryPurple,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                                    ),
                                    onPressed: _requestPermissionAndInitCamera,
                                    child: const Text("Coba lagi", style: TextStyle(fontWeight: FontWeight.bold)),
                                  )
                                ],
                              ),
                      ),
                    Positioned(
                      left: 0, right: 0, bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(18, 16, 18, 26),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(23)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              offset: const Offset(0, -3),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Tampilkan data user
                            if (userName != null)
                              Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.only(bottom: 10),
                                decoration: BoxDecoration(
                                  color: primaryPurple.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.person, size: 17, color: primaryPurple),
                                        const SizedBox(width: 7),
                                        Text(
                                          userName!,
                                          style: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 16, 
                                            fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (userEmail != null && userEmail!.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(left: 24, top: 4),
                                        child: Text(
                                          userEmail!,
                                          style: const TextStyle(
                                            color: Colors.black54,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            
                            // Tampilkan lokasi
                            Container(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.only(bottom: 15),
                              decoration: BoxDecoration(
                                color: Colors.grey[50],
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.grey[200]!),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.location_on, size: 17, color: Colors.red),
                                      const SizedBox(width: 7),
                                      const Text(
                                        "Lokasi Absen:",
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      const Spacer(),
                                      if (_absenLokasiString != null)
                                        IconButton(
                                          icon: const Icon(Icons.refresh, size: 18),
                                          onPressed: _getLiveLocation,
                                          padding: EdgeInsets.zero,
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  if (_alamatLengkap != null)
                                    Text(
                                      _alamatLengkap!,
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 12,
                                      ),
                                    )
                                  else if (_absenLokasiString != null)
                                    Text(
                                      "Koordinat: $_absenLokasiString",
                                      style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 11,
                                      ),
                                    )
                                  else
                                    const Text(
                                      "Tekan tombol Kirim untuk mengambil lokasi...",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 11,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            
                            // Tombol Kirim
                            SizedBox(
                              width: double.infinity,
                              height: 48,
                              child: ElevatedButton(
                                onPressed: (_loading || _userLoading) ? null : () => _detectAndVerify(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryPurple,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                  elevation: 3,
                                ),
                                child: _loading
                                    ? const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Text("Memproses...", style: TextStyle(fontWeight: FontWeight.bold)),
                                        ],
                                      )
                                    : const Text("Kirim Absen", 
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Overlay bulat garis putus-putus seperti gambar contoh
class _DashedCircleOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomPaint(
        size: const Size(260, 320),
        painter: _DashedOvalPainter(),
      ),
    );
  }
}

class _DashedOvalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
    const double dashWidth = 13;
    const double dashSpace = 7;
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final Path path = Path()..addOval(rect);
    final PathMetrics metrics = path.computeMetrics();
    for (final metric in metrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final double length = dashWidth;
        canvas.drawPath(
          metric.extractPath(distance, distance + length),
          paint,
        );
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// import 'dart:convert';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:http/http.dart' as http;
// import 'package:permission_handler/permission_handler.dart';
// import 'package:intl/intl.dart';

// const faceVerificationApiEndpoint =
//     'https://amare-homochrome-gamogenetically.ngrok-free.dev/face_verification';
// const cloudinaryPhotoUrl =
//     'https://res.cloudinary.com/dqu4sucua/image/upload/v1770353703/pic_haudi_p4s3u1.jpg';
// const primaryPurple = Color(0xFF3F7DF4);

// class FaceVerificationPage extends StatefulWidget {
//   final String userId;
//   final String userName;
//   final bool isCheckOut;
//   const FaceVerificationPage({
//     required this.userId,
//     required this.userName,
//     required this.isCheckOut,
//     Key? key, required DateTime today,
//   }) : super(key: key);

//   @override
//   State<FaceVerificationPage> createState() => _FaceVerificationPageState();
// }

// class _FaceVerificationPageState extends State<FaceVerificationPage> {
//   CameraController? _controller;
//   bool _loading = false;
//   String? _log;
//   String? _error;
//   bool _cameraInitialized = false;

//   String? _absenLongitude;
//   String? _absenLatitude;
//   String? _absenLokasiString;

//   @override
//   void initState() {
//     super.initState();
//     _requestPermissionAndInitCamera();
//   }

//   Future<void> _requestPermissionAndInitCamera() async {
//     try {
//       final PermissionStatus status = await Permission.camera.request();
//       if (!status.isGranted) {
//         setState(() {
//           _error = "Izin kamera ditolak.";
//           _loading = false;
//         });
//         return;
//       }
//       await _initCamera();
//     } catch (e) {
//       setState(() {
//         _error = "Gagal inisialisasi kamera: $e";
//         _loading = false;
//       });
//     }
//   }

//   Future<void> _initCamera() async {
//     try {
//       final cameras = await availableCameras();
//       if (cameras.isEmpty) throw Exception("Tidak ada kamera di device");
//       final frontCam = cameras.firstWhere(
//         (c) => c.lensDirection == CameraLensDirection.front,
//         orElse: () => cameras.first,
//       );
//       final camController = CameraController(
//         frontCam,
//         ResolutionPreset.low,
//         enableAudio: false,
//         imageFormatGroup: ImageFormatGroup.jpeg,
//       );
//       await camController.initialize();
//       setState(() {
//         _controller = camController;
//         _cameraInitialized = true;
//         _loading = false;
//       });
//     } on CameraException catch (e) {
//       setState(() {
//         _error = "Kamera gagal: ${e.description ?? e.code}";
//         _loading = false;
//       });
//     }
//   }

//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }

//   bool _isValidUrl(String url) {
//     try {
//       final uri = Uri.parse(url);
//       return uri.isAbsolute && (uri.scheme == "https" || uri.scheme == "http");
//     } catch (_) {
//       return false;
//     }
//   }

//   /// Ambil lokasi SAAT akan absen & tampilkan live di bawah.
//   /// Panggil fungsi ini tiap tombol "Kirim" ditekan
//   Future<void> _getLiveLocation() async {
//     setState(() {
//       _absenLatitude = null;
//       _absenLongitude = null;
//       _absenLokasiString = null;
//     });
//     try {
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//       }
//       if (permission == LocationPermission.deniedForever ||
//           permission == LocationPermission.denied) {
//         throw Exception('Lokasi tidak diizinkan oleh user');
//       }
//       final pos = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//       setState(() {
//         _absenLatitude = pos.latitude.toString();
//         _absenLongitude = pos.longitude.toString();
//         _absenLokasiString = "${pos.latitude}, ${pos.longitude}";
//       });
//     } catch (e) {
//       setState(() {
//         _absenLokasiString = "Lokasi tidak tersedia";
//       });
//     }
//   }

//   Future<void> _detectAndVerify(BuildContext context) async {
//     if (!mounted) return;
//     setState(() {
//       _loading = true;
//       _log = "Mengambil foto...";
//       _error = null;
//     });

//     if (!_isValidUrl(faceVerificationApiEndpoint)) {
//       setState(() {
//         _error = "URL backend tidak valid!";
//         _loading = false;
//       });
//       return;
//     }
//     if (!_isValidUrl(cloudinaryPhotoUrl)) {
//       setState(() {
//         _error = "URL enroll Cloudinary tidak valid!";
//         _loading = false;
//       });
//       return;
//     }

//     // Ambil lokasi realtime ketika absen
//     await _getLiveLocation();

//     try {
//       if (_controller == null || !_cameraInitialized) {
//         setState(() {
//           _error = 'Kamera belum siap.';
//           _loading = false;
//         });
//         return;
//       }

//       final XFile photo = await _controller!.takePicture();
//       setState(() => _log = "Mohon di tunggu...");

//       final imageBytes = await photo.readAsBytes();
//       final request = http.MultipartRequest(
//         'POST',
//         Uri.parse(faceVerificationApiEndpoint),
//       );
//       request.fields['nama'] = widget.userName;
//       request.fields['enroll_url'] = cloudinaryPhotoUrl;
//       request.files.add(
//         http.MultipartFile.fromBytes(
//           'selfie',
//           imageBytes,
//           filename: 'selfie.jpg',
//         ),
//       );

//       final http.StreamedResponse streamedResponse = await request.send();
//       final String responseBody = await streamedResponse.stream.bytesToString();
//       Map<String, dynamic> responseData;
//       try {
//         responseData = json.decode(responseBody);
//       } catch (_) {
//         responseData = {};
//       }

//       if (streamedResponse.statusCode == 200 && responseData['match'] == true) {
//         await _handleSuccessResponse(responseData);
//       } else {
//         String msg;
//         if (responseData['message'] != null) {
//           msg = responseData['message'];
//         } else if (responseData['error'] != null) {
//           msg = responseData['error'];
//         } else {
//           msg = "Verifikasi gagal.";
//         }
//         setState(() {
//           _error = msg;
//           _loading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         _error = "Terjadi kesalahan: ${e.toString().split('\n').first}";
//         _loading = false;
//       });
//     }
//   }

//   Future<void> _handleSuccessResponse(Map<String, dynamic> responseData) async {
//     setState(() => _log = "Menyimpan data absen...");
//     try {
//       final waktu = DateTime.now();
//       final dateKey = DateFormat('yyyy-MM-dd').format(waktu);

//       final lokasi = _absenLokasiString ?? "Lokasi tidak tersedia";
//       await FirebaseFirestore.instance
//           .collection('absensi')
//           .doc(widget.userId)
//           .collection('hari')
//           .doc(dateKey)
//           .set({
//         widget.isCheckOut ? 'checkOut' : 'checkIn': {
//           'waktu': waktu.toIso8601String(),
//           'jam': DateFormat('HH:mm').format(waktu),
//           'tanggal': dateKey,
//           'lokasi': lokasi,
//           'status': "Berhasil",
//           'verifikasi': 'wajah',
//           'similarity': (1 - (responseData['distance'] as double? ?? 0)) * 100,
//           'distance': responseData['distance'],
//           'nama': widget.userName,
//           'user_id': widget.userId,
//         },
//         'last_update': FieldValue.serverTimestamp(),
//       }, SetOptions(merge: true));
//       setState(() {
//         _loading = false;
//         _log = null;
//       });
//       _showSuccessDialog(responseData);
//     } catch (e) {
//       setState(() {
//         _error = "Absen tersimpan gagal: $e";
//         _loading = false;
//       });
//     }
//   }

//   void _showSuccessDialog(Map<String, dynamic> responseData) {
//     final similarity = (1 - (responseData['distance'] as double? ?? 0)) * 100;
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (context) => AlertDialog(
//         backgroundColor: Colors.white,
//         title: Row(
//           children: const [
//             Icon(Icons.verified, color: Colors.green, size: 28),
//             SizedBox(width: 10),
//             Text(
//               "Absen Berhasil",
//               style: TextStyle(
//                 color: Colors.green,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//               widget.userName,
//               style: const TextStyle(fontWeight: FontWeight.bold),
//             ),
//             Text(
//               widget.isCheckOut ? "Absen Pulang" : "Absen Masuk",
//               style: const TextStyle(color: Colors.grey),
//             ),
//             const SizedBox(height: 10),
//             Text("Similarity: ${similarity.toStringAsFixed(1)}%"),
//             if (_absenLokasiString != null)
//               Text(
//                 "Lokasi: $_absenLokasiString",
//                 style: const TextStyle(fontSize: 12, color: Colors.black54),
//               ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () =>
//                 Navigator.of(context).popUntil((route) => route.isFirst),
//             child: const Text(
//               "Selesai",
//               style: TextStyle(fontWeight: FontWeight.bold),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height;
//     final now = DateTime.now();
//     final timeText = DateFormat('HH.mm').format(now);
//     final dateLabel = DateFormat('d MMM y', "en_US").format(now);
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // AppBar custom
//             Container(
//               width: double.infinity,
//               color: Color(0xFF3F7DF4),
//               padding: const EdgeInsets.only(top: 8, left: 0, right: 0, bottom: 12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       IconButton(
//                         icon: const Icon(Icons.arrow_back, color: Colors.white),
//                         onPressed: _loading ? null : () => Navigator.of(context).pop(),
//                       ),
//                       const Spacer(),
//                       Container(
//                         margin: const EdgeInsets.only(right: 14, top: 4),
//                         padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
//                         decoration: BoxDecoration(
//                           color: Colors.white24,
//                           borderRadius: BorderRadius.circular(16)
//                         ),
//                         child: Text(
//                           timeText,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 15
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 22.0, bottom: 4),
//                     child: Text(
//                       widget.isCheckOut ? "Clock out" : "Clock in",
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 2),
//                   Padding(
//                     padding: const EdgeInsets.only(left: 22, right: 22, bottom: 4, top: 2),
//                     child: Container(
//                       padding: const EdgeInsets.all(10),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       child: Row(
//                         children: [
//                           const Icon(Icons.event, color:Color(0xFF3F7DF4), size: 19),
//                           const SizedBox(width: 8),
//                           Text(
//                             "$dateLabel (08:00 - 16:00)", // <-- Tanggal otomatis dan jam masuk kerja tetap
//                             style: const TextStyle(
//                               color: Colors.black87,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const Spacer(),
//                           Container(
//                             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//                             decoration: BoxDecoration(
//                               color: Colors.grey[100],
//                               borderRadius: BorderRadius.circular(10),
//                             ),
//                             // child: const Text(
//                             //   "dayoff",
//                             //   style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600, fontSize: 11),
//                             // ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: Stack(
//                 children: [
//                   if (_cameraInitialized && _controller != null && _controller!.value.isInitialized)
//                     Positioned.fill(
//                       child: Center(
//                         child: Stack(
//                           alignment: Alignment.center,
//                           children: [
//                             CameraPreview(_controller!),
//                             _DashedCircleOverlay(),
//                             if (_loading)
//                               Container(
//                                 color: Colors.black38,
//                                 child: Center(
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       const CircularProgressIndicator(color: Colors.white, strokeWidth: 4),
//                                       const SizedBox(height: 20),
//                                       Text(
//                                         _log ?? "Memverifikasi wajah...",
//                                         style: const TextStyle(
//                                           color: Colors.white,
//                                           fontSize: 16,
//                                         ),
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             if (_error != null && !_loading)
//                               Positioned(
//                                 top: 60,
//                                 left: 40,
//                                 right: 40,
//                                 child: Container(
//                                   padding: const EdgeInsets.all(12),
//                                   decoration: BoxDecoration(
//                                     color: Color(0xFF3F7DF4).withOpacity(0.9),
//                                     borderRadius: BorderRadius.circular(12),
//                                   ),
//                                   child: Row(
//                                     mainAxisSize: MainAxisSize.min,
//                                     children: [
//                                       const Icon(Icons.error_outline, color: Colors.white, size: 23),
//                                       const SizedBox(width: 10),
//                                       Expanded(
//                                         child: Text(_error!, textAlign: TextAlign.center,
//                                           style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//                                       ),
//                                       IconButton(
//                                         onPressed: () { setState((){ _error = null; }); },
//                                         icon: const Icon(Icons.close, color: Colors.white),
//                                       )
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                           ],
//                         ),
//                       ),
//                     )
//                   else
//                     Center(
//                       child: _error == null
//                           ? const CircularProgressIndicator(color: Color(0xFF3F7DF4))
//                           : Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(Icons.error_outline, color: Color(0xFF3F7DF4), size: 48),
//                                 const SizedBox(height: 12),
//                                 Text(_error!, style: const TextStyle(color: Color(0xFF3F7DF4), fontWeight: FontWeight.bold)),
//                                 ElevatedButton(
//                                   style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF3F7DF4)),
//                                   onPressed: _requestPermissionAndInitCamera,
//                                   child: const Text("Coba lagi", style: TextStyle(color: Colors.white)),
//                                 )
//                               ],
//                             ),
//                     ),
//                   Positioned(
//                     left: 0, right: 0, bottom: 0,
//                     child: Container(
//                       padding: const EdgeInsets.fromLTRB(18, 16, 18, 26),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: const BorderRadius.vertical(top: Radius.circular(23)),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black12,
//                             offset: const Offset(0, -3),
//                             blurRadius: 20,
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Row(
//                             children: [
//                               const Icon(Icons.location_on, size: 17, color: Colors.black54),
//                               const SizedBox(width: 7),
//                               Expanded(
//                                 child: Text(
//                                   _absenLokasiString != null
//                                       ? "Lokasi realtime: $_absenLokasiString"
//                                       : "Lokasi belum diambil",
//                                   style: const TextStyle(
//                                       color: Colors.black87, fontSize: 13),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(height: 20),
//                           SizedBox(
//                             width: double.infinity,
//                             height: 48,
//                             child: ElevatedButton(
//                               onPressed: _loading ? null : () => _detectAndVerify(context),
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: primaryPurple,
//                                 foregroundColor: Colors.white,
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10)),
//                               ),
//                               child: const Text("Kirim", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
//                             ),
//                           ),
//                         ],
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

// /// Overlay bulat garis putus-putus seperti gambar contoh
// class _DashedCircleOverlay extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: CustomPaint(
//         size: const Size(260, 320),
//         painter: _DashedOvalPainter(),
//       ),
//     );
//   }
// }

// class _DashedOvalPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final Paint paint = Paint()
//       ..color = Colors.white
//       ..strokeWidth = 3
//       ..style = PaintingStyle.stroke;
//     const double dashWidth = 13;
//     const double dashSpace = 7;
//     final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);
//     final Path path = Path()..addOval(rect);
//     final PathMetrics metrics = path.computeMetrics();
//     for (final metric in metrics) {
//       double distance = 0.0;
//       while (distance < metric.length) {
//         final double length = dashWidth;
//         canvas.drawPath(
//           metric.extractPath(distance, distance + length),
//           paint,
//         );
//         distance += dashWidth + dashSpace;
//       }
//     }
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) => false;
// }


