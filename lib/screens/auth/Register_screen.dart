import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _isObscure = true;
  bool _isConfirmObscure = true;
  bool _isLoading = false;

  final TextEditingController _companyIdController = TextEditingController();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Warna utama sama denganLoginScreen
  static const mainFont = 'Georgia';

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Konfirmasi kata sandi tidak cocok'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Dapatkan data dari form
      final companyId = _companyIdController.text.trim();
      final companyName = _companyNameController.text.trim();
      final fullName = _fullNameController.text.trim();
      final email = _emailController.text.trim();
      final phone = _phoneController.text.trim();
      final password = _passwordController.text.trim();

      // 2. Buat akun dengan Firebase Auth
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user!;
      final userId = user.uid;

      // set displayName on the Auth user for consistency
      try {
        await user.updateDisplayName(fullName);
        await user.reload();
      } catch (_) {}

      // Tunggu sampai auth token siap (kadang request.auth belum terisi segera)
      final auth = FirebaseAuth.instance;
      bool tokenReady = false;
      for (int i = 0; i < 6; i++) {
        final current = auth.currentUser;
        if (current != null) {
          try {
            await current.getIdToken(true);
            tokenReady = true;
            break;
          } catch (_) {}
        }
        await Future.delayed(const Duration(milliseconds: 300));
      }

      // 3. Simpan data lengkap ke Firestore (dengan retry jika token belum siap)
      final userData = {
        'companyId': companyId,
        'companyName': companyName,
        'fullName': fullName,
        'name': fullName,
        'email': email,
        'phone': phone,
        'uid': userId,
        'isActive': true,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      try {
        await _firestore.collection('users').doc(userId).set(userData);
      } on FirebaseException catch (e) {
        // Jika permission-denied, coba sekali lagi setelah jeda singkat
        if (e.code == 'permission-denied') {
          await Future.delayed(const Duration(milliseconds: 500));
          try {
            await _firestore.collection('users').doc(userId).set(userData);
          } on FirebaseException catch (e2) {
            // Berikan pesan yang jelas ke pengguna
            print('Firestore write failed (retry): ${e2.toString()}');
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Gagal menyimpan data ke Firestore: permission denied. Periksa aturan keamanan Firestore.',
                  ),
                  backgroundColor: Colors.red,
                ),
              );
            }
            rethrow;
          }
        } else {
          rethrow;
        }
      }

      print('✅ User registered successfully: $userId');

      // 4. Tampilkan pesan sukses dan arahkan ke halaman Login
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Registrasi berhasil! Silakan login menggunakan akun Anda.',
          ),
          backgroundColor: Colors.green.shade700,
          duration: const Duration(seconds: 2),
        ),
      );

      // Sign out user yang otomatis login setelah createUser, agar user pergi ke layar Login
      try {
        await _auth.signOut();
      } catch (_) {}

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      // Tangani error Firebase Auth
      String errorMessage = _mapRegisterError(e);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // Tangani error umum
      print('❌ Registration error: $e');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Terjadi kesalahan: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _autoLoginAndNavigate(
    String email,
    String password,
    String fullName,
  ) async {
    try {
      // Tunggu sebentar untuk memastikan user dibuat
      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      // Navigasi langsung ke home screen (user sudah login otomatis)
      final currentUser = _auth.currentUser;

      // Untuk sekarang, arahkan ke LoginScreen setelah registrasi
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      print('Error auto login after register: $e');
      if (mounted) {
        // Tetap arahkan ke login screen
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      }
    }
  }

  String _mapRegisterError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Email sudah digunakan. Silakan gunakan email lain atau login.';
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'weak-password':
        return 'Kata sandi terlalu lemah. Minimal 6 karakter.';
      case 'operation-not-allowed':
        return 'Registrasi dengan email/password tidak diizinkan. Hubungi administrator.';
      case 'network-request-failed':
        return 'Koneksi internet bermasalah. Cek koneksi Anda.';
      default:
        return 'Registrasi gagal: ${e.message}';
    }
  }

  Widget _buildTextField({
    required String label,
    required IconData prefixIcon,
    required TextEditingController controller,
    required String? Function(String?) validator,
    bool isPassword = false,
    bool isObscure = false,
    VoidCallback? onToggleObscure,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
    String? hintText,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Color(0xFF0C75BA),
              fontSize: 17,
              fontFamily: mainFont,
              fontWeight: FontWeight.w600,
              letterSpacing: 2.0,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFEFEFF2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextFormField(
              controller: controller,
              obscureText: isPassword && isObscure,
              keyboardType: keyboardType,
              maxLength: maxLength,
              style: TextStyle(
                color: Color(0xFF0C75BA),
                fontFamily: mainFont,
                fontSize: 16,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: Color(0xFF0C75BA).withOpacity(0.6),
                  fontFamily: mainFont,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 18,
                ),
                prefixIcon: Icon(
                  prefixIcon,
                  color: Color(0xFF0C75BA),
                  size: 22,
                ),
                suffixIcon: isPassword && onToggleObscure != null
                    ? IconButton(
                        icon: Icon(
                          isObscure ? Icons.visibility_off : Icons.visibility,
                          color: Color(0xFF0C75BA),
                          size: 22,
                        ),
                        onPressed: onToggleObscure,
                      )
                    : null,
                counterText: '',
                filled: true,
                fillColor: Colors.transparent,
              ),
              validator: validator,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Color(0xFF0C75BA),
            size: 22,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // LOGO - Sama seperti di LoginScreen
                const SizedBox(height: 20),
                Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 100,
                    width: 100,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 100,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: Icon(
                          Icons.person_add_alt_1,
                          size: 60,
                          color: Color(0xFF0C75BA),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // JUDUL - Sama seperti di LoginScreen
                Center(
                  child: Text(
                    'FaceApp',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFF0C75BA),
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      fontFamily: mainFont,
                      height: 1.2,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Center(
                  child: Text(
                    'Buat Akun Baru',
                    style: TextStyle(
                      color: Color(0xFF0C75BA),
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      fontFamily: mainFont,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 36),

                // Form registrasi
                Text(
                  'Informasi Perusahaan',
                  style: TextStyle(
                    color: Color(0xFF0C75BA),
                    fontSize: 16,
                    fontFamily: mainFont,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),

                _buildTextField(
                  label: 'ID Perusahaan',
                  prefixIcon: Icons.business,
                  controller: _companyIdController,
                  hintText: 'Contoh: 23456711',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'ID Perusahaan wajib diisi';
                    }
                    if (value.length < 3) {
                      return 'ID Perusahaan minimal 3 karakter';
                    }
                    return null;
                  },
                  maxLength: 20,
                ),

                _buildTextField(
                  label: 'Nama Perusahaan',
                  prefixIcon: Icons.business_center,
                  controller: _companyNameController,
                  hintText: 'Contoh: PT. Kimia Farma',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama Perusahaan wajib diisi';
                    }
                    if (value.length < 3) {
                      return 'Nama Perusahaan minimal 3 karakter';
                    }
                    return null;
                  },
                  maxLength: 50,
                ),

                const SizedBox(height: 8),
                Divider(color: Colors.grey.shade300, height: 1),
                const SizedBox(height: 20),

                Text(
                  'Informasi Pribadi',
                  style: TextStyle(
                    color: Color(0xFF0C75BA),
                    fontSize: 16,
                    fontFamily: mainFont,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),

                _buildTextField(
                  label: 'Nama Lengkap',
                  prefixIcon: Icons.person_outline,
                  controller: _fullNameController,
                  hintText: 'Contoh: Iwan Suryana',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nama Lengkap wajib diisi';
                    }
                    if (value.length < 3) {
                      return 'Nama Lengkap minimal 3 karakter';
                    }
                    return null;
                  },
                  maxLength: 50,
                ),

                _buildTextField(
                  label: 'Email',
                  prefixIcon: Icons.email_outlined,
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  hintText: 'contoh@email.com',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email wajib diisi';
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return 'Format email tidak valid';
                    }
                    return null;
                  },
                  maxLength: 50,
                ),

                _buildTextField(
                  label: 'Nomor Telepon',
                  prefixIcon: Icons.phone_outlined,
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  hintText: '081234567890',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Nomor Telepon wajib diisi';
                    }
                    final cleanPhone = value.replaceAll(RegExp(r'[^0-9]'), '');
                    if (cleanPhone.length < 10 || cleanPhone.length > 15) {
                      return 'Nomor Telepon 10-15 digit';
                    }
                    return null;
                  },
                  maxLength: 15,
                ),

                const SizedBox(height: 8),
                Divider(color: Colors.grey.shade300, height: 1),
                const SizedBox(height: 20),

                Text(
                  'Keamanan Akun',
                  style: TextStyle(
                    color: Color(0xFF0C75BA),
                    fontSize: 16,
                    fontFamily: mainFont,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),

                _buildTextField(
                  label: 'Kata Sandi',
                  prefixIcon: Icons.lock_outline,
                  controller: _passwordController,
                  isPassword: true,
                  isObscure: _isObscure,
                  hintText: 'Minimal 6 karakter',
                  onToggleObscure: () {
                    setState(() => _isObscure = !_isObscure);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kata Sandi wajib diisi';
                    }
                    if (value.length < 6) {
                      return 'Kata Sandi minimal 6 karakter';
                    }
                    return null;
                  },
                  maxLength: 20,
                ),

                _buildTextField(
                  label: 'Konfirmasi Kata Sandi',
                  prefixIcon: Icons.lock_outline,
                  controller: _confirmPasswordController,
                  isPassword: true,
                  isObscure: _isConfirmObscure,
                  hintText: 'Ulangi kata sandi',
                  onToggleObscure: () {
                    setState(() => _isConfirmObscure = !_isConfirmObscure);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Konfirmasi Kata Sandi wajib diisi';
                    }
                    return null;
                  },
                  maxLength: 20,
                ),

                // Informasi
                Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFEFF2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, color: Color(0xFF0C75BA)),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Dengan mendaftar, akun Anda akan dibuat dan Anda dapat langsung login setelah registrasi.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF0C75BA),
                            fontFamily: mainFont,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Tombol Daftar Akun - Warna sama dengan LoginScreen
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF0C75BA),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isLoading
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Daftar Akun ',
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w600,
                              fontSize: 17,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 24),

                // Tautan ke halaman login
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sudah punya akun? ',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 15,
                          fontFamily: mainFont,
                        ),
                      ),
                      GestureDetector(
                        onTap: _isLoading
                            ? null
                            : () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                        child: Text(
                          'Masuk di sini',
                          style: TextStyle(
                            color: Color(0xFF0C75BA),
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            fontFamily: mainFont,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _companyIdController.dispose();
    _companyNameController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
