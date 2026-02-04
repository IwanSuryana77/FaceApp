import 'package:flutter/material.dart';

class BerikanFeedbackPage extends StatefulWidget {
  const BerikanFeedbackPage({super.key});

  @override
  State<BerikanFeedbackPage> createState() => _BerikanFeedbackPageState();
}

class _BerikanFeedbackPageState extends State<BerikanFeedbackPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _judulController = TextEditingController();
  final _deskripsiController = TextEditingController();

  String _selectedKategori = "Saran";
  int _rating = 5;
  bool _isSubmitting = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  final List<String> _kategoriList = [
    "Saran",
    "Bug/Laporan Masalah",
    "Fitur Baru",
    "Kritik",
    "Pertanyaan",
    "Pujian",
  ];

  final Map<String, IconData> _kategoriIcons = {
    "Saran": Icons.lightbulb_rounded,
    "Bug/Laporan Masalah": Icons.bug_report_rounded,
    "Fitur Baru": Icons.add_circle_rounded,
    "Kritik": Icons.construction_rounded,
    "Pertanyaan": Icons.help_rounded,
    "Pujian": Icons.thumb_up_rounded,
  };

  final Map<String, List<Color>> _kategoriColors = {
    "Saran": [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
    "Bug/Laporan Masalah": [Color(0xFFEF4444), Color(0xFFDC2626)],
    "Fitur Baru": [Color(0xFF10B981), Color(0xFF059669)],
    "Kritik": [Color(0xFFF59E0B), Color(0xFFD97706)],
    "Pertanyaan": [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
    "Pujian": [Color(0xFFEC4899), Color(0xFFDB2777)],
  };

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
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
    _namaController.dispose();
    _emailController.dispose();
    _judulController.dispose();
    _deskripsiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
    final isVerySmallScreen = screenWidth < 320;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Header Gradient Area
            SliverToBoxAdapter(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  left: isSmallScreen ? 14 : 20,
                  right: isSmallScreen ? 14 : 20,
                  top: MediaQuery.of(context).padding.top + 24,
                  bottom: 24,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    // Pattern overlay (optional, hapus jika tidak punya asset-nya)
                    Positioned.fill(
                      child: Opacity(
                        opacity: 0.08,
                        // ...existing code...
                      ),
                    ),
                    // Content
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Icon & Share button
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.arrow_back_ios_new_rounded,
                                color: Colors.white,
                              ),
                              onPressed: () => Navigator.of(context).maybePop(),
                            ),
                            Spacer(),
                            IconButton(
                              icon: Icon(
                                Icons.share_outlined,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                // TODO: share, jika mau
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 6),
                        Text(
                          "Feedback & Saran",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isSmallScreen ? 22 : 26,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.2,
                            shadows: [
                              Shadow(
                                blurRadius: 8,
                                color: Colors.black.withOpacity(0.12),
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                          'Bantu kami meningkatkan aplikasi dengan feedback Anda',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.92),
                            fontSize: isSmallScreen ? 12.5 : 15,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Spacer agar card intro "Mengambang"
            SliverToBoxAdapter(child: SizedBox(height: 12)),

            // Card Intro
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 14 : 20,
                ),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(isSmallScreen ? 16 : 22),
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF8B5CF6).withOpacity(0.10),
                        blurRadius: 16,
                        spreadRadius: 1,
                        offset: const Offset(0, 8),
                      ),
                    ],
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: isSmallScreen ? 46 : 54,
                        height: isSmallScreen ? 46 : 54,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF8B5CF6).withOpacity(0.14),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.reviews_rounded,
                            size: isSmallScreen ? 28 : 32,
                            color: Color(0xFF8B5CF6),
                          ),
                        ),
                      ),
                      SizedBox(width: isSmallScreen ? 12 : 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bagikan Pengalaman Anda',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 16 : 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            SizedBox(height: 7),
                            Text(
                              'Setiap feedback membantu kami membuat aplikasi yang lebih baik untuk Anda',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 12 : 14,
                                color: Colors.grey.shade600,
                                height: 1.55,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // FORM SECTION
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 12 : 20,
                  vertical: 4,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // -- ADD FORM & RATING UI disini, TIDAK DIUBAH (copy dari kode asli Anda) --
                      _buildSectionHeader(
                        icon: Icons.star_rate_rounded,
                        title: 'Rating Aplikasi',
                        subtitle: 'Beri penilaian untuk pengalaman Anda',
                      ),
                      const SizedBox(height: 12),
                      _buildEnhancedRatingSection(
                        isVerySmallScreen,
                        isSmallScreen,
                      ),
                      const SizedBox(height: 24),

                      _buildSectionHeader(
                        icon: Icons.category_rounded,
                        title: 'Kategori Feedback',
                        subtitle:
                            'Pilih jenis feedback yang ingin Anda berikan',
                      ),
                      const SizedBox(height: 12),
                      _buildEnhancedCategorySection(isSmallScreen),
                      const SizedBox(height: 24),

                      _buildSectionHeader(
                        icon: Icons.description_rounded,
                        title: 'Detail Feedback',
                        subtitle: 'Isi informasi lengkap tentang feedback Anda',
                      ),
                      const SizedBox(height: 16),

                      // Nama Field
                      _buildTextFieldCard(
                        controller: _namaController,
                        label: "Nama Lengkap",
                        hint: "Masukkan nama Anda",
                        icon: Icons.person_rounded,
                        isSmallScreen: isSmallScreen,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Nama harus diisi";
                          }
                          return null;
                        },
                      ),

                      // Email Field
                      _buildTextFieldCard(
                        controller: _emailController,
                        label: "Email (opsional)",
                        hint: "email@example.com",
                        icon: Icons.email_rounded,
                        isSmallScreen: isSmallScreen,
                        keyboardType: TextInputType.emailAddress,
                      ),

                      // Judul Field
                      _buildTextFieldCard(
                        controller: _judulController,
                        label: "Judul Feedback",
                        hint: "Contoh: Saran untuk fitur absensi",
                        icon: Icons.title_rounded,
                        isSmallScreen: isSmallScreen,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Judul harus diisi";
                          }
                          return null;
                        },
                      ),

                      // Deskripsi Field
                      _buildTextFieldCard(
                        controller: _deskripsiController,
                        label: "Deskripsi Lengkap",
                        hint: "Ceritakan pengalaman Anda secara detail...",
                        icon: Icons.description_rounded,
                        isSmallScreen: isSmallScreen,
                        maxLines: 6,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Deskripsi harus diisi";
                          }
                          if (value.length < 20) {
                            return "Deskripsi minimal 20 karakter";
                          }
                          return null;
                        },
                      ),

                      // Submit Button
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF8B5CF6).withOpacity(0.19),
                              blurRadius: 14,
                              spreadRadius: 2,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _submitFeedback,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF8B5CF6),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              vertical: isSmallScreen ? 16 : 18,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                            shadowColor: Colors.transparent,
                          ),
                          child: _isSubmitting
                              ? SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    color: Colors.white,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.send_rounded,
                                      size: isSmallScreen ? 20 : 22,
                                    ),
                                    SizedBox(width: isSmallScreen ? 8 : 10),
                                    Text(
                                      'Kirim Feedback',
                                      style: TextStyle(
                                        fontSize: isSmallScreen ? 15 : 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Info Card
                      Container(
                        padding: EdgeInsets.all(isSmallScreen ? 15 : 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.08),
                              blurRadius: 13,
                              spreadRadius: 1,
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
                                    color: const Color(
                                      0xFF10B981,
                                    ).withOpacity(0.13),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    Icons.info_rounded,
                                    size: isSmallScreen ? 18 : 20,
                                    color: const Color(0xFF10B981),
                                  ),
                                ),
                                SizedBox(width: isSmallScreen ? 8 : 12),
                                Expanded(
                                  child: Text(
                                    'Feedback akan ditinjau oleh tim kami',
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 14 : 16,
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF1E293B),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '• Tim kami akan membaca setiap feedback yang masuk\n'
                              '• Feedback yang membangun akan diprioritaskan\n'
                              '• Update akan diumumkan melalui notifikasi\n'
                              '• Terima kasih atas kontribusi Anda!',
                              style: TextStyle(
                                fontSize: isSmallScreen ? 12 : 14,
                                color: Colors.grey.shade700,
                                height: 1.6,
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
          ],
        ),
      ),
    );
  }

  // Helper Modern Textfield
  Widget _buildTextFieldCard({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool isSmallScreen,
    int maxLines = 1,
    String? Function(String?)? validator,
    TextInputType? keyboardType,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.10),
            blurRadius: 7,
            spreadRadius: 1,
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            child: Icon(
              icon,
              size: isSmallScreen ? 20 : 24,
              color: const Color(0xFF8B5CF6),
            ),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(
            vertical: isSmallScreen ? 14 : 18,
            horizontal: 16,
          ),
        ),
        style: TextStyle(
          fontSize: isSmallScreen ? 14 : 15,
          color: const Color(0xFF1E293B),
        ),
        validator: validator,
        keyboardType: keyboardType,
      ),
    );
  }

  // Copy section header, star rating, dsb, dari kode Anda
  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;
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
                  color: const Color(0xFF8B5CF6).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  size: isSmallScreen ? 20 : 24,
                  color: const Color(0xFF8B5CF6),
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
            padding: EdgeInsets.only(
              left: isSmallScreen ? 34 : 44,
              right: isSmallScreen ? 8 : 0,
            ),
            child: Text(
              subtitle,
              style: TextStyle(
                fontSize: isSmallScreen ? 12 : 14,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedRatingSection(
    bool isVerySmallScreen,
    bool isSmallScreen,
  ) {
    final starSize = isVerySmallScreen ? 32.0 : (isSmallScreen ? 38.0 : 44.0);
    final starSpacing = isVerySmallScreen ? 2.0 : (isSmallScreen ? 4.0 : 6.0);

    return Container(
      width: double.infinity,
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
            color: Colors.grey.withOpacity(0.09),
            blurRadius: 13,
            spreadRadius: 1,
          ),
        ],
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Column(
        children: [
          // Rating stars dengan overflow handling
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: List.generate(5, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                  child: Container(
                    width: starSize + 8,
                    margin: EdgeInsets.symmetric(horizontal: starSpacing),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Background glow for selected star
                        if (index < _rating)
                          Icon(
                            Icons.star_rounded,
                            size: starSize + 4,
                            color: Colors.amber.withOpacity(0.15),
                          ),
                        Icon(
                          index < _rating
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          size: starSize,
                          color: index < _rating
                              ? Colors.amber
                              : Colors.grey.shade400,
                        ),
                        // Shine effect
                        if (index < _rating)
                          Positioned(
                            top: starSize * 0.15,
                            left: starSize * 0.15,
                            child: Icon(
                              Icons.star_rounded,
                              size: starSize * 0.6,
                              color: Colors.amber.withOpacity(0.25),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 14 : 20,
              vertical: isSmallScreen ? 8 : 10,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: _getRatingGradient(_rating)),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: _getRatingColor(_rating).withOpacity(0.19),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getRatingIcon(_rating),
                  color: Colors.white,
                  size: isSmallScreen ? 16 : 18,
                ),
                SizedBox(width: isSmallScreen ? 6 : 8),
                Text(
                  _getRatingText(_rating),
                  style: TextStyle(
                    fontSize: isSmallScreen ? 13 : 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Beri nilai ${_rating}/5',
            style: TextStyle(
              fontSize: isSmallScreen ? 12 : 13,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  List<Color> _getRatingGradient(int rating) {
    switch (rating) {
      case 1:
        return [Color(0xFFEF4444), Color(0xFFDC2626)];
      case 2:
        return [Color(0xFFF59E0B), Color(0xFFD97706)];
      case 3:
        return [Color(0xFF10B981), Color(0xFF059669)];
      case 4:
        return [Color(0xFF3B82F6), Color(0xFF1D4ED8)];
      case 5:
        return [Color(0xFF8B5CF6), Color(0xFF7C3AED)];
      default:
        return [Color(0xFF8B5CF6), Color(0xFF7C3AED)];
    }
  }

  Color _getRatingColor(int rating) {
    switch (rating) {
      case 1:
        return Color(0xFFEF4444);
      case 2:
        return Color(0xFFF59E0B);
      case 3:
        return Color(0xFF10B981);
      case 4:
        return Color(0xFF3B82F6);
      case 5:
        return Color(0xFF8B5CF6);
      default:
        return Color(0xFF8B5CF6);
    }
  }

  IconData _getRatingIcon(int rating) {
    switch (rating) {
      case 1:
        return Icons.sentiment_very_dissatisfied_rounded;
      case 2:
        return Icons.sentiment_dissatisfied_rounded;
      case 3:
        return Icons.sentiment_neutral_rounded;
      case 4:
        return Icons.sentiment_satisfied_rounded;
      case 5:
        return Icons.sentiment_very_satisfied_rounded;
      default:
        return Icons.sentiment_very_satisfied_rounded;
    }
  }

  String _getRatingText(int rating) {
    switch (rating) {
      case 1:
        return "Sangat Tidak Puas";
      case 2:
        return "Tidak Puas";
      case 3:
        return "Cukup Puas";
      case 4:
        return "Puas";
      case 5:
        return "Sangat Puas";
      default:
        return "Sangat Puas";
    }
  }

  Widget _buildEnhancedCategorySection(bool isSmallScreen) {
    return Container(
      width: double.infinity,
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
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 13,
            spreadRadius: 1,
          ),
        ],
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Wrap(
        spacing: isSmallScreen ? 8 : 12,
        runSpacing: isSmallScreen ? 8 : 12,
        children: _kategoriList.map((kategori) {
          final isSelected = _selectedKategori == kategori;
          final colors = _kategoriColors[kategori]!;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedKategori = kategori;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 14 : 18,
                vertical: isSmallScreen ? 10 : 12,
              ),
              decoration: BoxDecoration(
                gradient: isSelected
                    ? LinearGradient(
                        colors: colors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isSelected ? null : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected ? colors[0] : Colors.grey.shade300,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: colors[0].withOpacity(0.18),
                          blurRadius: 7,
                          spreadRadius: 1,
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 2,
                          offset: Offset(0, 1),
                        ),
                      ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _kategoriIcons[kategori],
                    size: isSmallScreen ? 18 : 20,
                    color: isSelected ? Colors.white : colors[0],
                  ),
                  SizedBox(width: isSmallScreen ? 6 : 9),
                  Text(
                    kategori,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 13 : 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : colors[0],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  void _submitFeedback() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      // Simulasi pengiriman feedback
      await Future.delayed(const Duration(milliseconds: 1500));

      // Tampilkan dialog sukses
      _showSuccessDialog(context);

      // Reset form
      _formKey.currentState!.reset();
      _namaController.clear();
      _emailController.clear();
      _judulController.clear();
      _deskripsiController.clear();
      setState(() {
        _rating = 5;
        _selectedKategori = "Saran";
        _isSubmitting = false;
      });
    }
  }

  void _showSuccessDialog(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 360;

    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(isSmallScreen ? 20 : 40),
        child: Container(
          padding: EdgeInsets.all(isSmallScreen ? 20 : 30),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
            ),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF8B5CF6).withOpacity(0.28),
                blurRadius: 28,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.21),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  size: isSmallScreen ? 46 : 60,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: isSmallScreen ? 16 : 20),
              Text(
                'Terima Kasih!',
                style: TextStyle(
                  fontSize: isSmallScreen ? 22 : 27,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 3,
                      color: Colors.black.withOpacity(0.15),
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
              ),
              SizedBox(height: isSmallScreen ? 8 : 10),
              Text(
                'Feedback Anda berhasil dikirim',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 16,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: isSmallScreen ? 4 : 8),
              Text(
                'Kami akan meninjau feedback Anda dan berusaha meningkatkan aplikasi',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: isSmallScreen ? 12 : 14,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              SizedBox(height: isSmallScreen ? 13 : 18),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Color(0xFF8B5CF6),
                    padding: EdgeInsets.symmetric(
                      vertical: isSmallScreen ? 13.5 : 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    'Kembali',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 15 : 16,
                      fontWeight: FontWeight.bold,
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
}

// import 'package:flutter/material.dart';

// class BerikanFeedbackPage extends StatefulWidget {
//   const BerikanFeedbackPage({super.key});

//   @override
//   State<BerikanFeedbackPage> createState() => _BerikanFeedbackPageState();
// }

// class _BerikanFeedbackPageState extends State<BerikanFeedbackPage>
//     with SingleTickerProviderStateMixin {
//   final _formKey = GlobalKey<FormState>();
//   final _namaController = TextEditingController();
//   final _emailController = TextEditingController();
//   final _judulController = TextEditingController();
//   final _deskripsiController = TextEditingController();

//   String _selectedKategori = "Saran";
//   int _rating = 5;
//   bool _isSubmitting = false;
//   late AnimationController _animationController;
//   late Animation<double> _scaleAnimation;

//   final List<String> _kategoriList = [
//     "Saran",
//     "Bug/Laporan Masalah",
//     "Fitur Baru",
//     "Kritik",
//     "Pertanyaan",
//     "Pujian",
//   ];

//   final Map<String, IconData> _kategoriIcons = {
//     "Saran": Icons.lightbulb_rounded,
//     "Bug/Laporan Masalah": Icons.bug_report_rounded,
//     "Fitur Baru": Icons.add_circle_rounded,
//     "Kritik": Icons.construction_rounded,
//     "Pertanyaan": Icons.help_rounded,
//     "Pujian": Icons.thumb_up_rounded,
//   };

//   final Map<String, List<Color>> _kategoriColors = {
//     "Saran": [const Color(0xFF3B82F6), const Color(0xFF1D4ED8)],
//     "Bug/Laporan Masalah": [const Color(0xFFEF4444), const Color(0xFFDC2626)],
//     "Fitur Baru": [const Color(0xFF10B981), const Color(0xFF059669)],
//     "Kritik": [const Color(0xFFF59E0B), const Color(0xFFD97706)],
//     "Pertanyaan": [const Color(0xFF8B5CF6), const Color(0xFF7C3AED)],
//     "Pujian": [const Color(0xFFEC4899), const Color(0xFFDB2777)],
//   };

//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       duration: const Duration(milliseconds: 600),
//       vsync: this,
//     );
//     _scaleAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
//       CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
//     );
//     _animationController.forward();
//   }

//   @override
//   void dispose() {
//     _animationController.dispose();
//     _namaController.dispose();
//     _emailController.dispose();
//     _judulController.dispose();
//     _deskripsiController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isSmallScreen = screenWidth < 360;
//     final isVerySmallScreen = screenWidth < 320;

//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC),
//       body: AnimatedBuilder(
//         animation: _scaleAnimation,
//         builder: (context, child) {
//           return Transform.scale(scale: _scaleAnimation.value, child: child);
//         },
//         child: CustomScrollView(
//           physics: const BouncingScrollPhysics(),
//           slivers: [
//             // AppBar dengan efek gradient
//             SliverAppBar(
//               expandedHeight: 200,
//               floating: false,
//               pinned: true,
//               flexibleSpace: FlexibleSpaceBar(
//                 title: Text(
//                   'Feedback & Saran',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: isSmallScreen ? 20 : 22,
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
//                         const Color(0xFF8B5CF6),
//                         const Color(0xFF7C3AED),
//                       ],
//                     ),
//                   ),
//                   child: Stack(
//                     children: [
//                       // Pattern overlay
//                       Positioned.fill(
//                         child: Opacity(
//                           opacity: 0.1,
//                           child: Container(
//                             decoration: const BoxDecoration(
//                               image: DecorationImage(
//                                 image: AssetImage('assets/images/pattern.png'),
//                                 repeat: ImageRepeat.repeat,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                       // Content
//                       Padding(
//                         padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Icon(
//                               Icons.feedback_rounded,
//                               size: isSmallScreen ? 36 : 40,
//                               color: Colors.white,
//                             ),
//                             const SizedBox(height: 10),
//                             Text(
//                               'Bantu kami meningkatkan aplikasi dengan feedback Anda',
//                               style: TextStyle(
//                                 color: Colors.white.withOpacity(0.9),
//                                 fontSize: isSmallScreen ? 13 : 14,
//                               ),
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
//                   horizontal: isSmallScreen ? 12 : 20,
//                   vertical: 16,
//                 ),
//                 child: Form(
//                   key: _formKey,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       // Header Card
//                       Container(
//                         width: double.infinity,
//                         padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
//                         margin: const EdgeInsets.only(bottom: 20),
//                         decoration: BoxDecoration(
//                           gradient: const LinearGradient(
//                             begin: Alignment.topLeft,
//                             end: Alignment.bottomRight,
//                             colors: [Colors.white, Color(0xFFF5F3FF)],
//                           ),
//                           borderRadius: BorderRadius.circular(20),
//                           boxShadow: [
//                             BoxShadow(
//                               color: const Color(0xFF8B5CF6).withOpacity(0.1),
//                               blurRadius: 20,
//                               spreadRadius: 2,
//                               offset: const Offset(0, 6),
//                             ),
//                           ],
//                           border: Border.all(color: Colors.white, width: 2),
//                         ),
//                         child: Row(
//                           children: [
//                             Container(
//                               width: isSmallScreen ? 48 : 60,
//                               height: isSmallScreen ? 48 : 60,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 gradient: LinearGradient(
//                                   colors: [
//                                     const Color(0xFF8B5CF6).withOpacity(0.1),
//                                     const Color(0xFF7C3AED).withOpacity(0.1),
//                                   ],
//                                 ),
//                               ),
//                               child: Center(
//                                 child: Icon(
//                                   Icons.reviews_rounded,
//                                   size: isSmallScreen ? 24 : 30,
//                                   color: const Color(0xFF8B5CF6),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: isSmallScreen ? 12 : 20),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     'Bagikan Pengalaman Anda',
//                                     style: TextStyle(
//                                       fontSize: isSmallScreen ? 16 : 18,
//                                       fontWeight: FontWeight.bold,
//                                       color: const Color(0xFF1E293B),
//                                     ),
//                                   ),
//                                   const SizedBox(height: 6),
//                                   Text(
//                                     'Setiap feedback membantu kami membuat aplikasi yang lebih baik untuk Anda',
//                                     style: TextStyle(
//                                       fontSize: isSmallScreen ? 12 : 14,
//                                       color: Colors.grey.shade600,
//                                       height: 1.4,
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

//                       // Rating Section
//                       _buildSectionHeader(
//                         icon: Icons.star_rate_rounded,
//                         title: 'Rating Aplikasi',
//                         subtitle: 'Beri penilaian untuk pengalaman Anda',
//                       ),
//                       const SizedBox(height: 12),
//                       _buildEnhancedRatingSection(
//                         isVerySmallScreen,
//                         isSmallScreen,
//                       ),
//                       const SizedBox(height: 24),

//                       // Kategori Section
//                       _buildSectionHeader(
//                         icon: Icons.category_rounded,
//                         title: 'Kategori Feedback',
//                         subtitle:
//                             'Pilih jenis feedback yang ingin Anda berikan',
//                       ),
//                       const SizedBox(height: 12),
//                       _buildEnhancedCategorySection(isSmallScreen),
//                       const SizedBox(height: 24),

//                       // Form Section
//                       _buildSectionHeader(
//                         icon: Icons.description_rounded,
//                         title: 'Detail Feedback',
//                         subtitle: 'Isi informasi lengkap tentang feedback Anda',
//                       ),
//                       const SizedBox(height: 16),

//                       // Nama Field
//                       Container(
//                         margin: const EdgeInsets.only(bottom: 16),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(16),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.withOpacity(0.1),
//                               blurRadius: 8,
//                               spreadRadius: 1,
//                             ),
//                           ],
//                         ),
//                         child: TextFormField(
//                           controller: _namaController,
//                           decoration: InputDecoration(
//                             labelText: "Nama Lengkap",
//                             hintText: "Masukkan nama Anda",
//                             prefixIcon: Container(
//                               margin: const EdgeInsets.all(12),
//                               child: Icon(
//                                 Icons.person_rounded,
//                                 size: isSmallScreen ? 20 : 24,
//                                 color: const Color(0xFF8B5CF6),
//                               ),
//                             ),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(16),
//                               borderSide: BorderSide.none,
//                             ),
//                             filled: true,
//                             fillColor: Colors.white,
//                             contentPadding: EdgeInsets.symmetric(
//                               vertical: isSmallScreen ? 14 : 18,
//                               horizontal: 16,
//                             ),
//                           ),
//                           style: TextStyle(
//                             fontSize: isSmallScreen ? 14 : 15,
//                             color: const Color(0xFF1E293B),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return "Nama harus diisi";
//                             }
//                             return null;
//                           },
//                         ),
//                       ),

//                       // Email Field
//                       Container(
//                         margin: const EdgeInsets.only(bottom: 16),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(16),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.withOpacity(0.1),
//                               blurRadius: 8,
//                               spreadRadius: 1,
//                             ),
//                           ],
//                         ),
//                         child: TextFormField(
//                           controller: _emailController,
//                           decoration: InputDecoration(
//                             labelText: "Email (opsional)",
//                             hintText: "email@example.com",
//                             prefixIcon: Container(
//                               margin: const EdgeInsets.all(12),
//                               child: Icon(
//                                 Icons.email_rounded,
//                                 size: isSmallScreen ? 20 : 24,
//                                 color: const Color(0xFF8B5CF6),
//                               ),
//                             ),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(16),
//                               borderSide: BorderSide.none,
//                             ),
//                             filled: true,
//                             fillColor: Colors.white,
//                             contentPadding: EdgeInsets.symmetric(
//                               vertical: isSmallScreen ? 14 : 18,
//                               horizontal: 16,
//                             ),
//                           ),
//                           keyboardType: TextInputType.emailAddress,
//                           style: TextStyle(
//                             fontSize: isSmallScreen ? 14 : 15,
//                             color: const Color(0xFF1E293B),
//                           ),
//                         ),
//                       ),

//                       // Judul Field
//                       Container(
//                         margin: const EdgeInsets.only(bottom: 16),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(16),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.withOpacity(0.1),
//                               blurRadius: 8,
//                               spreadRadius: 1,
//                             ),
//                           ],
//                         ),
//                         child: TextFormField(
//                           controller: _judulController,
//                           decoration: InputDecoration(
//                             labelText: "Judul Feedback",
//                             hintText: "Contoh: Saran untuk fitur absensi",
//                             prefixIcon: Container(
//                               margin: const EdgeInsets.all(12),
//                               child: Icon(
//                                 Icons.title_rounded,
//                                 size: isSmallScreen ? 20 : 24,
//                                 color: const Color(0xFF8B5CF6),
//                               ),
//                             ),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(16),
//                               borderSide: BorderSide.none,
//                             ),
//                             filled: true,
//                             fillColor: Colors.white,
//                             contentPadding: EdgeInsets.symmetric(
//                               vertical: isSmallScreen ? 14 : 18,
//                               horizontal: 16,
//                             ),
//                           ),
//                           style: TextStyle(
//                             fontSize: isSmallScreen ? 14 : 15,
//                             color: const Color(0xFF1E293B),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return "Judul harus diisi";
//                             }
//                             return null;
//                           },
//                         ),
//                       ),

//                       // Deskripsi Field
//                       Container(
//                         margin: const EdgeInsets.only(bottom: 24),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(16),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.withOpacity(0.1),
//                               blurRadius: 8,
//                               spreadRadius: 1,
//                             ),
//                           ],
//                         ),
//                         child: TextFormField(
//                           controller: _deskripsiController,
//                           maxLines: 6,
//                           decoration: InputDecoration(
//                             labelText: "Deskripsi Lengkap",
//                             hintText:
//                                 "Ceritakan pengalaman Anda secara detail...",
//                             alignLabelWithHint: true,
//                             prefixIcon: Container(
//                               margin: EdgeInsets.only(
//                                 top: 12,
//                                 left: 12,
//                                 bottom: isSmallScreen ? 40 : 0,
//                               ),
//                               child: Icon(
//                                 Icons.description_rounded,
//                                 size: isSmallScreen ? 20 : 24,
//                                 color: const Color(0xFF8B5CF6),
//                               ),
//                             ),
//                             border: OutlineInputBorder(
//                               borderRadius: BorderRadius.circular(16),
//                               borderSide: BorderSide.none,
//                             ),
//                             filled: true,
//                             fillColor: Colors.white,
//                             contentPadding: EdgeInsets.symmetric(
//                               vertical: isSmallScreen ? 16 : 20,
//                               horizontal: 16,
//                             ),
//                           ),
//                           style: TextStyle(
//                             fontSize: isSmallScreen ? 14 : 15,
//                             color: const Color(0xFF1E293B),
//                           ),
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return "Deskripsi harus diisi";
//                             }
//                             if (value.length < 20) {
//                               return "Deskripsi minimal 20 karakter";
//                             }
//                             return null;
//                           },
//                         ),
//                       ),

//                       // Submit Button
//                       Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(16),
//                           boxShadow: [
//                             BoxShadow(
//                               color: const Color(0xFF8B5CF6).withOpacity(0.2),
//                               blurRadius: 15,
//                               spreadRadius: 2,
//                               offset: const Offset(0, 6),
//                             ),
//                           ],
//                         ),
//                         child: ElevatedButton(
//                           onPressed: _isSubmitting ? null : _submitFeedback,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: const Color(0xFF8B5CF6),
//                             foregroundColor: Colors.white,
//                             padding: EdgeInsets.symmetric(
//                               vertical: isSmallScreen ? 16 : 20,
//                             ),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(16),
//                             ),
//                             elevation: 0,
//                             shadowColor: Colors.transparent,
//                           ),
//                           child: _isSubmitting
//                               ? SizedBox(
//                                   width: 24,
//                                   height: 24,
//                                   child: CircularProgressIndicator(
//                                     strokeWidth: 3,
//                                     color: Colors.white,
//                                   ),
//                                 )
//                               : Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Icon(
//                                       Icons.send_rounded,
//                                       size: isSmallScreen ? 20 : 22,
//                                     ),
//                                     SizedBox(width: isSmallScreen ? 8 : 12),
//                                     Text(
//                                       'Kirim Feedback',
//                                       style: TextStyle(
//                                         fontSize: isSmallScreen ? 15 : 16,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                         ),
//                       ),

//                       const SizedBox(height: 16),

//                       // Info Card
//                       Container(
//                         padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(16),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.grey.withOpacity(0.1),
//                               blurRadius: 15,
//                               spreadRadius: 1,
//                             ),
//                           ],
//                           border: Border.all(
//                             color: Colors.grey.shade100,
//                             width: 1,
//                           ),
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               children: [
//                                 Container(
//                                   padding: const EdgeInsets.all(6),
//                                   decoration: BoxDecoration(
//                                     color: const Color(
//                                       0xFF10B981,
//                                     ).withOpacity(0.1),
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                   child: Icon(
//                                     Icons.info_rounded,
//                                     size: isSmallScreen ? 18 : 20,
//                                     color: const Color(0xFF10B981),
//                                   ),
//                                 ),
//                                 SizedBox(width: isSmallScreen ? 8 : 12),
//                                 Expanded(
//                                   child: Text(
//                                     'Feedback akan ditinjau oleh tim kami',
//                                     style: TextStyle(
//                                       fontSize: isSmallScreen ? 14 : 16,
//                                       fontWeight: FontWeight.bold,
//                                       color: const Color(0xFF1E293B),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             const SizedBox(height: 10),
//                             Text(
//                               '• Tim kami akan membaca setiap feedback yang masuk\n'
//                               '• Feedback yang membangun akan diprioritaskan\n'
//                               '• Update akan diumumkan melalui notifikasi\n'
//                               '• Terima kasih atas kontribusi Anda!',
//                               style: TextStyle(
//                                 fontSize: isSmallScreen ? 12 : 14,
//                                 color: Colors.grey.shade700,
//                                 height: 1.6,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),

//                       const SizedBox(height: 40),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionHeader({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//   }) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isSmallScreen = screenWidth < 360;

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
//                   color: const Color(0xFF8B5CF6).withOpacity(0.1),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Icon(
//                   icon,
//                   size: isSmallScreen ? 20 : 24,
//                   color: const Color(0xFF8B5CF6),
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
//             padding: EdgeInsets.only(
//               left: isSmallScreen ? 34 : 44,
//               right: isSmallScreen ? 8 : 0,
//             ),
//             child: Text(
//               subtitle,
//               style: TextStyle(
//                 fontSize: isSmallScreen ? 12 : 14,
//                 color: Colors.grey.shade600,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildEnhancedRatingSection(
//     bool isVerySmallScreen,
//     bool isSmallScreen,
//   ) {
//     final starSize = isVerySmallScreen ? 32.0 : (isSmallScreen ? 38.0 : 44.0);
//     final starSpacing = isVerySmallScreen ? 2.0 : (isSmallScreen ? 4.0 : 6.0);

//     return Container(
//       width: double.infinity,
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
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 15,
//             spreadRadius: 1,
//           ),
//         ],
//         border: Border.all(color: Colors.white, width: 2),
//       ),
//       child: Column(
//         children: [
//           // Rating stars dengan overflow handling
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             physics: const NeverScrollableScrollPhysics(),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               mainAxisSize: MainAxisSize.min,
//               children: List.generate(5, (index) {
//                 return GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       _rating = index + 1;
//                     });
//                   },
//                   child: Container(
//                     width: starSize + 8,
//                     margin: EdgeInsets.symmetric(horizontal: starSpacing),
//                     child: Stack(
//                       alignment: Alignment.center,
//                       children: [
//                         // Background glow for selected star
//                         if (index < _rating)
//                           Icon(
//                             Icons.star_rounded,
//                             size: starSize + 4,
//                             color: Colors.amber.withOpacity(0.15),
//                           ),
//                         Icon(
//                           index < _rating
//                               ? Icons.star_rounded
//                               : Icons.star_border_rounded,
//                           size: starSize,
//                           color: index < _rating
//                               ? Colors.amber
//                               : Colors.grey.shade400,
//                         ),
//                         // Shine effect
//                         if (index < _rating)
//                           Positioned(
//                             top: starSize * 0.15,
//                             left: starSize * 0.15,
//                             child: Icon(
//                               Icons.star_rounded,
//                               size: starSize * 0.6,
//                               color: Colors.amber.withOpacity(0.25),
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//                 );
//               }),
//             ),
//           ),
//           const SizedBox(height: 16),
//           Container(
//             padding: EdgeInsets.symmetric(
//               horizontal: isSmallScreen ? 14 : 20,
//               vertical: isSmallScreen ? 8 : 10,
//             ),
//             decoration: BoxDecoration(
//               gradient: LinearGradient(colors: _getRatingGradient(_rating)),
//               borderRadius: BorderRadius.circular(10),
//               boxShadow: [
//                 BoxShadow(
//                   color: _getRatingColor(_rating).withOpacity(0.2),
//                   blurRadius: 8,
//                   spreadRadius: 1,
//                 ),
//               ],
//             ),
//             child: Row(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(
//                   _getRatingIcon(_rating),
//                   color: Colors.white,
//                   size: isSmallScreen ? 16 : 18,
//                 ),
//                 SizedBox(width: isSmallScreen ? 6 : 8),
//                 Text(
//                   _getRatingText(_rating),
//                   style: TextStyle(
//                     fontSize: isSmallScreen ? 13 : 15,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             'Beri nilai ${_rating}/5',
//             style: TextStyle(
//               fontSize: isSmallScreen ? 12 : 13,
//               color: Colors.grey.shade600,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   List<Color> _getRatingGradient(int rating) {
//     switch (rating) {
//       case 1:
//         return [const Color(0xFFEF4444), const Color(0xFFDC2626)];
//       case 2:
//         return [const Color(0xFFF59E0B), const Color(0xFFD97706)];
//       case 3:
//         return [const Color(0xFF10B981), const Color(0xFF059669)];
//       case 4:
//         return [const Color(0xFF3B82F6), const Color(0xFF1D4ED8)];
//       case 5:
//         return [const Color(0xFF8B5CF6), const Color(0xFF7C3AED)];
//       default:
//         return [const Color(0xFF8B5CF6), const Color(0xFF7C3AED)];
//     }
//   }

//   Color _getRatingColor(int rating) {
//     switch (rating) {
//       case 1:
//         return const Color(0xFFEF4444);
//       case 2:
//         return const Color(0xFFF59E0B);
//       case 3:
//         return const Color(0xFF10B981);
//       case 4:
//         return const Color(0xFF3B82F6);
//       case 5:
//         return const Color(0xFF8B5CF6);
//       default:
//         return const Color(0xFF8B5CF6);
//     }
//   }

//   IconData _getRatingIcon(int rating) {
//     switch (rating) {
//       case 1:
//         return Icons.sentiment_very_dissatisfied_rounded;
//       case 2:
//         return Icons.sentiment_dissatisfied_rounded;
//       case 3:
//         return Icons.sentiment_neutral_rounded;
//       case 4:
//         return Icons.sentiment_satisfied_rounded;
//       case 5:
//         return Icons.sentiment_very_satisfied_rounded;
//       default:
//         return Icons.sentiment_very_satisfied_rounded;
//     }
//   }

//   String _getRatingText(int rating) {
//     switch (rating) {
//       case 1:
//         return "Sangat Tidak Puas";
//       case 2:
//         return "Tidak Puas";
//       case 3:
//         return "Cukup Puas";
//       case 4:
//         return "Puas";
//       case 5:
//         return "Sangat Puas";
//       default:
//         return "Sangat Puas";
//     }
//   }

//   Widget _buildEnhancedCategorySection(bool isSmallScreen) {
//     return Container(
//       width: double.infinity,
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
//             color: Colors.grey.withOpacity(0.1),
//             blurRadius: 15,
//             spreadRadius: 1,
//           ),
//         ],
//         border: Border.all(color: Colors.white, width: 2),
//       ),
//       child: Wrap(
//         spacing: isSmallScreen ? 8 : 12,
//         runSpacing: isSmallScreen ? 8 : 12,
//         children: _kategoriList.map((kategori) {
//           final isSelected = _selectedKategori == kategori;
//           final colors = _kategoriColors[kategori]!;

//           return GestureDetector(
//             onTap: () {
//               setState(() {
//                 _selectedKategori = kategori;
//               });
//             },
//             child: AnimatedContainer(
//               duration: const Duration(milliseconds: 300),
//               padding: EdgeInsets.symmetric(
//                 horizontal: isSmallScreen ? 14 : 18,
//                 vertical: isSmallScreen ? 10 : 12,
//               ),
//               decoration: BoxDecoration(
//                 gradient: isSelected
//                     ? LinearGradient(
//                         colors: colors,
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                       )
//                     : null,
//                 color: isSelected ? null : Colors.grey.shade50,
//                 borderRadius: BorderRadius.circular(10),
//                 border: Border.all(
//                   color: isSelected ? colors[0] : Colors.grey.shade300,
//                   width: isSelected ? 2 : 1,
//                 ),
//                 boxShadow: isSelected
//                     ? [
//                         BoxShadow(
//                           color: colors[0].withOpacity(0.2),
//                           blurRadius: 6,
//                           spreadRadius: 1,
//                         ),
//                       ]
//                     : [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.05),
//                           blurRadius: 4,
//                           offset: const Offset(0, 2),
//                         ),
//                       ],
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(
//                     _kategoriIcons[kategori],
//                     size: isSmallScreen ? 18 : 20,
//                     color: isSelected ? Colors.white : colors[0],
//                   ),
//                   SizedBox(width: isSmallScreen ? 6 : 8),
//                   Text(
//                     kategori,
//                     style: TextStyle(
//                       fontSize: isSmallScreen ? 13 : 14,
//                       fontWeight: FontWeight.w600,
//                       color: isSelected ? Colors.white : colors[0],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }

//   void _submitFeedback() async {
//     if (_formKey.currentState!.validate()) {
//       setState(() {
//         _isSubmitting = true;
//       });

//       // Simulasi pengiriman feedback
//       await Future.delayed(const Duration(milliseconds: 1500));

//       // Tampilkan dialog sukses
//       _showSuccessDialog(context);

//       // Reset form
//       _formKey.currentState!.reset();
//       _namaController.clear();
//       _emailController.clear();
//       _judulController.clear();
//       _deskripsiController.clear();
//       setState(() {
//         _rating = 5;
//         _selectedKategori = "Saran";
//         _isSubmitting = false;
//       });
//     }
//   }

//   void _showSuccessDialog(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isSmallScreen = screenWidth < 360;

//     showDialog(
//       context: context,
//       barrierColor: Colors.black.withOpacity(0.5),
//       builder: (context) => Dialog(
//         backgroundColor: Colors.transparent,
//         insetPadding: EdgeInsets.all(isSmallScreen ? 20 : 40),
//         child: Container(
//           padding: EdgeInsets.all(isSmallScreen ? 20 : 30),
//           decoration: BoxDecoration(
//             gradient: const LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
//             ),
//             borderRadius: BorderRadius.circular(20),
//             boxShadow: [
//               BoxShadow(
//                 color: const Color(0xFF8B5CF6).withOpacity(0.3),
//                 blurRadius: 30,
//                 spreadRadius: 3,
//               ),
//             ],
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withOpacity(0.2),
//                   shape: BoxShape.circle,
//                 ),
//                 child: Icon(
//                   Icons.check_circle,
//                   size: isSmallScreen ? 48 : 60,
//                   color: Colors.white,
//                 ),
//               ),
//               SizedBox(height: isSmallScreen ? 16 : 20),
//               Text(
//                 'Terima Kasih!',
//                 style: TextStyle(
//                   fontSize: isSmallScreen ? 22 : 28,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                   shadows: [
//                     Shadow(
//                       blurRadius: 3,
//                       color: Colors.black.withOpacity(0.2),
//                       offset: const Offset(1, 1),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: isSmallScreen ? 8 : 10),
//               Text(
//                 'Feedback Anda berhasil dikirim',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: isSmallScreen ? 14 : 16,
//                   color: Colors.white,
//                 ),
//               ),
//               SizedBox(height: isSmallScreen ? 6 : 8),
//               Text(
//                 'Kami akan meninjau feedback Anda dan berusaha meningkatkan aplikasi',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: isSmallScreen ? 12 : 14,
//                   color: Colors.white.withOpacity(0.9),
//                 ),
//               ),
//               SizedBox(height: isSmallScreen ? 20 : 25),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: () => Navigator.pop(context),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.white,
//                     foregroundColor: const Color(0xFF8B5CF6),
//                     padding: EdgeInsets.symmetric(
//                       vertical: isSmallScreen ? 14 : 16,
//                     ),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     elevation: 3,
//                   ),
//                   child: Text(
//                     'Kembali',
//                     style: TextStyle(
//                       fontSize: isSmallScreen ? 15 : 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
