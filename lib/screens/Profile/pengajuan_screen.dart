import 'package:flutter/material.dart';

class PengajuanScreen extends StatelessWidget {
  const PengajuanScreen({super.key});

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
                    'Pengajuan',
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
              child: Text(
                'AJUKAN PERMOHONAN',
                style: TextStyle(
                  fontSize: isMobile ? 16 : 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1E293B),
                ),
              ),
            ),

            SizedBox(height: isMobile ? 16 : 20),

            _buildPengajuanCard(
              context,
              Icons.calendar_today,
              'Cuti',
              'Ajukan izin cuti untuk liburan atau keperluan pribadi',
              const Color(0xFF3B82F6),
              isMobile,
            ),
            SizedBox(height: isMobile ? 12 : 16),
            _buildPengajuanCard(
              context,
              Icons.access_time,
              'Lembur',
              'Ajukan permohonan lembur untuk pekerjaan ekstra',
              const Color(0xFFF59E0B),
              isMobile,
            ),
            SizedBox(height: isMobile ? 12 : 16),
            _buildPengajuanCard(
              context,
              Icons.medical_services,
              'Sakit',
              'Ajukan izin sakit dengan melampirkan surat dokter',
              const Color(0xFFEF4444),
              isMobile,
            ),
            SizedBox(height: isMobile ? 12 : 16),
            _buildPengajuanCard(
              context,
              Icons.money,
              'Reimbursement',
              'Ajukan penggantian biaya perjalanan dinas atau lainnya',
              const Color(0xFFEC4899),
              isMobile,
            ),

            SizedBox(height: isMobile ? 40 : 60),
          ],
        ),
      ),
    );
  }

  Widget _buildPengajuanCard(
    BuildContext context,
    IconData icon,
    String title,
    String description,
    Color color,
    bool isMobile,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
      child: GestureDetector(
        onTap: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Membuka pengajuan $title')));
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.15),
                spreadRadius: 1,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(isMobile ? 16 : 20),
            child: Row(
              children: [
                Container(
                  width: isMobile ? 50 : 60,
                  height: isMobile ? 50 : 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [color.withOpacity(0.9), color.withOpacity(0.7)],
                    ),
                  ),
                  child: Icon(
                    icon,
                    color: Colors.white,
                    size: isMobile ? 24 : 28,
                  ),
                ),
                SizedBox(width: isMobile ? 16 : 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: isMobile ? 18 : 20,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                      SizedBox(height: isMobile ? 6 : 8),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: isMobile ? 13 : 14,
                          color: const Color(0xFF4B5563),
                          height: 1.5,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  size: isMobile ? 16 : 18,
                  color: const Color(0xFF4B5563),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
