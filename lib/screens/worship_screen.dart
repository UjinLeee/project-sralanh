import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_sralanh/models/prayer.dart';
import 'package:project_sralanh/theme/app_theme.dart';
import 'package:project_sralanh/widgets/blurred_sralanh_top_bar.dart';

class WorshipScreen extends StatefulWidget {
  const WorshipScreen({super.key});

  @override
  State<WorshipScreen> createState() => _WorshipScreenState();
}

class _WorshipScreenState extends State<WorshipScreen> {
  List<Prayer> _prayers = [];
  int _prayerIndex = 0;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final raw = await rootBundle.loadString('assets/data/prayers.json');
      final list = (jsonDecode(raw) as List<dynamic>)
          .map((e) => Prayer.fromJson(e as Map<String, dynamic>))
          .toList();
      if (!mounted) return;
      setState(() {
        _prayers = list;
        _loading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBody: true,
      body: Stack(
        children: [
          Positioned.fill(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            '기도문을 불러오지 못했습니다.\n$_error',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.notoSansKr(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        padding: EdgeInsets.fromLTRB(
                          20,
                          MediaQuery.paddingOf(context).top + 72,
                          20,
                          120 + bottomInset,
                        ),
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 560),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _PrayerSegmentBar(
                                  prayers: _prayers,
                                  selectedIndex: _prayerIndex,
                                  onChanged: (i) =>
                                      setState(() => _prayerIndex = i),
                                ),
                                const SizedBox(height: 20),
                                ..._prayers[_prayerIndex].content.map(
                                  (c) => Padding(
                                    padding: const EdgeInsets.only(bottom: 20),
                                    child: _PrayerVerseCard(content: c),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
          ),
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: BlurredSralanhTopBar(title: '예배'),
          ),
        ],
      ),
    );
  }
}

class _PrayerSegmentBar extends StatelessWidget {
  const _PrayerSegmentBar({
    required this.prayers,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<Prayer> prayers;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        children: List.generate(prayers.length, (i) {
          final selected = i == selectedIndex;
          return Expanded(
            child: Material(
              color: selected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(999),
              shadowColor: AppColors.shadowSoft,
              elevation: selected ? 2 : 0,
              child: InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: () => onChanged(i),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    prayers[i].title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.notoSansKr(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: selected
                          ? AppColors.accentTeal
                          : AppColors.mutedSlate,
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _PrayerVerseCard extends StatelessWidget {
  const _PrayerVerseCard({required this.content});

  final Content content;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.12),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowSoft,
            blurRadius: 32,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'KOREAN',
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSansKr(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: AppColors.secondary.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            content.korean,
            textAlign: TextAlign.center,
            style: GoogleFonts.gowunDodum(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 1.35,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.secondaryContainer,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.onSecondaryContainer
                        .withValues(alpha: 0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'PRONUNCIATION',
                    style: GoogleFonts.notoSansKr(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.6,
                      color: AppColors.onSecondaryContainer
                          .withValues(alpha: 0.72),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    content.pronunciation,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.notoSansKr(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      height: 1.4,
                      color: AppColors.onSecondaryContainer,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'KHMER',
            textAlign: TextAlign.center,
            style: GoogleFonts.notoSansKr(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: AppColors.primary.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 14),
          Text(
            content.khmer,
            textAlign: TextAlign.center,
            style: khmerTextStyle(
              context: context,
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
