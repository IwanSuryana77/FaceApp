import 'package:flutter/material.dart';

class KeamananPrivasiPage extends StatefulWidget {
  const KeamananPrivasiPage({super.key});

  @override
  State<KeamananPrivasiPage> createState() => _KeamananPrivasiPageState();
}

class _KeamananPrivasiPageState extends State<KeamananPrivasiPage>
    with SingleTickerProviderStateMixin {
  bool _shareLocation = true;
  bool _enableBiometric = false;
  bool _showStatus = true;
  bool _dataCollection = false;
  bool _autoLogout = true;
  bool _encryptionEnabled = true;
  bool _activityLog = true;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final isLargeScreen = screenWidth > 600;
    final isDesktop = screenWidth > 1024;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: AnimatedBuilder(
        animation: _fadeAnimation,
        builder: (context, child) {
          return FadeTransition(opacity: _fadeAnimation, child: child);
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // HEADER MODERN ANTI-TIMPA
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: MediaQuery.of(context).padding.top + 24,
                  bottom: 20,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                          onPressed: () => Navigator.of(context).maybePop(),
                        ),
                        const Spacer(),
                      ],
                    ),
                    SizedBox(height: 5),
                    Icon(Icons.shield_rounded, size: isSmallScreen ? 36 : 46, color: Colors.white),
                    SizedBox(height: 10),
                    Text(
                      'Keamanan & Privasi',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmallScreen ? 22 : 25,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.4,
                        shadows: [
                          Shadow(
                            blurRadius: 7,
                            color: Colors.black.withOpacity(0.09),
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 7),
                    Text(
                      'Kelola keamanan dan privasi akun Anda',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.92),
                        fontSize: isSmallScreen ? 12.5 : 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Jarak header ke card berikutnya
            SliverToBoxAdapter(child: SizedBox(height: 10)),

            // ==== ISI KONTEN ====
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 12 : (isDesktop ? 80 : 20),
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    _buildSecurityStatusCard(isSmallScreen, isLargeScreen),
                    SizedBox(height: isSmallScreen ? 16 : 24),

                    // KEAMANAN AKUN
                    _buildSectionHeader(
                      icon: Icons.lock_person_rounded,
                      title: 'Keamanan Akun',
                      subtitle: 'Pengaturan keamanan untuk akun Anda',
                      isSmallScreen: isSmallScreen,
                    ),
                    SizedBox(height: isSmallScreen ? 12 : 16),
                    _buildSettingCard(
                      isSmallScreen: isSmallScreen,
                      children: [
                        _buildEnhancedSecuritySwitch(
                          title: 'Login Biometrik',
                          subtitle: 'Gunakan sidik jari/face ID untuk login yang lebih aman',
                          value: _enableBiometric,
                          icon: Icons.fingerprint_rounded,
                          onChanged: (value) {
                            setState(() {
                              _enableBiometric = value;
                            });
                          },
                          gradient: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                          isSmallScreen: isSmallScreen,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Divider(
                            height: 1,
                            color: Color(0xFFE5E7EB).withOpacity(0.6),
                          ),
                        ),
                        _buildEnhancedSecuritySwitch(
                          title: 'Auto Logout',
                          subtitle: 'Keluar otomatis setelah 30 menit tidak aktif',
                          value: _autoLogout,
                          icon: Icons.timer_rounded,
                          onChanged: (value) {
                            setState(() {
                              _autoLogout = value;
                            });
                          },
                          gradient: [Color(0xFF10B981), Color(0xFF059669)],
                          isSmallScreen: isSmallScreen,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Divider(
                            height: 1,
                            color: Color(0xFFE5E7EB).withOpacity(0.6),
                          ),
                        ),
                        _buildEnhancedSecuritySwitch(
                          title: 'Enkripsi Data',
                          subtitle: 'Enkripsi data lokal untuk keamanan maksimal',
                          value: _encryptionEnabled,
                          icon: Icons.enhanced_encryption_rounded,
                          onChanged: (value) {
                            setState(() {
                              _encryptionEnabled = value;
                            });
                          },
                          gradient: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                          isSmallScreen: isSmallScreen,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Divider(
                            height: 1,
                            color: Color(0xFFE5E7EB).withOpacity(0.6),
                          ),
                        ),
                        _buildActionTile(
                          icon: Icons.lock_reset_rounded,
                          title: 'Ubah Password',
                          subtitle: 'Perbarui password akun Anda',
                          gradient: [Color(0xFFF59E0B), Color(0xFFD97706)],
                          isSmallScreen: isSmallScreen,
                          onTap: () {},
                        ),
                      ],
                    ),
                    SizedBox(height: isSmallScreen ? 16 : 24),

                    // PRIVASI DATA
                    _buildSectionHeader(
                      icon: Icons.privacy_tip_rounded,
                      title: 'Privasi Data',
                      subtitle: 'Kelola bagaimana data Anda digunakan',
                      isSmallScreen: isSmallScreen,
                    ),
                    SizedBox(height: isSmallScreen ? 12 : 16),
                    _buildSettingCard(
                      isSmallScreen: isSmallScreen,
                      children: [
                        _buildEnhancedSecuritySwitch(
                          title: 'Bagikan Lokasi',
                          subtitle: 'Izinkan akses lokasi untuk absensi yang akurat',
                          value: _shareLocation,
                          icon: Icons.location_on_rounded,
                          onChanged: (value) {
                            setState(() {
                              _shareLocation = value;
                            });
                          },
                          gradient: [Color(0xFF0EA5E9), Color(0xFF0284C7)],
                          isSmallScreen: isSmallScreen,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Divider(
                            height: 1,
                            color: Color(0xFFE5E7EB).withOpacity(0.6),
                          ),
                        ),
                        _buildEnhancedSecuritySwitch(
                          title: 'Tampilkan Status',
                          subtitle: 'Perlihatkan status online kepada kolega',
                          value: _showStatus,
                          icon: Icons.visibility_rounded,
                          onChanged: (value) {
                            setState(() {
                              _showStatus = value;
                            });
                          },
                          gradient: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                          isSmallScreen: isSmallScreen,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Divider(
                            height: 1,
                            color: Color(0xFFE5E7EB).withOpacity(0.6),
                          ),
                        ),
                        _buildEnhancedSecuritySwitch(
                          title: 'Log Aktivitas',
                          subtitle: 'Catat aktivitas akun untuk keamanan',
                          value: _activityLog,
                          icon: Icons.history_rounded,
                          onChanged: (value) {
                            setState(() {
                              _activityLog = value;
                            });
                          },
                          gradient: [Color(0xFF10B981), Color(0xFF059669)],
                          isSmallScreen: isSmallScreen,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Divider(
                            height: 1,
                            color: Color(0xFFE5E7EB).withOpacity(0.6),
                          ),
                        ),
                        _buildEnhancedSecuritySwitch(
                          title: 'Koleksi Data Anonim',
                          subtitle: 'Izinkan pengumpulan data untuk pengembangan',
                          value: _dataCollection,
                          icon: Icons.analytics_rounded,
                          onChanged: (value) {
                            setState(() {
                              _dataCollection = value;
                            });
                          },
                          gradient: [Color(0xFFEC4899), Color(0xFFDB2777)],
                          isSmallScreen: isSmallScreen,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==== HELPER BUILDER ====
  Widget _buildSecurityStatusCard(bool isSmallScreen, bool isLargeScreen) {
    final securityScore =
        (_enableBiometric ? 20 : 0) +
        (_autoLogout ? 20 : 0) +
        (_encryptionEnabled ? 20 : 0) +
        (_shareLocation ? 15 : 0) +
        (_activityLog ? 15 : 0) +
        (_dataCollection ? 10 : 0);

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Color(0xFFF0F9FF)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withOpacity(0.08),
            blurRadius: 20,
            spreadRadius: 1,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: isSmallScreen ? 50 : 60,
                height: isSmallScreen ? 50 : 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF3B82F6).withOpacity(0.1),
                      const Color(0xFF1D4ED8).withOpacity(0.1),
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.shield_rounded,
                    size: isSmallScreen ? 28 : 32,
                    color: _getSecurityColor(securityScore),
                  ),
                ),
              ),
              SizedBox(width: isSmallScreen ? 12 : 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tingkat Keamanan',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 12 : 14,
                        color: const Color(0xFF6B7280),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 2 : 4),
                    Text(
                      '${securityScore}/100',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 22 : 28,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1E293B),
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 6 : 8),
                    LinearProgressIndicator(
                      value: securityScore / 100,
                      backgroundColor: Colors.grey.shade200,
                      color: _getSecurityColor(securityScore),
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 12 : 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSecurityStat('Rendah', Colors.red, isSmallScreen),
              _buildSecurityStat('Sedang', Colors.orange, isSmallScreen),
              _buildSecurityStat('Baik', Colors.green, isSmallScreen),
              _buildSecurityStat('Sangat Baik', Color(0xFF10B981), isSmallScreen),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildSecurityStat(String label, Color color, bool isSmallScreen) {
    return Column(
      children: [
        Container(
          width: 6,
          height: 6,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: isSmallScreen ? 9 : 10,
            color: Colors.grey.shade600,
            height: 1.2,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
  Color _getSecurityColor(int score) {
    if (score < 40) return Colors.red;
    if (score < 70) return Colors.orange;
    if (score < 90) return Colors.green;
    return Color(0xFF10B981);
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool isSmallScreen,
  }) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: isSmallScreen ? 20 : 24,
                  color: const Color(0xFF3B82F6),
                ),
              ),
              SizedBox(width: isSmallScreen ? 8 : 12),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 18,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1E293B),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Padding(
            padding: EdgeInsets.only(left: isSmallScreen ? 38 : 44),
            child: Text(
              subtitle,
              style: TextStyle(
                fontSize: isSmallScreen ? 13 : 14,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildSettingCard({
    required bool isSmallScreen,
    required List<Widget> children,
  }) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Color(0xFFF8FAFC)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 15,
            spreadRadius: 1,
          ),
        ],
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Column(children: children),
    );
  }
  Widget _buildEnhancedSecuritySwitch({
    required String title,
    required String subtitle,
    required bool value,
    required IconData icon,
    required Function(bool) onChanged,
    required List<Color> gradient,
    required bool isSmallScreen,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: value ? gradient[0].withOpacity(0.07) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
              decoration: BoxDecoration(
                gradient: value ? LinearGradient(colors: gradient) : null,
                color: value ? null : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
                boxShadow: value
                    ? [BoxShadow(color: gradient[0].withOpacity(0.17), blurRadius: 7, spreadRadius: 1)]
                    : null,
              ),
              child: Icon(
                icon,
                size: isSmallScreen ? 20 : 22,
                color: value ? Colors.white : Colors.grey.shade600,
              ),
            ),
            SizedBox(width: isSmallScreen ? 12 : 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 15,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1E293B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: isSmallScreen ? 2 : 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 12 : 13,
                      color: Colors.grey.shade600,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Transform.scale(
              scale: isSmallScreen ? 0.9 : 1.1,
              child: Switch.adaptive(
                value: value,
                onChanged: onChanged,
                activeColor: gradient[0],
                activeTrackColor: gradient[0].withOpacity(0.3),
                inactiveThumbColor: Colors.grey.shade400,
                inactiveTrackColor: Colors.grey.shade300,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required List<Color> gradient,
    required VoidCallback onTap,
    required bool isSmallScreen,
    bool isDanger = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
        decoration: BoxDecoration(
          color: isDanger
              ? Color(0xFFFEE2E2).withOpacity(0.5)
              : gradient[0].withOpacity(0.06),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: gradient),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: gradient[0].withOpacity(0.14),
                    blurRadius: 6,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Icon(
                icon,
                size: isSmallScreen ? 20 : 22,
                color: Colors.white,
              ),
            ),
            SizedBox(width: isSmallScreen ? 12 : 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 14 : 15,
                      fontWeight: FontWeight.w600,
                      color: isDanger ? Color(0xFFDC2626) : Color(0xFF1E293B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: isSmallScreen ? 2 : 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 12 : 13,
                      color: isDanger
                          ? Color(0xFFDC2626).withOpacity(0.8)
                          : Colors.grey.shade600,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: isDanger ? Color(0xFFDC2626) : gradient[0],
              size: isSmallScreen ? 22 : 24,
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// class KeamananPrivasiPage extends StatefulWidget {
//   const KeamananPrivasiPage({super.key});

//   @override
//   State<KeamananPrivasiPage> createState() => _KeamananPrivasiPageState();
// }

// class _KeamananPrivasiPageState extends State<KeamananPrivasiPage>
//     with SingleTickerProviderStateMixin {
//   bool _shareLocation = true;
//   bool _enableBiometric = false;
//   bool _showStatus = true;
//   bool _dataCollection = false;
//   bool _autoLogout = true;
//   bool _encryptionEnabled = true;
//   bool _activityLog = true;

//   late AnimationController _animationController;
//   late Animation<double> _fadeAnimation;

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isSmallScreen = screenWidth < 360;
//     final isLargeScreen = screenWidth > 600;
//     final isDesktop = screenWidth > 1024;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC),
//       body: AnimatedBuilder(
//         animation: _fadeAnimation,
//         builder: (context, child) {
//           return FadeTransition(opacity: _fadeAnimation, child: child);
//         },
//         child: CustomScrollView(
//           physics: const BouncingScrollPhysics(),
//           slivers: [
//             // AppBar dengan gradient dan efek glassmorphism
//             SliverAppBar(
//               expandedHeight: isSmallScreen ? 150 : 180,
//               floating: false,
//               pinned: true,
//               flexibleSpace: FlexibleSpaceBar(
//                 title: Text(
//                   'Keamanan & Privasi',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: isSmallScreen ? 18 : (isLargeScreen ? 24 : 22),
//                     fontWeight: FontWeight.bold,
//                     shadows: [
//                       Shadow(
//                         blurRadius: 4,
//                         color: Colors.black.withOpacity(0.3),
//                         offset: const Offset(1, 1),
//                       ),
//                     ],
//                   ),
//                 ),
//                 centerTitle: true,
//                 background: Container(
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       begin: Alignment.topLeft,
//                       end: Alignment.bottomRight,
//                       colors: [
//                         const Color(0xFF3B82F6),
//                         const Color(0xFF1D4ED8),
//                       ],
//                     ),
//                   ),
//                   child: Stack(
//                     children: [
//                       // Content
//                       Padding(
//                         padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Icon(
//                               Icons.shield_rounded,
//                               size: isSmallScreen ? 32 : 40,
//                               color: Colors.white,
//                             ),
//                             const SizedBox(height: 8),
//                             Text(
//                               'Kelola keamanan dan privasi akun Anda',
//                               style: TextStyle(
//                                 color: Colors.white.withOpacity(0.9),
//                                 fontSize: isSmallScreen ? 12 : 14,
//                               ),
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),

//             SliverToBoxAdapter(
//               child: Padding(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: isSmallScreen ? 12 : (isDesktop ? 80 : 20),
//                   vertical: 16,
//                 ),
//                 child: Column(
//                   children: [
//                     // Security Status Card
//                     _buildSecurityStatusCard(isSmallScreen, isLargeScreen),

//                     SizedBox(height: isSmallScreen ? 16 : 24),

//                     // Keamanan Akun Section
//                     _buildSectionHeader(
//                       icon: Icons.lock_person_rounded,
//                       title: 'Keamanan Akun',
//                       subtitle: 'Pengaturan keamanan untuk akun Anda',
//                       isSmallScreen: isSmallScreen,
//                     ),

//                     SizedBox(height: isSmallScreen ? 12 : 16),

//                     _buildSettingCard(
//                       isSmallScreen: isSmallScreen,
//                       children: [
//                         _buildEnhancedSecuritySwitch(
//                           title: 'Login Biometrik',
//                           subtitle:
//                               'Gunakan sidik jari/face ID untuk login yang lebih aman',
//                           value: _enableBiometric,
//                           icon: Icons.fingerprint_rounded,
//                           onChanged: (value) {
//                             setState(() {
//                               _enableBiometric = value;
//                             });
//                           },
//                           gradient: [
//                             const Color(0xFF8B5CF6),
//                             const Color(0xFF7C3AED),
//                           ],
//                           isSmallScreen: isSmallScreen,
//                         ),
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                             vertical: isSmallScreen ? 6 : 8,
//                           ),
//                           child: Divider(
//                             height: 1,
//                             color: const Color(0xFFE5E7EB).withOpacity(0.6),
//                           ),
//                         ),
//                         _buildEnhancedSecuritySwitch(
//                           title: 'Auto Logout',
//                           subtitle:
//                               'Keluar otomatis setelah 30 menit tidak aktif',
//                           value: _autoLogout,
//                           icon: Icons.timer_rounded,
//                           onChanged: (value) {
//                             setState(() {
//                               _autoLogout = value;
//                             });
//                           },
//                           gradient: [
//                             const Color(0xFF10B981),
//                             const Color(0xFF059669),
//                           ],
//                           isSmallScreen: isSmallScreen,
//                         ),
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                             vertical: isSmallScreen ? 6 : 8,
//                           ),
//                           child: Divider(
//                             height: 1,
//                             color: const Color(0xFFE5E7EB).withOpacity(0.6),
//                           ),
//                         ),
//                         _buildEnhancedSecuritySwitch(
//                           title: 'Enkripsi Data',
//                           subtitle:
//                               'Enkripsi data lokal untuk keamanan maksimal',
//                           value: _encryptionEnabled,
//                           icon: Icons.enhanced_encryption_rounded,
//                           onChanged: (value) {
//                             setState(() {
//                               _encryptionEnabled = value;
//                             });
//                           },
//                           gradient: [
//                             const Color(0xFF3B82F6),
//                             const Color(0xFF1D4ED8),
//                           ],
//                           isSmallScreen: isSmallScreen,
//                         ),
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                             vertical: isSmallScreen ? 6 : 8,
//                           ),
//                           child: Divider(
//                             height: 1,
//                             color: const Color(0xFFE5E7EB).withOpacity(0.6),
//                           ),
//                         ),
//                         _buildActionTile(
//                           icon: Icons.lock_reset_rounded,
//                           title: 'Ubah Password',
//                           subtitle: 'Perbarui password akun Anda',
//                           gradient: [
//                             const Color(0xFFF59E0B),
//                             const Color(0xFFD97706),
//                           ],
//                           isSmallScreen: isSmallScreen,
//                           onTap: () {
//                             _showChangePasswordDialog(
//                               context,
//                               isSmallScreen,
//                               isLargeScreen,
//                             );
//                           },
//                         ),
//                       ],
//                     ),

//                     SizedBox(height: isSmallScreen ? 16 : 24),

//                     // Privasi Data Section
//                     _buildSectionHeader(
//                       icon: Icons.privacy_tip_rounded,
//                       title: 'Privasi Data',
//                       subtitle: 'Kelola bagaimana data Anda digunakan',
//                       isSmallScreen: isSmallScreen,
//                     ),

//                     SizedBox(height: isSmallScreen ? 12 : 16),

//                     _buildSettingCard(
//                       isSmallScreen: isSmallScreen,
//                       children: [
//                         _buildEnhancedSecuritySwitch(
//                           title: 'Bagikan Lokasi',
//                           subtitle:
//                               'Izinkan akses lokasi untuk absensi yang akurat',
//                           value: _shareLocation,
//                           icon: Icons.location_on_rounded,
//                           onChanged: (value) {
//                             setState(() {
//                               _shareLocation = value;
//                             });
//                           },
//                           gradient: [
//                             const Color(0xFF0EA5E9),
//                             const Color(0xFF0284C7),
//                           ],
//                           isSmallScreen: isSmallScreen,
//                         ),
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                             vertical: isSmallScreen ? 6 : 8,
//                           ),
//                           child: Divider(
//                             height: 1,
//                             color: const Color(0xFFE5E7EB).withOpacity(0.6),
//                           ),
//                         ),
//                         _buildEnhancedSecuritySwitch(
//                           title: 'Tampilkan Status',
//                           subtitle: 'Perlihatkan status online kepada kolega',
//                           value: _showStatus,
//                           icon: Icons.visibility_rounded,
//                           onChanged: (value) {
//                             setState(() {
//                               _showStatus = value;
//                             });
//                           },
//                           gradient: [
//                             const Color(0xFF8B5CF6),
//                             const Color(0xFF7C3AED),
//                           ],
//                           isSmallScreen: isSmallScreen,
//                         ),
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                             vertical: isSmallScreen ? 6 : 8,
//                           ),
//                           child: Divider(
//                             height: 1,
//                             color: const Color(0xFFE5E7EB).withOpacity(0.6),
//                           ),
//                         ),
//                         _buildEnhancedSecuritySwitch(
//                           title: 'Log Aktivitas',
//                           subtitle: 'Catat aktivitas akun untuk keamanan',
//                           value: _activityLog,
//                           icon: Icons.history_rounded,
//                           onChanged: (value) {
//                             setState(() {
//                               _activityLog = value;
//                             });
//                           },
//                           gradient: [
//                             const Color(0xFF10B981),
//                             const Color(0xFF059669),
//                           ],
//                           isSmallScreen: isSmallScreen,
//                         ),
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                             vertical: isSmallScreen ? 6 : 8,
//                           ),
//                           child: Divider(
//                             height: 1,
//                             color: const Color(0xFFE5E7EB).withOpacity(0.6),
//                           ),
//                         ),
//                         _buildEnhancedSecuritySwitch(
//                           title: 'Koleksi Data Anonim',
//                           subtitle:
//                               'Izinkan pengumpulan data untuk pengembangan',
//                           value: _dataCollection,
//                           icon: Icons.analytics_rounded,
//                           onChanged: (value) {
//                             setState(() {
//                               _dataCollection = value;
//                             });
//                           },
//                           gradient: [
//                             const Color(0xFFEC4899),
//                             const Color(0xFFDB2777),
//                           ],
//                           isSmallScreen: isSmallScreen,
//                         ),
//                       ],
//                     ),

//                     SizedBox(height: isSmallScreen ? 16 : 24),

//                     // Informasi Pribadi Section
//                     _buildSectionHeader(
//                       icon: Icons.person_outline_rounded,
//                       title: 'Informasi Pribadi',
//                       subtitle: 'Kelola data pribadi Anda',
//                       isSmallScreen: isSmallScreen,
//                     ),

//                     SizedBox(height: isSmallScreen ? 12 : 16),

//                     _buildSettingCard(
//                       isSmallScreen: isSmallScreen,
//                       children: [
//                         _buildActionTile(
//                           icon: Icons.download_for_offline_rounded,
//                           title: 'Ekspor Data Pribadi',
//                           subtitle: 'Unduh semua data pribadi Anda',
//                           gradient: [
//                             const Color(0xFF3B82F6),
//                             const Color(0xFF1D4ED8),
//                           ],
//                           isSmallScreen: isSmallScreen,
//                           onTap: () {
//                             _exportPersonalData(context, isSmallScreen);
//                           },
//                         ),
//                         Padding(
//                           padding: EdgeInsets.symmetric(
//                             vertical: isSmallScreen ? 6 : 8,
//                           ),
//                           child: Divider(
//                             height: 1,
//                             color: const Color(0xFFE5E7EB).withOpacity(0.6),
//                           ),
//                         ),
//                         _buildActionTile(
//                           icon: Icons.delete_forever_rounded,
//                           title: 'Hapus Data Akun',
//                           subtitle: 'Hapus permanen semua data terkait akun',
//                           gradient: [
//                             const Color(0xFFEF4444),
//                             const Color(0xFFDC2626),
//                           ],
//                           isSmallScreen: isSmallScreen,
//                           isDanger: true,
//                           onTap: () {
//                             _showDeleteDataDialog(context, isSmallScreen);
//                           },
//                         ),
//                       ],
//                     ),

//                     SizedBox(height: isSmallScreen ? 16 : 24),

//                     // Kebijakan Privasi Card
//                     Container(
//                       padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                           colors: [
//                             const Color(0xFFF5F3FF),
//                             const Color(0xFFEDE9FE).withOpacity(0.5),
//                           ],
//                         ),
//                         borderRadius: BorderRadius.circular(16),
//                         border: Border.all(
//                           color: const Color(0xFFDDD6FE),
//                           width: 1,
//                         ),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.08),
//                             blurRadius: 15,
//                             spreadRadius: 1,
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Container(
//                                 padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
//                                 decoration: BoxDecoration(
//                                   color: const Color(
//                                     0xFF3B82F6,
//                                   ).withOpacity(0.1),
//                                   borderRadius: BorderRadius.circular(10),
//                                 ),
//                                 child: Icon(
//                                   Icons.security_rounded,
//                                   size: isSmallScreen ? 20 : 24,
//                                   color: const Color(0xFF3B82F6),
//                                 ),
//                               ),
//                               SizedBox(width: isSmallScreen ? 8 : 12),
//                               Expanded(
//                                 child: Text(
//                                   'Kebijakan Privasi',
//                                   style: TextStyle(
//                                     fontSize: isSmallScreen ? 16 : 18,
//                                     fontWeight: FontWeight.bold,
//                                     color: const Color(0xFF1E293B),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: isSmallScreen ? 12 : 16),
//                           Text(
//                             'AbsenIn menghormati privasi Anda. Data digunakan untuk:',
//                             style: TextStyle(
//                               fontSize: isSmallScreen ? 13 : 14,
//                               color: Colors.grey.shade700,
//                               height: 1.5,
//                             ),
//                           ),
//                           SizedBox(height: isSmallScreen ? 8 : 12),
//                           _buildPrivacyPoint(
//                             'Verifikasi kehadiran dan keamanan',
//                             isSmallScreen: isSmallScreen,
//                           ),
//                           _buildPrivacyPoint(
//                             'Penggajian dan tunjangan karyawan',
//                             isSmallScreen: isSmallScreen,
//                           ),
//                           _buildPrivacyPoint(
//                             'Pengembangan aplikasi yang lebih baik',
//                             isSmallScreen: isSmallScreen,
//                           ),
//                           _buildPrivacyPoint(
//                             'Kepatuhan dengan regulasi hukum',
//                             isSmallScreen: isSmallScreen,
//                           ),
//                           SizedBox(height: isSmallScreen ? 16 : 20),
//                           Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(14),
//                               gradient: LinearGradient(
//                                 colors: [
//                                   const Color(0xFF3B82F6).withOpacity(0.1),
//                                   const Color(0xFF1D4ED8).withOpacity(0.05),
//                                 ],
//                               ),
//                             ),
//                             child: ElevatedButton(
//                               onPressed: () {
//                                 _showPrivacyPolicy(context, isSmallScreen);
//                               },
//                               style: ElevatedButton.styleFrom(
//                                 backgroundColor: Colors.transparent,
//                                 foregroundColor: const Color(0xFF3B82F6),
//                                 padding: EdgeInsets.symmetric(
//                                   vertical: isSmallScreen ? 12 : 14,
//                                 ),
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(14),
//                                 ),
//                                 elevation: 0,
//                               ),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Icons.article_rounded,
//                                     size: isSmallScreen ? 18 : 20,
//                                   ),
//                                   SizedBox(width: isSmallScreen ? 6 : 8),
//                                   Text(
//                                     'Baca Kebijakan Lengkap',
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.w600,
//                                       fontSize: isSmallScreen ? 14 : 15,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                     SizedBox(height: isSmallScreen ? 20 : 40),

//                     // Security Tips
//                     Container(
//                       padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(16),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.grey.withOpacity(0.08),
//                             blurRadius: 15,
//                             spreadRadius: 1,
//                           ),
//                         ],
//                         border: Border.all(
//                           color: Colors.grey.shade100,
//                           width: 1,
//                         ),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Container(
//                                 padding: EdgeInsets.all(isSmallScreen ? 5 : 6),
//                                 decoration: BoxDecoration(
//                                   color: const Color(
//                                     0xFF10B981,
//                                   ).withOpacity(0.1),
//                                   borderRadius: BorderRadius.circular(8),
//                                 ),
//                                 child: Icon(
//                                   Icons.tips_and_updates_rounded,
//                                   size: isSmallScreen ? 18 : 20,
//                                   color: const Color(0xFF10B981),
//                                 ),
//                               ),
//                               SizedBox(width: isSmallScreen ? 8 : 12),
//                               Expanded(
//                                 child: Text(
//                                   'Tips Keamanan',
//                                   style: TextStyle(
//                                     fontSize: isSmallScreen ? 15 : 16,
//                                     fontWeight: FontWeight.bold,
//                                     color: const Color(0xFF1E293B),
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           SizedBox(height: isSmallScreen ? 10 : 12),
//                           _buildSecurityTip(
//                             'Gunakan password yang kuat dan unik',
//                             isSmallScreen: isSmallScreen,
//                           ),
//                           _buildSecurityTip(
//                             'Aktifkan verifikasi dua langkah jika tersedia',
//                             isSmallScreen: isSmallScreen,
//                           ),
//                           _buildSecurityTip(
//                             'Jangan bagikan kredensial login Anda',
//                             isSmallScreen: isSmallScreen,
//                           ),
//                           _buildSecurityTip(
//                             'Perbarui aplikasi secara berkala',
//                             isSmallScreen: isSmallScreen,
//                           ),
//                         ],
//                       ),
//                     ),

//                     SizedBox(height: isSmallScreen ? 40 : 60),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSecurityStatusCard(bool isSmallScreen, bool isLargeScreen) {
//     final securityScore =
//         (_enableBiometric ? 20 : 0) +
//         (_autoLogout ? 20 : 0) +
//         (_encryptionEnabled ? 20 : 0) +
//         (_shareLocation ? 15 : 0) +
//         (_activityLog ? 15 : 0) +
//         (_dataCollection ? 10 : 0);

//     return Container(
//       padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [Colors.white, Color(0xFFF0F9FF)],
//         ),
//         borderRadius: BorderRadius.circular(20),
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF3B82F6).withOpacity(0.08),
//             blurRadius: 20,
//             spreadRadius: 1,
//             offset: const Offset(0, 6),
//           ),
//         ],
//         border: Border.all(color: Colors.white, width: 2),
//       ),
//       child: Column(
//         children: [
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Container(
//                 width: isSmallScreen ? 50 : 60,
//                 height: isSmallScreen ? 50 : 60,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   gradient: LinearGradient(
//                     colors: [
//                       const Color(0xFF3B82F6).withOpacity(0.1),
//                       const Color(0xFF1D4ED8).withOpacity(0.1),
//                     ],
//                   ),
//                 ),
//                 child: Center(
//                   child: Icon(
//                     Icons.shield_rounded,
//                     size: isSmallScreen ? 28 : 32,
//                     color: _getSecurityColor(securityScore),
//                   ),
//                 ),
//               ),
//               SizedBox(width: isSmallScreen ? 12 : 20),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Tingkat Keamanan',
//                       style: TextStyle(
//                         fontSize: isSmallScreen ? 12 : 14,
//                         color: const Color(0xFF6B7280),
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     SizedBox(height: isSmallScreen ? 2 : 4),
//                     Text(
//                       '${securityScore}/100',
//                       style: TextStyle(
//                         fontSize: isSmallScreen ? 22 : 28,
//                         fontWeight: FontWeight.bold,
//                         color: const Color(0xFF1E293B),
//                       ),
//                     ),
//                     SizedBox(height: isSmallScreen ? 6 : 8),
//                     LinearProgressIndicator(
//                       value: securityScore / 100,
//                       backgroundColor: Colors.grey.shade200,
//                       color: _getSecurityColor(securityScore),
//                       minHeight: 6,
//                       borderRadius: BorderRadius.circular(3),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: isSmallScreen ? 12 : 20),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _buildSecurityStat('Rendah', Colors.red, isSmallScreen),
//               _buildSecurityStat('Sedang', Colors.orange, isSmallScreen),
//               _buildSecurityStat('Baik', Colors.green, isSmallScreen),
//               _buildSecurityStat(
//                 'Sangat Baik',
//                 const Color(0xFF10B981),
//                 isSmallScreen,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSecurityStat(String label, Color color, bool isSmallScreen) {
//     return Column(
//       children: [
//         Container(
//           width: 6,
//           height: 6,
//           decoration: BoxDecoration(color: color, shape: BoxShape.circle),
//         ),
//         SizedBox(height: 4),
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: isSmallScreen ? 9 : 10,
//             color: Colors.grey.shade600,
//             height: 1.2,
//           ),
//           textAlign: TextAlign.center,
//         ),
//       ],
//     );
//   }

//   Color _getSecurityColor(int score) {
//     if (score < 40) return Colors.red;
//     if (score < 70) return Colors.orange;
//     if (score < 90) return Colors.green;
//     return const Color(0xFF10B981);
//   }

//   Widget _buildSectionHeader({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required bool isSmallScreen,
//   }) {
//     return Container(
//       width: double.infinity,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFF3B82F6).withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(
//                   icon,
//                   size: isSmallScreen ? 20 : 24,
//                   color: const Color(0xFF3B82F6),
//                 ),
//               ),
//               SizedBox(width: isSmallScreen ? 8 : 12),
//               Expanded(
//                 child: Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: isSmallScreen ? 16 : 18,
//                     fontWeight: FontWeight.bold,
//                     color: const Color(0xFF1E293B),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           SizedBox(height: 4),
//           Padding(
//             padding: EdgeInsets.only(left: isSmallScreen ? 38 : 44),
//             child: Text(
//               subtitle,
//               style: TextStyle(
//                 fontSize: isSmallScreen ? 13 : 14,
//                 color: Colors.grey.shade600,
//                 height: 1.4,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSettingCard({
//     required bool isSmallScreen,
//     required List<Widget> children,
//   }) {
//     return Container(
//       padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [Colors.white, Color(0xFFF8FAFC)],
//         ),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.grey.withOpacity(0.08),
//             blurRadius: 15,
//             spreadRadius: 1,
//           ),
//         ],
//         border: Border.all(color: Colors.white, width: 2),
//       ),
//       child: Column(children: children),
//     );
//   }

//   Widget _buildEnhancedSecuritySwitch({
//     required String title,
//     required String subtitle,
//     required bool value,
//     required IconData icon,
//     required Function(bool) onChanged,
//     required List<Color> gradient,
//     required bool isSmallScreen,
//   }) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       decoration: BoxDecoration(
//         color: value ? gradient[0].withOpacity(0.05) : Colors.transparent,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Padding(
//         padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Container(
//               padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
//               decoration: BoxDecoration(
//                 gradient: value ? LinearGradient(colors: gradient) : null,
//                 color: value ? null : Colors.grey.shade100,
//                 borderRadius: BorderRadius.circular(10),
//                 boxShadow: value
//                     ? [
//                         BoxShadow(
//                           color: gradient[0].withOpacity(0.15),
//                           blurRadius: 6,
//                           spreadRadius: 1,
//                         ),
//                       ]
//                     : null,
//               ),
//               child: Icon(
//                 icon,
//                 size: isSmallScreen ? 20 : 22,
//                 color: value ? Colors.white : Colors.grey.shade600,
//               ),
//             ),
//             SizedBox(width: isSmallScreen ? 12 : 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     title,
//                     style: TextStyle(
//                       fontSize: isSmallScreen ? 14 : 15,
//                       fontWeight: FontWeight.w600,
//                       color: const Color(0xFF1E293B),
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   SizedBox(height: isSmallScreen ? 2 : 4),
//                   Text(
//                     subtitle,
//                     style: TextStyle(
//                       fontSize: isSmallScreen ? 12 : 13,
//                       color: Colors.grey.shade600,
//                       height: 1.3,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             ),
//             Transform.scale(
//               scale: isSmallScreen ? 0.9 : 1.1,
//               child: Switch.adaptive(
//                 value: value,
//                 onChanged: onChanged,
//                 activeColor: gradient[0],
//                 activeTrackColor: gradient[0].withOpacity(0.3),
//                 inactiveThumbColor: Colors.grey.shade400,
//                 inactiveTrackColor: Colors.grey.shade300,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildActionTile({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//     required List<Color> gradient,
//     required VoidCallback onTap,
//     required bool isSmallScreen,
//     bool isDanger = false,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
//         decoration: BoxDecoration(
//           color: isDanger
//               ? const Color(0xFFFEE2E2).withOpacity(0.5)
//               : gradient[0].withOpacity(0.05),
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Container(
//               padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(colors: gradient),
//                 borderRadius: BorderRadius.circular(10),
//                 boxShadow: [
//                   BoxShadow(
//                     color: gradient[0].withOpacity(0.15),
//                     blurRadius: 6,
//                     spreadRadius: 1,
//                   ),
//                 ],
//               ),
//               child: Icon(
//                 icon,
//                 size: isSmallScreen ? 20 : 22,
//                 color: Colors.white,
//               ),
//             ),
//             SizedBox(width: isSmallScreen ? 12 : 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     title,
//                     style: TextStyle(
//                       fontSize: isSmallScreen ? 14 : 15,
//                       fontWeight: FontWeight.w600,
//                       color: isDanger
//                           ? const Color(0xFFDC2626)
//                           : const Color(0xFF1E293B),
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   SizedBox(height: isSmallScreen ? 2 : 4),
//                   Text(
//                     subtitle,
//                     style: TextStyle(
//                       fontSize: isSmallScreen ? 12 : 13,
//                       color: isDanger
//                           ? const Color(0xFFDC2626).withOpacity(0.8)
//                           : Colors.grey.shade600,
//                       height: 1.3,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             ),
//             Icon(
//               Icons.chevron_right_rounded,
//               color: isDanger ? const Color(0xFFDC2626) : gradient[0],
//               size: isSmallScreen ? 22 : 24,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPrivacyPoint(String text, {required bool isSmallScreen}) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: isSmallScreen ? 6 : 8),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             margin: EdgeInsets.only(
//               top: isSmallScreen ? 7 : 6,
//               right: isSmallScreen ? 10 : 12,
//             ),
//             width: 5,
//             height: 5,
//             decoration: BoxDecoration(
//               color: const Color(0xFF3B82F6),
//               shape: BoxShape.circle,
//             ),
//           ),
//           Expanded(
//             child: Text(
//               text,
//               style: TextStyle(
//                 fontSize: isSmallScreen ? 13 : 14,
//                 color: Colors.grey.shade700,
//                 height: 1.5,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSecurityTip(String text, {required bool isSmallScreen}) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: isSmallScreen ? 8 : 10),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(
//             Icons.check_circle_rounded,
//             size: isSmallScreen ? 16 : 18,
//             color: const Color(0xFF10B981),
//           ),
//           SizedBox(width: isSmallScreen ? 10 : 12),
//           Expanded(
//             child: Text(
//               text,
//               style: TextStyle(
//                 fontSize: isSmallScreen ? 13 : 14,
//                 color: Colors.grey.shade700,
//                 height: 1.4,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _showChangePasswordDialog(
//     BuildContext context,
//     bool isSmallScreen,
//     bool isLargeScreen,
//   ) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(
//           top: Radius.circular(isSmallScreen ? 20 : 30),
//         ),
//       ),
//       builder: (context) => Container(
//         padding: EdgeInsets.all(isSmallScreen ? 20 : 25),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: 50,
//               height: 4,
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade300,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//             SizedBox(height: isSmallScreen ? 20 : 25),
//             Container(
//               padding: EdgeInsets.all(isSmallScreen ? 14 : 16),
//               decoration: BoxDecoration(
//                 color: const Color(0xFF3B82F6).withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: Row(
//                 children: [
//                   Container(
//                     padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFF3B82F6),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Icon(
//                       Icons.lock_reset_rounded,
//                       color: Colors.white,
//                       size: isSmallScreen ? 24 : 28,
//                     ),
//                   ),
//                   SizedBox(width: isSmallScreen ? 12 : 15),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'Ubah Password',
//                           style: TextStyle(
//                             fontSize: isSmallScreen ? 16 : 18,
//                             fontWeight: FontWeight.bold,
//                             color: const Color(0xFF1E293B),
//                           ),
//                         ),
//                         SizedBox(height: isSmallScreen ? 2 : 4),
//                         Text(
//                           'Anda akan diarahkan ke halaman perubahan password',
//                           style: TextStyle(
//                             fontSize: isSmallScreen ? 13 : 14,
//                             color: Colors.grey.shade600,
//                             height: 1.3,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: isSmallScreen ? 20 : 25),
//             Row(
//               children: [
//                 Expanded(
//                   child: OutlinedButton(
//                     onPressed: () => Navigator.pop(context),
//                     style: OutlinedButton.styleFrom(
//                       padding: EdgeInsets.symmetric(
//                         vertical: isSmallScreen ? 12 : 15,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       side: BorderSide(color: Colors.grey.shade300),
//                     ),
//                     child: Text(
//                       'Batal',
//                       style: TextStyle(
//                         fontSize: isSmallScreen ? 14 : 15,
//                         color: Colors.grey.shade700,
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: isSmallScreen ? 12 : 15),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                       // Navigate to change password page
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color(0xFF3B82F6),
//                       padding: EdgeInsets.symmetric(
//                         vertical: isSmallScreen ? 12 : 15,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(12),
//                       ),
//                       elevation: 2,
//                     ),
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(
//                           Icons.arrow_forward_rounded,
//                           size: isSmallScreen ? 17 : 18,
//                         ),
//                         SizedBox(width: isSmallScreen ? 6 : 8),
//                         Text(
//                           'Lanjut',
//                           style: TextStyle(
//                             fontSize: isSmallScreen ? 14 : 15,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: isSmallScreen ? 16 : 20),
//           ],
//         ),
//       ),
//     );
//   }

//   void _exportPersonalData(BuildContext context, bool isSmallScreen) {
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         backgroundColor: Colors.transparent,
//         insetPadding: EdgeInsets.all(isSmallScreen ? 20 : 30),
//         child: Container(
//           padding: EdgeInsets.all(isSmallScreen ? 20 : 30),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [Colors.white, const Color(0xFFF8FAFC)],
//             ),
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   gradient: LinearGradient(
//                     colors: [
//                       const Color(0xFF3B82F6).withOpacity(0.1),
//                       Colors.transparent,
//                     ],
//                   ),
//                 ),
//                 child: Icon(
//                   Icons.download_rounded,
//                   size: isSmallScreen ? 36 : 40,
//                   color: const Color(0xFF3B82F6),
//                 ),
//               ),
//               SizedBox(height: isSmallScreen ? 16 : 20),
//               Text(
//                 'Ekspor Data Pribadi',
//                 style: TextStyle(
//                   fontSize: isSmallScreen ? 20 : 22,
//                   fontWeight: FontWeight.bold,
//                   color: const Color(0xFF1E293B),
//                 ),
//               ),
//               SizedBox(height: isSmallScreen ? 8 : 10),
//               Text(
//                 'Data pribadi Anda akan dikirim ke email terdaftar dalam format PDF',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: isSmallScreen ? 13 : 14,
//                   color: Colors.grey.shade600,
//                   height: 1.4,
//                 ),
//               ),
//               SizedBox(height: isSmallScreen ? 20 : 25),
//               Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: () => Navigator.pop(context),
//                       style: OutlinedButton.styleFrom(
//                         padding: EdgeInsets.symmetric(
//                           vertical: isSmallScreen ? 12 : 15,
//                         ),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: Text(
//                         'Batal',
//                         style: TextStyle(
//                           fontSize: isSmallScreen ? 14 : 15,
//                           color: Colors.grey.shade700,
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: isSmallScreen ? 12 : 15),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Row(
//                               children: [
//                                 Container(
//                                   padding: const EdgeInsets.all(6),
//                                   decoration: BoxDecoration(
//                                     color: Colors.white,
//                                     borderRadius: BorderRadius.circular(20),
//                                   ),
//                                   child: const Icon(
//                                     Icons.download_done_rounded,
//                                     size: 20,
//                                     color: Colors.green,
//                                   ),
//                                 ),
//                                 SizedBox(width: isSmallScreen ? 8 : 12),
//                                 Expanded(
//                                   child: Text(
//                                     'Permintaan ekspor data telah dikirim ke email Anda',
//                                     style: TextStyle(fontSize: 14),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             backgroundColor: Colors.green,
//                             behavior: SnackBarBehavior.floating,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             margin: EdgeInsets.all(isSmallScreen ? 16 : 20),
//                             elevation: 6,
//                           ),
//                         );
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF3B82F6),
//                         padding: EdgeInsets.symmetric(
//                           vertical: isSmallScreen ? 12 : 15,
//                         ),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.download_rounded,
//                             size: isSmallScreen ? 17 : 18,
//                           ),
//                           SizedBox(width: isSmallScreen ? 6 : 8),
//                           Text(
//                             'Ekspor',
//                             style: TextStyle(
//                               fontSize: isSmallScreen ? 14 : 15,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _showDeleteDataDialog(BuildContext context, bool isSmallScreen) {
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         backgroundColor: Colors.transparent,
//         insetPadding: EdgeInsets.all(isSmallScreen ? 20 : 30),
//         child: Container(
//           padding: EdgeInsets.all(isSmallScreen ? 20 : 30),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [Colors.white, const Color(0xFFFEF2F2)],
//             ),
//             borderRadius: BorderRadius.circular(20),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   gradient: LinearGradient(
//                     colors: [
//                       const Color(0xFFEF4444).withOpacity(0.1),
//                       Colors.transparent,
//                     ],
//                   ),
//                 ),
//                 child: Icon(
//                   Icons.warning_amber_rounded,
//                   size: isSmallScreen ? 36 : 40,
//                   color: const Color(0xFFEF4444),
//                 ),
//               ),
//               SizedBox(height: isSmallScreen ? 16 : 20),
//               Text(
//                 'Hapus Data Akun',
//                 style: TextStyle(
//                   fontSize: isSmallScreen ? 20 : 22,
//                   fontWeight: FontWeight.bold,
//                   color: const Color(0xFF1E293B),
//                 ),
//               ),
//               SizedBox(height: isSmallScreen ? 8 : 10),
//               Text(
//                 'Semua data akun Anda akan dihapus permanen. Tindakan ini tidak dapat dibatalkan.',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: isSmallScreen ? 13 : 14,
//                   color: Colors.grey.shade600,
//                   height: 1.4,
//                 ),
//               ),
//               SizedBox(height: isSmallScreen ? 20 : 25),
//               Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton(
//                       onPressed: () => Navigator.pop(context),
//                       style: OutlinedButton.styleFrom(
//                         padding: EdgeInsets.symmetric(
//                           vertical: isSmallScreen ? 12 : 15,
//                         ),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: Text(
//                         'Batal',
//                         style: TextStyle(
//                           fontSize: isSmallScreen ? 14 : 15,
//                           color: Colors.grey.shade700,
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: isSmallScreen ? 12 : 15),
//                   Expanded(
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                         _showDeleteConfirmation(context, isSmallScreen);
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFFEF4444),
//                         padding: EdgeInsets.symmetric(
//                           vertical: isSmallScreen ? 12 : 15,
//                         ),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.delete_forever_rounded,
//                             size: isSmallScreen ? 17 : 18,
//                           ),
//                           SizedBox(width: isSmallScreen ? 6 : 8),
//                           Text(
//                             'Hapus Data',
//                             style: TextStyle(
//                               fontSize: isSmallScreen ? 14 : 15,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _showDeleteConfirmation(BuildContext context, bool isSmallScreen) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) => Container(
//         height: MediaQuery.of(context).size.height * 0.7,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.vertical(
//             top: Radius.circular(isSmallScreen ? 20 : 30),
//           ),
//         ),
//         child: Column(
//           children: [
//             Container(
//               width: 50,
//               height: 4,
//               margin: EdgeInsets.only(top: 16),
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade300,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//             Expanded(
//               child: Padding(
//                 padding: EdgeInsets.all(isSmallScreen ? 20 : 25),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Container(
//                       padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         gradient: LinearGradient(
//                           colors: [
//                             const Color(0xFFEF4444).withOpacity(0.1),
//                             Colors.transparent,
//                           ],
//                         ),
//                       ),
//                       child: Icon(
//                         Icons.error_outline_rounded,
//                         size: isSmallScreen ? 50 : 60,
//                         color: const Color(0xFFEF4444),
//                       ),
//                     ),
//                     SizedBox(height: isSmallScreen ? 16 : 20),
//                     Text(
//                       'Konfirmasi Penghapusan',
//                       style: TextStyle(
//                         fontSize: isSmallScreen ? 20 : 24,
//                         fontWeight: FontWeight.bold,
//                         color: const Color(0xFF1E293B),
//                       ),
//                     ),
//                     SizedBox(height: isSmallScreen ? 8 : 10),
//                     Text(
//                       'Untuk mengonfirmasi, ketik "HAPUS" pada kolom di bawah:',
//                       textAlign: TextAlign.center,
//                       style: TextStyle(
//                         fontSize: isSmallScreen ? 13 : 14,
//                         color: Colors.grey.shade600,
//                         height: 1.4,
//                       ),
//                     ),
//                     SizedBox(height: isSmallScreen ? 20 : 25),
//                     TextFormField(
//                       decoration: InputDecoration(
//                         hintText: 'Ketik HAPUS di sini',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(color: Colors.grey.shade300),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: const BorderSide(
//                             color: Color(0xFFEF4444),
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: isSmallScreen ? 24 : 30),
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Row(
//                                 children: [
//                                   Container(
//                                     padding: const EdgeInsets.all(6),
//                                     decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       borderRadius: BorderRadius.circular(20),
//                                     ),
//                                     child: const Icon(
//                                       Icons.check_circle_rounded,
//                                       size: 20,
//                                       color: Colors.green,
//                                     ),
//                                   ),
//                                   SizedBox(width: isSmallScreen ? 8 : 12),
//                                   Expanded(
//                                     child: Text(
//                                       'Permintaan penghapusan data telah dikirim',
//                                       style: TextStyle(fontSize: 14),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                               backgroundColor: Colors.green,
//                               behavior: SnackBarBehavior.floating,
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               margin: EdgeInsets.all(isSmallScreen ? 16 : 20),
//                               elevation: 6,
//                             ),
//                           );
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFFEF4444),
//                           padding: EdgeInsets.symmetric(
//                             vertical: isSmallScreen ? 14 : 16,
//                           ),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: Text(
//                           'Konfirmasi Hapus',
//                           style: TextStyle(
//                             fontSize: isSmallScreen ? 15 : 16,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showPrivacyPolicy(BuildContext context, bool isSmallScreen) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(
//           top: Radius.circular(isSmallScreen ? 20 : 30),
//         ),
//       ),
//       builder: (context) => Container(
//         padding: EdgeInsets.all(isSmallScreen ? 20 : 25),
//         height: MediaQuery.of(context).size.height * 0.8,
//         child: Column(
//           children: [
//             Container(
//               width: 50,
//               height: 4,
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade300,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//             ),
//             SizedBox(height: isSmallScreen ? 16 : 20),
//             Expanded(
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'Kebijakan Privasi AbsenIn',
//                       style: TextStyle(
//                         fontSize: isSmallScreen ? 20 : 24,
//                         fontWeight: FontWeight.bold,
//                         color: const Color(0xFF1E293B),
//                       ),
//                     ),
//                     SizedBox(height: isSmallScreen ? 16 : 20),
//                     _buildPrivacySection(
//                       title: '1. Data yang Kami Kumpulkan',
//                       points: [
//                         'Data pribadi (nama, email, nomor telepon)',
//                         'Data kehadiran (waktu absen, lokasi, foto)',
//                         'Data biometrik (untuk verifikasi keamanan)',
//                         'Data perangkat (jenis, sistem operasi, versi app)',
//                       ],
//                       isSmallScreen: isSmallScreen,
//                     ),
//                     SizedBox(height: isSmallScreen ? 16 : 20),
//                     _buildPrivacySection(
//                       title: '2. Penggunaan Data',
//                       points: [
//                         'Verifikasi kehadiran dan keamanan',
//                         'Penggajian dan tunjangan karyawan',
//                         'Pengembangan dan peningkatan aplikasi',
//                         'Kepatuhan dengan regulasi hukum',
//                       ],
//                       isSmallScreen: isSmallScreen,
//                     ),
//                     SizedBox(height: isSmallScreen ? 16 : 20),
//                     _buildPrivacySection(
//                       title: '3. Perlindungan Data',
//                       points: [
//                         'Enkripsi end-to-end untuk data sensitif',
//                         'Akses terbatas dengan autentikasi berlapis',
//                         'Audit keamanan rutin dan pemantauan',
//                         'Backup data terenkripsi secara berkala',
//                       ],
//                       isSmallScreen: isSmallScreen,
//                     ),
//                     SizedBox(height: isSmallScreen ? 16 : 20),
//                     _buildPrivacySection(
//                       title: '4. Hak Pengguna',
//                       points: [
//                         'Mengakses dan mengunduh data pribadi',
//                         'Memperbaiki data yang tidak akurat',
//                         'Menghapus akun dan data terkait',
//                         'Menolak pemrosesan data tertentu',
//                       ],
//                       isSmallScreen: isSmallScreen,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: isSmallScreen ? 16 : 20),
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () => Navigator.pop(context),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: const Color(0xFF3B82F6),
//                   padding: EdgeInsets.symmetric(
//                     vertical: isSmallScreen ? 14 : 16,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                 ),
//                 child: Text(
//                   'Mengerti',
//                   style: TextStyle(
//                     fontSize: isSmallScreen ? 15 : 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPrivacySection({
//     required String title,
//     required List<String> points,
//     required bool isSmallScreen,
//   }) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           title,
//           style: TextStyle(
//             fontSize: isSmallScreen ? 15 : 16,
//             fontWeight: FontWeight.bold,
//             color: const Color(0xFF1E293B),
//           ),
//         ),
//         SizedBox(height: isSmallScreen ? 10 : 12),
//         ...points.map(
//           (point) => Padding(
//             padding: EdgeInsets.only(bottom: isSmallScreen ? 6 : 8),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Container(
//                   margin: EdgeInsets.only(
//                     top: isSmallScreen ? 7 : 6,
//                     right: isSmallScreen ? 10 : 12,
//                   ),
//                   width: 5,
//                   height: 5,
//                   decoration: const BoxDecoration(
//                     color: Color(0xFF3B82F6),
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//                 Expanded(
//                   child: Text(
//                     point,
//                     style: TextStyle(
//                       fontSize: isSmallScreen ? 13 : 14,
//                       color: Colors.grey.shade700,
//                       height: 1.5,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
