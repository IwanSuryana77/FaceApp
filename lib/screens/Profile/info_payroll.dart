import 'package:flutter/material.dart';
import 'dart:math';

class InfoPayrollScreen extends StatefulWidget {
  const InfoPayrollScreen({super.key});

  @override
  State<InfoPayrollScreen> createState() => _InfoPayrollScreenState();
}

class _InfoPayrollScreenState extends State<InfoPayrollScreen>
    with TickerProviderStateMixin {
  final primaryColor = const Color(0xFF0D1B2A);
  final secondaryColor = const Color(0xFF1B3A5C);
  final accentColor = const Color(0xFFC9A227);
  final successColor = const Color(0xFF2A9D8F);
  final warningColor = const Color(0xFFE76F51);
  final backgroundColor = const Color(0xFFF5F7FA);
  final cardColor = const Color(0xFFFFFFFF);
  final moneyColor = const Color(0xFF27C227);

  late AnimationController _animationController;
  late Animation<double> _animation;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _moneyController;
  late Animation<double> _moneyAnimation;
  late AnimationController _waveController;
  final Map<String, bool> _hoverStates = {};
  final Map<String, bool> _expandedStates = {
    'salary': false,
    'details': false,
    'deductions': false,
  };

  int _selectedMonth = DateTime.now().month - 1;
  int _selectedYear = DateTime.now().year;

  final List<String> months = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  final List<int> years = [2023, 2024, 2025, 2026];

  @override
  void initState() {
    super.initState();

    if (!years.contains(_selectedYear)) {
      _selectedYear = years.last;
    }

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..forward();

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _moneyController = AnimationController(
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

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutSine),
    );

    _moneyAnimation = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _moneyController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    _moneyController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  void _triggerRipple() {
    _moneyController.forward(from: 0);
  }

  void _toggleExpand(String section) {
    setState(() {
      _expandedStates[section] = !_expandedStates[section]!;
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
                  _buildEnhancedPayrollHeader(context, isMobile),
                  const SizedBox(height: 24),
                  _buildEnhancedMonthSelector(context, isMobile),
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
                    _buildEnhancedSalarySummary(context, isMobile),
                    const SizedBox(height: 24),
                    _buildEnhancedSalaryDetails(context, isMobile),
                    const SizedBox(height: 24),
                    _buildEnhancedDeductions(context, isMobile),
                    const SizedBox(height: 32),
                    _buildEnhancedActionButtons(context, isMobile),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ]),
          ),
        ],
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
            animation: _moneyController,
            builder: (context, child) {
              return Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: moneyColor.withOpacity(
                    0.8 + _moneyController.value * 0.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: moneyColor.withOpacity(
                        0.3 + _moneyController.value * 0.2,
                      ),
                      blurRadius: 8,
                    ),
                  ],
                ),
              );
            },
          ),
          Text(
            'Info Payroll',
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
          onEnter: (_) => setState(() => _hoverStates['download'] = true),
          onExit: (_) => setState(() => _hoverStates['download'] = false),
          child: GestureDetector(
            onTap: _downloadPayroll,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 8),
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 20,
                vertical: isMobile ? 8 : 10,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0D1B2A), Color(0xFF1B3A5C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(
                      (_hoverStates['download'] ?? false) ? 0.4 : 0.3,
                    ),
                    blurRadius: (_hoverStates['download'] ?? false) ? 12 : 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.download_rounded,
                    color: Colors.white,
                    size: isMobile ? 20 : 22,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Download',
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

  Widget _buildEnhancedPayrollHeader(BuildContext context, bool isMobile) {
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
            onTap: () => _showPayrollStats(context, isMobile),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFFFFF), Color(0xFFF8FAFC)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(isMobile ? 20 : 24),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(
                      (_hoverStates['header'] ?? false) ? 0.15 : 0.1,
                    ),
                    spreadRadius: 2,
                    blurRadius: (_hoverStates['header'] ?? false) ? 25 : 20,
                    offset: const Offset(0, 8),
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
              padding: EdgeInsets.all(isMobile ? 24 : 28),
              child: Column(
                children: [
                  Row(
                    children: [
                      ScaleTransition(
                        scale: _pulseAnimation,
                        child: Container(
                          width: isMobile ? 70 : 80,
                          height: isMobile ? 70 : 80,
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
                                blurRadius: 15,
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
                            Icons.account_balance_wallet_rounded,
                            color: Colors.white,
                            size: 34,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Surya Ramadhan',
                              style: TextStyle(
                                fontSize: isMobile ? 20 : 22,
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
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildEnhancedPayrollSummary(isMobile),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedPayrollSummary(bool isMobile) {
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
                  Icons.money_rounded,
                  color: primaryColor,
                  size: isMobile ? 20 : 22,
                ),
                const SizedBox(width: 10),
                Text(
                  'Informasi Payroll',
                  style: TextStyle(
                    fontSize: isMobile ? 15 : 16,
                    fontWeight: FontWeight.w700,
                    color: primaryColor,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildEnhancedSummaryItem(
                    'Gaji Pokok',
                    'Rp 12.500.000',
                    Icons.attach_money,
                    isMobile,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
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
                Expanded(
                  child: _buildEnhancedSummaryItem(
                    'Tunjangan',
                    'Rp 3.250.000',
                    Icons.card_giftcard,
                    isMobile,
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
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
                Expanded(
                  child: _buildEnhancedSummaryItem(
                    'Total',
                    'Rp 15.750.000',
                    Icons.account_balance_wallet,
                    isMobile,
                    isTotal: true,
                  ),
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
    bool isMobile, {
    bool isTotal = false,
  }) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hoverStates['summary_$title'] = true),
      onExit: (_) => setState(() => _hoverStates['summary_$title'] = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 8 : 12,
          vertical: isMobile ? 12 : 16,
        ),
        decoration: BoxDecoration(
          color: (_hoverStates['summary_$title'] ?? false)
              ? (isTotal
                    ? successColor.withOpacity(0.1)
                    : accentColor.withOpacity(0.1))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: (_hoverStates['summary_$title'] ?? false)
                  ? (isTotal ? successColor : accentColor)
                  : primaryColor,
              size: isMobile ? 18 : 20,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isMobile ? 12 : 13,
                color: const Color(0xFF64748B),
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: isMobile ? 14 : 15,
                fontWeight: FontWeight.bold,
                color: isTotal ? successColor : primaryColor,
                shadows: isTotal
                    ? [
                        Shadow(
                          color: successColor.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedMonthSelector(BuildContext context, bool isMobile) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hoverStates['selector'] = true),
      onExit: (_) => setState(() => _hoverStates['selector'] = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(isMobile ? 20 : 24),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withOpacity(
                (_hoverStates['selector'] ?? false) ? 0.12 : 0.08,
              ),
              spreadRadius: 2,
              blurRadius: (_hoverStates['selector'] ?? false) ? 25 : 20,
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
            color: (_hoverStates['selector'] ?? false)
                ? accentColor.withOpacity(0.2)
                : Colors.white.withOpacity(0.8),
            width: 1,
          ),
        ),
        padding: EdgeInsets.all(isMobile ? 20 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AnimatedBuilder(
                  animation: _moneyController,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 0.9 + _moneyAnimation.value * 0.1,
                      child: Container(
                        width: isMobile ? 44 : 48,
                        height: isMobile ? 44 : 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              primaryColor.withOpacity(0.3),
                              primaryColor.withOpacity(0.1),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: primaryColor.withOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.calendar_today_rounded,
                          color: primaryColor,
                          size: isMobile ? 22 : 24,
                        ),
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
                        'Pilih Periode',
                        style: TextStyle(
                          fontSize: isMobile ? 18 : 20,
                          fontWeight: FontWeight.w800,
                          color: primaryColor,
                          letterSpacing: 0.8,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Pilih bulan dan tahun untuk melihat slip gaji',
                        style: TextStyle(
                          fontSize: isMobile ? 12 : 13,
                          color: const Color(0xFF64748B),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                Flexible(
                  child: _buildEnhancedDropdown(
                    'Bulan',
                    months[_selectedMonth],
                    (value) {
                      setState(() {
                        _selectedMonth = months.indexOf(value!);
                      });
                      _triggerRipple();
                    },
                    months,
                    isMobile,
                  ),
                ),
                Flexible(
                  child: _buildEnhancedDropdown(
                    'Tahun',
                    _selectedYear.toString(),
                    (value) {
                      setState(() {
                        _selectedYear = int.parse(value!);
                      });
                      _triggerRipple();
                    },
                    years.map((year) => year.toString()).toList(),
                    isMobile,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Slip Gaji untuk ${months[_selectedMonth]} $_selectedYear',
              style: TextStyle(
                fontSize: isMobile ? 13 : 14,
                color: const Color(0xFF4B5563),
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedDropdown(
    String label,
    String value,
    Function(String?) onChanged,
    List<String> items,
    bool isMobile,
  ) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hoverStates['dropdown_$label'] = true),
      onExit: (_) => setState(() => _hoverStates['dropdown_$label'] = false),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isMobile ? 14 : 15,
              color: const Color(0xFF4B5563),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [const Color(0xFFF8FAFC), const Color(0xFFF1F5F9)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: (_hoverStates['dropdown_$label'] ?? false)
                    ? accentColor.withOpacity(0.3)
                    : const Color(0xFFE2E8F0),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: primaryColor.withOpacity(
                    (_hoverStates['dropdown_$label'] ?? false) ? 0.1 : 0.05,
                  ),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 14 : 16),
              child: DropdownButton<String>(
                value: value,
                onChanged: onChanged,
                isExpanded: true,
                underline: const SizedBox(),
                icon: Icon(
                  Icons.arrow_drop_down_rounded,
                  color: primaryColor,
                  size: isMobile ? 24 : 28,
                ),
                dropdownColor: cardColor,
                borderRadius: BorderRadius.circular(12),
                elevation: 8,
                style: TextStyle(
                  fontSize: isMobile ? 15 : 16,
                  color: const Color(0xFF1E293B),
                  fontWeight: FontWeight.w600,
                ),
                items: items.map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        item,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedSalarySummary(BuildContext context, bool isMobile) {
    return _buildEnhancedSectionContainer(
      'Ringkasan Gaji',
      Icons.summarize_rounded,
      successColor,
      'salary',
      [
        _buildEnhancedSalaryItem(
          'Gaji Pokok',
          'Rp 12.500.000',
          Icons.attach_money_rounded,
          successColor,
          isMobile,
        ),
        _buildEnhancedSalaryItem(
          'Tunjangan Jabatan',
          'Rp 1.500.000',
          Icons.work_rounded,
          successColor,
          isMobile,
        ),
        _buildEnhancedSalaryItem(
          'Tunjangan Transport',
          'Rp 750.000',
          Icons.directions_car_rounded,
          successColor,
          isMobile,
        ),
        _buildEnhancedSalaryItem(
          'Tunjangan Makan',
          'Rp 1.000.000',
          Icons.restaurant_rounded,
          successColor,
          isMobile,
        ),
        const SizedBox(height: 8),
        _buildEnhancedSalaryItem(
          'Total Pendapatan',
          'Rp 15.750.000',
          Icons.add_chart_rounded,
          successColor,
          isMobile,
          isTotal: true,
        ),
      ],
      isMobile,
    );
  }

  Widget _buildEnhancedSalaryDetails(BuildContext context, bool isMobile) {
    return _buildEnhancedSectionContainer(
      'Detail Komponen Gaji',
      Icons.list_alt_rounded,
      primaryColor,
      'details',
      [
        _buildEnhancedDetailItem(
          'BPJS Kesehatan',
          'Perusahaan',
          'Rp 100.000',
          Icons.health_and_safety_rounded,
          primaryColor,
          isMobile,
        ),
        _buildEnhancedDetailItem(
          'BPJS Ketenagakerjaan',
          'Perusahaan',
          'Rp 200.000',
          Icons.security_rounded,
          primaryColor,
          isMobile,
        ),
        _buildEnhancedDetailItem(
          'PPH 21',
          'Pajak Penghasilan',
          'Rp 1.250.000',
          Icons.account_balance_rounded,
          primaryColor,
          isMobile,
        ),
        _buildEnhancedDetailItem(
          'Potongan Lainnya',
          'Biaya Admin',
          'Rp 50.000',
          Icons.receipt_long_rounded,
          primaryColor,
          isMobile,
        ),
      ],
      isMobile,
    );
  }

  Widget _buildEnhancedDeductions(BuildContext context, bool isMobile) {
    return _buildEnhancedSectionContainer(
      'Total Potongan',
      Icons.remove_circle_rounded,
      warningColor,
      'deductions',
      [
        _buildEnhancedDeductionItem(
          'Total Potongan',
          'Rp 1.600.000',
          warningColor,
          isMobile,
        ),
        const SizedBox(height: 12),
        _buildEnhancedDeductionItem(
          'Take Home Pay',
          'Rp 14.150.000',
          successColor,
          isMobile,
          isTotal: true,
        ),
      ],
      isMobile,
    );
  }

  Widget _buildEnhancedSectionContainer(
    String title,
    IconData icon,
    Color color,
    String sectionKey,
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
          onEnter: (_) =>
              setState(() => _hoverStates['section_$sectionKey'] = true),
          onExit: (_) =>
              setState(() => _hoverStates['section_$sectionKey'] = false),
          child: GestureDetector(
            onTap: () => _toggleExpand(sectionKey),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(isMobile ? 20 : 24),
                boxShadow: [
                  BoxShadow(
                    color: color.withOpacity(
                      (_hoverStates['section_$sectionKey'] ?? false)
                          ? 0.15
                          : 0.1,
                    ),
                    spreadRadius: 2,
                    blurRadius: (_hoverStates['section_$sectionKey'] ?? false)
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
                  color: (_hoverStates['section_$sectionKey'] ?? false)
                      ? color.withOpacity(0.2)
                      : Colors.white.withOpacity(0.8),
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(isMobile ? 20 : 24),
                    child: Row(
                      children: [
                        AnimatedBuilder(
                          animation: _moneyController,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: 0.9 + _moneyAnimation.value * 0.1,
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
                                child: Icon(
                                  icon,
                                  color: color,
                                  size: isMobile ? 22 : 24,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              fontSize: isMobile ? 18 : 20,
                              fontWeight: FontWeight.w800,
                              color: color,
                              letterSpacing: 0.8,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          transform: Matrix4.rotationZ(
                            _expandedStates[sectionKey]! ? pi / 2 : 0,
                          ),
                          child: Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: isMobile ? 18 : 20,
                            color: color.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 300),
                    crossFadeState: _expandedStates[sectionKey]!
                        ? CrossFadeState.showSecond
                        : CrossFadeState.showFirst,
                    firstChild: Container(),
                    secondChild: Column(children: items),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEnhancedSalaryItem(
    String title,
    String amount,
    IconData icon,
    Color color,
    bool isMobile, {
    bool isTotal = false,
  }) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hoverStates['salary_$title'] = true),
      onExit: (_) => setState(() => _hoverStates['salary_$title'] = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : 24,
          vertical: isMobile ? 14 : 16,
        ),
        decoration: BoxDecoration(
          color: (_hoverStates['salary_$title'] ?? false)
              ? color.withOpacity(0.05)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: isMobile ? 20 : 22),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: isMobile ? 15 : 16,
                  color: const Color(0xFF4B5563),
                  fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: AnimatedBuilder(
                animation: _moneyController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: isTotal
                        ? (0.98 + _moneyAnimation.value * 0.02)
                        : 1.0,
                    child: Text(
                      amount,
                      style: TextStyle(
                        fontSize: isMobile ? 15 : 16,
                        fontWeight: isTotal ? FontWeight.bold : FontWeight.w700,
                        color: isTotal ? successColor : const Color(0xFF1E293B),
                        shadows: isTotal
                            ? [
                                Shadow(
                                  color: successColor.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : [],
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.right,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedDetailItem(
    String title,
    String description,
    String amount,
    IconData icon,
    Color color,
    bool isMobile,
  ) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hoverStates['detail_$title'] = true),
      onExit: (_) => setState(() => _hoverStates['detail_$title'] = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : 24,
          vertical: isMobile ? 14 : 16,
        ),
        decoration: BoxDecoration(
          color: (_hoverStates['detail_$title'] ?? false)
              ? color.withOpacity(0.05)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: isMobile ? 20 : 22),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: isMobile ? 15 : 16,
                      color: const Color(0xFF1E293B),
                      fontWeight: FontWeight.w600,
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
                    maxLines: 1,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                amount,
                style: TextStyle(
                  fontSize: isMobile ? 15 : 16,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedDeductionItem(
    String title,
    String amount,
    Color color,
    bool isMobile, {
    bool isTotal = false,
  }) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hoverStates['deduction_$title'] = true),
      onExit: (_) => setState(() => _hoverStates['deduction_$title'] = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 20 : 24,
          vertical: isMobile ? 16 : 18,
        ),
        decoration: BoxDecoration(
          color: (_hoverStates['deduction_$title'] ?? false)
              ? color.withOpacity(0.05)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: isMobile ? 16 : 17,
                  fontWeight: isTotal ? FontWeight.bold : FontWeight.w700,
                  color: isTotal ? successColor : color,
                  letterSpacing: 0.3,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: AnimatedBuilder(
                animation: _moneyController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: isTotal
                        ? (0.98 + _moneyAnimation.value * 0.02)
                        : 1.0,
                    child: Text(
                      amount,
                      style: TextStyle(
                        fontSize: isMobile ? 16 : 17,
                        fontWeight: isTotal ? FontWeight.bold : FontWeight.w700,
                        color: isTotal ? successColor : color,
                        shadows: isTotal
                            ? [
                                Shadow(
                                  color: successColor.withOpacity(0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : [],
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      textAlign: TextAlign.right,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEnhancedActionButtons(BuildContext context, bool isMobile) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: [
        _buildEnhancedActionButton(
          context,
          Icons.download_rounded,
          'Download Slip',
          primaryColor,
          isMobile,
          _downloadPayroll,
        ),
        _buildEnhancedActionButton(
          context,
          Icons.share_rounded,
          'Bagikan',
          secondaryColor,
          isMobile,
          _sharePayroll,
        ),
        _buildEnhancedActionButton(
          context,
          Icons.print_rounded,
          'Print',
          accentColor,
          isMobile,
          _printPayroll,
        ),
      ],
    );
  }

  Widget _buildEnhancedActionButton(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    bool isMobile,
    VoidCallback onPressed,
  ) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hoverStates['button_$label'] = true),
      onExit: (_) => setState(() => _hoverStates['button_$label'] = false),
      child: GestureDetector(
        onTap: onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: isMobile ? null : 150,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: (_hoverStates['button_$label'] ?? false)
                  ? [color, Color.lerp(color, Colors.white, 0.3)!]
                  : [color.withOpacity(0.9), color.withOpacity(0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(
                  (_hoverStates['button_$label'] ?? false) ? 0.4 : 0.3,
                ),
                blurRadius: (_hoverStates['button_$label'] ?? false) ? 20 : 15,
                spreadRadius: 2,
                offset: const Offset(0, 6),
              ),
            ],
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: isMobile ? 20 : 22, color: Colors.white),
              const SizedBox(width: 10),
              Text(
                label,
                style: TextStyle(
                  fontSize: isMobile ? 14 : 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.5,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _downloadPayroll() {
    _showActionCompleted(
      'Mendownload slip gaji ${months[_selectedMonth]} $_selectedYear',
      successColor,
    );
  }

  void _sharePayroll() {
    _showActionCompleted(
      'Membagikan slip gaji ${months[_selectedMonth]} $_selectedYear',
      secondaryColor,
    );
  }

  void _printPayroll() {
    _showActionCompleted(
      'Mencetak slip gaji ${months[_selectedMonth]} $_selectedYear',
      accentColor,
    );
  }

  void _showActionCompleted(String message, Color color) {
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

  void _showPayrollStats(BuildContext context, bool isMobile) {
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
                'Statistik Payroll',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 24),
              _buildStatItem(
                'Gaji Pokok',
                'Rp 12.500.000',
                Icons.attach_money,
                moneyColor,
              ),
              _buildStatItem(
                'Total Tunjangan',
                'Rp 3.250.000',
                Icons.card_giftcard,
                accentColor,
              ),
              _buildStatItem(
                'Total Potongan',
                'Rp 1.600.000',
                Icons.remove_circle,
                warningColor,
              ),
              _buildStatItem(
                'Take Home Pay',
                'Rp 14.150.000',
                Icons.account_balance_wallet,
                successColor,
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
