import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:peresenceapp/screens/home/absen_page.dart';
import 'package:peresenceapp/screens/home/daftarabsen_page.dart';
import 'package:peresenceapp/screens/home/lembur_page.dart';
import 'package:peresenceapp/screens/home/reimbursement_page.dart';
import 'package:peresenceapp/screens/home/selipgaji_page.dart';
import 'package:peresenceapp/screens/kalender_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../theme/app_theme.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/promo_card.dart';
import '../../widgets/section_card.dart';
import '../../widgets/surface.dart';
import '../../widgets/icon_tile.dart';
import '../../services/auth_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required String userEmail,
    required String userName,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _pageController = PageController(viewportFraction: 0.92);
  // Notifier for attendance entries so DaftarAbsenPage updates live
  final ValueNotifier<List<AbsensiData>> _absensiNotifier =
      ValueNotifier<List<AbsensiData>>([]);

  @override
  void dispose() {
    _pageController.dispose();
    _absensiNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: GreetingHeader()),
          const SliverToBoxAdapter(child: SizedBox(height: 3)),
          SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 12),
            sliver: SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: 3),
                  SizedBox(
                    height: 200,
                    child: PageView(
                      controller: _pageController,
                      children: const [
                        PromoCard(
                          imageAsset: 'assets/images/safety.jpg',
                          title: 'Keselamatan',
                          desc: 'Utamakan keselamatan dalam bekerja.',
                        ),
                        PromoCard(
                          imageAsset: 'assets/images/work.jpg',
                          title: 'Kerja Produktif',
                          desc:
                              'Tingkatkan produktivitas dengan manajemen waktu yang baik.',
                        ),
                        PromoCard(
                          imageAsset: 'assets/images/fokus.jpg',
                          title: 'Fokus & Semangat',
                          desc:
                              'Jaga fokus dan semangat untuk hasil kerja terbaik.',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: 3,
                    effect: ExpandingDotsEffect(
                      dotHeight: 8,
                      dotWidth: 8,
                      activeDotColor: AppColors.primary,
                      dotColor: Color(0xFFE0E7F3),
                      expansionFactor: 3,
                      spacing: 8,
                    ),
                  ),
                  const SizedBox(height: 6),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
            sliver: SliverToBoxAdapter(
              child: Material(
                color: Colors.transparent,
                child: Surface(
                  padding: const EdgeInsets.all(14),
                  child: GridView.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      IconTile(
                        icon: Icons.calendar_today,
                        iconColor: AppColors.primary,
                        label: 'KALENDER',
                        textColor: Colors.black87,
                        labelStyle: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          letterSpacing: 0.6,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CalendarPage(),
                            ),
                          );
                        },
                      ),
                      IconTile(
                        icon: Icons.receipt_long,
                        iconColor: AppColors.primary,
                        label: 'SLIP GAJI',
                        textColor: Colors.black87,
                        labelStyle: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          letterSpacing: 0.6,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const SlipGajiPage(),
                            ),
                          );
                        },
                      ),
                      IconTile(
                        icon: Icons.list_alt,
                        iconColor: AppColors.primary,
                        label: 'DAFTAR ABSEN',
                        textColor: Colors.black87,
                        labelStyle: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          letterSpacing: 0.4,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DaftarAbsenPage(
                                absensiNotifier: _absensiNotifier,
                                absensi: [],
                              ),
                            ),
                          );
                        },
                      ),
                      IconTile(
                        icon: Icons.access_time,
                        iconColor: AppColors.primary,
                        label: 'LEMBUR',
                        textColor: Colors.black87,
                        labelStyle: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          letterSpacing: 0.4,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LemburPage(),
                            ),
                          );
                        },
                      ),
                      IconTile(
                        icon: Icons.attach_money,
                        iconColor: AppColors.primary,
                        label: 'REIMBURSE',
                        textColor: Colors.black87,
                        labelStyle: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          letterSpacing: 0.2,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ReimbursementPage(),
                            ),
                          );
                        },
                      ),
                      IconTile(
                        icon: Icons.camera_alt,
                        iconColor: AppColors.primary,
                        label: 'ABSEN',
                        textColor: Colors.black87,
                        labelStyle: const TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                          letterSpacing: 0.6,
                        ),
                        onTap: () {
                          final userId =
                              FirebaseAuth.instance.currentUser?.uid ?? 'guest';
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  AbsensiDashboardPage(userId: userId),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
            sliver: SliverToBoxAdapter(
              child: SectionCard(
                title: 'Pengumuman',
                actionText: 'Lihat semua',
                onActionTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AllPengumumanPage(),
                    ),
                  );
                },
                titleStyle: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
                actionTextStyle: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
                child: const EmptyState(
                  title: 'Belum ada pengumuman',
                  subtitle: 'Pengumuman akan tampil disini',
                  titleStyle: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  subtitleStyle: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
            sliver: SliverToBoxAdapter(
              child: SectionCard(
                title: 'Tugas',
                actionText: 'Lihat semua',
                onActionTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const AllTugasPage()),
                  );
                },
                titleStyle: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
                actionTextStyle: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
                child: const EmptyState(
                  title: 'Tidak ada tugas',
                  subtitle: 'Anda tidak memiliki tugas yang tertunda',
                  titleStyle: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                  subtitleStyle: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w400,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- HEADER PROFILES, AUTO-DATA FROM FIREBASE AUTH ---
class GreetingHeader extends StatefulWidget {
  const GreetingHeader({super.key});

  @override
  State<GreetingHeader> createState() => _GreetingHeaderState();
}

class _GreetingHeaderState extends State<GreetingHeader> {
  late Future<Map<String, dynamic>> _userDataFuture;

  static const List<String> _availableProfileAssets = [
    'assets/images/profil1.jpg',
    'assets/images/profil2.jpg',
    'assets/images/profil3.jpg',
    'assets/images/profil4.jpg',
    'assets/images/profil5.jpg',
    'assets/images/profil6.png',
    'assets/images/profil7.png',
    'assets/images/profil8.png',
  ];

  @override
  void initState() {
    super.initState();
    _userDataFuture = _fetchUserData();
  }

  Future<Map<String, dynamic>> _fetchUserData() async {
    try {
      String displayName = await AuthHelper.getCurrentUserName();
      String companyName = await AuthHelper.getCurrentUserCompanyName();

      final prefs = await SharedPreferences.getInstance();
      String savedPhotoAsset = prefs.getString('user_photo_asset') ?? '';

      if (savedPhotoAsset.isEmpty) {
        savedPhotoAsset = _getProfileAssetByUserName(displayName);
        await prefs.setString('user_photo_asset', savedPhotoAsset);
      }

      await prefs.setString('user_name', displayName);
      await prefs.setString('user_company', companyName);

      return {
        'name': displayName,
        'companyName': companyName,
        'photoAsset': savedPhotoAsset,
      };
    } catch (e) {
      print('Error fetching user data: $e');
      return {
        'name': 'User',
        'companyName': 'Unknown Company',
        'photoAsset': 'assets/images/profile1.png',
      };
    }
  }

  String _getProfileAssetByUserName(String userName) {
    if (userName.isEmpty || userName == 'User') {
      return 'assets/images/profile1.png';
    }

    final nameHash = userName.hashCode.abs();
    final index = nameHash % _availableProfileAssets.length;

    return _availableProfileAssets[index];
  }

  String getInitials(String name) {
    final cleanName = name.trim();
    if (cleanName.isEmpty) return 'U';
    final parts = cleanName.split(' ').where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return (parts[0][0] + parts.last[0]).toUpperCase();
  }

  Widget _buildAvatar(String photoAsset, String userName) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          photoAsset,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // FIX: Tambahkan textBaseline dan overflow untuk mencegah garis kuning
            return Container(
              color: Colors.white,
              child: Center(
                child: Text(
                  getInitials(userName),
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  // FIX 1: Tambahkan overflow untuk mencegah garis kuning
                  overflow: TextOverflow.clip,
                  // FIX 2: Atau bisa juga dengan menghilangkan baseline
                  textHeightBehavior: const TextHeightBehavior(
                    applyHeightToFirstAscent: false,
                    applyHeightToLastDescent: false,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _userDataFuture,
      builder: (context, snapshot) {
        final userName = snapshot.hasData
            ? snapshot.data!['name'] as String
            : 'User';
        final photoAsset = snapshot.hasData
            ? snapshot.data!['photoAsset'] as String
            : 'assets/images/profile1.png';
        final companyName = snapshot.hasData
            ? snapshot.data!['companyName'] as String
            : 'Unknown Company';

        return Container(
          width: double.infinity,
          color: AppColors.extraLight,
          padding: const EdgeInsets.only(top: 16, left: 0, right: 0, bottom: 8),
          child: Center(
            child: Container(
              height: 58,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 10),
                  _buildAvatar(photoAsset, userName),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // FIX 3: Tambahkan overflow untuk teks nama
                        Text(
                          userName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 2),
                        // FIX 4: Tambahkan overflow untuk teks company
                        Text(
                          companyName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.85),
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.notifications_none_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                    onPressed: () {
                      // TODO: Ke halaman notifikasi
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Halaman Pengumuman & Tugas
class AllPengumumanPage extends StatelessWidget {
  const AllPengumumanPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.extraLight,
      appBar: AppBar(
        title: const Text(
          'Semua Pengumuman',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: const Center(
        child: Text(
          'Daftar semua pengumuman',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
    );
  }
}

class AllTugasPage extends StatelessWidget {
  const AllTugasPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.extraLight,
      appBar: AppBar(
        title: const Text('Semua Tugas', style: TextStyle(color: Colors.white)),
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: const Center(
        child: Text(
          'Daftar semua tugas',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:peresenceapp/screens/home/absen_page.dart';
// import 'package:peresenceapp/screens/home/daftarabsen_page.dart';
// import 'package:peresenceapp/screens/home/lembur_page.dart';
// import 'package:peresenceapp/screens/home/reimbursement_page.dart';
// import 'package:peresenceapp/screens/home/selipgaji_page.dart';
// import 'package:peresenceapp/screens/kalender_page.dart';
// import 'package:smooth_page_indicator/smooth_page_indicator.dart';
// import '../../theme/app_theme.dart';
// import '../../widgets/empty_state.dart';
// import '../../widgets/promo_card.dart';
// import '../../widgets/section_card.dart';
// import '../../widgets/surface.dart';
// import '../../widgets/icon_tile.dart';
// import '../../services/auth_helper.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key, required String userEmail, required String userName});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final _pageController = PageController(viewportFraction: 0.92);

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: CustomScrollView(
//         slivers: [
//           // ---- HEADER GREETING BAR ----
//           const SliverToBoxAdapter(child: GreetingHeader()),

//           const SliverToBoxAdapter(
//             child: SizedBox(height: 3),
//           ), // Jarak antara header dan carousel
//           // ---- CAROUSEL ----
//           SliverPadding(
//             padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 12),
//             sliver: SliverToBoxAdapter(
//               child: Column(
//                 children: [
//                   const SizedBox(height: 3),
//                   SizedBox(
//                     height: 200,
//                     child: PageView(
//                       controller: _pageController,
//                       children: const [
//                         PromoCard(
//                           imageAsset: 'assets/images/safety.jpg',
//                           title: 'Utamakan Keselamatan',
//                           desc:
//                               'Selalu patuhi protokol keselamatan kerja di lingkungan kantor.',
//                         ),
//                         PromoCard(
//                           imageAsset: 'assets/images/work.jpg',
//                           title: 'Kerja Produktif',
//                           desc:
//                               'Tingkatkan produktivitas dengan manajemen waktu yang baik.',
//                         ),
//                         PromoCard(
//                           imageAsset: 'assets/images/fokus.jpg',
//                           title: 'Fokus & Semangat',
//                           desc:
//                               'Jaga fokus dan semangat untuk hasil kerja terbaik.',
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 12),
//                   SmoothPageIndicator(
//                     controller: _pageController,
//                     count: 3,
//                     effect: ExpandingDotsEffect(
//                       dotHeight: 8,
//                       dotWidth: 8,
//                       activeDotColor: AppColors.primary,
//                       dotColor: const Color(0xFFE0E7F3),
//                       expansionFactor: 3,
//                       spacing: 8,
//                     ),
//                   ),
//                   const SizedBox(height: 6),
//                 ],
//               ),
//             ),
//           ),
//           // ---- MENU GRID ----
//           SliverPadding(
//             padding: const EdgeInsets.fromLTRB(20, 8, 20, 14),
//             sliver: SliverToBoxAdapter(
//               child: Surface(
//                 padding: const EdgeInsets.all(14),
//                 child: GridView.count(
//                   crossAxisCount: 3,
//                   mainAxisSpacing: 14,
//                   crossAxisSpacing: 14,
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   children: [
//                     IconTile(
//                       icon: Icons.calendar_today,
//                       iconColor: AppColors.primary,
//                       label: 'KALENDER',
//                       textColor: Colors.black87,
//                       labelStyle: const TextStyle(
//                         color: Colors.black87,
//                         fontWeight: FontWeight.w700,
//                         fontSize: 12,
//                         letterSpacing: 0.6,
//                       ),
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => const CalendarPage(),
//                           ),
//                         );
//                       },
//                     ),
//                     IconTile(
//                       icon: Icons.receipt_long,
//                       iconColor: AppColors.primary,
//                       label: 'SLIP GAJI',
//                       textColor: Colors.black87,
//                       labelStyle: const TextStyle(
//                         color: Colors.black87,
//                         fontWeight: FontWeight.w700,
//                         fontSize: 12,
//                         letterSpacing: 0.6,
//                       ),
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => const SlipGajiPage(),
//                           ),
//                         );
//                       },
//                     ),
//                     IconTile(
//                       icon: Icons.list_alt,
//                       iconColor: AppColors.primary,
//                       label: 'DAFTAR ABSEN',
//                       textColor: Colors.black87,
//                       labelStyle: const TextStyle(
//                         color: Colors.black87,
//                         fontWeight: FontWeight.w700,
//                         fontSize: 12,
//                         letterSpacing: 0.4,
//                       ),
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => const DaftarAbsenPage(absensi: []),
//                           ),
//                         );
//                       },
//                     ),
//                     IconTile(
//                       icon: Icons.access_time,
//                       iconColor: AppColors.primary,
//                       label: 'LEMBUR',
//                       textColor: Colors.black87,
//                       labelStyle: const TextStyle(
//                         color: Colors.black87,
//                         fontWeight: FontWeight.w700,
//                         fontSize: 12,
//                         letterSpacing: 0.4,
//                       ),
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(builder: (_) => const LemburPage()),
//                         );
//                       },
//                     ),
//                     IconTile(
//                       icon: Icons.attach_money,
//                       iconColor: AppColors.primary,
//                       label: 'REIMBURSE',
//                       textColor: Colors.black87,
//                       labelStyle: const TextStyle(
//                         color: Colors.black87,
//                         fontWeight: FontWeight.w700,
//                         fontSize: 12,
//                         letterSpacing: 0.2,
//                       ),
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) => const ReimbursementListPage(),
//                           ),
//                         );
//                       },
//                     ),
//                     IconTile(
//                       icon: Icons.camera_alt,
//                       iconColor: AppColors.primary,
//                       label: 'ABSEN',
//                       textColor: Colors.black87,
//                       labelStyle: const TextStyle(
//                         color: Colors.black87,
//                         fontWeight: FontWeight.w700,
//                         fontSize: 12,
//                         letterSpacing: 0.6,
//                       ),
//                       onTap: () {
//                         final userId =
//                             FirebaseAuth.instance.currentUser?.uid ?? 'guest';
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (_) =>
//                                 AbsensiDashboardPage(userId: userId),
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),

//           // ---- PENGUMUMAN ----
//           SliverPadding(
//             padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),
//             sliver: SliverToBoxAdapter(
//               child: SectionCard(
//                 title: 'Pengumuman',
//                 actionText: 'Lihat semua',
//                 onActionTap: () {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(
//                       builder: (_) => const AllPengumumanPage(),
//                     ),
//                   );
//                 },
//                 titleStyle: const TextStyle(
//                   color: Colors.black87,
//                   fontWeight: FontWeight.w800,
//                   fontSize: 16,
//                 ),
//                 actionTextStyle: const TextStyle(
//                   color: AppColors.primary,
//                   fontWeight: FontWeight.w700,
//                   fontSize: 14,
//                 ),
//                 child: const EmptyState(
//                   title: 'Belum ada pengumuman',
//                   subtitle: 'Pengumuman akan tampil disini',
//                   titleStyle: TextStyle(
//                     color: Colors.black87,
//                     fontWeight: FontWeight.w600,
//                   ),
//                   subtitleStyle: TextStyle(color: Colors.black54),
//                 ),
//               ),
//             ),
//           ),

//           // ---- TUGAS ----
//           SliverPadding(
//             padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
//             sliver: SliverToBoxAdapter(
//               child: SectionCard(
//                 title: 'Tugas',
//                 actionText: 'Lihat semua',
//                 onActionTap: () {
//                   Navigator.of(context).push(
//                     MaterialPageRoute(builder: (_) => const AllTugasPage()),
//                   );
//                 },
//                 titleStyle: const TextStyle(
//                   color: Colors.black87,
//                   fontWeight: FontWeight.w800,
//                   fontSize: 16,
//                 ),
//                 actionTextStyle: const TextStyle(
//                   color: AppColors.primary,
//                   fontWeight: FontWeight.w700,
//                   fontSize: 14,
//                 ),
//                 child: const EmptyState(
//                   title: 'Tidak ada tugas',
//                   subtitle: 'Anda tidak memiliki tugas yang tertunda',
//                   titleStyle: TextStyle(
//                     color: Colors.black87,
//                     fontWeight: FontWeight.w600,
//                   ),
//                   subtitleStyle: TextStyle(color: Colors.black54),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // --- HEADER PROFILES, AUTO-DATA FROM FIREBASE AUTH ---
// class GreetingHeader extends StatefulWidget {
//   const GreetingHeader({super.key});

//   @override
//   State<GreetingHeader> createState() => _GreetingHeaderState();
// }

// class _GreetingHeaderState extends State<GreetingHeader> {
//   late Future<Map<String, dynamic>> _userDataFuture;

//   @override
//   void initState() {
//     super.initState();
//     _userDataFuture = _fetchUserData();
//   }

//   Future<Map<String, dynamic>> _fetchUserData() async {
//     final user = FirebaseAuth.instance.currentUser;
//     String displayName = await AuthHelper.getCurrentUserName();
//     String companyName = await AuthHelper.getCurrentUserCompanyName();
//     String photoUrl = user?.photoURL ?? '';

//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('user_name', displayName);
//     await prefs.setString('user_company', companyName);
//     await prefs.setString('user_photo', photoUrl);

//     return {
//       'name': displayName,
//       'companyName': companyName,
//       'photoUrl': photoUrl,
//     };
//   }

//   String getInitials(String name) {
//     final cleanName = name.trim();

//     if (cleanName.isEmpty) return 'U';

//     final parts = cleanName.split(' ').where((p) => p.isNotEmpty).toList();

//     if (parts.isEmpty) return 'U';

//     if (parts.length == 1) {
//       return parts[0][0].toUpperCase();
//     }

//     return (parts[0][0] + parts.last[0]).toUpperCase();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<Map<String, dynamic>>(
//       future: _userDataFuture,
//       builder: (context, snapshot) {
//         final userName = snapshot.hasData
//             ? snapshot.data!['name'] as String
//             : 'User';
//         final photoUrl = snapshot.hasData
//             ? snapshot.data!['photoUrl'] as String
//             : '';
//         final companyName = snapshot.hasData
//             ? snapshot.data!['companyName'] as String
//             : 'Unknown Company';

//         return Container(
//           width: double.infinity,
//           color: AppColors.extraLight,
//           padding: const EdgeInsets.only(top: 16, left: 0, right: 0, bottom: 8),
//           child: Center(
//             child: Container(
//               height: 58,
//               margin: const EdgeInsets.symmetric(horizontal: 16),
//               decoration: BoxDecoration(
//                 color: AppColors.primary,
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Row(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const SizedBox(width: 10),
//                   photoUrl.isNotEmpty
//                       ? CircleAvatar(
//                           radius: 20,
//                           backgroundColor: Colors.white,
//                           backgroundImage: NetworkImage(photoUrl),
//                         )
//                       : CircleAvatar(
//                           radius: 20,
//                           backgroundColor: Colors.white,
//                           child: Text(
//                             getInitials(userName),
//                             style: TextStyle(
//                               color: AppColors.primary,
//                               fontWeight: FontWeight.bold,
//                               fontSize: 16,
//                             ),
//                           ),
//                         ),
//                   const SizedBox(width: 14),
//                   Expanded(
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           userName,
//                           maxLines: 1,
//                           overflow: TextOverflow.ellipsis,
//                           style: const TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                           ),
//                         ),
//                         const SizedBox(height: 2),
//                         Text(
//                           companyName,
//                           style: TextStyle(
//                             color: Colors.white.withOpacity(0.85),
//                             fontSize: 12,
//                             fontWeight: FontWeight.w400,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   IconButton(
//                     icon: const Icon(
//                       Icons.notifications_none_rounded,
//                       color: Colors.white,
//                       size: 22,
//                     ),
//                     onPressed: () {
//                       // TODO: Ke halaman notifikasi
//                     },
//                   ),
//                   const SizedBox(width: 8),
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

// // Halaman Pengumuman & Tugas
// class AllPengumumanPage extends StatelessWidget {
//   const AllPengumumanPage({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.extraLight,
//       appBar: AppBar(
//         title: const Text(
//           'Semua Pengumuman',
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: AppColors.primary,
//         iconTheme: const IconThemeData(color: Colors.white),
//         elevation: 0,
//       ),
//       body: const Center(
//         child: Text(
//           'Daftar semua pengumuman',
//           style: TextStyle(color: Colors.black, fontSize: 16),
//         ),
//       ),
//     );
//   }
// }

// class AllTugasPage extends StatelessWidget {
//   const AllTugasPage({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.extraLight,
//       appBar: AppBar(
//         title: const Text('Semua Tugas', style: TextStyle(color: Colors.white)),
//         backgroundColor: AppColors.primary,
//         iconTheme: const IconThemeData(color: Colors.white),
//         elevation: 0,
//       ),
//       body: const Center(
//         child: Text(
//           'Daftar semua tugas',
//           style: TextStyle(color: Colors.black, fontSize: 16),
//         ),
//       ),
//     );
//   }
// }
