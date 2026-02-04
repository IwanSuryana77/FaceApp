import 'package:flutter/material.dart';
import 'dart:math';

class InfoKeluargaScreen extends StatefulWidget {
  const InfoKeluargaScreen({super.key});

  @override
  State<InfoKeluargaScreen> createState() => _InfoKeluargaScreenState();
}

class _InfoKeluargaScreenState extends State<InfoKeluargaScreen>
    with TickerProviderStateMixin {
  bool _isEditing = false;
  final primaryColor = const Color(0xFF0D1B2A);
  final secondaryColor = const Color(0xFF1B3A5C);
  final accentColor = const Color(0xFFC9A227);
  final successColor = const Color(0xFF2A9D8F);
  final warningColor = const Color(0xFFE76F51);
  final dangerColor = const Color(0xFFE63946);
  final backgroundColor = const Color(0xFFF5F7FA);
  final cardColor = const Color(0xFFFFFFFF);
  final darkAccent = const Color(0xFF1C2B3A);

  late AnimationController _animationController;
  late Animation<double> _animation;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;
  late AnimationController _heartbeatController;
  late Animation<double> _heartbeatAnimation;
  final Map<String, bool> _hoverStates = {};
  final Map<String, GlobalKey> _sectionKeys = {};
  final List<bool> _expandedStates = [false, false, false, false, false];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..forward();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _waveController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat();

    _heartbeatController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true);

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutSine),
    );

    _waveAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _waveController, curve: Curves.linear));

    _heartbeatAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _heartbeatController, curve: Curves.easeInOut),
    );

    // Initialize section keys
    _sectionKeys['family'] = GlobalKey();
    _sectionKeys['emergency'] = GlobalKey();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    _waveController.dispose();
    _heartbeatController.dispose();
    super.dispose();
  }

  void _triggerRipple() {
    _heartbeatController.forward(from: 0);
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
      _expandedStates[index] = !_expandedStates[index];
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
                  _buildEnhancedFamilyHeader(context, isMobile),
                  const SizedBox(height: 24),
                  _buildSectionNavigation(isMobile),
                  const SizedBox(height: 24),
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
                    _buildEnhancedFamilyMembers(context, isMobile),
                    const SizedBox(height: 28),
                    _buildEnhancedEmergencyContacts(context, isMobile),
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
                  Icons.family_restroom_rounded,
                  'Keluarga',
                  primaryColor,
                  () => _scrollToSection('family'),
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
                  Icons.emergency_rounded,
                  'Darurat',
                  warningColor,
                  () => _scrollToSection('emergency'),
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
            animation: _heartbeatController,
            builder: (context, child) {
              return Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor.withOpacity(
                    0.8 + _heartbeatController.value * 0.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: accentColor.withOpacity(
                        0.3 + _heartbeatController.value * 0.2,
                      ),
                      blurRadius: 8,
                    ),
                  ],
                ),
              );
            },
          ),
          Text(
            'Info Keluarga',
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

  Widget _buildEnhancedFamilyHeader(BuildContext context, bool isMobile) {
    return FadeTransition(
      opacity: _animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.2),
          end: Offset.zero,
        ).animate(_animation),
        child: MouseRegion(
          onEnter: (_) => setState(() => _hoverStates['header'] = true),
          onExit: (_) => setState(() => _hoverStates['header'] = false),
          child: GestureDetector(
            onTap: () => _showFamilyStats(context, isMobile),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(isMobile ? 16 : 24),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(
                      (_hoverStates['header'] ?? false) ? 0.15 : 0.1,
                    ),
                    spreadRadius: 1,
                    blurRadius: (_hoverStates['header'] ?? false) ? 20 : 15,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.9),
                    spreadRadius: -4,
                    blurRadius: 12,
                    offset: const Offset(0, -4),
                  ),
                ],
                border: Border.all(
                  color: (_hoverStates['header'] ?? false)
                      ? accentColor.withOpacity(0.3)
                      : const Color(0xFFE2E8F0),
                  width: 1.5,
                ),
              ),
              padding: EdgeInsets.all(isMobile ? 16 : 28),
              child: Column(
                children: [
                  Row(
                    children: [
                      ScaleTransition(
                        scale: _pulseAnimation,
                        child: Container(
                          width: isMobile ? 60 : 80,
                          height: isMobile ? 60 : 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF0D1B2A), Color(0xFF1B3A5C)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.4),
                                blurRadius: 10,
                                spreadRadius: 1,
                                offset: const Offset(0, 2),
                              ),
                            ],
                            border: Border.all(
                              color: accentColor.withOpacity(0.3),
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.family_restroom_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Surya Ramadhan',
                              style: TextStyle(
                                fontSize: isMobile ? 18 : 22,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                                letterSpacing: 0.5,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: isMobile ? 10 : 14,
                                vertical: isMobile ? 3 : 5,
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
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: successColor.withOpacity(0.3),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                'Fullstack Developer',
                                style: TextStyle(
                                  fontSize: isMobile ? 12 : 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.8,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildEnhancedFamilySummary(isMobile),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedFamilySummary(bool isMobile) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hoverStates['summary'] = true),
      onExit: (_) => setState(() => _hoverStates['summary'] = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.all(isMobile ? 12 : 20),
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
                  Icons.group_rounded,
                  color: primaryColor,
                  size: isMobile ? 18 : 22,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Data Keluarga',
                    style: TextStyle(
                      fontSize: isMobile ? 14 : 16,
                      fontWeight: FontWeight.w700,
                      color: primaryColor,
                      letterSpacing: 0.3,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.spaceEvenly,
              children: [
                _buildEnhancedSummaryItem(
                  'Orang Tua',
                  '2 Orang',
                  Icons.elderly,
                  isMobile,
                ),
                _buildEnhancedSummaryItem(
                  'Istri',
                  'Tidak Ada',
                  Icons.female,
                  isMobile,
                ),
                _buildEnhancedSummaryItem(
                  'Anak',
                  'Tidak Ada',
                  Icons.child_care,
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
    bool isAvailable = !value.contains('Tidak');

    return MouseRegion(
      onEnter: (_) => setState(() => _hoverStates['summary_$title'] = true),
      onExit: (_) => setState(() => _hoverStates['summary_$title'] = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 8 : 16,
          vertical: isMobile ? 8 : 12,
        ),
        constraints: const BoxConstraints(minWidth: 0),
        decoration: BoxDecoration(
          color: (_hoverStates['summary_$title'] ?? false)
              ? (isAvailable
                    ? accentColor.withOpacity(0.1)
                    : Colors.grey.withOpacity(0.1))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: (_hoverStates['summary_$title'] ?? false)
                  ? (isAvailable ? accentColor : Colors.grey)
                  : (isAvailable ? primaryColor : Colors.grey),
              size: isMobile ? 18 : 20,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: isMobile ? 11 : 13,
                color: const Color(0xFF64748B),
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: isMobile ? 14 : 18,
                fontWeight: FontWeight.bold,
                color: isAvailable ? primaryColor : const Color(0xFF94A3B8),
                shadows: isAvailable
                    ? [
                        Shadow(
                          color: primaryColor.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedFamilyMembers(BuildContext context, bool isMobile) {
    return Container(
      key: _sectionKeys['family'],
      child: _buildEnhancedSectionContainer(
        context,
        'Anggota Keluarga',
        Icons.people_alt_rounded,
        primaryColor,
        [
          _buildEnhancedFamilyCard(
            context,
            0,
            'Ayah',
            'Bambang Sutrisno',
            '58 Tahun',
            'Pensiunan Guru',
            'ayah@email.com',
            Icons.male_rounded,
            primaryColor,
            isMobile,
          ),
          _buildEnhancedFamilyCard(
            context,
            1,
            'Ibu',
            'Siti Rahayu',
            '55 Tahun',
            'Ibu Rumah Tangga',
            'ibu@email.com',
            Icons.female_rounded,
            secondaryColor,
            isMobile,
          ),
          _buildEnhancedEmptyStateCard(
            context,
            'Belum Menikah',
            'Status: Lajang',
            'Anda belum memiliki istri dan anak',
            Icons.person_outline_rounded,
            const Color(0xFF94A3B8),
            isMobile,
          ),
        ],
        isMobile,
      ),
    );
  }

  Widget _buildEnhancedEmergencyContacts(BuildContext context, bool isMobile) {
    return Container(
      key: _sectionKeys['emergency'],
      child: _buildEnhancedSectionContainer(
        context,
        'Kontak Darurat',
        Icons.phone_callback_rounded,
        warningColor,
        [
          _buildEnhancedContactCard(
            context,
            2,
            'Ayah',
            'Bambang Sutrisno',
            '0813-4567-8901',
            'Hubungan: Orang Tua',
            Icons.phone_rounded,
            warningColor,
            isMobile,
          ),
          _buildEnhancedContactCard(
            context,
            3,
            'Ibu',
            'Siti Rahayu',
            '0815-6789-0123',
            'Hubungan: Orang Tua',
            Icons.phone_rounded,
            warningColor,
            isMobile,
          ),
          _buildEnhancedContactCard(
            context,
            4,
            'Sahabat',
            'Ahmad Fauzi',
            '0814-5678-9012',
            'Hubungan: Teman Dekat',
            Icons.person_rounded,
            warningColor,
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
                animation: _heartbeatController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: 0.9 + _heartbeatAnimation.value * 0.1,
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

  Widget _buildEnhancedFamilyCard(
    BuildContext context,
    int index,
    String relation,
    String name,
    String age,
    String occupation,
    String email,
    IconData icon,
    Color color,
    bool isMobile,
  ) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hoverStates['family_$index'] = true),
      onExit: (_) => setState(() => _hoverStates['family_$index'] = false),
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
              colors: (_hoverStates['family_$index'] ?? false)
                  ? [color.withOpacity(0.1), color.withOpacity(0.05)]
                  : [color.withOpacity(0.05), color.withOpacity(0.02)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
            border: Border.all(
              color: (_hoverStates['family_$index'] ?? false)
                  ? color.withOpacity(0.3)
                  : color.withOpacity(0.1),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(
                  (_hoverStates['family_$index'] ?? false) ? 0.2 : 0.15,
                ),
                blurRadius: (_hoverStates['family_$index'] ?? false) ? 15 : 8,
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
                              relation,
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
                                age,
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
                          name,
                          style: TextStyle(
                            fontSize: isMobile ? 15 : 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E293B),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          occupation,
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
                      _expandedStates[index] ? pi / 2 : 0,
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
                crossFadeState: _expandedStates[index]
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
                        Icon(Icons.email_rounded, color: color, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            email,
                            style: TextStyle(
                              fontSize: isMobile ? 13 : 14,
                              color: const Color(0xFF4B5563),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        if (_isEditing)
                          IconButton(
                            onPressed: () => _showEnhancedEditDialog(
                              context,
                              relation,
                              name,
                              color,
                            ),
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

  Widget _buildEnhancedEmptyStateCard(
    BuildContext context,
    String title,
    String subtitle,
    String description,
    IconData icon,
    Color color,
    bool isMobile,
  ) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hoverStates['empty'] = true),
      onExit: (_) => setState(() => _hoverStates['empty'] = false),
      child: GestureDetector(
        onTap: () {
          if (_isEditing) {
            _showAddFamilyMemberDialog(context);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(
            horizontal: isMobile ? 12 : 16,
            vertical: isMobile ? 6 : 8,
          ),
          padding: EdgeInsets.all(isMobile ? 16 : 20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: (_hoverStates['empty'] ?? false)
                  ? [color.withOpacity(0.1), color.withOpacity(0.05)]
                  : [color.withOpacity(0.05), color.withOpacity(0.02)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
            border: Border.all(
              color: (_hoverStates['empty'] ?? false)
                  ? color.withOpacity(0.3)
                  : color.withOpacity(0.1),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(
                  (_hoverStates['empty'] ?? false) ? 0.2 : 0.15,
                ),
                blurRadius: (_hoverStates['empty'] ?? false) ? 15 : 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: isMobile ? 52 : 56,
                height: isMobile ? 52 : 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [color.withOpacity(0.15), color.withOpacity(0.08)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(color: color.withOpacity(0.2), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(icon, color: color, size: isMobile ? 24 : 26),
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
                        color: color,
                        letterSpacing: 0.3,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: isMobile ? 15 : 16,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF1E293B),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: isMobile ? 13 : 14,
                        color: const Color(0xFF64748B),
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              ScaleTransition(
                scale: Tween<double>(begin: 0.9, end: 1.0).animate(
                  CurvedAnimation(
                    parent: _animationController,
                    curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
                  ),
                ),
                child: Icon(
                  Icons.add_circle_rounded,
                  size: isMobile ? 28 : 32,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedContactCard(
    BuildContext context,
    int index,
    String relation,
    String name,
    String phone,
    String details,
    IconData icon,
    Color color,
    bool isMobile,
  ) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hoverStates['contact_$index'] = true),
      onExit: (_) => setState(() => _hoverStates['contact_$index'] = false),
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
              colors: (_hoverStates['contact_$index'] ?? false)
                  ? [color.withOpacity(0.1), color.withOpacity(0.05)]
                  : [color.withOpacity(0.05), color.withOpacity(0.02)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
            border: Border.all(
              color: (_hoverStates['contact_$index'] ?? false)
                  ? color.withOpacity(0.3)
                  : color.withOpacity(0.1),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(
                  (_hoverStates['contact_$index'] ?? false) ? 0.2 : 0.15,
                ),
                blurRadius: (_hoverStates['contact_$index'] ?? false) ? 15 : 8,
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
                          relation,
                          style: TextStyle(
                            fontSize: isMobile ? 16 : 17,
                            fontWeight: FontWeight.w700,
                            color: color,
                            letterSpacing: 0.3,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: isMobile ? 15 : 16,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF1E293B),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.phone_rounded,
                              size: isMobile ? 18 : 20,
                              color: const Color(0xFF64748B),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Text(
                                phone,
                                style: TextStyle(
                                  fontSize: isMobile ? 14 : 15,
                                  color: const Color(0xFF4B5563),
                                  fontWeight: FontWeight.w500,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
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
                      _expandedStates[index] ? pi / 2 : 0,
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
                crossFadeState: _expandedStates[index]
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
                            onPressed: () => _showEnhancedEditDialog(
                              context,
                              relation,
                              name,
                              color,
                            ),
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
            scale: _pulseAnimation,
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
                        'Tambah Data Keluarga',
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
                            Icons.person_add_rounded,
                            'Tambah Anggota Keluarga',
                            'Tambahkan anggota keluarga baru',
                            primaryColor,
                            isMobile,
                          ),
                          _buildEnhancedBottomSheetOption(
                            context,
                            Icons.contact_phone_rounded,
                            'Tambah Kontak Darurat',
                            'Tambahkan kontak darurat baru',
                            warningColor,
                            isMobile,
                          ),
                          _buildEnhancedBottomSheetOption(
                            context,
                            Icons.cloud_upload_rounded,
                            'Upload Dokumen Keluarga',
                            'Unggah dokumen KK atau akta',
                            successColor,
                            isMobile,
                          ),
                          _buildEnhancedBottomSheetOption(
                            context,
                            Icons.photo_library_rounded,
                            'Album Keluarga',
                            'Lihat dan kelola foto keluarga',
                            accentColor,
                            isMobile,
                          ),
                          _buildEnhancedBottomSheetOption(
                            context,
                            Icons.share_rounded,
                            'Bagikan Data Keluarga',
                            'Bagikan informasi keluarga',
                            secondaryColor,
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
          _showActionCompleted(context, '$title berhasil', color);
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
    String relation,
    String name,
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
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.edit_rounded, color: color, size: 48),
              const SizedBox(height: 16),
              Text(
                'Edit $relation',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                name,
                style: const TextStyle(fontSize: 16, color: Color(0xFF4B5563)),
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
                      child: const Text(
                        'Batal',
                        style: TextStyle(
                          color: Color(0xFF64748B),
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

  void _showAddFamilyMemberDialog(BuildContext context) {
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
                color: successColor.withOpacity(0.2),
                blurRadius: 30,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.person_add_rounded, color: successColor, size: 48),
              const SizedBox(height: 16),
              Text(
                'Tambah Anggota Keluarga',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: successColor,
                ),
              ),
              const SizedBox(height: 24),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Nama Lengkap',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Hubungan',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
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
                      child: const Text(
                        'Batal',
                        style: TextStyle(
                          color: Color(0xFF64748B),
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
                          'Anggota keluarga ditambahkan',
                          successColor,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: successColor,
                        elevation: 8,
                      ),
                      child: const Text(
                        'Tambah',
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

  void _showFamilyStats(BuildContext context, bool isMobile) {
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
                'Statistik Keluarga',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 24),
              _buildStatItem('Total Anggota', '4', Icons.group, primaryColor),
              _buildStatItem(
                'Usia Rata-rata',
                '45',
                Icons.timeline,
                accentColor,
              ),
              _buildStatItem(
                'Kontak Darurat',
                '3',
                Icons.emergency,
                warningColor,
              ),
              _buildStatItem('Dokumen', '2', Icons.folder, successColor),
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
