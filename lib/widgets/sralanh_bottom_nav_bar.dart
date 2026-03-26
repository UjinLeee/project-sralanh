import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_sralanh/theme/app_theme.dart';

/// BottomNavBar — design_system_showcase_final.html (tabbar-sralanh · 3탭).
class SralanhNavItem {
  const SralanhNavItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}

class SralanhBottomNavBar extends StatelessWidget {
  const SralanhBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    required this.bottomPadding,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<SralanhNavItem> items;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 12,
            bottom: 24 + bottomPadding,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.82),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(48)),
            border: Border(
              top: BorderSide(color: AppColors.accentTealBorder),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowNav,
                blurRadius: 30,
                offset: const Offset(0, -10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (i) {
              final item = items[i];
              final selected = i == currentIndex;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Material(
                    color: selected ? AppColors.accentTeal : Colors.transparent,
                    borderRadius: BorderRadius.circular(999),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(999),
                      onTap: () => onTap(i),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 4,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              item.icon,
                              size: 22,
                              color: selected
                                  ? Colors.white
                                  : AppColors.mutedSlate,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item.label,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.notoSansKr(
                                fontSize: 8.5,
                                fontWeight: FontWeight.w600,
                                height: 1.15,
                                letterSpacing: 0.2,
                                color: selected
                                    ? Colors.white
                                    : AppColors.mutedSlate,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
