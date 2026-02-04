import 'package:flutter/material.dart';

class BahasaPage extends StatefulWidget {
  const BahasaPage({super.key});

  @override
  State<BahasaPage> createState() => _BahasaPageState();
}

class _BahasaPageState extends State<BahasaPage> {
  String _bahasaTerpilih = 'Bahasa Indonesia';
  bool _isApplying = false;

  final List<Map<String, dynamic>> _daftarBahasa = [
    {
      'nama': 'Bahasa Indonesia',
      'kode': 'id',
      'flag': '🇮🇩',
      'deskripsi': 'Bahasa resmi Indonesia',
      'gradient': [Color(0xFFEF4444), Color(0xFFDC2626)], // Merah
    },
    {
      'nama': 'English',
      'kode': 'en',
      'flag': '🇺🇸',
      'deskripsi': 'International English',
      'gradient': [Color(0xFF3B82F6), Color(0xFF1D4ED8)], // Biru
    },
    {
      'nama': '日本語',
      'kode': 'ja',
      'flag': '🇯🇵',
      'deskripsi': 'Bahasa Jepang',
      'gradient': [Color(0xFF8B5CF6), Color(0xFF7C3AED)], // Ungu
    },
    {
      'nama': '한국어',
      'kode': 'ko',
      'flag': '🇰🇷',
      'deskripsi': 'Bahasa Korea',
      'gradient': [Color(0xFF10B981), Color(0xFF059669)], // Hijau
    },

     {
      'nama': 'العربية',
      'kode': 'ar',
      'flag': '🇸🇦',
      'deskripsi': 'Bahasa Arab',
      'gradient': [Color(0xFF6366F1), Color(0xFF4F46E5)], // Indigo
    },
    {
      'nama': 'Français',
      'kode': 'fr',
      'flag': '🇫🇷',
      'deskripsi': 'Bahasa Perancis',
      'gradient': [Color(0xFFEC4899), Color(0xFFDB2777)], // Pink
    },
    {
      'nama': 'Español',
      'kode': 'es',
      'flag': '🇪🇸',
      'deskripsi': 'Bahasa Spanyol',
      'gradient': [Color(0xFF14B8A6), Color(0xFF0D9488)], // Teal
    },
    {
      'nama': 'Deutsch',
      'kode': 'de',
      'flag': '🇩🇪',
      'deskripsi': 'Bahasa Jerman',
      'gradient': [Color(0xFF8B5CF6), Color(0xFF7C3AED)], // Ungu
    },
    {
      'nama': 'Italiano',
      'kode': 'it',
      'flag': '🇮🇹',
      'deskripsi': 'Bahasa Italia',
      'gradient': [Color(0xFF84CC16), Color(0xFF65A30D)], // Lime
    },
    {
      'nama': 'Português',
      'kode': 'pt',
      'flag': '🇵🇹',
      'deskripsi': 'Bahasa Portugal',
      'gradient': [Color(0xFFF97316), Color(0xFFEA580C)], // Orange
    },
    {
      'nama': 'Русский',
      'kode': 'ru',
      'flag': '🇷🇺',
      'deskripsi': 'Bahasa Rusia',
      'gradient': [Color(0xFF0EA5E9), Color(0xFF0284C7)], // Sky
    },
    {
      'nama': 'Türkçe',
      'kode': 'tr',
      'flag': '🇹🇷',
      'deskripsi': 'Bahasa Turki',
      'gradient': [Color(0xFF8B5CF6), Color(0xFF7C3AED)], // Ungu
    },
    {
      'nama': 'हिन्दी',
      'kode': 'hi',
      'flag': '🇮🇳',
      'deskripsi': 'Bahasa Hindi',
      'gradient': [Color(0xFFF59E0B), Color(0xFFD97706)], // Oranye
    },
    {
      'nama': 'বাংলা',
      'kode': 'bn',
      'flag': '🇧🇩',
      'deskripsi': 'Bahasa Bengali',
      'gradient': [Color(0xFF10B981), Color(0xFF059669)], // Hijau
    },
    {
      'nama': 'ไทย',
      'kode': 'th',
      'flag': '🇹🇭',
      'deskripsi': 'Bahasa Thailand',
      'gradient': [Color(0xFFEC4899), Color(0xFFDB2777)], // Pink
    },
    {
      'nama': 'Tiếng Việt',
      'kode': 'vi',
      'flag': '🇻🇳',
      'deskripsi': 'Bahasa Vietnam',
      'gradient': [Color(0xFF3B82F6), Color(0xFF1D4ED8)], // Biru
    },
    {
      'nama': 'Nederlands',
      'kode': 'nl',
      'flag': '🇳🇱',
      'deskripsi': 'Bahasa Belanda',
      'gradient': [Color(0xFFF59E0B), Color(0xFFD97706)], // Oranye
    },
    {
      'nama': 'Polski',
      'kode': 'pl',
      'flag': '🇵🇱',
      'deskripsi': 'Bahasa Polandia',
      'gradient': [Color(0xFF8B5CF6), Color(0xFF7C3AED)], // Ungu
    },
    {
      'nama': 'Svenska',
      'kode': 'sv',
      'flag': '🇸🇪',
      'deskripsi': 'Bahasa Swedia',
      'gradient': [Color(0xFF0EA5E9), Color(0xFF0284C7)], // Sky
    },
    // ... Tambahkan bahasa lain sesuai kebutuhan ...
  ];

  void _applyLanguage() async {
    setState(() {
      _isApplying = true;
    });

    // Simulasi perubahan bahasa, bisa diganti trigger localization asli
    await Future.delayed(const Duration(milliseconds: 800));

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
              child: const Icon(Icons.translate, size: 20, color: Colors.green),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Bahasa berhasil diubah ke $_bahasaTerpilih',
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(20),
        elevation: 10,
        duration: const Duration(milliseconds: 1200),
      ),
    );
    setState(() {
      _isApplying = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final current = _daftarBahasa.firstWhere((e) => e['nama'] == _bahasaTerpilih);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Modern Gradient Header, tidak tertimpa
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: MediaQuery.of(context).padding.top + 24,
                bottom: 18,
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
                  // Pattern overlay, hapus saja jika file tidak ada
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.09,
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/pattern.png'),
                            repeat: ImageRepeat.repeat,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                            onPressed: () => Navigator.of(context).maybePop(),
                          ),
                          const Spacer(),
                          const Icon(Icons.language_rounded, color: Colors.white, size: 28),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Bahasa',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.4,
                          shadows: [
                            Shadow(
                              blurRadius: 8,
                              color: Colors.black.withOpacity(0.13),
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        'Pilih bahasa untuk aplikasi',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Spasi memo header ke card
          SliverToBoxAdapter(child: SizedBox(height: 12)),

          // Card Bahasa Aktif
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                margin: const EdgeInsets.only(bottom: 25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: current['gradient'][0].withOpacity(0.09),
                      blurRadius: 22,
                      spreadRadius: 2,
                      offset: const Offset(0, 6),
                    ),
                  ],
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            (current['gradient'] as List<Color>).first.withOpacity(0.13),
                            (current['gradient'] as List<Color>).last.withOpacity(0.10),
                          ],
                        ),
                      ),
                      child: Center(
                        child: Text(
                          current['flag'],
                          style: const TextStyle(fontSize: 28),
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bahasa Saat Ini',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            current['nama'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            current['deskripsi'],
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[500],
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: List<Color>.from(current['gradient']),
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: current['gradient'][0].withOpacity(0.3),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: const Text(
                        'Aktif',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Daftar Bahasa Vertical
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Section Title
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: current['gradient'][0].withOpacity(0.11),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.list_rounded,
                          size: 23,
                          color: current['gradient'][0],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Daftar Bahasa Tersedia',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Text(
                    '${_daftarBahasa.length} bahasa tersedia',
                    style: TextStyle(
                      fontSize: 13.5,
                      color: Colors.grey[600],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // List bahasa vertikal
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _daftarBahasa.length,
                    separatorBuilder: (c, i) => const SizedBox(height: 12),
                    itemBuilder: (ctx, idx) {
                      final bahasa = _daftarBahasa[idx];
                      final isSelected = _bahasaTerpilih == bahasa['nama'];
                      return _buildLanguageCard(
                        flag: bahasa['flag'],
                        nama: bahasa['nama'],
                        deskripsi: bahasa['deskripsi'],
                        gradient: bahasa['gradient'],
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            _bahasaTerpilih = bahasa['nama'];
                          });
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Button Terapkan Bahasa
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 25),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: current['gradient'][0].withOpacity(0.28),
                          blurRadius: 18,
                          spreadRadius: 2,
                          offset: const Offset(0, 7),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      onPressed: _isApplying ? null : _applyLanguage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: current['gradient'][0],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 17, horizontal: 24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _isApplying
                            ? [
                                const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                    color: Colors.white,
                                  ),
                                ),
                              ]
                            : [
                                const Icon(Icons.translate, size: 20),
                                const SizedBox(width: 10),
                                const Text(
                                  'Terapkan Bahasa',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageCard({
    required String flag,
    required String nama,
    required String deskripsi,
    required List<Color> gradient,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 330),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(colors: gradient)
              : LinearGradient(colors: [Colors.white, Colors.white.withOpacity(0.94)]),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? gradient[0].withOpacity(0.21)
                  : Colors.grey.withOpacity(0.07),
              blurRadius: 14,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: isSelected ? gradient[0] : Colors.grey.shade200,
            width: isSelected ? 2 : 1.3,
          ),
        ),
        child: Stack(
          children: [
            // glow effect for selected
            if (isSelected)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withOpacity(0.10),
                        Colors.transparent,
                      ],
                      radius: 0.78,
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Container(
                    width: 41,
                    height: 41,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(isSelected ? 0.18 : 0.11),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.17),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(flag, style: const TextStyle(fontSize: 23)),
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nama,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: isSelected ? Colors.white : Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          deskripsi,
                          style: TextStyle(
                            fontSize: 12.5,
                            color: isSelected
                                ? Colors.white.withOpacity(0.91)
                                : Colors.grey.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.09),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(Icons.check_circle_rounded, size: 16, color: gradient[0]),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';

// class BahasaPage extends StatefulWidget {
//   const BahasaPage({super.key});

//   @override
//   State<BahasaPage> createState() => _BahasaPageState();
// }

// class _BahasaPageState extends State<BahasaPage> {
//   String _bahasaTerpilih = 'Bahasa Indonesia';
//   bool _isApplying = false;

//   final List<Map<String, dynamic>> _daftarBahasa = [
//     {
//       'nama': 'Bahasa Indonesia',
//       'kode': 'id',
//       'flag': '🇮🇩',
//       'deskripsi': 'Bahasa resmi Indonesia',
//       'gradient': [Color(0xFFEF4444), Color(0xFFDC2626)], // Merah
//     },
//     {
//       'nama': 'English',
//       'kode': 'en',
//       'flag': '🇺🇸',
//       'deskripsi': 'International English',
//       'gradient': [Color(0xFF3B82F6), Color(0xFF1D4ED8)], // Biru
//     },
//     {
//       'nama': '日本語',
//       'kode': 'ja',
//       'flag': '🇯🇵',
//       'deskripsi': 'Bahasa Jepang',
//       'gradient': [Color(0xFF8B5CF6), Color(0xFF7C3AED)], // Ungu
//     },
//     {
//       'nama': '한국어',
//       'kode': 'ko',
//       'flag': '🇰🇷',
//       'deskripsi': 'Bahasa Korea',
//       'gradient': [Color(0xFF10B981), Color(0xFF059669)], // Hijau
//     },
//     {
//       'nama': '中文',
//       'kode': 'zh',
//       'flag': '🇨🇳',
//       'deskripsi': 'Bahasa Mandarin',
//       'gradient': [Color(0xFFF59E0B), Color(0xFFD97706)], // Oranye
//     },
//     {
//       'nama': 'العربية',
//       'kode': 'ar',
//       'flag': '🇸🇦',
//       'deskripsi': 'Bahasa Arab',
//       'gradient': [Color(0xFF6366F1), Color(0xFF4F46E5)], // Indigo
//     },
//     {
//       'nama': 'Français',
//       'kode': 'fr',
//       'flag': '🇫🇷',
//       'deskripsi': 'Bahasa Perancis',
//       'gradient': [Color(0xFFEC4899), Color(0xFFDB2777)], // Pink
//     },
//     {
//       'nama': 'Español',
//       'kode': 'es',
//       'flag': '🇪🇸',
//       'deskripsi': 'Bahasa Spanyol',
//       'gradient': [Color(0xFF14B8A6), Color(0xFF0D9488)], // Teal
//     },
//     {
//       'nama': 'Deutsch',
//       'kode': 'de',
//       'flag': '🇩🇪',
//       'deskripsi': 'Bahasa Jerman',
//       'gradient': [Color(0xFF8B5CF6), Color(0xFF7C3AED)], // Ungu
//     },
//     {
//       'nama': 'Italiano',
//       'kode': 'it',
//       'flag': '🇮🇹',
//       'deskripsi': 'Bahasa Italia',
//       'gradient': [Color(0xFF84CC16), Color(0xFF65A30D)], // Lime
//     },
//     {
//       'nama': 'Português',
//       'kode': 'pt',
//       'flag': '🇵🇹',
//       'deskripsi': 'Bahasa Portugal',
//       'gradient': [Color(0xFFF97316), Color(0xFFEA580C)], // Orange
//     },
//     {
//       'nama': 'Русский',
//       'kode': 'ru',
//       'flag': '🇷🇺',
//       'deskripsi': 'Bahasa Rusia',
//       'gradient': [Color(0xFF0EA5E9), Color(0xFF0284C7)], // Sky
//     },
//     {
//       'nama': 'Türkçe',
//       'kode': 'tr',
//       'flag': '🇹🇷',
//       'deskripsi': 'Bahasa Turki',
//       'gradient': [Color(0xFF8B5CF6), Color(0xFF7C3AED)], // Ungu
//     },
//     {
//       'nama': 'हिन्दी',
//       'kode': 'hi',
//       'flag': '🇮🇳',
//       'deskripsi': 'Bahasa Hindi',
//       'gradient': [Color(0xFFF59E0B), Color(0xFFD97706)], // Oranye
//     },
//     {
//       'nama': 'বাংলা',
//       'kode': 'bn',
//       'flag': '🇧🇩',
//       'deskripsi': 'Bahasa Bengali',
//       'gradient': [Color(0xFF10B981), Color(0xFF059669)], // Hijau
//     },
//     {
//       'nama': 'ไทย',
//       'kode': 'th',
//       'flag': '🇹🇭',
//       'deskripsi': 'Bahasa Thailand',
//       'gradient': [Color(0xFFEC4899), Color(0xFFDB2777)], // Pink
//     },
//     {
//       'nama': 'Tiếng Việt',
//       'kode': 'vi',
//       'flag': '🇻🇳',
//       'deskripsi': 'Bahasa Vietnam',
//       'gradient': [Color(0xFF3B82F6), Color(0xFF1D4ED8)], // Biru
//     },
//     {
//       'nama': 'Nederlands',
//       'kode': 'nl',
//       'flag': '🇳🇱',
//       'deskripsi': 'Bahasa Belanda',
//       'gradient': [Color(0xFFF59E0B), Color(0xFFD97706)], // Oranye
//     },
//     {
//       'nama': 'Polski',
//       'kode': 'pl',
//       'flag': '🇵🇱',
//       'deskripsi': 'Bahasa Polandia',
//       'gradient': [Color(0xFF8B5CF6), Color(0xFF7C3AED)], // Ungu
//     },
//     {
//       'nama': 'Svenska',
//       'kode': 'sv',
//       'flag': '🇸🇪',
//       'deskripsi': 'Bahasa Swedia',
//       'gradient': [Color(0xFF0EA5E9), Color(0xFF0284C7)], // Sky
//     },
//   ];

//   void _applyLanguage() async {
//     setState(() {
//       _isApplying = true;
//     });

//     // Simulasi proses apply language
//     await Future.delayed(const Duration(milliseconds: 1500));

//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Row(
//           children: [
//             Container(
//               padding: const EdgeInsets.all(8),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: const Icon(Icons.translate, size: 20, color: Colors.green),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Text(
//                 'Bahasa berhasil diubah ke $_bahasaTerpilih',
//                 style: const TextStyle(fontSize: 14),
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: Colors.green,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         margin: const EdgeInsets.all(20),
//         elevation: 10,
//         action: SnackBarAction(
//           label: 'Restart App',
//           textColor: Colors.white,
//           onPressed: () {
//             // Simulasi restart aplikasi
//           },
//         ),
//       ),
//     );

//     setState(() {
//       _isApplying = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8FAFC),
//       body: CustomScrollView(
//         physics: const BouncingScrollPhysics(),
//         slivers: [
//           // AppBar dengan efek gradient
//           SliverAppBar(
//             expandedHeight: 180,
//             floating: false,
//             pinned: true,
//             flexibleSpace: FlexibleSpaceBar(
//               title: Text(
//                 'Bahasa',
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   shadows: [
//                     Shadow(
//                       blurRadius: 4,
//                       color: Colors.black.withOpacity(0.3),
//                       offset: const Offset(1, 1),
//                     ),
//                   ],
//                 ),
//               ),
//               centerTitle: true,
//               background: Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.topLeft,
//                     end: Alignment.bottomRight,
//                     colors: [const Color(0xFF8B5CF6), const Color(0xFF7C3AED)],
//                   ),
//                 ),
//                 child: Stack(
//                   children: [
//                     // Pattern overlay
//                     Positioned.fill(
//                       child: Opacity(
//                         opacity: 0.1,
//                         child: Container(
//                           decoration: const BoxDecoration(
//                             image: DecorationImage(
//                               image: AssetImage('assets/images/pattern.png'),
//                               repeat: ImageRepeat.repeat,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     // Content
//                     Padding(
//                       padding: const EdgeInsets.all(20),
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.end,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Icon(
//                             Icons.language_rounded,
//                             size: 40,
//                             color: Colors.white,
//                           ),
//                           const SizedBox(height: 10),
//                           Text(
//                             'Pilih bahasa untuk aplikasi',
//                             style: TextStyle(
//                               color: Colors.white.withOpacity(0.9),
//                               fontSize: 14,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),

//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.all(20),
//               child: Column(
//                 children: [
//                   // Current Language Card
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.all(24),
//                     margin: const EdgeInsets.only(bottom: 30),
//                     decoration: BoxDecoration(
//                       gradient: const LinearGradient(
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                         colors: [Colors.white, Color(0xFFF5F3FF)],
//                       ),
//                       borderRadius: BorderRadius.circular(24),
//                       boxShadow: [
//                         BoxShadow(
//                           color: const Color(0xFF8B5CF6).withOpacity(0.1),
//                           blurRadius: 25,
//                           spreadRadius: 2,
//                           offset: const Offset(0, 8),
//                         ),
//                       ],
//                       border: Border.all(color: Colors.white, width: 2),
//                     ),
//                     child: Column(
//                       children: [
//                         Row(
//                           children: [
//                             Container(
//                               width: 60,
//                               height: 60,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 gradient: LinearGradient(
//                                   colors: [
//                                     const Color(0xFF8B5CF6).withOpacity(0.1),
//                                     const Color(0xFF7C3AED).withOpacity(0.1),
//                                   ],
//                                 ),
//                               ),
//                               child: const Center(
//                                 child: Icon(
//                                   Icons.translate_rounded,
//                                   size: 30,
//                                   color: Color(0xFF8B5CF6),
//                                 ),
//                               ),
//                             ),
//                             const SizedBox(width: 20),
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   const Text(
//                                     'Bahasa Saat Ini',
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       color: Color(0xFF6B7280),
//                                       fontWeight: FontWeight.w500,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(
//                                     _bahasaTerpilih,
//                                     style: const TextStyle(
//                                       fontSize: 20,
//                                       fontWeight: FontWeight.bold,
//                                       color: Color(0xFF1E293B),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 16,
//                                 vertical: 8,
//                               ),
//                               decoration: BoxDecoration(
//                                 gradient: const LinearGradient(
//                                   colors: [
//                                     Color(0xFF8B5CF6),
//                                     Color(0xFF7C3AED),
//                                   ],
//                                 ),
//                                 borderRadius: BorderRadius.circular(20),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: const Color(
//                                       0xFF8B5CF6,
//                                     ).withOpacity(0.3),
//                                     blurRadius: 10,
//                                     spreadRadius: 1,
//                                   ),
//                                 ],
//                               ),
//                               child: const Text(
//                                 'Aktif',
//                                 style: TextStyle(
//                                   color: Colors.white,
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 14,
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 20),
//                         Container(
//                           padding: const EdgeInsets.all(16),
//                           decoration: BoxDecoration(
//                             color: const Color(0xFFF5F3FF),
//                             borderRadius: BorderRadius.circular(16),
//                             border: Border.all(
//                               color: const Color(0xFFDDD6FE),
//                               width: 1,
//                             ),
//                           ),
//                           child: Row(
//                             children: [
//                               const Icon(
//                                 Icons.info_outline_rounded,
//                                 color: Color(0xFF8B5CF6),
//                                 size: 20,
//                               ),
//                               const SizedBox(width: 12),
//                               Expanded(
//                                 child: Text(
//                                   'Pilih bahasa dari daftar di bawah untuk mengubah bahasa aplikasi',
//                                   style: TextStyle(
//                                     fontSize: 14,
//                                     color: Colors.grey.shade700,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   // Section Title
//                   Container(
//                     width: double.infinity,
//                     margin: const EdgeInsets.only(bottom: 20),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.all(8),
//                               decoration: BoxDecoration(
//                                 color: const Color(0xFF8B5CF6).withOpacity(0.1),
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: const Icon(
//                                 Icons.list_rounded,
//                                 size: 24,
//                                 color: Color(0xFF8B5CF6),
//                               ),
//                             ),
//                             const SizedBox(width: 12),
//                             const Text(
//                               'Daftar Bahasa Tersedia',
//                               style: TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: Color(0xFF1E293B),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           '${_daftarBahasa.length} bahasa tersedia',
//                           style: TextStyle(
//                             fontSize: 14,
//                             color: Colors.grey.shade600,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),

//                   // Language Grid
//                   GridView.builder(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     gridDelegate:
//                         const SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 2,
//                           childAspectRatio: 1.2,
//                           crossAxisSpacing: 16,
//                           mainAxisSpacing: 16,
//                         ),
//                     itemCount: _daftarBahasa.length,
//                     itemBuilder: (context, index) {
//                       final bahasa = _daftarBahasa[index];
//                       final isSelected = _bahasaTerpilih == bahasa['nama'];

//                       return _buildLanguageCard(
//                         flag: bahasa['flag'],
//                         nama: bahasa['nama'],
//                         deskripsi: bahasa['deskripsi'],
//                         gradient: bahasa['gradient'] as List<Color>,
//                         isSelected: isSelected,
//                         onTap: () {
//                           setState(() {
//                             _bahasaTerpilih = bahasa['nama'];
//                           });
//                         },
//                       );
//                     },
//                   ),

//                   const SizedBox(height: 30),

//                   // Information Card
//                   Container(
//                     padding: const EdgeInsets.all(24),
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                         colors: [
//                           const Color(0xFFF5F3FF),
//                           const Color(0xFFEDE9FE).withOpacity(0.5),
//                         ],
//                       ),
//                       borderRadius: BorderRadius.circular(20),
//                       border: Border.all(
//                         color: const Color(0xFFDDD6FE),
//                         width: 1,
//                       ),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.1),
//                           blurRadius: 15,
//                           spreadRadius: 2,
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           children: [
//                             Container(
//                               padding: const EdgeInsets.all(8),
//                               decoration: BoxDecoration(
//                                 color: const Color(0xFF8B5CF6).withOpacity(0.1),
//                                 borderRadius: BorderRadius.circular(10),
//                               ),
//                               child: const Icon(
//                                 Icons.info_rounded,
//                                 size: 20,
//                                 color: Color(0xFF8B5CF6),
//                               ),
//                             ),
//                             const SizedBox(width: 12),
//                             const Text(
//                               'Informasi Penting',
//                               style: TextStyle(
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.bold,
//                                 color: Color(0xFF1E293B),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 16),
//                         _buildInfoItem(
//                           'Perubahan bahasa akan mempengaruhi seluruh tampilan aplikasi',
//                         ),
//                         _buildInfoItem(
//                           'Beberapa konten mungkin tidak tersedia dalam semua bahasa',
//                         ),
//                         _buildInfoItem(
//                           'Restart aplikasi diperlukan untuk menerapkan perubahan secara penuh',
//                         ),
//                         _buildInfoItem(
//                           'Bahasa dapat diubah kapan saja dari pengaturan',
//                         ),
//                       ],
//                     ),
//                   ),

//                   const SizedBox(height: 40),

//                   // Apply Button
//                   Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(20),
//                       boxShadow: [
//                         BoxShadow(
//                           color: const Color(0xFF8B5CF6).withOpacity(0.3),
//                           blurRadius: 20,
//                           spreadRadius: 3,
//                           offset: const Offset(0, 8),
//                         ),
//                       ],
//                     ),
//                     child: ElevatedButton(
//                       onPressed: _isApplying ? null : _applyLanguage,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xFF8B5CF6),
//                         foregroundColor: Colors.white,
//                         padding: const EdgeInsets.symmetric(
//                           vertical: 18,
//                           horizontal: 24,
//                         ),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                         elevation: 0,
//                         shadowColor: Colors.transparent,
//                       ),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: _isApplying
//                             ? [
//                                 const SizedBox(
//                                   width: 24,
//                                   height: 24,
//                                   child: CircularProgressIndicator(
//                                     strokeWidth: 3,
//                                     color: Colors.white,
//                                   ),
//                                 ),
//                               ]
//                             : [
//                                 const Icon(
//                                   Icons.check_circle_rounded,
//                                   size: 22,
//                                 ),
//                                 const SizedBox(width: 12),
//                                 const Text(
//                                   'Terapkan Bahasa',
//                                   style: TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                       ),
//                     ),
//                   ),

//                   const SizedBox(height: 60),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLanguageCard({
//     required String flag,
//     required String nama,
//     required String deskripsi,
//     required List<Color> gradient,
//     required bool isSelected,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 300),
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: isSelected
//                 ? gradient
//                 : [Colors.white, Colors.white.withOpacity(0.9)],
//           ),
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: isSelected
//                   ? gradient[0].withOpacity(0.3)
//                   : Colors.grey.withOpacity(0.1),
//               blurRadius: 15,
//               spreadRadius: 2,
//               offset: const Offset(0, 4),
//             ),
//             BoxShadow(
//               color: Colors.white.withOpacity(0.9),
//               blurRadius: 10,
//               spreadRadius: 2,
//               offset: const Offset(-2, -2),
//             ),
//           ],
//           border: Border.all(
//             color: isSelected
//                 ? gradient[0].withOpacity(0.4)
//                 : Colors.grey.shade200,
//             width: isSelected ? 2 : 1.5,
//           ),
//         ),
//         child: Stack(
//           children: [
//             // Glow effect for selected
//             if (isSelected)
//               Positioned.fill(
//                 child: Container(
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(20),
//                     gradient: RadialGradient(
//                       colors: [
//                         Colors.white.withOpacity(0.1),
//                         Colors.transparent,
//                       ],
//                       radius: 0.8,
//                     ),
//                   ),
//                 ),
//               ),

//             // Main content
//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Flag
//                   Container(
//                     width: 48,
//                     height: 48,
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(isSelected ? 0.2 : 0.1),
//                       borderRadius: BorderRadius.circular(12),
//                       border: Border.all(
//                         color: Colors.white.withOpacity(0.3),
//                         width: 1,
//                       ),
//                     ),
//                     child: Center(
//                       child: Text(flag, style: const TextStyle(fontSize: 24)),
//                     ),
//                   ),
//                   const SizedBox(height: 12),

//                   // Language name
//                   Text(
//                     nama,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                       color: isSelected
//                           ? Colors.white
//                           : const Color(0xFF1E293B),
//                     ),
//                   ),
//                   const SizedBox(height: 4),

//                   // Description
//                   Text(
//                     deskripsi,
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                       fontSize: 11,
//                       color: isSelected
//                           ? Colors.white.withOpacity(0.9)
//                           : Colors.grey.shade600,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Selected indicator
//             if (isSelected)
//               Positioned(
//                 top: 12,
//                 right: 12,
//                 child: Container(
//                   padding: const EdgeInsets.all(4),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     shape: BoxShape.circle,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.1),
//                         blurRadius: 4,
//                         spreadRadius: 1,
//                       ),
//                     ],
//                   ),
//                   child: Icon(
//                     Icons.check_circle_rounded,
//                     size: 16,
//                     color: gradient[0],
//                   ),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoItem(String text) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             margin: const EdgeInsets.only(top: 6, right: 12),
//             width: 6,
//             height: 6,
//             decoration: BoxDecoration(
//               color: const Color(0xFF8B5CF6),
//               shape: BoxShape.circle,
//               boxShadow: [
//                 BoxShadow(
//                   color: const Color(0xFF8B5CF6).withOpacity(0.3),
//                   blurRadius: 4,
//                   spreadRadius: 1,
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Text(
//               text,
//               style: TextStyle(
//                 fontSize: 14,
//                 color: Colors.grey.shade700,
//                 height: 1.5,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
