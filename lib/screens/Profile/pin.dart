import 'package:flutter/material.dart';

class PinPage extends StatefulWidget {
  const PinPage({super.key});

  @override
  State<PinPage> createState() => _PinPageState();
}

class _PinPageState extends State<PinPage> with SingleTickerProviderStateMixin {
  List<String> _pinDigits = List.filled(6, '');
  int _currentIndex = 0;
  bool _isSettingPin = false;
  bool _isVerifying = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onDigitPressed(String digit) {
    if (_currentIndex < 6) {
      setState(() {
        _pinDigits[_currentIndex] = digit;
        _currentIndex++;
      });
    }
  }

  void _onBackspacePressed() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _pinDigits[_currentIndex] = '';
      });
    }
  }

  void _clearPin() {
    setState(() {
      _pinDigits = List.filled(6, '');
      _currentIndex = 0;
    });
  }

  void _submitPin() async {
    if (_currentIndex == 6) {
      setState(() {
        _isVerifying = true;
      });

      await Future.delayed(const Duration(milliseconds: 800));

      // PIN submission logic

      if (_isSettingPin) {
        _showSuccessDialog('PIN berhasil diset!');
        setState(() {
          _isSettingPin = false;
          _clearPin();
        });
      } else {
        _showSuccessDialog('PIN terverifikasi!');
        setState(() {
          _isSettingPin = true;
          _clearPin();
        });
      }

      setState(() {
        _isVerifying = false;
      });
    } else {
      _showErrorSnackBar('PIN harus terdiri dari 6 digit');
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(40),
        child: Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF7C3AED), Color(0xFF5B21B6)],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF7C3AED).withOpacity(0.4),
                blurRadius: 40,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_circle,
                  size: 60,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Sukses!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 4,
                      color: Colors.black.withOpacity(0.2),
                      offset: const Offset(1, 1),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                message,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF7C3AED),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.error_outline,
                color: Colors.redAccent,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message, style: const TextStyle(fontSize: 14)),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFFEE2E2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(20),
        elevation: 10,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 360;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: screenHeight),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 12 : 20,
                  vertical: isSmallScreen ? 16 : 24,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Bagian atas
                    Column(
                      children: [
                        // App Bar Custom
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.1),
                                      blurRadius: 15,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  onPressed: () => Navigator.pop(context),
                                  icon: const Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                  ),
                                  color: const Color(0xFF7C3AED),
                                  iconSize: 20,
                                ),
                              ),
                              Expanded(
                                child: Center(
                                  child: Text(
                                    'Keamanan PIN',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF1E293B),
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 48),
                            ],
                          ),
                        ),

                        // Header Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(25),
                          margin: const EdgeInsets.only(bottom: 30),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFFFFFFFF), Color(0xFFF5F3FF)],
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF7C3AED,
                                ).withOpacity(0.08),
                                blurRadius: 30,
                                spreadRadius: 2,
                                offset: const Offset(0, 10),
                              ),
                            ],
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: Column(
                            children: [
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    width: 90,
                                    height: 90,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        colors: [
                                          const Color(
                                            0xFF7C3AED,
                                          ).withOpacity(0.1),
                                          const Color(
                                            0xFF5B21B6,
                                          ).withOpacity(0.1),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: const LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          Color(0xFF7C3AED),
                                          Color(0xFF5B21B6),
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(
                                            0xFF7C3AED,
                                          ).withOpacity(0.4),
                                          blurRadius: 20,
                                          spreadRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.lock_person_rounded,
                                      size: 36,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Text(
                                _isSettingPin
                                    ? 'Buat PIN Baru'
                                    : 'Verifikasi PIN',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B),
                                  height: 1.2,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _isSettingPin
                                    ? 'Masukkan 6 digit PIN baru untuk keamanan akun Anda'
                                    : 'Masukkan PIN Anda saat ini untuk melanjutkan',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                  height: 1.4,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),

                        // PIN Display
                        Container(
                          margin: const EdgeInsets.only(bottom: 40),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(6, (index) {
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: isSmallScreen ? 36 : 44,
                                    height: isSmallScreen ? 36 : 44,
                                    margin: EdgeInsets.symmetric(
                                      horizontal: isSmallScreen ? 4 : 8,
                                    ),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: index < _currentIndex
                                          ? const LinearGradient(
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                              colors: [
                                                Color(0xFF7C3AED),
                                                Color(0xFF5B21B6),
                                              ],
                                            )
                                          : null,
                                      color: index < _currentIndex
                                          ? null
                                          : Colors.white,
                                      border: Border.all(
                                        color: index < _currentIndex
                                            ? const Color(0xFF7C3AED)
                                            : Colors.grey.shade300,
                                        width: index < _currentIndex ? 2 : 1.5,
                                      ),
                                      boxShadow: [
                                        if (index < _currentIndex)
                                          BoxShadow(
                                            color: const Color(
                                              0xFF7C3AED,
                                            ).withOpacity(0.3),
                                            blurRadius: 10,
                                            spreadRadius: 1,
                                          ),
                                        BoxShadow(
                                          color: Colors.white.withOpacity(0.8),
                                          blurRadius: 5,
                                          spreadRadius: 2,
                                          offset: const Offset(-2, -2),
                                        ),
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.05),
                                          blurRadius: 5,
                                          spreadRadius: 1,
                                          offset: const Offset(2, 2),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: AnimatedSwitcher(
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        transitionBuilder: (child, animation) {
                                          return ScaleTransition(
                                            scale: animation,
                                            child: child,
                                          );
                                        },
                                        child: _pinDigits[index].isNotEmpty
                                            ? const Icon(
                                                Icons.circle_rounded,
                                                size: 14,
                                                color: Colors.white,
                                              )
                                            : const SizedBox.shrink(),
                                      ),
                                    ),
                                  );
                                }),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                '${_currentIndex}/6 digit',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Numpad dengan LayoutBuilder untuk menghindari overflow
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return Container(
                          margin: EdgeInsets.only(bottom: screenHeight * 0.05),
                          child: GridView.count(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            crossAxisCount: 3,
                            childAspectRatio: 1.0,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            padding: EdgeInsets.zero,
                            children: [
                              // Digits 1-9
                              ...List.generate(9, (index) {
                                return _buildNumpadButton(
                                  text: '${index + 1}',
                                  onPressed: () =>
                                      _onDigitPressed('${index + 1}'),
                                  index: index,
                                );
                              }),

                              // Clear Button
                              _buildNumpadButton(
                                text: 'Hapus',
                                onPressed: _clearPin,
                                backgroundColor: Colors.white,
                                textColor: const Color(0xFFDC2626),
                                index: 9,
                                isSpecial: true,
                              ),

                              // Digit 0
                              _buildNumpadButton(
                                text: '0',
                                onPressed: () => _onDigitPressed('0'),
                                index: 10,
                              ),

                              // Backspace
                              _buildNumpadButton(
                                icon: Icons.backspace_outlined,
                                onPressed: _onBackspacePressed,
                                backgroundColor: Colors.white,
                                iconColor: const Color(0xFF7C3AED),
                                index: 11,
                                isSpecial: true,
                              ),
                            ],
                          ),
                        );
                      },
                    ),

                    // Bagian bawah
                    Column(
                      children: [
                        // Tombol Submit
                        SizedBox(
                          width: double.infinity,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(14),
                              gradient: _currentIndex == 6
                                  ? const LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Color(0xFF7C3AED),
                                        Color(0xFF5B21B6),
                                      ],
                                    )
                                  : LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        Colors.grey.shade400,
                                        Colors.grey.shade500,
                                      ],
                                    ),
                              boxShadow: _currentIndex == 6
                                  ? [
                                      BoxShadow(
                                        color: const Color(
                                          0xFF7C3AED,
                                        ).withOpacity(0.4),
                                        blurRadius: 12,
                                        spreadRadius: 2,
                                        offset: const Offset(0, 4),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: ElevatedButton(
                              onPressed: _currentIndex == 6 ? _submitPin : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                              ),
                              child: _isVerifying
                                  ? const SizedBox(
                                      width: 22,
                                      height: 22,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 3,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          _isSettingPin
                                              ? 'Set PIN Baru'
                                              : 'Verifikasi Sekarang',
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Icon(
                                          Icons.arrow_forward_rounded,
                                          size: 18,
                                          color: Colors.white,
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Info Card
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 15,
                                spreadRadius: 2,
                              ),
                            ],
                            border: Border.all(
                              color: Colors.grey.shade100,
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF5F3FF),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.security_rounded,
                                      size: 18,
                                      color: Color(0xFF7C3AED),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Text(
                                    'Tips Keamanan PIN',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1E293B),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _buildInfoItem(
                                'Gunakan kombinasi angka yang mudah diingat namun sulit ditebak',
                              ),
                              _buildInfoItem(
                                'Jangan gunakan tanggal lahir atau angka berurutan',
                              ),
                              _buildInfoItem(
                                'Ganti PIN secara berkala setiap 3 bulan',
                              ),
                              _buildInfoItem(
                                'Jangan bagikan PIN Anda kepada siapapun',
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNumpadButton({
    String? text,
    IconData? icon,
    required VoidCallback onPressed,
    Color backgroundColor = Colors.white,
    Color textColor = const Color(0xFF1E293B),
    Color iconColor = const Color(0xFF1E293B),
    required int index,
    bool isSpecial = false,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.9),
            blurRadius: 8,
            offset: const Offset(-3, -3),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [backgroundColor, backgroundColor.withOpacity(0.9)],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.8), width: 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(16),
          splashColor: const Color(0xFF7C3AED).withOpacity(0.1),
          highlightColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white.withOpacity(0.1), Colors.transparent],
              ),
            ),
            child: Center(
              child: icon != null
                  ? Icon(icon, size: 24, color: iconColor)
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          text!,
                          style: TextStyle(
                            fontSize: isSpecial ? 20 : 26,
                            fontWeight: FontWeight.w500,
                            color: textColor,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5, right: 10),
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: const Color(0xFF7C3AED),
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
