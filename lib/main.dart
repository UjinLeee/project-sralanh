import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons/lucide_icons.dart';

void main() {
  runApp(const KhmerLearningApp());
}

class KhmerLearningApp extends StatelessWidget {
  const KhmerLearningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF3FAFF), // surface
        textTheme: GoogleFonts.beVietnamProTextTheme(),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // 디자인 시스템 색상 정의
  static const Color primary = Color(0xFF136964);
  static const Color primaryContainer = Color(0xFF80CBC4);
  static const Color secondaryContainer = Color(0xFFFFCCBC);
  static const Color onSecondaryContainer = Color(0xFF7A5448);
  static const Color onSurfaceVariant = Color(0xFF3F4947);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      // 1. Top App Bar
      appBar: AppBar(
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.menu, color: primary),
          onPressed: () {},
        ),
        title: Text(
          '홈',
          style: GoogleFonts.plusJakartaSans(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 20,
              backgroundColor: primaryContainer,
              backgroundImage: const NetworkImage('https://picsum.photos/seed/user/100/100'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 2. Today's Goal Section
            _buildGoalSection(),
            const SizedBox(height: 40),

            // 3. Phrase of the Day Card
            _buildPhraseCard(),
            const SizedBox(height: 40),

            // 4. Quick Start Actions
            _buildQuickActions(),
            const SizedBox(height: 40),

            // 5. Featured Lesson
            _buildFeaturedLesson(),
            const SizedBox(height: 100), // 하단 네비게이션 여백
          ],
        ),
      ),
      // 6. Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: secondaryContainer,
        shape: const CircleBorder(),
        child: const Icon(LucideIcons.messageCircle, color: onSecondaryContainer),
      ),
      // 7. Bottom Navigation
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildGoalSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('오늘의 목표', style: GoogleFonts.plusJakartaSans(fontSize: 24, fontWeight: FontWeight.bold)),
            const Text('85%', style: TextStyle(color: primary, fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
        const SizedBox(height: 16),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: const LinearProgressIndicator(
            value: 0.85,
            minHeight: 16,
            backgroundColor: Color(0xFFE6F6FF),
            valueColor: AlwaysStoppedAnimation<Color>(primaryContainer),
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          '조금만 더 힘내세요! 오늘의 학습 완료까지 얼마 남지 않았습니다.',
          style: TextStyle(color: onSurfaceVariant, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildPhraseCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(color: secondaryContainer, borderRadius: BorderRadius.circular(99)),
                child: const Text('오늘의 문장', style: TextStyle(color: onSecondaryContainer, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
              const CircleAvatar(
                backgroundColor: primary,
                child: Icon(LucideIcons.volume2, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'តើអ្នកសុខសប្បាយជាទេ?',
            style: GoogleFonts.kantumruyPro(fontSize: 36, fontWeight: FontWeight.bold, color: primary),
          ),
          const SizedBox(height: 8),
          const Text('잘 지내세요?', style: TextStyle(fontSize: 20, color: onSurfaceVariant, fontWeight: FontWeight.w500)),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildTag('#인사'),
              const SizedBox(width: 12),
              _buildTag('#기초'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: const Color(0xFFE6F6FF), borderRadius: BorderRadius.circular(99)),
      child: Text(label, style: const TextStyle(color: onSurfaceVariant, fontSize: 12)),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 160,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(32)),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(LucideIcons.playCircle, color: Colors.white, size: 40),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ចាប់ផ្តើមភ្លាមៗ', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    Text('학습 시작', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: SizedBox(
            height: 160,
            child: Column(
              children: [
                _buildSmallAction(secondaryContainer, LucideIcons.bookOpen, '단어장', onSecondaryContainer),
                const SizedBox(height: 16),
                _buildSmallAction(const Color(0xFFE6F6FF), LucideIcons.history, '기록', primary),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSmallAction(Color bg, IconData icon, String label, Color iconColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(24)),
        child: Row(
          children: [
            CircleAvatar(backgroundColor: Colors.white, radius: 18, child: Icon(icon, size: 18, color: iconColor)),
            const SizedBox(width: 12),
            Text(label, style: TextStyle(fontWeight: FontWeight.bold, color: iconColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedLesson() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('추천 레슨', style: GoogleFonts.plusJakartaSans(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32), border: Border.all(color: Colors.black.withOpacity(0.05))),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network('https://picsum.photos/seed/market/200/200', width: 80, height: 80, fit: BoxFit.cover),
              ),
              const SizedBox(width: 24),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('នៅផ្សារ', style: TextStyle(color: primary, fontWeight: FontWeight.bold)),
                    Text('시장 구경하기', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('15개 단어 • 5분', style: TextStyle(color: onSurfaceVariant, fontSize: 12)),
                  ],
                ),
              ),
              const Icon(LucideIcons.chevronRight, color: Colors.grey),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(48)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 30, offset: const Offset(0, -10))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(LucideIcons.graduationCap, 'មេរៀន', true),
          _buildNavItem(LucideIcons.bookOpen, 'វចនានុក្រម', false),
          _buildNavItem(LucideIcons.languages, 'ការអនុវត្ត', false),
          _buildNavItem(LucideIcons.user, 'ប្រវត្តិរូប', false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: isActive ? BoxDecoration(color: primary, borderRadius: BorderRadius.circular(99)) : null,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isActive ? Colors.white : Colors.grey),
          Text(label, style: TextStyle(color: isActive ? Colors.white : Colors.grey, fontSize: 10, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
