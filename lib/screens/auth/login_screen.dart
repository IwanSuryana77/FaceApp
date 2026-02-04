import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:peresenceapp/services/auth_helper.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _obscure = true;
  bool _loading = false;
  bool _isCheckingAutoLogin = true; // Tambahkan flag untuk auto login check

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Cek auto login dengan delay untuk memberi waktu splash screen (jika ada)
    _checkAutoLogin();
  }

  Future<void> _checkAutoLogin() async {
    // Tunggu sedikit untuk animasi/loading
    await Future.delayed(const Duration(milliseconds: 300));

    // Cek apakah user sudah login menggunakan Firebase Auth langsung
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      print('🔄 User sudah login, email: ${currentUser.email}');

      try {
        // Tunggu sedikit untuk memastikan data user siap
        await Future.delayed(const Duration(milliseconds: 200));

        if (!mounted) return;

        // Pindah ke home screen
        await _navigateToHomeScreen();
      } catch (e) {
        print(' Error saat auto login: $e');
        if (mounted) {
          setState(() => _isCheckingAutoLogin = false);
        }
      }
    } else {
      print('ℹ️ User belum login');
      if (mounted) {
        setState(() => _isCheckingAutoLogin = false);
      }
    }
  }

  Future<void> _navigateToHomeScreen() async {
    try {
      // Dapatkan data user
      final userName = await AuthHelper.getCurrentUserName();
      final userEmail = AuthHelper.getCurrentUserEmail();

      print(' Auto login berhasil! User: $userName, Email: $userEmail');

      if (!mounted) return;

      // Navigasi ke halaman utama dengan bottom navigation
      Navigator.pushReplacementNamed(context, '/main');
    } catch (e) {
      print('Error mendapatkan data user: $e');
      if (mounted) {
        setState(() => _isCheckingAutoLogin = false);
      }
    }
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      // Login dengan Firebase Auth langsung
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Tunggu sebentar untuk memastikan login berhasil
      await Future.delayed(const Duration(milliseconds: 300));

      // Cek apakah user sudah login
      if (FirebaseAuth.instance.currentUser != null) {
        // Dapatkan data user
        final userName = await AuthHelper.getCurrentUserName();
        final userEmail = AuthHelper.getCurrentUserEmail();

        print(' Login manual berhasil! User: $userName, Email: $userEmail');

        // Navigasi ke HomeScreen
        if (!mounted) return;

        Navigator.pushReplacementNamed(context, '/main');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Login berhasil! Selamat datang $userName'),
            backgroundColor: Colors.green.shade700,
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        throw Exception('Login gagal: user tidak ditemukan');
      }
    } on FirebaseAuthException catch (e) {
      _showError(_mapAuthError(e));
    } catch (e) {
      _showError('Terjadi kesalahan. Coba lagi nanti: $e');
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  String _mapAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
      case 'invalid-credential':
        return 'Email atau password salah.';
      case 'wrong-password':
        return 'Kata sandi salah.';
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'user-disabled':
        return 'Akun ini dinonaktifkan. Hubungi administrator.';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan gagal. Coba lagi nanti.';
      case 'network-request-failed':
        return 'Koneksi internet bermasalah. Cek koneksi Anda.';
      default:
        return 'Terjadi kesalahan: ${e.message}';
    }
  }

  void _showError(String msg) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red.shade700,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _forgotPassword() {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan email terlebih dahulu'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Lupa Kata Sandi?'),
        content: Text(
          'Kami akan mengirim email reset password ke:\n${_emailController.text}',
          style: const TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                await AuthHelper.sendPasswordResetEmail(
                  _emailController.text.trim(),
                );

                if (!mounted) return;

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Email reset password telah dikirim ke ${_emailController.text}',
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              } catch (e) {
                if (!mounted) return;

                Navigator.pop(context);
                _showError('Gagal mengirim email: $e');
              }
            },
            child: const Text('Kirim'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const mainFont = 'Georgia';

    // Tampilkan loading jika sedang cek auto login
    if (_isCheckingAutoLogin) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
              Text(
                '',
                style: TextStyle(
                  color: Color(0xFF0C75BA),
                  fontFamily: mainFont,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // LOGO/Judul di atas
              const SizedBox(height: 36),

              // Logo dari asset
              Image.asset(
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
                      Icons.person,
                      size: 60,
                      color: Color(0xFF0C75BA),
                    ),
                  );
                },
              ),

              const SizedBox(height: 24),

              // Judul
              Text(
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

              const SizedBox(height: 8),

              Text(
                'Masuk Akun',
                style: TextStyle(
                  color: Color(0xFF0C75BA),
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  fontFamily: mainFont,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 36),

              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // EMAIL/PERUSAHAAN TITLE
                    Text(
                      "Email",
                      style: TextStyle(
                        color: Color(0xFF0C75BA),
                        fontSize: 17,
                        fontFamily: mainFont,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2.0,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // EMAIL FIELD
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFEFF2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: TextStyle(
                          color: Color(0xFF0C75BA),
                          fontFamily: mainFont,
                          fontSize: 16,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 18,
                          ),
                          hintText: 'Masukkan email Anda',
                          hintStyle: TextStyle(
                            color: Color(0xFF0C75BA),
                            fontFamily: 'Georgia',
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: Color(0xFF0C75BA),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return "Email wajib diisi";
                          }
                          // Validasi format email
                          final isEmail = RegExp(
                            r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                          ).hasMatch(v);
                          if (!isEmail) {
                            return "Format email tidak valid";
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(height: 32),

                    // PASSWORD TITLE
                    Text(
                      "Kata Sandi",
                      style: TextStyle(
                        color: Color(0xFF0C75BA),
                        fontSize: 17,
                        fontFamily: mainFont,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2.0,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // PASSWORD FIELD
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFEFF2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: _obscure,
                        style: TextStyle(
                          color: Color(0xFF0C75BA),
                          fontFamily: mainFont,
                          fontSize: 16,
                          letterSpacing: 2.0,
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 18,
                          ),
                          hintText: '••••••',
                          hintStyle: const TextStyle(
                            color: Color(0xFF0C75BA),
                            fontFamily: 'Georgia',
                            fontWeight: FontWeight.w400,
                            fontSize: 18,
                            letterSpacing: 2.0,
                          ),
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: Color(0xFF0C75BA),
                          ),
                          suffixIcon: IconButton(
                            onPressed: () =>
                                setState(() => _obscure = !_obscure),
                            icon: Icon(
                              _obscure
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Color(0xFF0C75BA),
                            ),
                          ),
                        ),
                        validator: (v) {
                          if (v == null || v.isEmpty) {
                            return "Kata sandi wajib diisi";
                          }
                          if (v.length < 6) {
                            return "Minimal 6 karakter";
                          }
                          return null;
                        },
                      ),
                    ),

                    // Lupa Password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _forgotPassword,
                        child: Text(
                          'Lupa Kata Sandi?',
                          style: TextStyle(
                            color: Color(0xFF0C75BA),
                            fontSize: 14,
                            fontFamily: mainFont,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 38),

                    // LOGIN BUTTON
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _loading ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF0C75BA),
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(56),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          textStyle: GoogleFonts.roboto(
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                          ),
                        ),
                        child: _loading
                            ? SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : const Text("MASUK"),
                      ),
                    ),
                  ],
                ),
              ),

              // SWITCH KE REGISTER
              const SizedBox(height: 32),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Belum punya akun? ",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 15,
                      fontFamily: mainFont,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    },
                    child: Text(
                      "Daftar di sini",
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

              const SizedBox(height: 40),

              // Divider atau informasi tambahan
              Row(
                children: [
                  Expanded(
                    child: Divider(color: Colors.grey.shade300, thickness: 1),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'atau',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontFamily: mainFont,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(color: Colors.grey.shade300, thickness: 1),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Versi aplikasi
              Text(
                'Version 1.0.0',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                  fontFamily: mainFont,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
