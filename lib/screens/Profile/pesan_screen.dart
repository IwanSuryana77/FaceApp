import 'package:flutter/material.dart';

class PesanScreen extends StatelessWidget {
  const PesanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(
                isMobile ? 16 : 24,
                isMobile ? 40 : 50,
                isMobile ? 16 : 24,
                isMobile ? 16 : 24,
              ),
              child: Row(
                children: [
                  Text(
                    'Pesan',
                    style: TextStyle(
                      fontSize: isMobile ? 24 : 28,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Cari pesan...',
                  prefixIcon: Icon(Icons.search, color: const Color(0xFF4B5563)),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 16 : 20,
                    vertical: isMobile ? 12 : 14,
                  ),
                ),
              ),
            ),

            SizedBox(height: isMobile ? 20 : 24),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
              child: Text(
                'PESAN TERBARU',
                style: TextStyle(
                  fontSize: isMobile ? 16 : 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ),

            SizedBox(height: isMobile ? 12 : 16),

            // Daftar Pesan
            _buildMessageItem(
              context,
              'Admin HR',
              'Pengumuman libur nasional',
              'Hari ini • 09:30',
              Icons.notifications,
              true,
              isMobile,
            ),
            SizedBox(height: isMobile ? 8 : 12),
            _buildMessageItem(
              context,
              'Manager',
              'Laporan bulanan perlu direview',
              'Kemarin • 14:45',
              Icons.person,
              false,
              isMobile,
            ),
            SizedBox(height: isMobile ? 8 : 12),
            _buildMessageItem(
              context,
              'Tim IT',
              'Maintenance sistem hari Sabtu',
              '2 hari lalu • 11:20',
              Icons.computer,
              false,
              isMobile,
            ),
            SizedBox(height: isMobile ? 8 : 12),
            _buildMessageItem(
              context,
              'Finance',
              'Slip gaji sudah tersedia',
              '3 hari lalu • 16:05',
              Icons.attach_money,
              false,
              isMobile,
            ),

            SizedBox(height: isMobile ? 40 : 60),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageItem(
    BuildContext context,
    String sender,
    String message,
    String time,
    IconData icon,
    bool isNew,
    bool isMobile,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 14 : 18),
          child: Row(
            children: [
              Container(
                width: isMobile ? 45 : 50,
                height: isMobile ? 45 : 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)],
                  ),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: isMobile ? 20 : 24,
                ),
              ),
              SizedBox(width: isMobile ? 16 : 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          sender,
                          style: TextStyle(
                            fontSize: isMobile ? 16 : 18,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF1E293B),
                          ),
                        ),
                        if (isNew)
                          Container(
                            margin: EdgeInsets.only(left: isMobile ? 8 : 12),
                            padding: EdgeInsets.symmetric(
                              horizontal: isMobile ? 6 : 8,
                              vertical: isMobile ? 2 : 3,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEF4444),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Baru',
                              style: TextStyle(
                                fontSize: isMobile ? 10 : 12,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: isMobile ? 4 : 6),
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: isMobile ? 13 : 14,
                        color: const Color(0xFF4B5563),
                        height: 1.4,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Text(
                time,
                style: TextStyle(
                  fontSize: isMobile ? 11 : 13,
                  color: const Color(0xFF64748B),
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ),
      ),
    );
  }
}