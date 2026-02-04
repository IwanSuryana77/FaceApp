import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'info_personal_screen.dart';
import 'info_pendidikan.dart';
import 'info_keluarga.dart';
import 'info_payroll.dart';
import 'info_tambahan.dart';
import 'pusat_bantuan.dart';
import 'keamanan_privasi.dart';
import 'berikan_feedback.dart';
import 'keluar.dart';
import 'ubah_katasandi.dart';
import 'pin.dart';
import 'pengingat_cio.dart';
import 'bahasa.dart';

class ProfilScreen extends StatefulWidget {
  const ProfilScreen({super.key});

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen>
    with TickerProviderStateMixin {
  final primaryColor = const Color(0xFF1E40AF);
  final secondaryColor = const Color(0xFF3B82F6);
  final accentColor = const Color(0xFF8B5CF6);
  final successColor = const Color(0xFF10B981);
  final warningColor = const Color(0xFFF59E0B);
  final dangerColor = const Color(0xFFEF4444);
  late AnimationController _headerAnimationController;
  late AnimationController _sectionAnimationController;
  late AnimationController _iconAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();

    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..forward();

    _sectionAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _iconAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = CurvedAnimation(
      parent: _headerAnimationController,
      curve: Curves.easeInOutCubic,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _headerAnimationController,
            curve: const Interval(0.2, 1.0, curve: Curves.easeOutBack),
          ),
        );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _headerAnimationController,
        curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
      ),
    );

    _rotateAnimation = Tween<double>(begin: -0.05, end: 0.05).animate(
      CurvedAnimation(
        parent: _iconAnimationController,
        curve: Curves.easeInOutSine,
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(milliseconds: 300), () {
        _sectionAnimationController.forward();
      });
    });
  }

  @override
  void dispose() {
    _headerAnimationController.dispose();
    _sectionAnimationController.dispose();
    _iconAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              const Color(0xFFF0F9FF).withOpacity(0.8),
              const Color(0xFFE0F2FE).withOpacity(0.6),
              const Color(0xFFBAE6FD).withOpacity(0.4),
            ],
            center: Alignment.topCenter,
            radius: 1.5,
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // Enhanced Header with Glassmorphism Effect
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    expandedHeight: isMobile ? 280 : 320,
                    floating: false,
                    pinned: true,
                    snap: false,
                    stretch: true,
                    elevation: 0,
                    flexibleSpace: FlexibleSpaceBar(
                      stretchModes: const [
                        StretchMode.zoomBackground,
                        StretchMode.blurBackground,
                      ],
                      background: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              primaryColor.withOpacity(0.1),
                              Colors.transparent,
                              primaryColor.withOpacity(0.05),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            stops: const [0.0, 0.5, 1.0],
                          ),
                        ),
                        child: BackdropFilter(
                          filter: ui.ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                          child: Container(
                            color: Colors.white.withOpacity(0.02),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(
                                isMobile ? 16 : 24,
                                statusBarHeight + (isMobile ? 16 : 24),
                                isMobile ? 16 : 24,
                                isMobile ? 16 : 24,
                              ),
                              child: FadeTransition(
                                opacity: _fadeAnimation,
                                child: SlideTransition(
                                  position: _slideAnimation,
                                  child: Column(
                                    children: [
                                      ScaleTransition(
                                        scale: _scaleAnimation,
                                        child: _buildProfileHeader(
                                          context,
                                          isMobile,
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      _buildUserInfo(context, isMobile),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    actions: [_buildHeaderActions(context, isMobile)],
                  ),

                  // Content Sections with responsive padding
                  SliverPadding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 12 : 18,
                      vertical: isMobile ? 8 : 12,
                    ),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // Info Saya Section
                        _buildAnimatedSection(
                          context,
                          'Info Saya',
                          Icons.person_outline,
                          primaryColor,
                          [
                            _buildEnhancedMenuItem(
                              context,
                              Icons.person,
                              'Info Personal',
                              'Lengkapi informasi pribadi Anda',
                              primaryColor,
                              const Color(0xFFBFDBFE),
                              isInfoPersonal: true,
                              isUbahPassword: false,
                              isPin: false,
                              isPengingatCIO: false,
                              isBahasa: false,
                              isPusatBantuan: false,
                              isKeamananPrivasi: false,
                              isBerikanFeedback: false,
                              isKeluar: false,
                              isMobile: isMobile,
                            ),
                            _buildEnhancedMenuItem(
                              context,
                              Icons.school,
                              'Info Pendidikan',
                              'Riwayat pendidikan terakhir',
                              const Color(0xFF2563EB),
                              const Color(0xFFBFDBFE),
                              isInfoPendidikan: true,
                              isUbahPassword: false,
                              isPin: false,
                              isPengingatCIO: false,
                              isBahasa: false,
                              isPusatBantuan: false,
                              isKeamananPrivasi: false,
                              isBerikanFeedback: false,
                              isKeluar: false,
                              isMobile: isMobile,
                            ),
                            _buildEnhancedMenuItem(
                              context,
                              Icons.family_restroom,
                              'Info Keluarga',
                              'Data anggota keluarga',
                              const Color(0xFF1E40AF),
                              const Color(0xFFBFDBFE),
                              isInfoKeluarga: true,
                              isUbahPassword: false,
                              isPin: false,
                              isPengingatCIO: false,
                              isBahasa: false,
                              isPusatBantuan: false,
                              isKeamananPrivasi: false,
                              isBerikanFeedback: false,
                              isKeluar: false,
                              isMobile: isMobile,
                            ),
                            _buildEnhancedMenuItem(
                              context,
                              Icons.account_balance_wallet,
                              'Info Payroll',
                              'Detail gaji dan tunjangan',
                              const Color(0xFF0EA5E9),
                              const Color(0xFFBFDBFE),
                              isInfoPayroll: true,
                              isUbahPassword: false,
                              isPin: false,
                              isPengingatCIO: false,
                              isBahasa: false,
                              isPusatBantuan: false,
                              isKeamananPrivasi: false,
                              isBerikanFeedback: false,
                              isKeluar: false,
                              isMobile: isMobile,
                            ),
                            _buildEnhancedMenuItem(
                              context,
                              Icons.info,
                              'Info Tambahan',
                              'Informasi tambahan yang relevan',
                              const Color(0xFF06B6D4),
                              const Color(0xFFBFDBFE),
                              isInfoTambahan: true,
                              isUbahPassword: false,
                              isPin: false,
                              isPengingatCIO: false,
                              isBahasa: false,
                              isPusatBantuan: false,
                              isKeamananPrivasi: false,
                              isBerikanFeedback: false,
                              isKeluar: false,
                              isMobile: isMobile,
                            ),
                          ],
                          isMobile,
                        ),

                        SizedBox(height: isMobile ? 24 : 28),

                        // Pengaturan Section
                        _buildAnimatedSection(
                          context,
                          'Pengaturan',
                          Icons.settings,
                          accentColor,
                          [
                            _buildEnhancedMenuItem(
                              context,
                              Icons.lock,
                              'Ubah Kata Sandi',
                              'Perbarui keamanan akun Anda',
                              const Color(0xFF8B5CF6),
                              const Color(0xFFDDD6FE),
                              isInfoPersonal: false,
                              isInfoPendidikan: false,
                              isInfoKeluarga: false,
                              isInfoPayroll: false,
                              isInfoTambahan: false,
                              isUbahPassword: true,
                              isPin: false,
                              isPengingatCIO: false,
                              isBahasa: false,
                              isPusatBantuan: false,
                              isKeamananPrivasi: false,
                              isBerikanFeedback: false,
                              isKeluar: false,
                              isMobile: isMobile,
                            ),
                            _buildEnhancedMenuItem(
                              context,
                              Icons.vpn_key,
                              'PIN',
                              'Atur PIN untuk transaksi',
                              const Color(0xFF7C3AED),
                              const Color(0xFFDDD6FE),
                              isInfoPersonal: false,
                              isInfoPendidikan: false,
                              isInfoKeluarga: false,
                              isInfoPayroll: false,
                              isInfoTambahan: false,
                              isUbahPassword: false,
                              isPin: true,
                              isPengingatCIO: false,
                              isBahasa: false,
                              isPusatBantuan: false,
                              isKeamananPrivasi: false,
                              isBerikanFeedback: false,
                              isKeluar: false,
                              isMobile: isMobile,
                            ),
                            _buildEnhancedMenuItem(
                              context,
                              Icons.access_time,
                              'Pengingat Clock In/Out',
                              'Atur notifikasi jam masuk/keluar',
                              const Color(0xFFA78BFA),
                              const Color(0xFFDDD6FE),
                              isInfoPersonal: false,
                              isInfoPendidikan: false,
                              isInfoKeluarga: false,
                              isInfoPayroll: false,
                              isInfoTambahan: false,
                              isUbahPassword: false,
                              isPin: false,
                              isPengingatCIO: true,
                              isBahasa: false,
                              isPusatBantuan: false,
                              isKeamananPrivasi: false,
                              isBerikanFeedback: false,
                              isKeluar: false,
                              isMobile: isMobile,
                            ),
                            _buildEnhancedMenuItem(
                              context,
                              Icons.language,
                              'Bahasa',
                              'Pilih bahasa yang diinginkan',
                              accentColor,
                              const Color(0xFFDDD6FE),
                              isInfoPersonal: false,
                              isInfoPendidikan: false,
                              isInfoKeluarga: false,
                              isInfoPayroll: false,
                              isInfoTambahan: false,
                              isUbahPassword: false,
                              isPin: false,
                              isPengingatCIO: false,
                              isBahasa: true,
                              isPusatBantuan: false,
                              isKeamananPrivasi: false,
                              isBerikanFeedback: false,
                              isKeluar: false,
                              isMobile: isMobile,
                            ),
                          ],
                          isMobile,
                        ),

                        SizedBox(height: isMobile ? 24 : 28),

                        // Bantuan & Lainnya Section
                        _buildAnimatedSection(
                          context,
                          'Bantuan & Lainnya',
                          Icons.help_outline,
                          successColor,
                          [
                            _buildEnhancedMenuItem(
                              context,
                              Icons.help,
                              'Pusat Bantuan',
                              'Dapatkan bantuan untuk masalah umum',
                              successColor,
                              const Color(0xFFA7F3D0),
                              isInfoPersonal: false,
                              isInfoPendidikan: false,
                              isInfoKeluarga: false,
                              isInfoPayroll: false,
                              isInfoTambahan: false,
                              isUbahPassword: false,
                              isPin: false,
                              isPengingatCIO: false,
                              isBahasa: false,
                              isPusatBantuan: true,
                              isKeamananPrivasi: false,
                              isBerikanFeedback: false,
                              isKeluar: false,
                              isMobile: isMobile,
                            ),
                            _buildEnhancedMenuItem(
                              context,
                              Icons.security,
                              'Keamanan & Privasi',
                              'Tinjau kebijakan keamanan',
                              const Color(0xFF059669),
                              const Color(0xFFA7F3D0),
                              isInfoPersonal: false,
                              isInfoPendidikan: false,
                              isInfoKeluarga: false,
                              isInfoPayroll: false,
                              isInfoTambahan: false,
                              isUbahPassword: false,
                              isPin: false,
                              isPengingatCIO: false,
                              isBahasa: false,
                              isPusatBantuan: false,
                              isKeamananPrivasi: true,
                              isBerikanFeedback: false,
                              isKeluar: false,
                              isMobile: isMobile,
                            ),
                            _buildEnhancedMenuItem(
                              context,
                              Icons.feedback,
                              'Berikan Feedback',
                              'Bantu kami meningkatkan aplikasi',
                              const Color(0xFF22C55E),
                              const Color(0xFFA7F3D0),
                              isInfoPersonal: false,
                              isInfoPendidikan: false,
                              isInfoKeluarga: false,
                              isInfoPayroll: false,
                              isInfoTambahan: false,
                              isUbahPassword: false,
                              isPin: false,
                              isPengingatCIO: false,
                              isBahasa: false,
                              isPusatBantuan: false,
                              isKeamananPrivasi: false,
                              isBerikanFeedback: true,
                              isKeluar: false,
                              isMobile: isMobile,
                            ),
                            _buildEnhancedMenuItem(
                              context,
                              Icons.exit_to_app,
                              'Keluar',
                              'Tutup sesi dan keluar dari aplikasi',
                              dangerColor,
                              const Color(0xFFFECACA),
                              isInfoPersonal: false,
                              isInfoPendidikan: false,
                              isInfoKeluarga: false,
                              isInfoPayroll: false,
                              isInfoTambahan: false,
                              isUbahPassword: false,
                              isPin: false,
                              isPengingatCIO: false,
                              isBahasa: false,
                              isPusatBantuan: false,
                              isKeamananPrivasi: false,
                              isBerikanFeedback: false,
                              isKeluar: true,
                              isMobile: isMobile,
                            ),
                          ],
                          isMobile,
                        ),

                        // Bottom padding with decorative element
                        Container(
                          height: isMobile ? 60 : 80,
                          margin: const EdgeInsets.only(top: 20),
                          child: Center(
                            child: Opacity(
                              opacity: 0.6,
                              child: Text(
                                'Version 2.0.1 • Made with ❤️',
                                style: TextStyle(
                                  fontSize: isMobile ? 12 : 13,
                                  color: const Color(0xFF6B7280),
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, bool isMobile) {
    return RotationTransition(
      turns: _rotateAnimation,
      child: Container(
        width: isMobile ? 110 : 130,
        height: isMobile ? 110 : 130,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: SweepGradient(
            colors: [
              primaryColor.withOpacity(0.3),
              secondaryColor.withOpacity(0.2),
              accentColor.withOpacity(0.1),
              Colors.transparent,
              primaryColor.withOpacity(0.1),
            ],
            stops: const [0.0, 0.3, 0.6, 0.8, 1.0],
            startAngle: 0.0,
            endAngle: 3.14 * 2,
          ),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(0.25),
              spreadRadius: 4,
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
            BoxShadow(
              color: secondaryColor.withOpacity(0.15),
              spreadRadius: 2,
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
            BoxShadow(
              color: Colors.white.withOpacity(0.6),
              spreadRadius: -3,
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
          border: Border.all(color: Colors.white.withOpacity(0.8), width: 3),
        ),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: ClipOval(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [secondaryColor, accentColor],
                  center: Alignment.topLeft,
                  radius: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: Image.asset(
                'assets/images/profil.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [secondaryColor, accentColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Colors.white,
                      size: 50,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, bool isMobile) {
    return Column(
      children: [
        ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: [primaryColor, secondaryColor],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(bounds);
          },
          child: Text(
            'Hello, Leonardo Dicaprio',
            style: TextStyle(
              fontSize: isMobile ? 22 : 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 0.8,
              height: 1.2,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Fullstack Developer',
          style: TextStyle(
            fontSize: isMobile ? 14 : 16,
            color: const Color(0xFF4B5563),
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            shadows: [
              const Shadow(
                color: Colors.white,
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 20,
            vertical: isMobile ? 8 : 10,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                successColor.withOpacity(0.3),
                successColor.withOpacity(0.15),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: successColor.withOpacity(0.4),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: successColor.withOpacity(0.2),
                blurRadius: 10,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeInOut,
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: successColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: successColor.withOpacity(0.6),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Active • Online',
                style: TextStyle(
                  color: successColor,
                  fontWeight: FontWeight.bold,
                  fontSize: isMobile ? 13 : 14,
                  letterSpacing: 0.8,
                  shadows: [
                    Shadow(
                      color: successColor.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderActions(BuildContext context, bool isMobile) {
    return Padding(
      padding: EdgeInsets.only(right: isMobile ? 16 : 24),
      child: Row(
        children: [
          _buildAnimatedIcon(
            Icons.notifications,
            const Color(0xFF4B5563),
            () {
              _showNotification(context);
            },
            isMobile,
            badgeCount: 3,
          ),
          const SizedBox(width: 12),
          _buildAnimatedIcon(
            Icons.edit,
            secondaryColor,
            () {
              _showEditProfile(context);
            },
            isMobile,
            hasPulseEffect: true,
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedIcon(
    IconData icon,
    Color color,
    VoidCallback onTap,
    bool isMobile, {
    int badgeCount = 0,
    bool hasPulseEffect = false,
  }) {
    return Stack(
      children: [
        ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
            CurvedAnimation(
              parent: _headerAnimationController,
              curve: const Interval(0.5, 1.0, curve: Curves.elasticOut),
            ),
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: isMobile ? 40 : 46,
              height: isMobile ? 40 : 46,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                border: Border.all(color: color.withOpacity(0.2), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(0.1),
                    blurRadius: 8,
                    spreadRadius: 1,
                    offset: const Offset(0, 2),
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.4),
                    spreadRadius: -2,
                    blurRadius: 4,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              child: Center(
                child: hasPulseEffect
                    ? PulseAnimation(
                        child: Icon(
                          icon,
                          color: color,
                          size: isMobile ? 18 : 22,
                        ),
                      )
                    : Icon(icon, color: color, size: isMobile ? 18 : 22),
              ),
            ),
          ),
        ),
        if (badgeCount > 0)
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: dangerColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: dangerColor.withOpacity(0.5),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  badgeCount.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAnimatedSection(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    List<Widget> items,
    bool isMobile,
  ) {
    return FadeTransition(
      opacity: _sectionAnimationController,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
            .animate(
              CurvedAnimation(
                parent: _sectionAnimationController,
                curve: Curves.easeOutBack,
              ),
            ),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.98),
                Colors.white.withOpacity(0.92),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(isMobile ? 20 : 24),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.12),
                spreadRadius: 3,
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.8),
                spreadRadius: -4,
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
            ],
            border: Border.all(color: color.withOpacity(0.15), width: 1.5),
          ),
          child: Column(
            children: [
              _buildSectionHeader(
                context,
                title,
                icon,
                color,
                items.length,
                isMobile,
              ),
              ...items,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    int itemCount,
    bool isMobile,
  ) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        isMobile ? 20 : 24,
        isMobile ? 18 : 22,
        isMobile ? 20 : 24,
        isMobile ? 14 : 18,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.08), color.withOpacity(0.03)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isMobile ? 20 : 24),
          topRight: Radius.circular(isMobile ? 20 : 24),
        ),
        border: Border(
          bottom: BorderSide(color: color.withOpacity(0.1), width: 1.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: isMobile ? 38 : 44,
            height: isMobile ? 38 : 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [color.withOpacity(0.25), color.withOpacity(0.1)],
                radius: 0.8,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.2),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Icon(icon, color: color, size: isMobile ? 20 : 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: isMobile ? 18 : 20,
                fontWeight: FontWeight.w800,
                color: color,
                letterSpacing: 0.6,
                shadows: [
                  Shadow(
                    color: color.withOpacity(0.08),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 10 : 12,
              vertical: isMobile ? 5 : 6,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.15), color.withOpacity(0.08)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withOpacity(0.25), width: 1.5),
            ),
            child: Text(
              '$itemCount Item${itemCount > 1 ? 's' : ''}',
              style: TextStyle(
                color: color,
                fontSize: isMobile ? 12 : 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedMenuItem(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Color iconColor,
    Color backgroundColor, {
    bool isInfoPersonal = false,
    bool isInfoPendidikan = false,
    bool isInfoKeluarga = false,
    bool isInfoPayroll = false,
    bool isInfoTambahan = false,
    bool isUbahPassword = false,
    bool isPin = false,
    bool isPengingatCIO = false,
    bool isBahasa = false,
    bool isPusatBantuan = false,
    bool isKeamananPrivasi = false,
    bool isBerikanFeedback = false,
    bool isKeluar = false,
    required bool isMobile,
  }) {
    final itemKey = GlobalKey();
    bool isHovering = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (_) => setState(() => isHovering = true),
          onExit: (_) => setState(() => isHovering = false),
          child: GestureDetector(
            key: itemKey,
            onTap: () => _handleMenuItemTap(
              context,
              isInfoPersonal: isInfoPersonal,
              isInfoPendidikan: isInfoPendidikan,
              isInfoKeluarga: isInfoKeluarga,
              isInfoPayroll: isInfoPayroll,
              isInfoTambahan: isInfoTambahan,
              isUbahPassword: isUbahPassword,
              isPin: isPin,
              isPengingatCIO: isPengingatCIO,
              isBahasa: isBahasa,
              isPusatBantuan: isPusatBantuan,
              isKeamananPrivasi: isKeamananPrivasi,
              isBerikanFeedback: isBerikanFeedback,
              isKeluar: isKeluar,
              title: title,
              iconColor: iconColor,
            ),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              transform: Matrix4.identity()
                ..scale(isHovering ? 1.01 : 1.0)
                ..translate(isHovering ? 4.0 : 0.0, 0.0),
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 20 : 24,
                vertical: isMobile ? 16 : 20,
              ),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: const Color(0xFFE2E8F0).withOpacity(0.8),
                    width: 1.0,
                  ),
                ),
                gradient: isHovering
                    ? LinearGradient(
                        colors: [
                          iconColor.withOpacity(0.08),
                          iconColor.withOpacity(0.03),
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      )
                    : null,
                boxShadow: isHovering
                    ? [
                        BoxShadow(
                          color: iconColor.withOpacity(0.15),
                          blurRadius: 12,
                          spreadRadius: 2,
                          offset: const Offset(0, 3),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                children: [
                  // Animated icon with glow effect
                  _buildAnimatedMenuItemIcon(
                    icon,
                    iconColor,
                    backgroundColor,
                    isMobile,
                    isHovering,
                  ),

                  const SizedBox(width: 18),

                  // Text content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: isMobile ? 16 : 17,
                            fontWeight: FontWeight.w700,
                            color: isKeluar
                                ? dangerColor
                                : const Color(0xFF1E293B),
                            letterSpacing: 0.3,
                            shadows: isHovering
                                ? [
                                    Shadow(
                                      color: iconColor.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: const Offset(0, 1),
                                    ),
                                  ]
                                : null,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: isMobile ? 13 : 14,
                            color: const Color(0xFF64748B),
                            height: 1.4,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 0.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Animated arrow with glow
                  _buildAnimatedArrow(
                    isInfoPersonal ||
                        isInfoPendidikan ||
                        isInfoKeluarga ||
                        isInfoPayroll ||
                        isInfoTambahan ||
                        isUbahPassword ||
                        isPin ||
                        isPengingatCIO ||
                        isBahasa ||
                        isPusatBantuan ||
                        isKeamananPrivasi ||
                        isBerikanFeedback ||
                        isKeluar,
                    isMobile,
                    isHovering,
                    iconColor,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedMenuItemIcon(
    IconData icon,
    Color iconColor,
    Color backgroundColor,
    bool isMobile,
    bool isHovering,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.elasticOut,
      width: isMobile ? 46 : 52,
      height: isMobile ? 46 : 52,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            backgroundColor.withOpacity(isHovering ? 0.95 : 0.85),
            backgroundColor.withOpacity(isHovering ? 0.7 : 0.5),
          ],
          radius: 0.9,
          stops: const [0.0, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: iconColor.withOpacity(isHovering ? 0.5 : 0.3),
            spreadRadius: isHovering ? 2 : 1,
            blurRadius: isHovering ? 15 : 8,
            offset: const Offset(0, 3),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.6),
            spreadRadius: -2,
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
        border: Border.all(
          color: iconColor.withOpacity(isHovering ? 0.3 : 0.15),
          width: isHovering ? 2.0 : 1.5,
        ),
      ),
      child: Center(
        child: Icon(icon, color: iconColor, size: isMobile ? 22 : 24),
      ),
    );
  }

  Widget _buildAnimatedArrow(
    bool isSpecial,
    bool isMobile,
    bool isHovering,
    Color iconColor,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      transform: Matrix4.identity()..translate(isHovering ? 6.0 : 0.0, 0.0),
      child: Container(
        width: isMobile ? 30 : 34,
        height: isMobile ? 30 : 34,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              iconColor.withOpacity(isHovering ? 0.2 : 0.1),
              iconColor.withOpacity(isHovering ? 0.1 : 0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border.all(
            color: iconColor.withOpacity(isHovering ? 0.3 : 0.15),
            width: 1.5,
          ),
        ),
        child: Center(
          child: Icon(
            Icons.arrow_forward_ios_rounded,
            size: isMobile ? 14 : 16,
            color: iconColor.withOpacity(isHovering ? 0.9 : 0.7),
          ),
        ),
      ),
    );
  }

  void _handleMenuItemTap(
    BuildContext context, {
    bool isInfoPersonal = false,
    bool isInfoPendidikan = false,
    bool isInfoKeluarga = false,
    bool isInfoPayroll = false,
    bool isInfoTambahan = false,
    bool isUbahPassword = false,
    bool isPin = false,
    bool isPengingatCIO = false,
    bool isBahasa = false,
    bool isPusatBantuan = false,
    bool isKeamananPrivasi = false,
    bool isBerikanFeedback = false,
    bool isKeluar = false,
    required String title,
    required Color iconColor,
  }) {
    Widget? targetPage;

    if (isInfoPersonal) {
      targetPage = const InfoPersonalScreen();
    } else if (isInfoPendidikan) {
      targetPage = const InfoPendidikanScreen();
    } else if (isInfoKeluarga) {
      targetPage = const InfoKeluargaScreen();
    } else if (isInfoPayroll) {
      targetPage = const InfoPayrollScreen();
    } else if (isInfoTambahan) {
      targetPage = const InfoTambahanScreen();
    } else if (isUbahPassword) {
      targetPage = const UbahKataSandiPage();
    } else if (isPin) {
      targetPage = const PinPage();
    } else if (isPengingatCIO) {
      targetPage = const PengingatCIOPage();
    } else if (isBahasa) {
      targetPage = const BahasaPage();
    } else if (isPusatBantuan) {
      targetPage = const PusatBantuanPage();
    } else if (isKeamananPrivasi) {
      targetPage = const KeamananPrivasiPage();
    } else if (isBerikanFeedback) {
      targetPage = const BerikanFeedbackPage();
    } else if (isKeluar) {
      _showLogoutDialog(context);
      return;
    }

    if (targetPage != null) {
      _navigateWithAnimation(context, targetPage);
    } else {
      _showToast(context, 'Membuka $title', iconColor);
    }
  }

  void _navigateWithAnimation(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: FadeTransition(opacity: animation, child: child),
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      ),
    );
  }

  void _showToast(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(milliseconds: 800),
        elevation: 6,
      ),
    );
  }

  void _showNotification(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 20,
        backgroundColor: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor.withOpacity(0.1), Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.notifications_active_rounded,
                size: 60,
                color: primaryColor,
              ),
              const SizedBox(height: 16),
              const Text(
                'Notifikasi',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tidak ada notifikasi baru',
                style: TextStyle(color: Color(0xFF64748B)),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  'Tutup',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditProfile(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 20,
        backgroundColor: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [secondaryColor.withOpacity(0.1), Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.edit_rounded, size: 60, color: secondaryColor),
              const SizedBox(height: 16),
              const Text(
                'Edit Profil',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Fitur edit profil akan segera hadir!',
                style: TextStyle(color: Color(0xFF64748B)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: secondaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                ),
                child: const Text(
                  'Mengerti',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 20,
        backgroundColor: Colors.white,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                dangerColor.withOpacity(0.1),
                Colors.white.withOpacity(0.95),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: dangerColor.withOpacity(0.2), width: 1.5),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.exit_to_app_rounded, size: 60, color: dangerColor),
              const SizedBox(height: 16),
              const Text(
                'Keluar Aplikasi',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Apakah Anda yakin ingin keluar dari aplikasi?',
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF4B5563),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFFF1F5F9),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        side: BorderSide(
                          color: const Color(0xFFE2E8F0),
                          width: 1.5,
                        ),
                      ),
                      child: const Text(
                        'Batal',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF4B5563),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const KeluarPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: dangerColor,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                      ),
                      child: const Text(
                        'Keluar',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PulseAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const PulseAnimation({
    Key? key,
    required this.child,
    this.duration = const Duration(milliseconds: 1500),
  }) : super(key: key);

  @override
  _PulseAnimationState createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: widget.duration, vsync: this)
      ..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: _animation, child: widget.child);
  }
}
