

// import 'package:flutter/material.dart';

// class CustomBottomNavigationBar extends StatefulWidget {
//   final int currentIndex;
//   final Function(int) onItemTapped;

//   const CustomBottomNavigationBar({
//     super.key,
//     required this.currentIndex,
//     required this.onItemTapped,
//   });

//   @override
//   State<CustomBottomNavigationBar> createState() =>
//       _CustomBottomNavigationBarState();
// }

// class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
//   late int _currentIndex;

//   @override
//   void initState() {
//     super.initState();
//     _currentIndex = widget.currentIndex;
//   }

//   @override
//   void didUpdateWidget(CustomBottomNavigationBar oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.currentIndex != _currentIndex) {
//       setState(() {
//         _currentIndex = widget.currentIndex;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isMobile = screenWidth < 600;

//     return Container(
//       height: isMobile ? 70 : 80,
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [Colors.white.withOpacity(0.95), Color(0xFFE0F2FE)],
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.blueGrey.withOpacity(0.15),
//             blurRadius: 20,
//             spreadRadius: 1,
//             offset: Offset(0, -5),
//           ),
//           BoxShadow(
//             color: Colors.white.withOpacity(0.9),
//             blurRadius: 10,
//             spreadRadius: 2,
//             offset: Offset(0, -2),
//           ),
//         ],
//         border: Border(
//           top: BorderSide(color: Colors.blueAccent.withOpacity(0.1), width: 1),
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           _buildNavItem(
//             index: 0,
//             icon: Icons.home_rounded,
//             activeIcon: Icons.home_filled,
//             label: 'BERANDA',
//             isMobile: isMobile,
//             gradient: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
//           ),
//           _buildNavItem(
//             index: 1,
//             icon: Icons.description_outlined,
//             activeIcon: Icons.description_rounded,
//             label: 'PENGAJUAN',
//             isMobile: isMobile,
//             gradient: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
//           ),
//           _buildNavItem(
//             index: 2,
//             icon: Icons.chat_bubble_outline_rounded,
//             activeIcon: Icons.chat_bubble_rounded,
//             label: 'PESAN',
//             isMobile: isMobile,
//             gradient: [Color(0xFF10B981), Color(0xFF059669)],
//           ),
//           _buildNavItem(
//             index: 3,
//             icon: Icons.person_outline_rounded,
//             activeIcon: Icons.person_rounded,
//             label: 'PROFIL',
//             isMobile: isMobile,
//             gradient: [Color(0xFFF59E0B), Color(0xFFD97706)],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNavItem({
//     required int index,
//     required IconData icon,
//     required IconData activeIcon,
//     required String label,
//     required bool isMobile,
//     required List<Color> gradient,
//   }) {
//     final bool isActive = _currentIndex == index;
//     final double iconSize = isMobile ? 22 : 26;
//     final double activeIconSize = isMobile ? 26 : 30;

//     return Expanded(
//       child: GestureDetector(
//         onTap: () {
//           widget.onItemTapped(index);
//         },
//         child: Container(
//           margin: const EdgeInsets.symmetric(horizontal: 4),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Animated icon container
//               AnimatedContainer(
//                 duration: const Duration(milliseconds: 300),
//                 curve: Curves.easeInOut,
//                 width: isActive ? (isMobile ? 50 : 55) : (isMobile ? 40 : 45),
//                 height: isActive ? (isMobile ? 50 : 55) : (isMobile ? 40 : 45),
//                 decoration: BoxDecoration(
//                   gradient: isActive
//                       ? LinearGradient(
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                           colors: gradient,
//                         )
//                       : null,
//                   color: isActive ? null : Colors.transparent,
//                   shape: BoxShape.circle,
//                   boxShadow: isActive
//                       ? [
//                           BoxShadow(
//                             color: gradient[0].withOpacity(0.4),
//                             blurRadius: 12,
//                             spreadRadius: 2,
//                             offset: const Offset(0, 4),
//                           ),
//                           BoxShadow(
//                             color: Colors.white.withOpacity(0.9),
//                             blurRadius: 5,
//                             spreadRadius: 1,
//                             offset: const Offset(0, -2),
//                           ),
//                         ]
//                       : null,
//                   border: isActive
//                       ? null
//                       : Border.all(
//                           color: Colors.blueGrey.withOpacity(0.1),
//                           width: 1.5,
//                         ),
//                 ),
//                 child: Stack(
//                   children: [
//                     // Glow effect for active item
//                     if (isActive)
//                       Positioned.fill(
//                         child: Container(
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             gradient: RadialGradient(
//                               colors: [
//                                 gradient[0].withOpacity(0.2),
//                                 Colors.transparent,
//                               ],
//                               radius: 0.8,
//                             ),
//                           ),
//                         ),
//                       ),

//                     // Icon with animation
//                     Center(
//                       child: AnimatedSwitcher(
//                         duration: const Duration(milliseconds: 300),
//                         transitionBuilder: (child, animation) {
//                           return ScaleTransition(
//                             scale: animation,
//                             child: child,
//                           );
//                         },
//                         child: Icon(
//                           isActive ? activeIcon : icon,
//                           key: ValueKey<bool>(isActive),
//                           size: isActive ? activeIconSize : iconSize,
//                           color: isActive ? Colors.white : Color(0xFF6B7280),
//                         ),
//                       ),
//                     ),

//                     // Notification badge (example for messages)
//                     if (index == 2)
//                       Positioned(
//                         top: 4,
//                         right: 4,
//                         child: Container(
//                           width: 8,
//                           height: 8,
//                           decoration: BoxDecoration(
//                             color: Colors.redAccent,
//                             shape: BoxShape.circle,
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.redAccent.withOpacity(0.5),
//                                 blurRadius: 3,
//                                 spreadRadius: 1,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 4),

//               // Label with animation
//               AnimatedContainer(
//                 duration: const Duration(milliseconds: 200),
//                 child: Text(
//                   label,
//                   style: TextStyle(
//                     fontSize: isMobile ? 10 : 11,
//                     fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
//                     color: isActive ? gradient[0] : Color(0xFF6B7280),
//                     letterSpacing: -0.2,
//                     shadows: isActive
//                         ? [
//                             Shadow(
//                               blurRadius: 1,
//                               color: gradient[0].withOpacity(0.3),
//                               offset: const Offset(0, 1),
//                             ),
//                           ]
//                         : null,
//                   ),
//                 ),
//               ),

//               // Active indicator line
//               AnimatedContainer(
//                 duration: const Duration(milliseconds: 300),
//                 curve: Curves.easeInOut,
//                 margin: const EdgeInsets.only(top: 4),
//                 width: isActive ? 24 : 0,
//                 height: 3,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(colors: gradient),
//                   borderRadius: BorderRadius.circular(2),
//                   boxShadow: [
//                     BoxShadow(
//                       color: gradient[0].withOpacity(0.4),
//                       blurRadius: 4,
//                       spreadRadius: 1,
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
// }

// // Advanced version with floating action button in the middle
// class CustomBottomNavigationBarV2 extends StatefulWidget {
//   final int currentIndex;
//   final Function(int) onItemTapped;

//   const CustomBottomNavigationBarV2({
//     super.key,
//     required this.currentIndex,
//     required this.onItemTapped,
//   });

//   @override
//   State<CustomBottomNavigationBarV2> createState() =>
//       _CustomBottomNavigationBarV2State();
// }

// class _CustomBottomNavigationBarV2State
//     extends State<CustomBottomNavigationBarV2> {
//   late int _currentIndex;

//   @override
//   void initState() {
//     super.initState();
//     _currentIndex = widget.currentIndex;
//   }

//   @override
//   void didUpdateWidget(CustomBottomNavigationBarV2 oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.currentIndex != _currentIndex) {
//       setState(() {
//         _currentIndex = widget.currentIndex;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     final isMobile = screenWidth < 600;

//     return Container(
//       height: isMobile ? 80 : 90,
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.97),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.08),
//             blurRadius: 25,
//             spreadRadius: 2,
//             offset: const Offset(0, -8),
//           ),
//         ],
//         borderRadius: const BorderRadius.only(
//           topLeft: Radius.circular(25),
//           topRight: Radius.circular(25),
//         ),
//       ),
//       child: Stack(
//         children: [
//           // Background pattern
//           Positioned.fill(
//             child: Opacity(
//               opacity: 0.03,
//               child: Container(
//                 decoration: BoxDecoration(
//                   image: DecorationImage(
//                     image: AssetImage(
//                       'assets/images/nav_pattern.png',
//                     ), // Add your pattern image
//                     repeat: ImageRepeat.repeat,
//                   ),
//                 ),
//               ),
//             ),
//           ),

//           // Navigation items
//           Row(
//             children: [
//               _buildNavItemV2(
//                 index: 0,
//                 icon: Icons.dashboard_outlined,
//                 activeIcon: Icons.dashboard_rounded,
//                 label: 'Beranda',
//                 isMobile: isMobile,
//               ),
//               _buildNavItemV2(
//                 index: 1,
//                 icon: Icons.file_copy_outlined,
//                 activeIcon: Icons.file_copy_rounded,
//                 label: 'Pengajuan',
//                 isMobile: isMobile,
//               ),

//               // Spacer for middle button
//               Spacer(),

//               // Floating action button in middle
//               Transform.translate(
//                 offset: const Offset(0, -25),
//                 child: GestureDetector(
//                   onTap: () => widget.onItemTapped(2),
//                   child: Container(
//                     width: isMobile ? 60 : 70,
//                     height: isMobile ? 60 : 70,
//                     decoration: BoxDecoration(
//                       gradient: const LinearGradient(
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                         colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
//                       ),
//                       shape: BoxShape.circle,
//                       boxShadow: [
//                         BoxShadow(
//                           color: Color(0xFF6366F1).withOpacity(0.4),
//                           blurRadius: 15,
//                           spreadRadius: 3,
//                           offset: const Offset(0, 8),
//                         ),
//                         BoxShadow(
//                           color: Colors.white.withOpacity(0.9),
//                           blurRadius: 10,
//                           spreadRadius: 2,
//                           offset: const Offset(0, -3),
//                         ),
//                       ],
//                       border: Border.all(color: Colors.white, width: 4),
//                     ),
//                     child: Stack(
//                       children: [
//                         // Animated ripple effect
//                         Positioned.fill(
//                           child: AnimatedContainer(
//                             duration: const Duration(milliseconds: 2000),
//                             curve: Curves.easeInOut,
//                             decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               gradient: RadialGradient(
//                                 colors: [
//                                   Colors.white.withOpacity(
//                                     _currentIndex == 2 ? 0.2 : 0,
//                                   ),
//                                   Colors.transparent,
//                                 ],
//                                 radius: 0.8,
//                               ),
//                             ),
//                           ),
//                         ),

//                         Center(
//                           child: Icon(
//                             Icons.qr_code_scanner_rounded,
//                             size: isMobile ? 28 : 32,
//                             color: Colors.white,
//                           ),
//                         ),

//                         // Pulse animation for active state
//                         if (_currentIndex == 2)
//                           Positioned.fill(
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 gradient: RadialGradient(
//                                   colors: [
//                                     Colors.white.withOpacity(0.1),
//                                     Colors.transparent,
//                                   ],
//                                   stops: [0.5, 1.0],
//                                 ),
//                               ),
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),

//               Spacer(),

//               _buildNavItemV2(
//                 index: 3,
//                 icon: Icons.chat_outlined,
//                 activeIcon: Icons.chat_rounded,
//                 label: 'Pesan',
//                 isMobile: isMobile,
//               ),
//               _buildNavItemV2(
//                 index: 4,
//                 icon: Icons.person_outline,
//                 activeIcon: Icons.person_rounded,
//                 label: 'Profil',
//                 isMobile: isMobile,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNavItemV2({
//     required int index,
//     required IconData icon,
//     required IconData activeIcon,
//     required String label,
//     required bool isMobile,
//   }) {
//     final bool isActive = _currentIndex == index;
//     final Map<int, Color> colorMap = {
//       0: Color(0xFF3B82F6),
//       1: Color(0xFF8B5CF6),
//       3: Color(0xFF10B981),
//       4: Color(0xFFF59E0B),
//     };
//     final Color color = colorMap[index] ?? Color(0xFF6B7280);

//     return Expanded(
//       child: GestureDetector(
//         onTap: () => widget.onItemTapped(index),
//         child: Container(
//           height: double.infinity,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Icon with background glow
//               Container(
//                 width: isMobile ? 36 : 40,
//                 height: isMobile ? 36 : 40,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   gradient: RadialGradient(
//                     colors: [
//                       isActive ? color.withOpacity(0.15) : Colors.transparent,
//                       Colors.transparent,
//                     ],
//                     radius: 1.0,
//                   ),
//                 ),
//                 child: Center(
//                   child: AnimatedSwitcher(
//                     duration: const Duration(milliseconds: 300),
//                     transitionBuilder: (child, animation) {
//                       return ScaleTransition(scale: animation, child: child);
//                     },
//                     child: Icon(
//                       isActive ? activeIcon : icon,
//                       key: ValueKey<bool>(isActive),
//                       size: isMobile ? 22 : 24,
//                       color: isActive ? color : Color(0xFF9CA3AF),
//                     ),
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 6),

//               // Label with animation
//               AnimatedContainer(
//                 duration: const Duration(milliseconds: 200),
//                 padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
//                 decoration: BoxDecoration(
//                   color: isActive ? color.withOpacity(0.1) : Colors.transparent,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Text(
//                   label,
//                   style: TextStyle(
//                     fontSize: isMobile ? 10 : 11,
//                     fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
//                     color: isActive ? color : Color(0xFF9CA3AF),
//                     letterSpacing: -0.1,
//                   ),
//                 ),
//               ),

//               // Animated dot indicator
//               AnimatedContainer(
//                 duration: const Duration(milliseconds: 300),
//                 margin: const EdgeInsets.only(top: 4),
//                 width: isActive ? 6 : 0,
//                 height: isActive ? 6 : 0,
//                 decoration: BoxDecoration(
//                   color: color,
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: color.withOpacity(0.5),
//                       blurRadius: 4,
//                       spreadRadius: 1,
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
// }

// // Version 3: Modern minimalist with curved design
// class CustomBottomNavigationBarV3 extends StatelessWidget {
//   final int currentIndex;
//   final Function(int) onItemTapped;

//   const CustomBottomNavigationBarV3({
//     super.key,
//     required this.currentIndex,
//     required this.onItemTapped,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 90,
//       decoration: BoxDecoration(color: Colors.transparent),
//       child: Stack(
//         children: [
//           // Curved background
//           Positioned.fill(child: CustomPaint(painter: _NavBarPainter())),

//           // Navigation items
//           Positioned.fill(
//             top: 15,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 _buildNavItemV3(
//                   index: 0,
//                   icon: Icons.home_outlined,
//                   activeIcon: Icons.home_filled,
//                   label: 'Beranda',
//                 ),
//                 _buildNavItemV3(
//                   index: 1,
//                   icon: Icons.description_outlined,
//                   activeIcon: Icons.description,
//                   label: 'Pengajuan',
//                 ),
//                 _buildNavItemV3(
//                   index: 2,
//                   icon: Icons.chat_outlined,
//                   activeIcon: Icons.chat,
//                   label: 'Pesan',
//                 ),
//                 _buildNavItemV3(
//                   index: 3,
//                   icon: Icons.person_outlined,
//                   activeIcon: Icons.person,
//                   label: 'Profil',
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNavItemV3({
//     required int index,
//     required IconData icon,
//     required IconData activeIcon,
//     required String label,
//   }) {
//     final bool isActive = currentIndex == index;

//     return GestureDetector(
//       onTap: () => onItemTapped(index),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Container(
//             width: 48,
//             height: 48,
//             decoration: BoxDecoration(
//               color: isActive ? Colors.white : Colors.transparent,
//               shape: BoxShape.circle,
//               boxShadow: isActive
//                   ? [
//                       BoxShadow(
//                         color: Colors.blueAccent.withOpacity(0.2),
//                         blurRadius: 12,
//                         spreadRadius: 3,
//                         offset: const Offset(0, 4),
//                       ),
//                     ]
//                   : null,
//             ),
//             child: Center(
//               child: Icon(
//                 isActive ? activeIcon : icon,
//                 size: 24,
//                 color: isActive ? Colors.blueAccent : Colors.white,
//               ),
//             ),
//           ),
//           const SizedBox(height: 8),
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 12,
//               fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
//               color: isActive
//                   ? Colors.blueAccent
//                   : Colors.white.withOpacity(0.8),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _NavBarPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = Colors.blueAccent
//       ..style = PaintingStyle.fill;

//     final path = Path()
//       ..moveTo(0, 20)
//       ..quadraticBezierTo(size.width * 0.2, 0, size.width * 0.4, 0)
//       ..quadraticBezierTo(size.width * 0.5, -20, size.width * 0.6, 0)
//       ..quadraticBezierTo(size.width * 0.8, 0, size.width, 20)
//       ..lineTo(size.width, size.height)
//       ..lineTo(0, size.height)
//       ..close();

//     canvas.drawPath(path, paint);

//     // Add subtle shadow
//     final shadowPaint = Paint()
//       ..color = Colors.black.withOpacity(0.1)
//       ..maskFilter = MaskFilter.blur(BlurStyle.normal, 10);

//     canvas.drawPath(path, shadowPaint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
// }

import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class BottomNav extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;

  const BottomNav({super.key, required this.index, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 16,
            offset: Offset(0, -6),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: NavigationBar(
        selectedIndex: index,
        onDestinationSelected: onChanged,
        backgroundColor: Colors.white,
        elevation: 0,
        indicatorColor: AppColors.primaryLight,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded, color: AppColors.primary),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.send_outlined),
            selectedIcon: Icon(Icons.send_rounded, color: AppColors.primary),
            label: 'Pengajuan',
          ),
          NavigationDestination(
            icon: Icon(Icons.inbox_outlined),
            selectedIcon: Icon(Icons.inbox_rounded, color: AppColors.primary),
            label: 'Inbox',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person_rounded, color: AppColors.primary),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
