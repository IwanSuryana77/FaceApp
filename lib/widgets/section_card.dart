import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import 'surface.dart';

class SectionCard extends StatelessWidget {
  final String title;
  final String actionText;
  final VoidCallback onActionTap;
  final Widget child;

  const SectionCard({
    super.key,
    required this.title,
    required this.actionText,
    required this.onActionTap,
    required this.child, required TextStyle titleStyle, required TextStyle actionTextStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Surface(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              TextButton(
                onPressed: onActionTap,
                child: Text(
                  actionText,
                  style: const TextStyle(
                    color: AppColors.navy,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }
}