import 'package:flutter/material.dart';
import 'dart:math';

class InfoPendidikanScreen extends StatefulWidget {
  const InfoPendidikanScreen({super.key});

  @override
  State<InfoPendidikanScreen> createState() => _InfoPendidikanScreenState();
}

class _InfoPendidikanScreenState extends State<InfoPendidikanScreen>
    with TickerProviderStateMixin {
  bool _isEditing = false;
  final primaryColor = const Color(0xFF0D1B2A);
  final secondaryColor = const Color(0xFF1B3A5C);
  final accentColor = const Color(0xFFC9A227);
  final successColor = const Color(0xFF2A9D8F);
  final backgroundColor = const Color(0xFFF5F7FA);
  final cardColor = const Color(0xFFFFFFFF);
  final darkAccent = const Color(0xFF1C2B3A);

  late AnimationController _animationController;
  late Animation<double> _animation;
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;
  final Map<String, bool> _hoverStates = {};
  final Map<String, GlobalKey> _sectionKeys = {};
  final List<bool> _expandedItems = [false, false, false, false, false, false];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..forward();

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _waveController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );

    _glowAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOutSine),
    );

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _waveController, curve: Curves.linear));

    // Initialize section keys
    _sectionKeys['education'] = GlobalKey();
    _sectionKeys['certification'] = GlobalKey();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _glowController.dispose();
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  void _triggerRipple() {
    _pulseController.forward(from: 0);
  }

  void _scrollToSection(String section) {
    if (_sectionKeys[section]?.currentContext != null) {
      Scrollable.ensureVisible(
        _sectionKeys[section]!.currentContext!,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
      _triggerRipple();
    }
  }

  void _toggleExpand(int index) {
    setState(() {
      _expandedItems[index] = !_expandedItems[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final horizontalPadding = isMobile ? 16.0 : 24.0;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildEnhancedAppBar(isMobile),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: isMobile ? 16 : 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildEnhancedEducationHeader(context, isMobile),
                  const SizedBox(height: 28),
                  _buildSectionNavigation(isMobile),
                  const SizedBox(height: 28),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Container(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Column(
                  children: [
                    _buildEnhancedEducationHistory(context, isMobile),
                    const SizedBox(height: 32),
                    _buildEnhancedCertifications(context, isMobile),
                    const SizedBox(height: 48),
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
      floatingActionButton: _buildEnhancedFAB(context, isMobile),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildSectionNavigation(bool isMobile) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, (1 - _pulseAnimation.value) * 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: const LinearGradient(
                colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFC)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.1),
                  spreadRadius: 2,
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildNavButton(
                  Icons.history_edu_rounded,
                  'Riwayat',
                  primaryColor,
                  () => _scrollToSection('education'),
                  isMobile,
                ),
                Container(
                  width: 1,
                  height: 30,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        primaryColor.withOpacity(0.3),
                        Colors.transparent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                _buildNavButton(
                  Icons.verified_user_rounded,
                  'Sertifikasi',
                  successColor,
                  () => _scrollToSection('certification'),
                  isMobile,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNavButton(
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap,
    bool isMobile,
  ) {
    return Expanded(
      child: MouseRegion(
        onEnter: (_) => setState(() => _hoverStates['nav_$label'] = true),
        onExit: (_) => setState(() => _hoverStates['nav_$label'] = false),
        child: GestureDetector(
          onTap: () {
            onTap();
            _triggerRipple();
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 12 : 16,
              vertical: isMobile ? 16 : 20,
            ),
            decoration: BoxDecoration(
              color: (_hoverStates['nav_$label'] ?? false)
                  ? color.withOpacity(0.05)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color, size: isMobile ? 24 : 28),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 16,
                    fontWeight: FontWeight.w600,
                    color: color,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildEnhancedAppBar(bool isMobile) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Row(
        children: [
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor.withOpacity(
                    0.8 + _pulseController.value * 0.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withOpacity(
                        0.3 + _pulseController.value * 0.2,
                      ),
                      blurRadius: 8,
                    ),
                  ],
                ),
              );
            },
          ),
          Text(
            'Info Pendidikan',
            style: TextStyle(
              fontSize: isMobile ? 22 : 24,
              fontWeight: FontWeight.w800,
              color: primaryColor,
              letterSpacing: 0.8,
              shadows: [
                Shadow(
                  color: primaryColor.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ],
      ),
      leading: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () {
            Navigator.pop(context);
            _triggerRipple();
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0D1B2A), Color(0xFF1B3A5C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ),
      actions: [
        MouseRegion(
          onEnter: (_) => setState(() => _hoverStates['edit'] = true),
          onExit: (_) => setState(() => _hoverStates['edit'] = false),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _isEditing = !_isEditing;
              });
              _showAnimatedSnackBar(context);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 8),
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 20,
                vertical: isMobile ? 8 : 10,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _isEditing
                      ? [successColor, const Color(0xFF4ECDC4)]
                      : [secondaryColor, const Color(0xFF2C5282)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: (_isEditing ? successColor : secondaryColor)
                        .withOpacity(
                          (_hoverStates['edit'] ?? false) ? 0.4 : 0.2,
                        ),
                    blurRadius: (_hoverStates['edit'] ?? false) ? 12 : 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _isEditing
                        ? Icons.check_circle_rounded
                        : Icons.edit_rounded,
                    color: Colors.white,
                    size: isMobile ? 20 : 22,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isEditing ? 'Simpan' : 'Edit',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isMobile ? 14 : 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showAnimatedSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            _isEditing ? Icons.edit_rounded : Icons.check_circle_rounded,
            color: Colors.white,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _isEditing ? 'Mode edit aktif' : 'Perubahan disimpan',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: _isEditing ? successColor : accentColor,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      duration: const Duration(milliseconds: 1500),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8,
      animation: CurvedAnimation(
        parent: AnimationController(
          duration: const Duration(milliseconds: 300),
          vsync: this,
        )..forward(),
        curve: Curves.easeOut,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget _buildEnhancedEducationHeader(BuildContext context, bool isMobile) {
    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(_animation),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(isMobile ? 20 : 24),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.9),
                spreadRadius: -4,
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
            ],
            border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
          ),
          padding: EdgeInsets.all(isMobile ? 24 : 28),
          child: Column(
            children: [
              Row(
                children: [
                  ScaleTransition(
                    scale: _glowAnimation,
                    child: MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () => _showEducationStats(context, isMobile),
                        child: Container(
                          width: isMobile ? 70 : 80,
                          height: isMobile ? 70 : 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF0D1B2A), Color(0xFF1B3A5C)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              stops: [0.3, 0.9],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.4),
                                blurRadius: 15,
                                spreadRadius: 2,
                                offset: const Offset(0, 4),
                              ),
                              BoxShadow(
                                color: Colors.white.withOpacity(0.2),
                                blurRadius: 10,
                                spreadRadius: -2,
                                offset: const Offset(0, -2),
                              ),
                            ],
                            border: Border.all(
                              color: accentColor.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              const Icon(
                                Icons.school_rounded,
                                color: Colors.white,
                                size: 34,
                              ),
                              Positioned(
                                right: 8,
                                bottom: 8,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: accentColor,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: accentColor.withOpacity(0.5),
                                        blurRadius: 8,
                                        spreadRadius: 2,
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
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Leonardo Dicaprio',
                          style: TextStyle(
                            fontSize: isMobile ? 20 : 22,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                            letterSpacing: 0.5,
                            height: 1.2,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 12 : 14,
                            vertical: isMobile ? 4 : 5,
                          ),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                successColor.withOpacity(0.9),
                                const Color(0xFF4ECDC4),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: successColor.withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                            border: Border.all(
                              color: Colors.white.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            'Fullstack Developer',
                            style: TextStyle(
                              fontSize: isMobile ? 13 : 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildEnhancedEducationSummary(isMobile),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedEducationSummary(bool isMobile) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hoverStates['summary'] = true),
      onExit: (_) => setState(() => _hoverStates['summary'] = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.all(isMobile ? 16 : 20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              primaryColor.withOpacity(0.05),
              primaryColor.withOpacity(0.02),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: (_hoverStates['summary'] ?? false)
                ? accentColor.withOpacity(0.3)
                : primaryColor.withOpacity(0.1),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(
                (_hoverStates['summary'] ?? false) ? 0.1 : 0.05,
              ),
              blurRadius: (_hoverStates['summary'] ?? false) ? 15 : 10,
              spreadRadius: 2,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.menu_book_rounded,
                  color: primaryColor,
                  size: isMobile ? 20 : 22,
                ),
                const SizedBox(width: 10),
                Text(
                  'Pendidikan Formal',
                  style: TextStyle(
                    fontSize: isMobile ? 15 : 16,
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildEnhancedSummaryItem(
                  'S1',
                  'Teknik Informatika',
                  Icons.school,
                  isMobile,
                ),
                Container(
                  height: 30,
                  width: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        primaryColor.withOpacity(0.3),
                        Colors.transparent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                _buildEnhancedSummaryItem('IPK', '3.99', Icons.star, isMobile),
                Container(
                  height: 30,
                  width: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        primaryColor.withOpacity(0.3),
                        Colors.transparent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                _buildEnhancedSummaryItem(
                  'SKS',
                  '144',
                  Icons.list_alt,
                  isMobile,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedSummaryItem(
    String title,
    String value,
    IconData icon,
    bool isMobile,
  ) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hoverStates['summary_$title'] = true),
      onExit: (_) => setState(() => _hoverStates['summary_$title'] = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12 : 16,
          vertical: isMobile ? 8 : 12,
        ),
        decoration: BoxDecoration(
          color: (_hoverStates['summary_$title'] ?? false)
              ? accentColor.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: (_hoverStates['summary_$title'] ?? false)
                  ? accentColor
                  : primaryColor,
              size: isMobile ? 18 : 20,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: isMobile ? 12 : 13,
                color: const Color(0xFF64748B),
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: isMobile ? 16 : 18,
                fontWeight: FontWeight.bold,
                color: primaryColor,
                shadows: [
                  Shadow(
                    color: primaryColor.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedEducationHistory(BuildContext context, bool isMobile) {
    return Container(
      key: _sectionKeys['education'],
      child: _buildEnhancedSectionContainer(
        context,
        'Riwayat Pendidikan',
        Icons.history_edu_rounded,
        primaryColor,
        [
          _buildEnhancedEducationCard(
            context,
            0,
            'Sarjana (S1)',
            'Teknik Informatika',
            'Oxford University',
            '2018 - 2022',
            'IPK: 3.99 • Predikat: Cum Laude',
            Icons.school_rounded,
            primaryColor,
            isMobile,
          ),
          _buildEnhancedEducationCard(
            context,
            1,
            'Diploma (D3)',
            'Manajemen Informatika',
            'Politeknik Negeri Bandung',
            '2015 - 2018',
            'IPK: 3.85 • Predikat: Sangat Memuaskan',
            Icons.account_balance_rounded,
            secondaryColor,
            isMobile,
          ),
          _buildEnhancedEducationCard(
            context,
            2,
            'SMA',
            'IPA',
            'SMA Negeri 5 Bandung',
            '2012 - 2015',
            'Nilai UN: 89.5 • Lulus dengan Prestasi',
            Icons.edit_note_rounded,
            accentColor,
            isMobile,
          ),
        ],
        isMobile,
      ),
    );
  }

  Widget _buildEnhancedCertifications(BuildContext context, bool isMobile) {
    return Container(
      key: _sectionKeys['certification'],
      child: _buildEnhancedSectionContainer(
        context,
        'Sertifikasi',
        Icons.verified_user_rounded,
        successColor,
        [
          _buildEnhancedCertificationCard(
            context,
            3,
            'Flutter Developer',
            'Google',
            '2023',
            'Valid hingga: 2025',
            Icons.phone_android_rounded,
            successColor,
            isMobile,
          ),
          _buildEnhancedCertificationCard(
            context,
            4,
            'AWS Certified Developer',
            'Amazon Web Services',
            '2022',
            'Valid hingga: 2024',
            Icons.cloud_rounded,
            const Color(0xFF2C5282),
            isMobile,
          ),
          _buildEnhancedCertificationCard(
            context,
            5,
            'Google UX Design',
            'Google',
            '2021',
            'Valid seumur hidup',
            Icons.design_services_rounded,
            const Color(0xFFE63946),
            isMobile,
          ),
        ],
        isMobile,
      ),
    );
  }

  Widget _buildEnhancedSectionContainer(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    List<Widget> items,
    bool isMobile,
  ) {
    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
            .animate(
              CurvedAnimation(
                parent: _animationController,
                curve: const Interval(0.3, 1.0, curve: Curves.easeOutCubic),
              ),
            ),
        child: MouseRegion(
          onEnter: (_) => setState(() => _hoverStates['section_$title'] = true),
          onExit: (_) => setState(() => _hoverStates['section_$title'] = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(isMobile ? 20 : 24),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(
                    (_hoverStates['section_$title'] ?? false) ? 0.15 : 0.1,
                  ),
                  spreadRadius: 2,
                  blurRadius: (_hoverStates['section_$title'] ?? false)
                      ? 30
                      : 25,
                  offset: const Offset(0, 6),
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.8),
                  spreadRadius: -4,
                  blurRadius: 15,
                  offset: const Offset(0, -4),
                ),
              ],
              border: Border.all(
                color: (_hoverStates['section_$title'] ?? false)
                    ? color.withOpacity(0.2)
                    : Colors.white.withOpacity(0.8),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                _buildEnhancedSectionHeader(
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
      ),
    );
  }

  Widget _buildEnhancedSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    int itemCount,
    bool isMobile,
  ) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _triggerRipple(),
        child: Container(
          padding: EdgeInsets.fromLTRB(
            isMobile ? 20 : 24,
            isMobile ? 18 : 22,
            isMobile ? 20 : 24,
            isMobile ? 12 : 16,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withOpacity(0.05), color.withOpacity(0.02)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isMobile ? 20 : 24),
              topRight: Radius.circular(isMobile ? 20 : 24),
            ),
          ),
          child: Row(
            children: [
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 0.9 + _pulseAnimation.value * 0.1,
                    child: Container(
                      width: isMobile ? 44 : 48,
                      height: isMobile ? 44 : 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            color.withOpacity(0.3),
                            color.withOpacity(0.1),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(icon, color: color, size: isMobile ? 22 : 24),
                    ),
                  );
                },
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: isMobile ? 18 : 20,
                        fontWeight: FontWeight.w800,
                        color: color,
                        letterSpacing: 0.8,
                        shadows: [
                          Shadow(
                            color: color.withOpacity(0.1),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$itemCount item${itemCount > 1 ? 's' : ''}',
                      style: TextStyle(
                        fontSize: isMobile ? 12 : 13,
                        color: const Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 12 : 14,
                  vertical: isMobile ? 6 : 8,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: color.withOpacity(0.2), width: 1.5),
                ),
                child: Text(
                  'Lihat Semua',
                  style: TextStyle(
                    color: color,
                    fontSize: isMobile ? 12 : 13,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedEducationCard(
    BuildContext context,
    int index,
    String level,
    String major,
    String institution,
    String period,
    String details,
    IconData icon,
    Color color,
    bool isMobile,
  ) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hoverStates['edu_$index'] = true),
      onExit: (_) => setState(() => _hoverStates['edu_$index'] = false),
      child: GestureDetector(
        onTap: () => _toggleExpand(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(
            horizontal: isMobile ? 12 : 16,
            vertical: isMobile ? 6 : 8,
          ),
          padding: EdgeInsets.all(isMobile ? 16 : 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: (_hoverStates['edu_$index'] ?? false)
                  ? [color.withOpacity(0.1), color.withOpacity(0.05)]
                  : [color.withOpacity(0.05), color.withOpacity(0.02)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
            border: Border.all(
              color: (_hoverStates['edu_$index'] ?? false)
                  ? color.withOpacity(0.3)
                  : color.withOpacity(0.1),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(
                  (_hoverStates['edu_$index'] ?? false) ? 0.2 : 0.15,
                ),
                blurRadius: (_hoverStates['edu_$index'] ?? false) ? 15 : 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  ScaleTransition(
                    scale: Tween<double>(begin: 0.9, end: 1.0).animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
                      ),
                    ),
                    child: Container(
                      width: isMobile ? 52 : 56,
                      height: isMobile ? 52 : 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            color.withOpacity(0.3),
                            color.withOpacity(0.15),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(
                          color: color.withOpacity(0.4),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(icon, color: color, size: isMobile ? 24 : 26),
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              level,
                              style: TextStyle(
                                fontSize: isMobile ? 16 : 17,
                                fontWeight: FontWeight.w700,
                                color: color,
                                letterSpacing: 0.3,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isMobile ? 10 : 12,
                                vertical: isMobile ? 4 : 5,
                              ),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    color.withOpacity(0.15),
                                    color.withOpacity(0.08),
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: color.withOpacity(0.2),
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                period,
                                style: TextStyle(
                                  fontSize: isMobile ? 13 : 14,
                                  color: color,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          major,
                          style: TextStyle(
                            fontSize: isMobile ? 15 : 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E293B),
                            letterSpacing: 0.2,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          institution,
                          style: TextStyle(
                            fontSize: isMobile ? 14 : 15,
                            color: const Color(0xFF4B5563),
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    transform: Matrix4.rotationZ(
                      _expandedItems[index] ? pi / 2 : 0,
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: isMobile ? 16 : 18,
                      color: color.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                crossFadeState: _expandedItems[index]
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Container(
                    padding: EdgeInsets.all(isMobile ? 12 : 16),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: color.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          color: color,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            details,
                            style: TextStyle(
                              fontSize: isMobile ? 13 : 14,
                              color: const Color(0xFF4B5563),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        if (_isEditing)
                          IconButton(
                            onPressed: () =>
                                _showEnhancedEditDialog(context, level, color),
                            icon: Icon(
                              Icons.edit_rounded,
                              color: color,
                              size: 16,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedCertificationCard(
    BuildContext context,
    int index,
    String title,
    String issuer,
    String year,
    String validity,
    IconData icon,
    Color color,
    bool isMobile,
  ) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hoverStates['cert_$index'] = true),
      onExit: (_) => setState(() => _hoverStates['cert_$index'] = false),
      child: GestureDetector(
        onTap: () => _toggleExpand(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(
            horizontal: isMobile ? 12 : 16,
            vertical: isMobile ? 6 : 8,
          ),
          padding: EdgeInsets.all(isMobile ? 16 : 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: (_hoverStates['cert_$index'] ?? false)
                  ? [color.withOpacity(0.1), color.withOpacity(0.05)]
                  : [color.withOpacity(0.05), color.withOpacity(0.02)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
            border: Border.all(
              color: (_hoverStates['cert_$index'] ?? false)
                  ? color.withOpacity(0.3)
                  : color.withOpacity(0.1),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(
                  (_hoverStates['cert_$index'] ?? false) ? 0.2 : 0.15,
                ),
                blurRadius: (_hoverStates['cert_$index'] ?? false) ? 15 : 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  ScaleTransition(
                    scale: Tween<double>(begin: 0.9, end: 1.0).animate(
                      CurvedAnimation(
                        parent: _animationController,
                        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
                      ),
                    ),
                    child: Container(
                      width: isMobile ? 52 : 56,
                      height: isMobile ? 52 : 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            color.withOpacity(0.3),
                            color.withOpacity(0.15),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(
                          color: color.withOpacity(0.4),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(icon, color: color, size: isMobile ? 24 : 26),
                    ),
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: isMobile ? 16 : 17,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1E293B),
                            letterSpacing: 0.3,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          issuer,
                          style: TextStyle(
                            fontSize: isMobile ? 15 : 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF4B5563),
                            letterSpacing: 0.2,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.date_range_rounded,
                              size: isMobile ? 16 : 18,
                              color: color,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              year,
                              style: TextStyle(
                                fontSize: isMobile ? 14 : 15,
                                color: color,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    transform: Matrix4.rotationZ(
                      _expandedItems[index] ? pi / 2 : 0,
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: isMobile ? 16 : 18,
                      color: color.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                crossFadeState: _expandedItems[index]
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Container(
                    padding: EdgeInsets.all(isMobile ? 12 : 16),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: color.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.verified_rounded, color: color, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            validity,
                            style: TextStyle(
                              fontSize: isMobile ? 13 : 14,
                              color: const Color(0xFF4B5563),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        if (_isEditing)
                          IconButton(
                            onPressed: () =>
                                _showEnhancedEditDialog(context, title, color),
                            icon: Icon(
                              Icons.edit_rounded,
                              color: color,
                              size: 16,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedFAB(BuildContext context, bool isMobile) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _waveController,
          builder: (context, child) {
            return Transform.scale(
              scale: 1 + _waveAnimation.value * 0.2,
              child: Container(
                width: isMobile ? 70 : 80,
                height: isMobile ? 70 : 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor.withOpacity(
                    0.1 - _waveAnimation.value * 0.1,
                  ),
                ),
              ),
            );
          },
        ),
        ScaleTransition(
          scale: Tween<double>(begin: 0.8, end: 1.0).animate(
            CurvedAnimation(
              parent: _animationController,
              curve: const Interval(0.6, 1.0, curve: Curves.easeOutBack),
            ),
          ),
          child: ScaleTransition(
            scale: _glowAnimation,
            child: FloatingActionButton(
              onPressed: () {
                _showEnhancedAddOptions(context, isMobile);
                _triggerRipple();
              },
              backgroundColor: Colors.transparent,
              elevation: 0,
              child: Container(
                width: isMobile ? 56 : 60,
                height: isMobile ? 56 : 60,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0D1B2A), Color(0xFF1B3A5C)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.4),
                      blurRadius: 15,
                      spreadRadius: 2,
                      offset: const Offset(0, 6),
                    ),
                    BoxShadow(
                      color: accentColor.withOpacity(0.3),
                      blurRadius: 20,
                      spreadRadius: -2,
                    ),
                  ],
                  border: Border.all(
                    color: accentColor.withOpacity(0.4),
                    width: 1.5,
                  ),
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showEnhancedAddOptions(BuildContext context, bool isMobile) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.only(top: 50),
          child: DraggableScrollableSheet(
            initialChildSize: 0.4,
            minChildSize: 0.3,
            maxChildSize: 0.7,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32),
                    topRight: Radius.circular(32),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.2),
                      blurRadius: 40,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 12, bottom: 8),
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: primaryColor.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        'Tambah Data',
                        style: TextStyle(
                          fontSize: isMobile ? 20 : 22,
                          fontWeight: FontWeight.w800,
                          color: primaryColor,
                          letterSpacing: 0.8,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        controller: scrollController,
                        padding: EdgeInsets.zero,
                        children: [
                          _buildEnhancedBottomSheetOption(
                            context,
                            Icons.add_circle_rounded,
                            'Tambah Pendidikan',
                            'Tambahkan riwayat pendidikan baru',
                            primaryColor,
                            isMobile,
                          ),
                          _buildEnhancedBottomSheetOption(
                            context,
                            Icons.upload_rounded,
                            'Upload Dokumen',
                            'Unggah sertifikat atau transkrip',
                            secondaryColor,
                            isMobile,
                          ),
                          _buildEnhancedBottomSheetOption(
                            context,
                            Icons.share_rounded,
                            'Bagikan Riwayat',
                            'Bagikan profil pendidikan Anda',
                            successColor,
                            isMobile,
                          ),
                          _buildEnhancedBottomSheetOption(
                            context,
                            Icons.download_rounded,
                            'Export Data',
                            'Ekspor data pendidikan ke PDF',
                            accentColor,
                            isMobile,
                          ),
                          _buildEnhancedBottomSheetOption(
                            context,
                            Icons.qr_code_rounded,
                            'QR Code',
                            'Buat QR Code untuk sertifikat',
                            const Color(0xFFE63946),
                            isMobile,
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildEnhancedBottomSheetOption(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Color color,
    bool isMobile,
  ) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hoverStates['option_$title'] = true),
      onExit: (_) => setState(() => _hoverStates['option_$title'] = false),
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
          _showActionCompleted(context, title, color);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 20,
            vertical: isMobile ? 6 : 8,
          ),
          padding: EdgeInsets.all(isMobile ? 16 : 20),
          decoration: BoxDecoration(
            color: (_hoverStates['option_$title'] ?? false)
                ? color.withOpacity(0.05)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
            border: Border.all(
              color: (_hoverStates['option_$title'] ?? false)
                  ? color.withOpacity(0.2)
                  : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: isMobile ? 52 : 56,
                height: isMobile ? 52 : 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: (_hoverStates['option_$title'] ?? false)
                        ? [color, Color.lerp(color, Colors.white, 0.3)!]
                        : [color.withOpacity(0.1), color.withOpacity(0.1)],
                  ),
                ),
                child: Icon(
                  icon,
                  color: (_hoverStates['option_$title'] ?? false)
                      ? Colors.white
                      : color,
                  size: isMobile ? 24 : 26,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: isMobile ? 16 : 17,
                        fontWeight: FontWeight.w700,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: isMobile ? 13 : 14,
                        color: const Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                transform: Matrix4.translationValues(
                  (_hoverStates['option_$title'] ?? false) ? 4 : 0,
                  0,
                  0,
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: isMobile ? 16 : 18,
                  color: (_hoverStates['option_$title'] ?? false)
                      ? color
                      : const Color(0xFFCBD5E1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEnhancedEditDialog(
    BuildContext context,
    String title,
    Color color,
  ) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.2),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
            border: Border.all(color: color.withOpacity(0.2), width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.edit_rounded, color: color, size: 48),
              const SizedBox(height: 16),
              Text(
                'Edit $title',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: backgroundColor,
                  hintText: 'Masukkan informasi...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: color, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: backgroundColor,
                      ),
                      child: Text(
                        'Batal',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showActionCompleted(
                          context,
                          'Perubahan disimpan',
                          color,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: color,
                        elevation: 8,
                        shadowColor: color.withOpacity(0.3),
                      ),
                      child: const Text(
                        'Simpan',
                        style: TextStyle(
                          color: Colors.white,
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

  void _showActionCompleted(BuildContext context, String message, Color color) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 100,
        left: MediaQuery.of(context).size.width / 2 - 100,
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: 200,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [color, Color.lerp(color, Colors.white, 0.3)!],
                    ),
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Berhasil!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 2), () => overlayEntry.remove());
  }

  void _showEducationStats(BuildContext context, bool isMobile) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(isMobile ? 20 : 40),
        child: Container(
          padding: EdgeInsets.all(isMobile ? 24 : 32),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(32),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                primaryColor.withOpacity(0.05),
                secondaryColor.withOpacity(0.05),
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Statistik Pendidikan',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 24),
              _buildStatItem(
                'Total Pendidikan',
                '3 Tingkat',
                Icons.school,
                primaryColor,
              ),
              _buildStatItem('IPK Rata-rata', '3.87', Icons.star, accentColor),
              _buildStatItem('Sertifikasi', '3', Icons.verified, successColor),
              _buildStatItem(
                'Tahun Pengalaman',
                '5',
                Icons.timeline,
                secondaryColor,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                ),
                child: const Text(
                  'Tutup',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.1),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 14,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: primaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
