import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SvgIconTile extends StatelessWidget {
  final String asset;
  final String label;
  final VoidCallback? onTap;

  const SvgIconTile({
    super.key,
    required this.asset,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: const Color.fromARGB(234, 251, 254, 255),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color.fromARGB(179, 245, 248, 252)),
            ),
            child: Center(child: Image.asset(asset, width: 30, height: 30)),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.navy,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.25,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
