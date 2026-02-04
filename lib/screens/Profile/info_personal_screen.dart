import 'package:flutter/material.dart';

class InfoPersonalScreen extends StatefulWidget {
  const InfoPersonalScreen({super.key});

  @override
  State<InfoPersonalScreen> createState() => _InfoPersonalScreenState();
}

class _InfoPersonalScreenState extends State<InfoPersonalScreen>
    with TickerProviderStateMixin {
  bool _isEditing = false;
  final primaryColor = const Color(0xFF1E3A8A);
  final secondaryColor = const Color(0xFF0EA5E9);
  final accentColor = const Color(0xFF8B5CF6);
  final backgroundColor = const Color(0xFFF8FAFC);
  final cardColor = const Color(0xFFFFFFFF);
  final textPrimary = const Color(0xFF1F2937);
  final textSecondary = const Color(0xFF6B7280);
  final successColor = const Color(0xFF10B981);
  final borderColor = const Color(0xFFE5E7EB);

  // Data dinamis!
  Map<String, String> _dataPersonal = {
    'Nama Lengkap': 'Leonardo .D. Caprio',
    'Tempat Lahir': 'Bekasi',
    'Tanggal Lahir': '30 Oktober 2004',
    'Jenis Kelamin': 'Laki-laki',
    'Agama': 'Islam',
  };
  Map<String, String> _dataContact = {
    'Email Utama': 'Leonard1.com',
    'Nomor HP': '0812-3456-7890',
    'Alamat': 'Jl. Didiparawirakusumah No. 123',
    'Kota': 'Kota Bandung',
  };

  late AnimationController _animationController;
  late Animation<double> _animation;
  late AnimationController _pulseController;
  late AnimationController _slideController;
  late Animation<double> _slideAnimation;
  late AnimationController _rippleController;
  final Map<String, bool> _hoverStates = {};
  final Map<String, GlobalKey> _cardKeys = {};

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

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _rippleController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );

    _slideAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
    );

    _cardKeys['personal'] = GlobalKey();
    _cardKeys['contact'] = GlobalKey();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    _slideController.dispose();
    _rippleController.dispose();
    super.dispose();
  }

  void _triggerRipple() {
    _rippleController.forward(from: 0);
  }

  void _scrollToSection(String section) {
    if (_cardKeys[section]?.currentContext != null) {
      Scrollable.ensureVisible(
        _cardKeys[section]!.currentContext!,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
      _triggerRipple();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final horizontalPadding = isMobile ? 16.0 : 24.0;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: _buildAppBar(isMobile),
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
                  _buildProfileHeader(context, isMobile, screenWidth),
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
                    _buildPersonalInfoSection(context, isMobile),
                    const SizedBox(height: 32),
                    _buildContactInfoSection(context, isMobile),
                    const SizedBox(height: 60),
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
      animation: _slideController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, (1 - _slideAnimation.value) * 50),
          child: Opacity(
            opacity: _slideAnimation.value,
            child: Card(
              elevation: 4,
              shadowColor: primaryColor.withOpacity(0.1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: borderColor, width: 1.5),
              ),
              color: cardColor,
              child: Padding(
                padding: EdgeInsets.all(isMobile ? 12 : 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildNavButton(
                      Icons.person_rounded,
                      'Data Pribadi',
                      primaryColor,
                      () => _scrollToSection('personal'),
                      isMobile,
                    ),
                    Container(width: 1, height: 30, color: borderColor),
                    _buildNavButton(
                      Icons.contact_phone_rounded,
                      'Kontak',
                      secondaryColor,
                      () => _scrollToSection('contact'),
                      isMobile,
                    ),
                  ],
                ),
              ),
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
              vertical: isMobile ? 10 : 14,
            ),
            decoration: BoxDecoration(
              color: (_hoverStates['nav_$label'] ?? false)
                  ? color.withOpacity(0.05)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color, size: isMobile ? 22 : 24),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: isMobile ? 12 : 14,
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

  AppBar _buildAppBar(bool isMobile) {
    return AppBar(
      backgroundColor: cardColor,
      elevation: 4,
      shadowColor: primaryColor.withOpacity(0.15),
      surfaceTintColor: cardColor,
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
                  color: successColor.withOpacity(
                    0.8 + _pulseController.value * 0.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: successColor.withOpacity(
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
            'Info Personal',
            style: TextStyle(
              fontSize: isMobile ? 22 : 24,
              fontWeight: FontWeight.w800,
              color: primaryColor,
              letterSpacing: 0.8,
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
            margin: EdgeInsets.all(isMobile ? 8 : 12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [primaryColor, secondaryColor],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: cardColor,
              size: isMobile ? 20 : 24,
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
                _slideController.forward(from: 0);
              });
              _showAnimatedSnackBar(context);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.only(
                right: isMobile ? 8 : 12,
                top: 8,
                bottom: 8,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 20,
                vertical: isMobile ? 8 : 10,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: _isEditing
                    ? LinearGradient(
                        colors: [successColor, const Color(0xFF34D399)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : LinearGradient(
                        colors: [secondaryColor, accentColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                boxShadow: [
                  BoxShadow(
                    color: (_isEditing ? successColor : secondaryColor)
                        .withOpacity(
                          (_hoverStates['edit'] ?? false) ? 0.4 : 0.2,
                        ),
                    blurRadius: (_hoverStates['edit'] ?? false) ? 16 : 8,
                    offset: const Offset(0, 4),
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
                    color: cardColor,
                    size: isMobile ? 20 : 22,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _isEditing ? 'Simpan' : 'Edit',
                    style: TextStyle(
                      color: cardColor,
                      fontWeight: FontWeight.w700,
                      fontSize: isMobile ? 14 : 16,
                      letterSpacing: 0.8,
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
            color: cardColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _isEditing ? 'Mode edit diaktifkan' : 'Perubahan disimpan',
              style: TextStyle(fontWeight: FontWeight.w600, color: cardColor),
            ),
          ),
        ],
      ),
      backgroundColor: _isEditing ? secondaryColor : successColor,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      duration: const Duration(milliseconds: 2000),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Widget _buildProfileHeader(
      BuildContext context, bool isMobile, double maxWidth) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, (1 - _animation.value) * 30),
          child: Transform.scale(
            scale: 0.95 + (_animation.value * 0.05),
            child: Opacity(
              opacity: _animation.value,
              child: MouseRegion(
                onEnter: (_) => setState(() => _hoverStates['profile'] = true),
                onExit: (_) => setState(() => _hoverStates['profile'] = false),
                child: GestureDetector(
                  onTap: () => _showProfileDetails(context, isMobile),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(isMobile ? 24 : 28),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          primaryColor.withOpacity(0.9),
                          secondaryColor.withOpacity(0.8),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: primaryColor.withOpacity(
                              (_hoverStates['profile'] ?? false) ? 0.4 : 0.2),
                          blurRadius:
                              (_hoverStates['profile'] ?? false) ? 30 : 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -50,
                          top: -50,
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  Colors.white.withOpacity(0.1),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(isMobile ? 24 : 32),
                          child: Row(
                            children: [
                              _buildAnimatedProfileAvatar(isMobile),
                              const SizedBox(width: 20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    _buildNameBadge(isMobile),
                                    const SizedBox(height: 16),
                                    _buildEnhancedContactInfo(isMobile),
                                  ],
                                ),
                              ),
                              if (maxWidth > 500) _buildStatusBadge(isMobile),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedProfileAvatar(bool isMobile) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: isMobile ? 100 : 120,
              height: isMobile ? 100 : 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.transparent,
                border: Border.all(
                  color: Colors.white
                      .withOpacity(0.3 + _pulseController.value * 0.2),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(
                        0.1 + _pulseController.value * 0.1),
                    spreadRadius: 2,
                    blurRadius: 20,
                  ),
                ],
              ),
            ),
            Container(
              width: isMobile ? 88 : 104,
              height: isMobile ? 88 : 104,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.5),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/profil.jpg',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [primaryColor, secondaryColor],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Icon(
                        Icons.person_rounded,
                        color: cardColor,
                        size: 40,
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildNameBadge(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _dataPersonal['Nama Lengkap'] ?? '',
          style: TextStyle(
            fontSize: isMobile ? 24 : 28,
            fontWeight: FontWeight.w800,
            color: cardColor,
            letterSpacing: 0.5,
            height: 1.2,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 16 : 20,
            vertical: isMobile ? 8 : 10,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
          ),
          child: Text(
            'Fullstack Developer',
            style: TextStyle(
              fontSize: isMobile ? 14 : 16,
              color: cardColor,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedContactInfo(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildEnhancedContactItem(
          Icons.email_rounded,
          _dataContact['Email Utama'] ?? '-',
          isMobile,
        ),
        const SizedBox(height: 8),
        _buildEnhancedContactItem(
          Icons.phone_rounded,
          _dataContact['Nomor HP'] ?? '-',
          isMobile,
        ),
      ],
    );
  }

  Widget _buildEnhancedContactItem(IconData icon, String text, bool isMobile) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hoverStates['contact_$text'] = true),
      onExit: (_) => setState(() => _hoverStates['contact_$text'] = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: (_hoverStates['contact_$text'] ?? false)
              ? Colors.white.withOpacity(0.3)
              : Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
        ),
        child: Row(
          children: [
            Icon(icon, size: isMobile ? 18 : 20, color: cardColor),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: isMobile ? 14 : 16,
                  color: cardColor,
                  fontWeight: FontWeight.w500,
                  height: 1.4,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (_hoverStates['contact_$text'] ?? false)
              Icon(
                Icons.copy_rounded,
                size: 16,
                color: cardColor.withOpacity(0.8),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(bool isMobile) {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.95 + (_pulseController.value * 0.1),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 20 : 24,
              vertical: isMobile ? 12 : 14,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.9),
                  Colors.white.withOpacity(0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.white
                      .withOpacity(0.4 + _pulseController.value * 0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: successColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: successColor.withOpacity(0.8),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Aktif',
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w800,
                    fontSize: isMobile ? 14 : 16,
                    letterSpacing: 1.2,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPersonalInfoSection(BuildContext context, bool isMobile) {
    return Container(
      key: _cardKeys['personal'],
      child: _buildEnhancedSectionContainer(
        context,
        'Data Pribadi',
        Icons.person_2_rounded,
        primaryColor,
        [
          for (var entry in _dataPersonal.entries)
            _buildEnhancedInfoCard(
              context,
              entry.key,
              entry.value,
              _getIconForPersonalField(entry.key),
              primaryColor,
              isMobile,
            ),
        ],
        isMobile,
      ),
    );
  }

  Widget _buildContactInfoSection(BuildContext context, bool isMobile) {
    return Container(
      key: _cardKeys['contact'],
      child: _buildEnhancedSectionContainer(
        context,
        'Kontak',
        Icons.contact_page_rounded,
        secondaryColor,
        [
          for (var entry in _dataContact.entries)
            _buildEnhancedInfoCard(
              context,
              entry.key,
              entry.value,
              _getIconForContactField(entry.key),
              secondaryColor,
              isMobile,
            ),
        ],
        isMobile,
      ),
    );
  }

  IconData _getIconForPersonalField(String label) {
    switch (label) {
      case 'Nama Lengkap':
        return Icons.person_rounded;
      case 'Tempat Lahir':
        return Icons.location_on_rounded;
      case 'Tanggal Lahir':
        return Icons.calendar_month_rounded;
      case 'Jenis Kelamin':
        return Icons.transgender_rounded;
      case 'Agama':
        return Icons.workspace_premium_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  IconData _getIconForContactField(String label) {
    switch (label) {
      case 'Email Utama':
        return Icons.email_rounded;
      case 'Nomor HP':
        return Icons.phone_rounded;
      case 'Alamat':
        return Icons.home_work_rounded;
      case 'Kota':
        return Icons.location_city_rounded;
      default:
        return Icons.info_rounded;
    }
  }

  void _showEditDialog(BuildContext context, String label) {
    final isPersonal = _dataPersonal.containsKey(label);
    final controller = TextEditingController(
      text: isPersonal ? _dataPersonal[label] : _dataContact[label],
    );
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Icon(Icons.edit_rounded, color: primaryColor),
            const SizedBox(width: 12),
            Text(
              'Edit $label',
              style: TextStyle(color: textPrimary, fontWeight: FontWeight.w800),
            ),
          ],
        ),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Masukkan $label baru',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primaryColor),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal', style: TextStyle(color: textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                if (isPersonal) {
                  _dataPersonal[label] = controller.text;
                } else {
                  _dataContact[label] = controller.text;
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$label berhasil diperbarui'),
                  backgroundColor: successColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text('Simpan', style: TextStyle(color: cardColor)),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedSectionContainer(
      BuildContext context,
      String title,
      IconData icon,
      Color color,
      List<Widget> items,
      bool isMobile) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, (1 - _animation.value) * 40),
          child: Opacity(
            opacity: _animation.value,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Row(
                    children: [
                      Container(
                        width: isMobile ? 48 : 56,
                        height: isMobile ? 48 : 56,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              color,
                              Color.lerp(color, Colors.white, 0.3)!,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: color.withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          icon,
                          color: cardColor,
                          size: isMobile ? 24 : 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: isMobile ? 22 : 26,
                            fontWeight: FontWeight.w800,
                            color: textPrimary,
                            letterSpacing: 0.8,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
                ...items,
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEnhancedInfoCard(
      BuildContext context,
      String label,
      String value,
      IconData icon,
      Color iconColor,
      bool isMobile) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hoverStates['card_$label'] = true),
      onExit: (_) => setState(() => _hoverStates['card_$label'] = false),
      child: GestureDetector(
        onTap: () => _onCardTap(context, label),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: (_hoverStates['card_$label'] ?? false)
                  ? iconColor.withOpacity(0.3)
                  : borderColor,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: (_hoverStates['card_$label'] ?? false)
                    ? iconColor.withOpacity(0.15)
                    : Colors.grey.withOpacity(0.1),
                blurRadius: (_hoverStates['card_$label'] ?? false) ? 20 : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                right: 0,
                top: 0,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: (_hoverStates['card_$label'] ?? false) ? 100 : 0,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        iconColor.withOpacity(0.1),
                        iconColor.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(60),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 20 : 24,
                  vertical: isMobile ? 20 : 24,
                ),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: isMobile ? 52 : 60,
                      height: isMobile ? 52 : 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: (_hoverStates['card_$label'] ?? false)
                              ? [
                                  iconColor,
                                  Color.lerp(iconColor, Colors.white, 0.3)!,
                                ]
                              : [
                                  iconColor.withOpacity(0.1),
                                  iconColor.withOpacity(0.1),
                                ],
                        ),
                        border: Border.all(
                          color: (_hoverStates['card_$label'] ?? false)
                              ? iconColor.withOpacity(0.5)
                              : iconColor.withOpacity(0.2),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        icon,
                        color: (_hoverStates['card_$label'] ?? false)
                            ? cardColor
                            : iconColor,
                        size: isMobile ? 24 : 26,
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            label,
                            style: TextStyle(
                              fontSize: isMobile ? 14 : 15,
                              color: textSecondary,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            value,
                            style: TextStyle(
                              fontSize: isMobile ? 18 : 20,
                              color: textPrimary,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      transform: Matrix4.translationValues(
                        (_hoverStates['card_$label'] ?? false) ? 8 : 0,
                        0,
                        0,
                      ),
                      child: Icon(
                        _isEditing
                            ? Icons.edit_rounded
                            : Icons.arrow_forward_ios_rounded,
                        color: (_hoverStates['card_$label'] ?? false)
                            ? iconColor
                            : textSecondary,
                        size: isMobile ? 20 : 22,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onCardTap(BuildContext context, String label) {
    if (_isEditing) {
      _showEditDialog(context, label);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lihat detail $label'),
          backgroundColor: primaryColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }

  Widget _buildEnhancedFAB(BuildContext context, bool isMobile) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _rippleController,
          builder: (context, child) {
            return Transform.scale(
              scale: 1 + _rippleController.value * 0.3,
              child: Container(
                width: isMobile ? 70 : 80,
                height: isMobile ? 70 : 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryColor.withOpacity(
                    0.1 - _rippleController.value * 0.1,
                  ),
                ),
              ),
            );
          },
        ),
        FloatingActionButton.extended(
          onPressed: () {
            //_showEnhancedBottomSheet(context, isMobile);
            _triggerRipple();
          },
          backgroundColor: primaryColor,
          foregroundColor: cardColor,
          elevation: 8,
          hoverElevation: 12,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isMobile ? 20 : 24),
          ),
          icon: Icon(Icons.more_horiz_rounded, size: isMobile ? 28 : 32),
          label: Text(
            'Opsi Lain',
            style: TextStyle(
              fontSize: isMobile ? 16 : 18,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ),
      ],
    );
  }

  void _showProfileDetails(BuildContext context, bool isMobile) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(isMobile ? 20 : 40),
        child: Stack(
          children: [
            Container(
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
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: primaryColor, width: 3),
                      image: DecorationImage(
                        image: AssetImage('assets/profil.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    _dataPersonal['Nama Lengkap'] ?? '-',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Fullstack Developer',
                    style: TextStyle(
                      fontSize: 16,
                      color: secondaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildDetailItem(
                    'Status',
                    'Aktif',
                    Icons.circle,
                    successColor,
                  ),
                  _buildDetailItem(
                    'Member Since',
                    '2023',
                    Icons.calendar_today,
                    primaryColor,
                  ),
                  _buildDetailItem(
                    'Terakhir Login',
                    '2 jam lalu',
                    Icons.access_time,
                    accentColor,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 16,
                      ),
                    ),
                    child: Text('Tutup', style: TextStyle(color: cardColor)),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close_rounded, color: textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.1),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(color: textSecondary, fontSize: 14),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: 16,
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


// import 'package:flutter/material.dart';

// class InfoPersonalScreen extends StatefulWidget {
//   const InfoPersonalScreen({super.key});

//   @override
//   State<InfoPersonalScreen> createState() => _InfoPersonalScreenState();
// }

// class _InfoPersonalScreenState extends State<InfoPersonalScreen>
//     with TickerProviderStateMixin {
//   // Hapus SingleTickerProviderStateMixin
//   bool _isEditing = false;
//   final primaryColor = const Color(0xFF1E3A8A);
//   final secondaryColor = const Color(0xFF0EA5E9);
//   final accentColor = const Color(0xFF8B5CF6);
//   final backgroundColor = const Color(0xFFF8FAFC);
//   final cardColor = const Color(0xFFFFFFFF);
//   final textPrimary = const Color(0xFF1F2937);
//   final textSecondary = const Color(0xFF6B7280);
//   final successColor = const Color(0xFF10B981);
//   final borderColor = const Color(0xFFE5E7EB);

//   late AnimationController _animationController;
//   late Animation<double> _animation;
//   late AnimationController _pulseController;
//   late AnimationController _slideController;
//   late Animation<double> _slideAnimation;
//   late AnimationController _rippleController;
//   final Map<String, bool> _hoverStates = {};
//   final Map<String, GlobalKey> _cardKeys = {};

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 1000),
//       vsync: this,
//     )..forward();

//     _pulseController = AnimationController(
//       duration: const Duration(milliseconds: 2000),
//       vsync: this,
//     )..repeat(reverse: true);

//     _slideController = AnimationController(
//       duration: const Duration(milliseconds: 800),
//       vsync: this,
//     );

//     _rippleController = AnimationController(
//       duration: const Duration(milliseconds: 500),
//       vsync: this,
//     );

//     _animation = CurvedAnimation(
//       parent: _animationController,
//       curve: Curves.easeOutCubic,
//     );

//     _slideAnimation = Tween<double>(begin: 0, end: 1).animate(
//       CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
//     );

//     // Initialize card keys
//     _cardKeys['personal'] = GlobalKey();
//     _cardKeys['contact'] = GlobalKey();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     _pulseController.dispose();
//     _slideController.dispose();
//     _rippleController.dispose();
//     super.dispose();
//   }

//   void _triggerRipple() {
//     _rippleController.forward(from: 0);
//   }

//   void _scrollToSection(String section) {
//     if (_cardKeys[section]?.currentContext != null) {
//       Scrollable.ensureVisible(
//         _cardKeys[section]!.currentContext!,
//         duration: const Duration(milliseconds: 800),
//         curve: Curves.easeInOut,
//       );
//       _triggerRipple();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isMobile = screenWidth < 600;
//     final horizontalPadding = isMobile ? 16.0 : 24.0;

//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: _buildAppBar(isMobile),
//       body: CustomScrollView(
//         physics: const BouncingScrollPhysics(),
//         slivers: [
//           SliverToBoxAdapter(
//             child: Container(
//               padding: EdgeInsets.symmetric(
//                 horizontal: horizontalPadding,
//                 vertical: isMobile ? 16 : 24,
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildProfileHeader(context, isMobile, screenWidth),
//                   const SizedBox(height: 24),
//                   _buildSectionNavigation(isMobile),
//                   const SizedBox(height: 24),
//                 ],
//               ),
//             ),
//           ),
//           SliverList(
//             delegate: SliverChildListDelegate([
//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
//                 child: Column(
//                   children: [
//                     _buildPersonalInfoSection(context, isMobile),
//                     const SizedBox(height: 32),
//                     _buildContactInfoSection(context, isMobile),
//                     const SizedBox(height: 60),
//                   ],
//                 ),
//               ),
//             ]),
//           ),
//         ],
//       ),
//       floatingActionButton: _buildEnhancedFAB(context, isMobile),
//       floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
//     );
//   }

//   // ... (sisa kode tetap sama seperti sebelumnya)

//   Widget _buildSectionNavigation(bool isMobile) {
//     return AnimatedBuilder(
//       animation: _slideController,
//       builder: (context, child) {
//         return Transform.translate(
//           offset: Offset(0, (1 - _slideAnimation.value) * 50),
//           child: Opacity(
//             opacity: _slideAnimation.value,
//             child: Card(
//               elevation: 4,
//               shadowColor: primaryColor.withOpacity(0.1),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(16),
//                 side: BorderSide(color: borderColor, width: 1.5),
//               ),
//               color: cardColor,
//               child: Padding(
//                 padding: EdgeInsets.all(isMobile ? 12 : 16),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     _buildNavButton(
//                       Icons.person_rounded,
//                       'Data Pribadi',
//                       primaryColor,
//                       () => _scrollToSection('personal'),
//                       isMobile,
//                     ),
//                     Container(width: 1, height: 30, color: borderColor),
//                     _buildNavButton(
//                       Icons.contact_phone_rounded,
//                       'Kontak',
//                       secondaryColor,
//                       () => _scrollToSection('contact'),
//                       isMobile,
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildNavButton(
//     IconData icon,
//     String label,
//     Color color,
//     VoidCallback onTap,
//     bool isMobile,
//   ) {
//     return Expanded(
//       child: MouseRegion(
//         onEnter: (_) => setState(() => _hoverStates['nav_$label'] = true),
//         onExit: (_) => setState(() => _hoverStates['nav_$label'] = false),
//         child: GestureDetector(
//           onTap: () {
//             onTap();
//             _triggerRipple();
//           },
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 300),
//             padding: EdgeInsets.symmetric(
//               horizontal: isMobile ? 12 : 16,
//               vertical: isMobile ? 10 : 14,
//             ),
//             decoration: BoxDecoration(
//               color: (_hoverStates['nav_$label'] ?? false)
//                   ? color.withOpacity(0.05)
//                   : Colors.transparent,
//               borderRadius: BorderRadius.circular(12),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(icon, color: color, size: isMobile ? 22 : 24),
//                 const SizedBox(height: 6),
//                 Text(
//                   label,
//                   style: TextStyle(
//                     fontSize: isMobile ? 12 : 14,
//                     fontWeight: FontWeight.w600,
//                     color: color,
//                     letterSpacing: 0.5,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   AppBar _buildAppBar(bool isMobile) {
//     return AppBar(
//       backgroundColor: cardColor,
//       elevation: 4,
//       shadowColor: primaryColor.withOpacity(0.15),
//       surfaceTintColor: cardColor,
//       title: Row(
//         children: [
//           AnimatedBuilder(
//             animation: _pulseController,
//             builder: (context, child) {
//               return Container(
//                 width: 10,
//                 height: 10,
//                 margin: const EdgeInsets.only(right: 12),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: successColor.withOpacity(
//                     0.8 + _pulseController.value * 0.2,
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: successColor.withOpacity(
//                         0.3 + _pulseController.value * 0.2,
//                       ),
//                       blurRadius: 8,
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//           Text(
//             'Info Personal',
//             style: TextStyle(
//               fontSize: isMobile ? 22 : 24,
//               fontWeight: FontWeight.w800,
//               color: primaryColor,
//               letterSpacing: 0.8,
//             ),
//           ),
//         ],
//       ),
//       leading: MouseRegion(
//         cursor: SystemMouseCursors.click,
//         child: GestureDetector(
//           onTap: () {
//             Navigator.pop(context);
//             _triggerRipple();
//           },
//           child: Container(
//             margin: EdgeInsets.all(isMobile ? 8 : 12),
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               gradient: LinearGradient(
//                 colors: [primaryColor, secondaryColor],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               boxShadow: [
//                 BoxShadow(
//                   color: primaryColor.withOpacity(0.3),
//                   blurRadius: 8,
//                   offset: const Offset(0, 4),
//                 ),
//               ],
//             ),
//             child: Icon(
//               Icons.arrow_back_ios_new_rounded,
//               color: cardColor,
//               size: isMobile ? 20 : 24,
//             ),
//           ),
//         ),
//       ),
//       actions: [
//         MouseRegion(
//           onEnter: (_) => setState(() => _hoverStates['edit'] = true),
//           onExit: (_) => setState(() => _hoverStates['edit'] = false),
//           child: GestureDetector(
//             onTap: () {
//               setState(() {
//                 _isEditing = !_isEditing;
//                 _slideController.forward(from: 0);
//               });
//               _showAnimatedSnackBar(context);
//             },
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 300),
//               margin: EdgeInsets.only(
//                 right: isMobile ? 8 : 12,
//                 top: 8,
//                 bottom: 8,
//               ),
//               padding: EdgeInsets.symmetric(
//                 horizontal: isMobile ? 16 : 20,
//                 vertical: isMobile ? 8 : 10,
//               ),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(16),
//                 gradient: _isEditing
//                     ? LinearGradient(
//                         colors: [successColor, const Color(0xFF34D399)],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       )
//                     : LinearGradient(
//                         colors: [secondaryColor, accentColor],
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: (_isEditing ? successColor : secondaryColor)
//                         .withOpacity(
//                           (_hoverStates['edit'] ?? false) ? 0.4 : 0.2,
//                         ),
//                     blurRadius: (_hoverStates['edit'] ?? false) ? 16 : 8,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(
//                     _isEditing
//                         ? Icons.check_circle_rounded
//                         : Icons.edit_rounded,
//                     color: cardColor,
//                     size: isMobile ? 20 : 22,
//                   ),
//                   const SizedBox(width: 8),
//                   Text(
//                     _isEditing ? 'Simpan' : 'Edit',
//                     style: TextStyle(
//                       color: cardColor,
//                       fontWeight: FontWeight.w700,
//                       fontSize: isMobile ? 14 : 16,
//                       letterSpacing: 0.8,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   void _showAnimatedSnackBar(BuildContext context) {
//     final snackBar = SnackBar(
//       content: Row(
//         children: [
//           Icon(
//             _isEditing ? Icons.edit_rounded : Icons.check_circle_rounded,
//             color: cardColor,
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Text(
//               _isEditing ? 'Mode edit diaktifkan' : 'Perubahan disimpan',
//               style: TextStyle(fontWeight: FontWeight.w600, color: cardColor),
//             ),
//           ),
//         ],
//       ),
//       backgroundColor: _isEditing ? secondaryColor : successColor,
//       behavior: SnackBarBehavior.floating,
//       margin: const EdgeInsets.all(16),
//       duration: const Duration(milliseconds: 2000),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       elevation: 6,
//       animation: CurvedAnimation(
//         parent: AnimationController(
//           duration: const Duration(milliseconds: 300),
//           vsync: this,
//         )..forward(),
//         curve: Curves.easeOut,
//       ),
//     );
//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }

//   Widget _buildProfileHeader(
//     BuildContext context,
//     bool isMobile,
//     double maxWidth,
//   ) {
//     return AnimatedBuilder(
//       animation: _animationController,
//       builder: (context, child) {
//         return Transform.translate(
//           offset: Offset(0, (1 - _animation.value) * 30),
//           child: Transform.scale(
//             scale: 0.95 + (_animation.value * 0.05),
//             child: Opacity(
//               opacity: _animation.value,
//               child: MouseRegion(
//                 onEnter: (_) => setState(() => _hoverStates['profile'] = true),
//                 onExit: (_) => setState(() => _hoverStates['profile'] = false),
//                 child: GestureDetector(
//                   onTap: () => _showProfileDetails(context, isMobile),
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 300),
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(isMobile ? 24 : 28),
//                       gradient: LinearGradient(
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                         colors: [
//                           primaryColor.withOpacity(0.9),
//                           secondaryColor.withOpacity(0.8),
//                         ],
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: primaryColor.withOpacity(
//                             (_hoverStates['profile'] ?? false) ? 0.4 : 0.2,
//                           ),
//                           blurRadius: (_hoverStates['profile'] ?? false)
//                               ? 30
//                               : 20,
//                           offset: const Offset(0, 10),
//                         ),
//                       ],
//                     ),
//                     child: Stack(
//                       children: [
//                         Positioned(
//                           right: -50,
//                           top: -50,
//                           child: Container(
//                             width: 200,
//                             height: 200,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               gradient: LinearGradient(
//                                 colors: [
//                                   Colors.white.withOpacity(0.1),
//                                   Colors.transparent,
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: EdgeInsets.all(isMobile ? 24 : 32),
//                           child: Row(
//                             children: [
//                               _buildAnimatedProfileAvatar(isMobile),
//                               const SizedBox(width: 20),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     _buildNameBadge(isMobile),
//                                     const SizedBox(height: 16),
//                                     _buildEnhancedContactInfo(isMobile),
//                                   ],
//                                 ),
//                               ),
//                               if (maxWidth > 500) _buildStatusBadge(isMobile),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildAnimatedProfileAvatar(bool isMobile) {
//     return AnimatedBuilder(
//       animation: _pulseController,
//       builder: (context, child) {
//         return Stack(
//           alignment: Alignment.center,
//           children: [
//             Container(
//               width: isMobile ? 100 : 120,
//               height: isMobile ? 100 : 120,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.transparent,
//                 border: Border.all(
//                   color: Colors.white.withOpacity(
//                     0.3 + _pulseController.value * 0.2,
//                   ),
//                   width: 2,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.white.withOpacity(
//                       0.1 + _pulseController.value * 0.1,
//                     ),
//                     spreadRadius: 2,
//                     blurRadius: 20,
//                   ),
//                 ],
//               ),
//             ),
//             Container(
//               width: isMobile ? 88 : 104,
//               height: isMobile ? 88 : 104,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 border: Border.all(
//                   color: Colors.white.withOpacity(0.5),
//                   width: 3,
//                 ),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.2),
//                     spreadRadius: 2,
//                     blurRadius: 20,
//                     offset: const Offset(0, 4),
//                   ),
//                 ],
//               ),
//               child: ClipOval(
//                 child: Image.asset(
//                   'assets/profil.jpg',
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) {
//                     return Container(
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           colors: [primaryColor, secondaryColor],
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                         ),
//                       ),
//                       child: Icon(
//                         Icons.person_rounded,
//                         color: cardColor,
//                         size: 40,
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildNameBadge(bool isMobile) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Leonardo Dicaprio',
//           style: TextStyle(
//             fontSize: isMobile ? 24 : 28,
//             fontWeight: FontWeight.w800,
//             color: cardColor,
//             letterSpacing: 0.5,
//             height: 1.2,
//           ),
//           maxLines: 2,
//           overflow: TextOverflow.ellipsis,
//         ),
//         const SizedBox(height: 8),
//         Container(
//           padding: EdgeInsets.symmetric(
//             horizontal: isMobile ? 16 : 20,
//             vertical: isMobile ? 8 : 10,
//           ),
//           decoration: BoxDecoration(
//             color: Colors.white.withOpacity(0.2),
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
//           ),
//           child: Text(
//             'Fullstack Developer',
//             style: TextStyle(
//               fontSize: isMobile ? 14 : 16,
//               color: cardColor,
//               fontWeight: FontWeight.w600,
//               letterSpacing: 0.8,
//             ),
//             maxLines: 1,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildEnhancedContactInfo(bool isMobile) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         _buildEnhancedContactItem(
//           Icons.email_rounded,
//           'Leonard1@email.com',
//           isMobile,
//         ),
//         const SizedBox(height: 8),
//         _buildEnhancedContactItem(
//           Icons.phone_rounded,
//           '0812-3456-7890',
//           isMobile,
//         ),
//       ],
//     );
//   }

//   Widget _buildEnhancedContactItem(IconData icon, String text, bool isMobile) {
//     return MouseRegion(
//       onEnter: (_) => setState(() => _hoverStates['contact_$text'] = true),
//       onExit: (_) => setState(() => _hoverStates['contact_$text'] = false),
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 200),
//         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//         decoration: BoxDecoration(
//           color: (_hoverStates['contact_$text'] ?? false)
//               ? Colors.white.withOpacity(0.3)
//               : Colors.white.withOpacity(0.15),
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
//         ),
//         child: Row(
//           children: [
//             Icon(icon, size: isMobile ? 18 : 20, color: cardColor),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 text,
//                 style: TextStyle(
//                   fontSize: isMobile ? 14 : 16,
//                   color: cardColor,
//                   fontWeight: FontWeight.w500,
//                   height: 1.4,
//                 ),
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ),
//             if (_hoverStates['contact_$text'] ?? false)
//               Icon(
//                 Icons.copy_rounded,
//                 size: 16,
//                 color: cardColor.withOpacity(0.8),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildStatusBadge(bool isMobile) {
//     return AnimatedBuilder(
//       animation: _pulseController,
//       builder: (context, child) {
//         return Transform.scale(
//           scale: 0.95 + (_pulseController.value * 0.1),
//           child: Container(
//             padding: EdgeInsets.symmetric(
//               horizontal: isMobile ? 20 : 24,
//               vertical: isMobile ? 12 : 14,
//             ),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   Colors.white.withOpacity(0.9),
//                   Colors.white.withOpacity(0.7),
//                 ],
//                 begin: Alignment.topLeft,
//                 end: Alignment.bottomRight,
//               ),
//               borderRadius: BorderRadius.circular(24),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.white.withOpacity(
//                     0.4 + _pulseController.value * 0.2,
//                   ),
//                   blurRadius: 15,
//                   offset: const Offset(0, 3),
//                 ),
//               ],
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   width: 10,
//                   height: 10,
//                   decoration: BoxDecoration(
//                     color: successColor,
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: successColor.withOpacity(0.8),
//                         blurRadius: 8,
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   'Aktif',
//                   style: TextStyle(
//                     color: primaryColor,
//                     fontWeight: FontWeight.w800,
//                     fontSize: isMobile ? 14 : 16,
//                     letterSpacing: 1.2,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildPersonalInfoSection(BuildContext context, bool isMobile) {
//     return Container(
//       key: _cardKeys['personal'],
//       child: _buildEnhancedSectionContainer(
//         context,
//         'Data Pribadi',
//         Icons.person_2_rounded,
//         primaryColor,
//         [
//           _buildEnhancedInfoCard(
//             context,
//             'Nama Lengkap',
//             'Leonardo .D. Caprio',
//             Icons.person_rounded,
//             primaryColor,
//             isMobile,
//           ),
//           _buildEnhancedInfoCard(
//             context,
//             'Tempat Lahir',
//             'Bekasi',
//             Icons.location_on_rounded,
//             primaryColor,
//             isMobile,
//           ),
//           _buildEnhancedInfoCard(
//             context,
//             'Tanggal Lahir',
//             '30 Oktober 2004',
//             Icons.calendar_month_rounded,
//             primaryColor,
//             isMobile,
//           ),
//           _buildEnhancedInfoCard(
//             context,
//             'Jenis Kelamin',
//             'Laki-laki',
//             Icons.transgender_rounded,
//             primaryColor,
//             isMobile,
//           ),
//           _buildEnhancedInfoCard(
//             context,
//             'Agama',
//             'Islam',
//             Icons.workspace_premium_rounded,
//             primaryColor,
//             isMobile,
//           ),
//         ],
//         isMobile,
//       ),
//     );
//   }

//   Widget _buildContactInfoSection(BuildContext context, bool isMobile) {
//     return Container(
//       key: _cardKeys['contact'],
//       child: _buildEnhancedSectionContainer(
//         context,
//         'Kontak',
//         Icons.contact_page_rounded,
//         secondaryColor,
//         [
//           _buildEnhancedInfoCard(
//             context,
//             'Email Utama',
//             'Leonard1.com',
//             Icons.email_rounded,
//             secondaryColor,
//             isMobile,
//           ),
//           _buildEnhancedInfoCard(
//             context,
//             'Nomor HP',
//             '0812-3456-7890',
//             Icons.phone_rounded,
//             secondaryColor,
//             isMobile,
//           ),
//           _buildEnhancedInfoCard(
//             context,
//             'Alamat',
//             'Jl. Didiparawirakusumah No. 123',
//             Icons.home_work_rounded,
//             secondaryColor,
//             isMobile,
//           ),
//           _buildEnhancedInfoCard(
//             context,
//             'Kota',
//             'Kota Bandung',
//             Icons.location_city_rounded,
//             secondaryColor,
//             isMobile,
//           ),
//         ],
//         isMobile,
//       ),
//     );
//   }

//   Widget _buildEnhancedSectionContainer(
//     BuildContext context,
//     String title,
//     IconData icon,
//     Color color,
//     List<Widget> items,
//     bool isMobile,
//   ) {
//     return AnimatedBuilder(
//       animation: _animationController,
//       builder: (context, child) {
//         return Transform.translate(
//           offset: Offset(0, (1 - _animation.value) * 40),
//           child: Opacity(
//             opacity: _animation.value,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: EdgeInsets.only(bottom: 16),
//                   child: Row(
//                     children: [
//                       Container(
//                         width: isMobile ? 48 : 56,
//                         height: isMobile ? 48 : 56,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           gradient: LinearGradient(
//                             colors: [
//                               color,
//                               Color.lerp(color, Colors.white, 0.3)!,
//                             ],
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                           ),
//                           boxShadow: [
//                             BoxShadow(
//                               color: color.withOpacity(0.3),
//                               blurRadius: 12,
//                               offset: const Offset(0, 4),
//                             ),
//                           ],
//                         ),
//                         child: Icon(
//                           icon,
//                           color: cardColor,
//                           size: isMobile ? 24 : 28,
//                         ),
//                       ),
//                       const SizedBox(width: 16),
//                       Expanded(
//                         child: Text(
//                           title,
//                           style: TextStyle(
//                             fontSize: isMobile ? 22 : 26,
//                             fontWeight: FontWeight.w800,
//                             color: textPrimary,
//                             letterSpacing: 0.8,
//                           ),
//                           overflow: TextOverflow.ellipsis,
//                           maxLines: 1,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 ...items,
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildEnhancedInfoCard(
//     BuildContext context,
//     String label,
//     String value,
//     IconData icon,
//     Color iconColor,
//     bool isMobile,
//   ) {
//     return MouseRegion(
//       onEnter: (_) => setState(() => _hoverStates['card_$label'] = true),
//       onExit: (_) => setState(() => _hoverStates['card_$label'] = false),
//       child: GestureDetector(
//         onTap: () => _onCardTap(context, label),
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 300),
//           margin: EdgeInsets.only(bottom: 12),
//           decoration: BoxDecoration(
//             color: cardColor,
//             borderRadius: BorderRadius.circular(20),
//             border: Border.all(
//               color: (_hoverStates['card_$label'] ?? false)
//                   ? iconColor.withOpacity(0.3)
//                   : borderColor,
//               width: 1.5,
//             ),
//             boxShadow: [
//               BoxShadow(
//                 color: (_hoverStates['card_$label'] ?? false)
//                     ? iconColor.withOpacity(0.15)
//                     : Colors.grey.withOpacity(0.1),
//                 blurRadius: (_hoverStates['card_$label'] ?? false) ? 20 : 8,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: Stack(
//             children: [
//               Positioned(
//                 right: 0,
//                 top: 0,
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 300),
//                   width: (_hoverStates['card_$label'] ?? false) ? 100 : 0,
//                   height: 100,
//                   decoration: BoxDecoration(
//                     gradient: LinearGradient(
//                       colors: [
//                         iconColor.withOpacity(0.1),
//                         iconColor.withOpacity(0.05),
//                       ],
//                     ),
//                     borderRadius: BorderRadius.only(
//                       topRight: Radius.circular(20),
//                       bottomLeft: Radius.circular(60),
//                     ),
//                   ),
//                 ),
//               ),
//               Padding(
//                 padding: EdgeInsets.symmetric(
//                   horizontal: isMobile ? 20 : 24,
//                   vertical: isMobile ? 20 : 24,
//                 ),
//                 child: Row(
//                   children: [
//                     AnimatedContainer(
//                       duration: const Duration(milliseconds: 300),
//                       width: isMobile ? 52 : 60,
//                       height: isMobile ? 52 : 60,
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         gradient: LinearGradient(
//                           colors: (_hoverStates['card_$label'] ?? false)
//                               ? [
//                                   iconColor,
//                                   Color.lerp(iconColor, Colors.white, 0.3)!,
//                                 ]
//                               : [
//                                   iconColor.withOpacity(0.1),
//                                   iconColor.withOpacity(0.1),
//                                 ],
//                         ),
//                         border: Border.all(
//                           color: (_hoverStates['card_$label'] ?? false)
//                               ? iconColor.withOpacity(0.5)
//                               : iconColor.withOpacity(0.2),
//                           width: 2,
//                         ),
//                       ),
//                       child: Icon(
//                         icon,
//                         color: (_hoverStates['card_$label'] ?? false)
//                             ? cardColor
//                             : iconColor,
//                         size: isMobile ? 24 : 26,
//                       ),
//                     ),
//                     const SizedBox(width: 18),
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             label,
//                             style: TextStyle(
//                               fontSize: isMobile ? 14 : 15,
//                               color: textSecondary,
//                               fontWeight: FontWeight.w600,
//                               letterSpacing: 0.5,
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 1,
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             value,
//                             style: TextStyle(
//                               fontSize: isMobile ? 18 : 20,
//                               color: textPrimary,
//                               fontWeight: FontWeight.w700,
//                               letterSpacing: 0.3,
//                             ),
//                             overflow: TextOverflow.ellipsis,
//                             maxLines: 2,
//                           ),
//                         ],
//                       ),
//                     ),
//                     AnimatedContainer(
//                       duration: const Duration(milliseconds: 300),
//                       transform: Matrix4.translationValues(
//                         (_hoverStates['card_$label'] ?? false) ? 8 : 0,
//                         0,
//                         0,
//                       ),
//                       child: Icon(
//                         _isEditing
//                             ? Icons.edit_rounded
//                             : Icons.arrow_forward_ios_rounded,
//                         color: (_hoverStates['card_$label'] ?? false)
//                             ? iconColor
//                             : textSecondary,
//                         size: isMobile ? 20 : 22,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _onCardTap(BuildContext context, String label) {
//     if (_isEditing) {
//       _showEditDialog(context, label);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Lihat detail $label'),
//           backgroundColor: primaryColor,
//           behavior: SnackBarBehavior.floating,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//       );
//     }
//   }

//   void _showEditDialog(BuildContext context, String label) {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: cardColor,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
//         title: Row(
//           children: [
//             Icon(Icons.edit_rounded, color: primaryColor),
//             const SizedBox(width: 12),
//             Text(
//               'Edit $label',
//               style: TextStyle(color: textPrimary, fontWeight: FontWeight.w800),
//             ),
//           ],
//         ),
//         content: TextField(
//           decoration: InputDecoration(
//             hintText: 'Masukkan $label baru',
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(color: borderColor),
//             ),
//             focusedBorder: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12),
//               borderSide: BorderSide(color: primaryColor),
//             ),
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: Text('Batal', style: TextStyle(color: textSecondary)),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context);
//               ScaffoldMessenger.of(context).showSnackBar(
//                 SnackBar(
//                   content: Text('$label berhasil diperbarui'),
//                   backgroundColor: successColor,
//                 ),
//               );
//             },
//             style: ElevatedButton.styleFrom(
//               backgroundColor: primaryColor,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//             ),
//             child: Text('Simpan', style: TextStyle(color: cardColor)),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEnhancedFAB(BuildContext context, bool isMobile) {
//     return Stack(
//       children: [
//         AnimatedBuilder(
//           animation: _rippleController,
//           builder: (context, child) {
//             return Transform.scale(
//               scale: 1 + _rippleController.value * 0.3,
//               child: Container(
//                 width: isMobile ? 70 : 80,
//                 height: isMobile ? 70 : 80,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: primaryColor.withOpacity(
//                     0.1 - _rippleController.value * 0.1,
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//         FloatingActionButton.extended(
//           onPressed: () {
//             _showEnhancedBottomSheet(context, isMobile);
//             _triggerRipple();
//           },
//           backgroundColor: primaryColor,
//           foregroundColor: cardColor,
//           elevation: 8,
//           hoverElevation: 12,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(isMobile ? 20 : 24),
//           ),
//           icon: Icon(Icons.more_horiz_rounded, size: isMobile ? 28 : 32),
//           label: Text(
//             'Opsi Lain',
//             style: TextStyle(
//               fontSize: isMobile ? 16 : 18,
//               fontWeight: FontWeight.w700,
//               letterSpacing: 0.8,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   void _showEnhancedBottomSheet(BuildContext context, bool isMobile) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       builder: (context) {
//         return Container(
//           margin: EdgeInsets.only(top: 100),
//           child: DraggableScrollableSheet(
//             initialChildSize: 0.4,
//             minChildSize: 0.3,
//             maxChildSize: 0.8,
//             builder: (context, scrollController) {
//               return Container(
//                 decoration: BoxDecoration(
//                   color: cardColor,
//                   borderRadius: BorderRadius.only(
//                     topLeft: Radius.circular(isMobile ? 32 : 40),
//                     topRight: Radius.circular(isMobile ? 32 : 40),
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.2),
//                       blurRadius: 30,
//                       offset: const Offset(0, -10),
//                     ),
//                   ],
//                 ),
//                 child: Column(
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.only(
//                         top: isMobile ? 24 : 28,
//                         bottom: 16,
//                       ),
//                       child: Container(
//                         width: 60,
//                         height: 6,
//                         decoration: BoxDecoration(
//                           color: borderColor,
//                           borderRadius: BorderRadius.circular(3),
//                         ),
//                       ),
//                     ),
//                     Expanded(
//                       child: ListView(
//                         controller: scrollController,
//                         padding: EdgeInsets.symmetric(
//                           horizontal: isMobile ? 20 : 24,
//                         ),
//                         children: [
//                           _buildBottomSheetHeader(isMobile),
//                           const SizedBox(height: 24),
//                           _buildEnhancedBottomSheetOption(
//                             context,
//                             Icons.download_rounded,
//                             'Export Data',
//                             'Ekspor data pribadi ke PDF',
//                             secondaryColor,
//                             isMobile,
//                           ),
//                           _buildEnhancedBottomSheetOption(
//                             context,
//                             Icons.print_rounded,
//                             'Print Profile',
//                             'Cetak profil untuk dokumen resmi',
//                             primaryColor,
//                             isMobile,
//                           ),
//                           _buildEnhancedBottomSheetOption(
//                             context,
//                             Icons.share_rounded,
//                             'Share Profile',
//                             'Bagikan profil melalui media sosial',
//                             accentColor,
//                             isMobile,
//                           ),
//                           _buildEnhancedBottomSheetOption(
//                             context,
//                             Icons.qr_code_rounded,
//                             'QR Code',
//                             'Buat QR Code untuk profil Anda',
//                             successColor,
//                             isMobile,
//                           ),
//                           _buildEnhancedBottomSheetOption(
//                             context,
//                             Icons.settings_rounded,
//                             'Pengaturan',
//                             'Atur preferensi dan privasi',
//                             textSecondary,
//                             isMobile,
//                           ),
//                           SizedBox(
//                             height:
//                                 MediaQuery.of(context).viewInsets.bottom + 20,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildBottomSheetHeader(bool isMobile) {
//     return Column(
//       children: [
//         Text(
//           'Opsi Tambahan',
//           style: TextStyle(
//             fontSize: isMobile ? 24 : 28,
//             fontWeight: FontWeight.w800,
//             color: primaryColor,
//             letterSpacing: 1.0,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           'Pilih tindakan yang ingin dilakukan',
//           style: TextStyle(
//             fontSize: isMobile ? 14 : 16,
//             color: textSecondary,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildEnhancedBottomSheetOption(
//     BuildContext context,
//     IconData icon,
//     String title,
//     String subtitle,
//     Color color,
//     bool isMobile,
//   ) {
//     return MouseRegion(
//       onEnter: (_) => setState(() => _hoverStates['option_$title'] = true),
//       onExit: (_) => setState(() => _hoverStates['option_$title'] = false),
//       child: GestureDetector(
//         onTap: () {
//           Navigator.pop(context);
//           _showActionCompleted(context, title, color);
//         },
//         child: AnimatedContainer(
//           duration: const Duration(milliseconds: 300),
//           margin: EdgeInsets.only(bottom: isMobile ? 12 : 14),
//           padding: EdgeInsets.all(isMobile ? 16 : 20),
//           decoration: BoxDecoration(
//             color: (_hoverStates['option_$title'] ?? false)
//                 ? color.withOpacity(0.05)
//                 : Colors.transparent,
//             borderRadius: BorderRadius.circular(isMobile ? 18 : 22),
//             border: Border.all(
//               color: (_hoverStates['option_$title'] ?? false)
//                   ? color.withOpacity(0.2)
//                   : borderColor,
//               width: 1.5,
//             ),
//           ),
//           child: Row(
//             children: [
//               AnimatedContainer(
//                 duration: const Duration(milliseconds: 300),
//                 width: isMobile ? 52 : 60,
//                 height: isMobile ? 52 : 60,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   gradient: LinearGradient(
//                     colors: (_hoverStates['option_$title'] ?? false)
//                         ? [color, Color.lerp(color, Colors.white, 0.3)!]
//                         : [color.withOpacity(0.1), color.withOpacity(0.1)],
//                   ),
//                 ),
//                 child: Icon(
//                   icon,
//                   color: (_hoverStates['option_$title'] ?? false)
//                       ? cardColor
//                       : color,
//                   size: isMobile ? 24 : 26,
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       title,
//                       style: TextStyle(
//                         fontSize: isMobile ? 18 : 20,
//                         fontWeight: FontWeight.w800,
//                         color: textPrimary,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       subtitle,
//                       style: TextStyle(
//                         fontSize: isMobile ? 14 : 15,
//                         color: textSecondary,
//                         fontWeight: FontWeight.w500,
//                       ),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   ],
//                 ),
//               ),
//               AnimatedContainer(
//                 duration: const Duration(milliseconds: 300),
//                 transform: Matrix4.translationValues(
//                   (_hoverStates['option_$title'] ?? false) ? 4 : 0,
//                   0,
//                   0,
//                 ),
//                 child: Icon(
//                   Icons.arrow_forward_ios_rounded,
//                   color: (_hoverStates['option_$title'] ?? false)
//                       ? color
//                       : borderColor,
//                   size: isMobile ? 18 : 20,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void _showActionCompleted(BuildContext context, String title, Color color) {
//     final overlay = Overlay.of(context);
//     final overlayEntry = OverlayEntry(
//       builder: (context) => Positioned(
//         top: 100,
//         left: MediaQuery.of(context).size.width / 2 - 100,
//         child: Material(
//           color: Colors.transparent,
//           child: Container(
//             width: 200,
//             padding: const EdgeInsets.all(20),
//             decoration: BoxDecoration(
//               color: cardColor,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: color.withOpacity(0.3),
//                   blurRadius: 20,
//                   offset: const Offset(0, 10),
//                 ),
//               ],
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   width: 60,
//                   height: 60,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     gradient: LinearGradient(
//                       colors: [color, Color.lerp(color, Colors.white, 0.3)!],
//                     ),
//                   ),
//                   child: Icon(Icons.check_rounded, color: cardColor, size: 32),
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   'Berhasil!',
//                   style: TextStyle(
//                     fontSize: 18,
//                     fontWeight: FontWeight.w800,
//                     color: textPrimary,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   '$title berhasil dilakukan',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(fontSize: 14, color: textSecondary),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );

//     overlay.insert(overlayEntry);
//     Future.delayed(const Duration(seconds: 2), () => overlayEntry.remove());
//   }

//   void _showProfileDetails(BuildContext context, bool isMobile) {
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         backgroundColor: Colors.transparent,
//         insetPadding: EdgeInsets.all(isMobile ? 20 : 40),
//         child: Stack(
//           children: [
//             Container(
//               padding: EdgeInsets.all(isMobile ? 24 : 32),
//               decoration: BoxDecoration(
//                 color: cardColor,
//                 borderRadius: BorderRadius.circular(32),
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [
//                     primaryColor.withOpacity(0.05),
//                     secondaryColor.withOpacity(0.05),
//                   ],
//                 ),
//               ),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Container(
//                     width: 120,
//                     height: 120,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       border: Border.all(color: primaryColor, width: 3),
//                       image: DecorationImage(
//                         image: AssetImage('assets/profil.jpg'),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                   Text(
//                     'Leonardo Dicaprio',
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.w800,
//                       color: textPrimary,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     'Fullstack Developer',
//                     style: TextStyle(
//                       fontSize: 16,
//                       color: secondaryColor,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                   _buildDetailItem(
//                     'Status',
//                     'Aktif',
//                     Icons.circle,
//                     successColor,
//                   ),
//                   _buildDetailItem(
//                     'Member Since',
//                     '2023',
//                     Icons.calendar_today,
//                     primaryColor,
//                   ),
//                   _buildDetailItem(
//                     'Terakhir Login',
//                     '2 jam lalu',
//                     Icons.access_time,
//                     accentColor,
//                   ),
//                   const SizedBox(height: 32),
//                   ElevatedButton(
//                     onPressed: () => Navigator.pop(context),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: primaryColor,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       padding: EdgeInsets.symmetric(
//                         horizontal: 40,
//                         vertical: 16,
//                       ),
//                     ),
//                     child: Text('Tutup', style: TextStyle(color: cardColor)),
//                   ),
//                 ],
//               ),
//             ),
//             Positioned(
//               top: 16,
//               right: 16,
//               child: IconButton(
//                 onPressed: () => Navigator.pop(context),
//                 icon: Icon(Icons.close_rounded, color: textSecondary),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailItem(
//     String label,
//     String value,
//     IconData icon,
//     Color color,
//   ) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         children: [
//           Container(
//             width: 40,
//             height: 40,
//             decoration: BoxDecoration(
//               shape: BoxShape.circle,
//               color: color.withOpacity(0.1),
//             ),
//             child: Icon(icon, color: color, size: 20),
//           ),
//           const SizedBox(width: 16),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   label,
//                   style: TextStyle(color: textSecondary, fontSize: 14),
//                 ),
//                 Text(
//                   value,
//                   style: TextStyle(
//                     color: textPrimary,
//                     fontSize: 16,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
