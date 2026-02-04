import 'package:flutter/material.dart';

class InfoTambahanScreen extends StatefulWidget {
  const InfoTambahanScreen({super.key});

  @override
  State<InfoTambahanScreen> createState() => _InfoTambahanScreenState();
}

class _InfoTambahanScreenState extends State<InfoTambahanScreen>
    with TickerProviderStateMixin {
  // Getter untuk warna
  Color get primaryColor => const Color(0xFF0D1B2A);
  Color get secondaryColor => const Color(0xFF1B3A5C);
  Color get accentColor => const Color(0xFFC9A227);
  Color get successColor => const Color(0xFF2A9D8F);
  Color get warningColor => const Color(0xFFE76F51);
  Color get infoColor => const Color(0xFF0EA5E9);
  Color get backgroundColor => const Color(0xFFF5F7FA);
  Color get cardColor => const Color(0xFFFFFFFF);
  Color get surfaceColor => const Color(0xFFF8FAFC);

  late AnimationController _animationController;
  late Animation<double> _animation;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  final List<String> _skills = [
    'Flutter & Dart',
    'React Native',
    'JavaScript',
    'Node.js',
    'UI/UX Design',
    'Database SQL',
    'Firebase',
    'Git & GitHub',
  ];

  final List<int> _skillLevels = [90, 85, 80, 75, 70, 85, 80, 95];
  List<double> _skillAnimations = List.generate(8, (index) => 0.0);

  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..forward();

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutQuart,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutSine),
    );

    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOutSine),
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
        );

    _slideController.forward();

    // Animate skill bars sequentially
    Future.delayed(const Duration(milliseconds: 300), () {
      for (int i = 0; i < _skills.length; i++) {
        Future.delayed(Duration(milliseconds: i * 100), () {
          if (mounted) {
            setState(() {
              _skillAnimations[i] = _skillLevels[i] / 100.0;
            });
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    _glowController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final horizontalPadding = isMobile ? 20.0 : 32.0;
    final expandedHeight = isMobile ? 180.0 : 220.0;

    return Scaffold(
      backgroundColor: backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: expandedHeight,
            collapsedHeight: kToolbarHeight + 20,
            floating: true,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                final double currentHeight = constraints.biggest.height;
                final double minHeight = kToolbarHeight;
                final double maxHeight = expandedHeight;

                double percentage = 0.0;
                if (maxHeight > minHeight) {
                  percentage =
                      ((currentHeight - minHeight) / (maxHeight - minHeight))
                          .clamp(0.0, 1.0);
                }

                final double opacity = percentage;

                return Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        primaryColor.withOpacity(opacity * 0.9),
                        primaryColor.withOpacity(opacity * 0.7),
                        Colors.transparent,
                      ],
                    ),
                  ),
                  child: FlexibleSpaceBar(
                    titlePadding: EdgeInsets.only(
                      left: isMobile ? 60.0 : 80.0,
                      bottom: 16.0,
                    ),
                    expandedTitleScale: 1.2,
                    title: AnimatedOpacity(
                      opacity: (1.0 - percentage).clamp(0.0, 1.0),
                      duration: Duration.zero,
                      child: Text(
                        'Info Tambahan',
                        style: TextStyle(
                          fontSize: isMobile ? 20 : 22,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.8,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            primaryColor.withOpacity(0.95),
                            secondaryColor.withOpacity(0.9),
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: horizontalPadding,
                          right: horizontalPadding,
                          top: kToolbarHeight + 40,
                          bottom: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FadeTransition(
                              opacity: _animation,
                              child: SlideTransition(
                                position:
                                    Tween<Offset>(
                                      begin: const Offset(-0.5, 0),
                                      end: Offset.zero,
                                    ).animate(
                                      CurvedAnimation(
                                        parent: _animationController,
                                        curve: const Interval(
                                          0.0,
                                          0.5,
                                          curve: Curves.easeOutCubic,
                                        ),
                                      ),
                                    ),
                                child: Row(
                                  children: [
                                    ScaleTransition(
                                      scale: _glowAnimation,
                                      child: Container(
                                        width: isMobile ? 60 : 70,
                                        height: isMobile ? 60 : 70,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: const LinearGradient(
                                            colors: [
                                              Colors.white,
                                              Color(0xFFE2E8F0),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.white.withOpacity(
                                                0.4,
                                              ),
                                              blurRadius: 20,
                                              spreadRadius: 2,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                          border: Border.all(
                                            color: accentColor.withOpacity(0.3),
                                            width: 2,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.insights_rounded,
                                          color: Color(0xFF0D1B2A),
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Profil Lengkap',
                                            style: TextStyle(
                                              fontSize: isMobile ? 14 : 16,
                                              color: Colors.white.withOpacity(
                                                0.9,
                                              ),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            'Informasi Tambahan',
                                            style: TextStyle(
                                              fontSize: isMobile ? 24 : 28,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            FadeTransition(
                              opacity: CurvedAnimation(
                                parent: _animationController,
                                curve: const Interval(0.3, 0.8),
                              ),
                              child: SlideTransition(
                                position:
                                    Tween<Offset>(
                                      begin: const Offset(0, 0.5),
                                      end: Offset.zero,
                                    ).animate(
                                      CurvedAnimation(
                                        parent: _animationController,
                                        curve: const Interval(
                                          0.3,
                                          0.8,
                                          curve: Curves.easeOutCubic,
                                        ),
                                      ),
                                    ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    _buildStatItem('Skill', '8', isMobile),
                                    _buildStatItem('Bahasa', '3', isMobile),
                                    _buildStatItem(
                                      'Sertifikasi',
                                      '5',
                                      isMobile,
                                    ),
                                    _buildStatItem('Hobi', '5', isMobile),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            leading: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Material(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(12),
                  splashColor: Colors.white.withOpacity(0.2),
                  highlightColor: Colors.white.withOpacity(0.1),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1.5,
                      ),
                    ),
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Material(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: () {
                      _showEditDialog(context, isMobile);
                    },
                    borderRadius: BorderRadius.circular(12),
                    splashColor: Colors.white.withOpacity(0.2),
                    highlightColor: Colors.white.withOpacity(0.1),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.edit_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Tab Navigation
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 12,
              ),
              child: _buildTabNavigation(isMobile),
            ),
          ),
          // Main Content (Flexible space based on tab)
          SliverFillRemaining(
            hasScrollBody: false,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: _buildSelectedTabContent(isMobile),
                    ),
                  ),
                  SizedBox(height: isMobile ? 80 : 60), // Space for FAB
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(context, isMobile),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // ... (semua fungsi lainnya TETAP SAMA dari sini ke bawah) ...

  Widget _buildSelectedTabContent(bool isMobile) {
    switch (_selectedTab) {
      case 0:
        return _buildSkillsSection(isMobile);
      case 1:
        return _buildLanguagesSection(isMobile);
      case 2:
        return _buildHobbiesSection(isMobile);
      case 3:
        return _buildCertificationsSection(isMobile);
      default:
        return _buildSkillsSection(isMobile);
    }
  }

  Widget _buildTabNavigation(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.03),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildTabItem(0, Icons.code_rounded, 'Skill', isMobile),
          _buildTabItem(1, Icons.language_rounded, 'Bahasa', isMobile),
          _buildTabItem(2, Icons.sports_esports_rounded, 'Hobi', isMobile),
          _buildTabItem(3, Icons.verified_rounded, 'Sertifikasi', isMobile),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, IconData icon, String label, bool isMobile) {
    final bool isSelected = _selectedTab == index;
    return Expanded(
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedTab = index;
            });
            _slideController.reset();
            _slideController.forward();
          },
          borderRadius: BorderRadius.circular(12),
          splashColor: isSelected ? accentColor.withOpacity(0.2) : null,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: isSelected
                  ? LinearGradient(
                      colors: [
                        primaryColor.withOpacity(0.9),
                        secondaryColor.withOpacity(0.9),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : null,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: isSelected ? Colors.white : const Color(0xFF64748B),
                  size: isMobile ? 18 : 20,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: isMobile ? 10 : 11,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String title, String value, bool isMobile) {
    return Column(
      children: [
        Container(
          width: isMobile ? 45 : 50,
          height: isMobile ? 45 : 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.2),
                Colors.white.withOpacity(0.1),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: Colors.white.withOpacity(0.3),
              width: 1.2,
            ),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontSize: isMobile ? 14 : 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(
            fontSize: isMobile ? 11 : 12,
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildSkillsSection(bool isMobile) {
    return SlideTransition(
      position: _slideAnimation,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.05),
                  blurRadius: 20,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(color: const Color(0xFFF1F5F9), width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              infoColor.withOpacity(0.15),
                              infoColor.withOpacity(0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Icon(
                          Icons.code_rounded,
                          color: infoColor,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Keahlian Teknis',
                              style: TextStyle(
                                fontSize: isMobile ? 16 : 18,
                                fontWeight: FontWeight.w800,
                                color: primaryColor,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${_skills.length} keahlian yang dikuasai',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                ...List.generate(
                  _skills.length,
                  (index) => _buildSkillItem(
                    _skills[index],
                    _skillLevels[index],
                    _skillAnimations[index],
                    isMobile,
                    index,
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          SizedBox(height: 20), // Extra spacing at bottom
        ],
      ),
    );
  }

  Widget _buildSkillItem(
    String skill,
    int level,
    double animation,
    bool isMobile,
    int index,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  skill,
                  style: TextStyle(
                    fontSize: isMobile ? 14 : 15,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E293B),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      infoColor.withOpacity(0.12),
                      infoColor.withOpacity(0.03),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: infoColor.withOpacity(0.15),
                    width: 1,
                  ),
                ),
                child: Text(
                  '$level%',
                  style: TextStyle(
                    fontSize: isMobile ? 13 : 14,
                    fontWeight: FontWeight.w700,
                    color: infoColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Stack(
            children: [
              Container(
                height: 5,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 800),
                curve: Curves.easeOutQuart,
                width: animation * (MediaQuery.of(context).size.width - 80),
                height: 5,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [infoColor, infoColor.withOpacity(0.7)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(2.5),
                  boxShadow: [
                    BoxShadow(
                      color: infoColor.withOpacity(0.3),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLanguagesSection(bool isMobile) {
    final List<Map<String, dynamic>> languages = [
      {
        'name': 'Bahasa Indonesia',
        'level': 'Aktif',
        'icon': Icons.flag_rounded,
      },
      {
        'name': 'Bahasa Inggris',
        'level': 'Menengah',
        'icon': Icons.language_rounded,
      },
      {
        'name': 'Bahasa Sunda',
        'level': 'Aktif',
        'icon': Icons.emoji_emotions_rounded,
      },
    ];

    return SlideTransition(
      position: _slideAnimation,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.05),
                  blurRadius: 20,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(color: const Color(0xFFF1F5F9), width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              accentColor.withOpacity(0.15),
                              accentColor.withOpacity(0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Icon(
                          Icons.language_rounded,
                          color: accentColor,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Kemampuan Bahasa',
                              style: TextStyle(
                                fontSize: isMobile ? 16 : 18,
                                fontWeight: FontWeight.w800,
                                color: primaryColor,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${languages.length} bahasa yang dikuasai',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                ...List.generate(
                  languages.length,
                  (index) => _buildLanguageItem(
                    languages[index]['name'] as String,
                    languages[index]['level'] as String,
                    languages[index]['icon'] as IconData,
                    isMobile,
                    index,
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          SizedBox(height: 20), // Extra spacing at bottom
        ],
      ),
    );
  }

  Widget _buildLanguageItem(
    String language,
    String level,
    IconData icon,
    bool isMobile,
    int index,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: () {
            _showLanguageDetail(context, language, level);
          },
          borderRadius: BorderRadius.circular(14),
          splashColor: accentColor.withOpacity(0.08),
          highlightColor: accentColor.withOpacity(0.04),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFF1F5F9), width: 1),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        accentColor.withOpacity(0.12),
                        accentColor.withOpacity(0.03),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Icon(icon, color: accentColor, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        language,
                        style: TextStyle(
                          fontSize: isMobile ? 14 : 15,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Level: $level',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: accentColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    level == 'Aktif' ? 'Native' : 'Intermediate',
                    style: TextStyle(
                      fontSize: 12,
                      color: accentColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHobbiesSection(bool isMobile) {
    final List<Map<String, dynamic>> hobbies = [
      {'name': 'Membaca Buku Teknologi', 'icon': Icons.menu_book_rounded},
      {'name': 'Olahraga (Futsal, Gym)', 'icon': Icons.sports_soccer_rounded},
      {'name': 'Fotografi Digital', 'icon': Icons.camera_alt_rounded},
      {'name': 'Bermain Musik (Gitar)', 'icon': Icons.music_note_rounded},
      {'name': 'Traveling & Wisata', 'icon': Icons.travel_explore_rounded},
    ];

    return SlideTransition(
      position: _slideAnimation,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.05),
                  blurRadius: 20,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(color: const Color(0xFFF1F5F9), width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              successColor.withOpacity(0.15),
                              successColor.withOpacity(0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Icon(
                          Icons.sports_esports_rounded,
                          color: successColor,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hobi & Minat',
                              style: TextStyle(
                                fontSize: isMobile ? 16 : 18,
                                fontWeight: FontWeight.w800,
                                color: primaryColor,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${hobbies.length} hobi yang diminati',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(
                      hobbies.length,
                      (index) => _buildHobbyChip(
                        hobbies[index]['name'] as String,
                        hobbies[index]['icon'] as IconData,
                        isMobile,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          SizedBox(height: 20), // Extra spacing at bottom
        ],
      ),
    );
  }

  Widget _buildHobbyChip(String hobby, IconData icon, bool isMobile) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: () {
          _showHobbyDetail(context, hobby);
        },
        borderRadius: BorderRadius.circular(16),
        splashColor: successColor.withOpacity(0.08),
        highlightColor: successColor.withOpacity(0.04),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: successColor.withOpacity(0.04),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: successColor.withOpacity(0.15), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: successColor),
              const SizedBox(width: 6),
              Text(
                hobby,
                style: TextStyle(
                  fontSize: isMobile ? 12 : 13,
                  color: const Color(0xFF1E293B),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCertificationsSection(bool isMobile) {
    final List<Map<String, String>> certifications = [
      {'name': 'Google Flutter Developer', 'year': '2023'},
      {'name': 'AWS Cloud Practitioner', 'year': '2022'},
      {'name': 'Scrum Master Certified', 'year': '2022'},
      {'name': 'React Native Masterclass', 'year': '2021'},
      {'name': 'UI/UX Design Fundamentals', 'year': '2021'},
    ];

    return SlideTransition(
      position: _slideAnimation,
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.05),
                  blurRadius: 20,
                  spreadRadius: 1,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(color: const Color(0xFFF1F5F9), width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              warningColor.withOpacity(0.15),
                              warningColor.withOpacity(0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Icon(
                          Icons.verified_rounded,
                          color: warningColor,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sertifikasi & Pelatihan',
                              style: TextStyle(
                                fontSize: isMobile ? 16 : 18,
                                fontWeight: FontWeight.w800,
                                color: primaryColor,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${certifications.length} sertifikasi diperoleh',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                ...List.generate(
                  certifications.length,
                  (index) => _buildCertificationItem(
                    certifications[index]['name']!,
                    certifications[index]['year']!,
                    isMobile,
                    index,
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
          SizedBox(height: 20), // Extra spacing at bottom
        ],
      ),
    );
  }

  Widget _buildCertificationItem(
    String title,
    String year,
    bool isMobile,
    int index,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: () {
            _showCertificationDetail(context, title, year);
          },
          borderRadius: BorderRadius.circular(14),
          splashColor: warningColor.withOpacity(0.08),
          highlightColor: warningColor.withOpacity(0.04),
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFF1F5F9), width: 1),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        warningColor.withOpacity(0.12),
                        warningColor.withOpacity(0.03),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Icon(
                    Icons.verified_rounded,
                    color: warningColor,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: isMobile ? 14 : 15,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_rounded,
                            size: 14,
                            color: warningColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Tahun: $year',
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: warningColor.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'Verified',
                    style: TextStyle(
                      fontSize: 11,
                      color: warningColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context, bool isMobile) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ScaleTransition(
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
              _showAddOptions(context, isMobile);
            },
            backgroundColor: primaryColor,
            elevation: 4,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, bool isMobile) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(20),
          child: Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(0.15),
                  blurRadius: 30,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              accentColor.withOpacity(0.15),
                              accentColor.withOpacity(0.05),
                            ],
                          ),
                        ),
                        child: Icon(
                          Icons.edit_rounded,
                          color: accentColor,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Edit Profil',
                              style: TextStyle(
                                fontSize: isMobile ? 18 : 20,
                                fontWeight: FontWeight.w800,
                                color: primaryColor,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Ubah informasi tambahan profil',
                              style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                ..._buildEditOptions(context, isMobile),
                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildEditOptions(BuildContext context, bool isMobile) {
    final List<Map<String, dynamic>> options = [
      {'icon': Icons.code_rounded, 'title': 'Edit Skill', 'color': infoColor},
      {
        'icon': Icons.language_rounded,
        'title': 'Edit Bahasa',
        'color': accentColor,
      },
      {
        'icon': Icons.sports_esports_rounded,
        'title': 'Edit Hobi',
        'color': successColor,
      },
      {
        'icon': Icons.verified_rounded,
        'title': 'Edit Sertifikasi',
        'color': warningColor,
      },
    ];

    return options.map((option) {
      final Color color = option['color'] as Color;
      final IconData icon = option['icon'] as IconData;
      final String title = option['title'] as String;

      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
            _showSuccessSnackbar(context, '$title dibuka', color);
          },
          splashColor: color.withOpacity(0.08),
          highlightColor: color.withOpacity(0.04),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        color.withOpacity(0.12),
                        color.withOpacity(0.03),
                      ],
                    ),
                  ),
                  child: Icon(icon, color: color, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: 16, color: color),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  void _showAddOptions(BuildContext context, bool isMobile) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          margin: const EdgeInsets.only(top: 40),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withOpacity(0.15),
                blurRadius: 30,
                spreadRadius: 3,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 6),
                width: 36,
                height: 3,
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(1.5),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Tambah Informasi',
                  style: TextStyle(
                    fontSize: isMobile ? 18 : 20,
                    fontWeight: FontWeight.w800,
                    color: primaryColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              ..._buildBottomSheetOptions(context, isMobile),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildBottomSheetOptions(BuildContext context, bool isMobile) {
    final List<Map<String, dynamic>> options = [
      {
        'icon': Icons.code_rounded,
        'title': 'Tambah Skill Baru',
        'subtitle': 'Tambahkan keahlian teknis baru',
        'color': infoColor,
      },
      {
        'icon': Icons.language_rounded,
        'title': 'Tambah Bahasa',
        'subtitle': 'Tambahkan kemampuan bahasa',
        'color': accentColor,
      },
      {
        'icon': Icons.verified_rounded,
        'title': 'Tambah Sertifikasi',
        'subtitle': 'Tambahkan sertifikasi baru',
        'color': warningColor,
      },
      {
        'icon': Icons.share_rounded,
        'title': 'Bagikan Profil',
        'subtitle': 'Bagikan profil lengkap Anda',
        'color': successColor,
      },
    ];

    return options.map((option) {
      final Color color = option['color'] as Color;
      final IconData icon = option['icon'] as IconData;
      final String title = option['title'] as String;
      final String subtitle = option['subtitle'] as String;

      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
            _showSuccessSnackbar(context, '$title berhasil', color);
          },
          splashColor: color.withOpacity(0.08),
          highlightColor: color.withOpacity(0.04),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        color.withOpacity(0.12),
                        color.withOpacity(0.03),
                      ],
                    ),
                  ),
                  child: Icon(icon, color: color, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios_rounded, size: 16, color: color),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  void _showLanguageDetail(
    BuildContext context,
    String language,
    String level,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      accentColor.withOpacity(0.15),
                      accentColor.withOpacity(0.05),
                    ],
                  ),
                ),
                child: Icon(
                  Icons.language_rounded,
                  color: accentColor,
                  size: 28,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                language,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Level: $level',
                style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  void _showHobbyDetail(BuildContext context, String hobby) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      successColor.withOpacity(0.15),
                      successColor.withOpacity(0.05),
                    ],
                  ),
                ),
                child: Icon(
                  Icons.sports_esports_rounded,
                  color: successColor,
                  size: 28,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                hobby,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  void _showCertificationDetail(
    BuildContext context,
    String title,
    String year,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      warningColor.withOpacity(0.15),
                      warningColor.withOpacity(0.05),
                    ],
                  ),
                ),
                child: Icon(
                  Icons.verified_rounded,
                  color: warningColor,
                  size: 28,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 16,
                    color: warningColor,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Tahun: $year',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessSnackbar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        duration: const Duration(milliseconds: 1500),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 6,
      ),
    );
  }
}
