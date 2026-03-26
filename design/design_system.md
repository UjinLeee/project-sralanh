# Sralanh — 앱 전용 디자인 시스템

> **기준**: `lib/theme/app_theme.dart`, `home_screen.dart`, `phrase_study_screen.dart`에 구현된 색·타이포·패턴을 정리하고, 동일 톤으로 확장 컴포넌트를 정의합니다.  
> **플랫폼**: Flutter (Material 3)

---

## 1. 공통 컴포넌트 식별

### 1.1 식별 방법론

실제 코드에서 **반복되는 UI 패턴**을 추출했습니다. 일부는 `AppColors`·`ThemeData`와 연동되고, 일부는 화면 로컬 상수(틸 액센트, 슬레이트 톤)로 보강됩니다.

### 1.2 식별·정의된 컴포넌트

| Level | 컴포넌트 | 등장·용도 | 설명 |
|-------|---------|-----------|------|
| **Token** | `AppColors` + `buildAppTheme` | 전체 | M3 계열 팔레트, `GoogleFonts` 기반 텍스트 테마 |
| **Atom** | `khmerTextStyle` | 홈, 학습 카드 | 크메르어 전용 `Kantumruy Pro` 스타일 헬퍼 |
| **Atom** | `GlassIconButton` (패턴) | 홈 상단바 | 틸 포그라운드 + 민트 반투명 배경 원형 메뉴 버튼 |
| **Atom** | `PrimaryFAB` (패턴) | 홈, 학습 카드 | `AppColors.primary` 원형 + 볼륨 아이콘, elevation·그림자 |
| **Atom** | `ChipTag` | 홈 오늘의 문장 | `surfaceContainerLow` 캡슐 태그 |
| **Molecule** | `PhraseOfDayCard` | 홈 | 그라데이션 글로우 + 흰 카드 + 배지 + 크메르/한국어 |
| **Molecule** | `QuickActionGrid` | 홈 | 메인 CTA 타일 + 보조 2분할 타일 |
| **Molecule** | `FeaturedLessonRow` | 홈 | 썸네일 + 크메르 제목 + 메타 텍스트 행 |
| **Molecule** | **`SavedWordsOverview`** | 단어장 흐름(설계) | 저장 단어 목록·필터·빈 상태 — [§2.5](#25-molecule-savedwordsoverview--저장한-단어-모아보기) |
| **Organism** | `BlurredTopBar` | 홈, 학습 | `BackdropFilter` + 연민트 글래스 배경 |
| **Organism** | `BottomNavBar` | 홈 | 상단 라운드 글래스, 틸 선택 필, 슬레이트 비활성 · **프로필 탭 없음**(수업·레슨 · 사전·어휘 · 연습·실습 3탭) |
| **Organism** | `StudyChrome` | 학습 | 진행 헤더 + 하단 네비/도트 + `NEXT` 캡슐 |
| **Organism** | **`ThreeStepPhraseLayout`** | 학습 카드 | 한국어 → 발음 → 크메르 3구역 — [§2.6](#26-organism-threestepphraselayout--3단계-성구-레이아웃) |

---

## 2. 디자인 토큰 (`AppColors` + 화면 보조색)

### 2.1 Colors

> **원칙**: 브랜드·의미 색은 `AppColors`를 단일 출처로 쓰고, 글래스/탭 등에서만 틸·슬레이트 보조색을 허용합니다.

#### 코어 팔레트 (구현 확정)

```dart
// lib/theme/app_theme.dart — AppColors 요약
abstract final class AppColors {
  static const Color primary = Color(0xFF136964);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color primaryContainer = Color(0xFF80CBC4);
  static const Color onPrimaryContainer = Color(0xFF005652);

  static const Color secondary = Color(0xFF7B5549);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color secondaryContainer = Color(0xFFFFCCBC);
  static const Color onSecondaryContainer = Color(0xFF7A5448);

  static const Color tertiaryContainer = Color(0xFFFBAA8F);
  static const Color onTertiaryContainer = Color(0xFF773C28);

  static const Color surface = Color(0xFFF3FAFF);
  static const Color surfaceContainer = Color(0xFFDBF1FE);
  static const Color surfaceContainerLow = Color(0xFFE6F6FF);
  static const Color surfaceContainerHigh = Color(0xFFD5ECF8);
  static const Color surfaceContainerHighest = Color(0xFFCFE6F2);

  static const Color onSurface = Color(0xFF071E27);
  static const Color onSurfaceVariant = Color(0xFF3F4947);
  static const Color outlineVariant = Color(0xFFBEC9C7);

  static const Color primaryFixed = Color(0xFFA4F0E9);
  static const Color secondaryFixed = Color(0xFFFFDBD0);
}
```

#### 화면에서 추가로 쓰이는 보조색

| 토큰명(문서용) | HEX | 용도 |
|----------------|-----|------|
| `accentTeal` | `#0D9488` | 글래스 바 내 아이콘, 하단 탭 **선택** 배경 |
| `accentTealSurface` | `#CCFBF1` @ 35~50% | 상·하단 바 보더/버튼 배경 |
| `glassMint` | `#F0FDFA` @ 82% | 홈 상단 블러 배경 |
| `titleSlate` | `#1E293B` | 앱바·섹션 타이틀 (Plus Jakarta) |
| `mutedSlate` | `#64748B` | 비활성 탭 아이콘·라벨 |
| `footerMuted` | `#6F7977` | 학습 푸터 `PREVIOUS` 라벨·아이콘 |
| `shadow` | `#071E27` @ 4~6% | 카드·바 소프트 섀도 |
| `error` | `#BA1A1A` | `ColorScheme.error` |

**사용 규칙 (요약)**

| 요소 | 색상 | 비고 |
|------|------|------|
| 메인 CTA·재생 FAB | `primary` | 홈 학습 시작, 학습 카드 볼륨 |
| 진행 바 채움 | `primaryContainer` | 홈·학습 공통 |
| 따뜻한 배지·발음 블록 | `secondaryContainer` / `onSecondaryContainer` | 카테고리 원형, 발음 pill |
| 플로팅 채팅 FAB | `tertiaryContainer` / `onTertiaryContainer` | 홈 우하단 |
| 본문·캡션 | `onSurface` / `onSurfaceVariant` | 계층 구분 |
| 카드 보더 | `outlineVariant` @ 낮은 알파 | 미세 구분선 |
| 오늘의 문장 글로우 | `primaryFixed` + `secondaryFixed` @ 35% 그라데이션 | 홈 히어로 카드 |

### 2.2 Typography — 폰트 추천 3종

앱에 이미 적용된 조합이 **한·영 UI + 크메르 본문**에 균형이 좋아, 아래 3가지를 **권장 스택**으로 둡니다.

| 역할 | 폰트 | 용도 |
|------|------|------|
| **Display / 제목** | **Plus Jakarta Sans** | 화면 타이틀, 학습 카드 한국어 강조, 레슨 라벨 |
| **Body / UI** | **Be Vietnam Pro** | 본문, 캡션, 버튼·칩, 발음 표기, 퍼센트·메타 |
| **Khmer** | **Kantumruy Pro** | 크메르어 문장·레슨 제목 (`khmerTextStyle`) |

구현 참고: `buildAppTheme()`에서 본문에 Be Vietnam Pro, 헤드라인 계열에 Plus Jakarta Sans를 얹는 방식과 동일하게 유지합니다.

**타이포 스케일 (화면에서 관측된 대표값)**

| 용도 | 폰트 | 크기·굵기 (참고) |
|------|------|------------------|
| 홈 섹션 타이틀 | Plus Jakarta Sans | 22px, bold |
| 앱바 타이틀 | Plus Jakarta Sans | 20px, bold |
| 오늘의 문장 크메르 | Kantumruy Pro | ~32px, bold, `primary` |
| 오늘의 문장 한국어 | Be Vietnam Pro | 20px, w500 |
| 학습 카드 한국어 | Plus Jakarta Sans | 스케일 반응형 ~28sp, bold |
| 학습 카드 발음 | Be Vietnam Pro | 캡션 ~10sp / 본문 ~24sp, w600~w800 |
| 하단 탭 라벨 | Be Vietnam Pro | ~8.5sp, w600 |

### 2.3 Spacing & Radius

```dart
// 관측된 패턴 기준 (논리 픽셀)
const spacing = {
  'xs': 4,
  'sm': 8,
  'md': 12,
  'lg': 16,
  'xl': 20,
  '2xl': 24,
  '3xl': 32,
  '4xl': 40,
};

const radius = {
  'card': 24,        // 메인 카드, 퀵액션
  'cardInner': 16,   // 레슨 썸네일
  'pill': 999,       // 프로그레스 바, 칩, 탭 필
  'bottomSheet': 48, // 하단 네비 상단 코너
};
```

### 2.4 Shadow 프리셋

```dart
// 개념적 프리셋 (Flutter: BoxShadow)
const shadows = {
  'cardLift': BoxShadow(
    color: Color(0xFF071E27).withValues(alpha: 0.04),
    blurRadius: 40,
    offset: Offset(0, 20),
  ),
  'primaryButton': BoxShadow(
    color: AppColors.primary.withValues(alpha: 0.35),
    blurRadius: 0, // elevation과 병행
    offset: Offset(0, 8),
  ),
  'navBar': BoxShadow(
    color: Color(0xFF071E27).withValues(alpha: 0.06),
    blurRadius: 30,
    offset: Offset(0, -10),
  ),
};
```

---

## 2.5 Molecule: `SavedWordsOverview` — 저장한 단어 모아보기

사용자가 **저장한 어휘·문장을 한 화면에서 스캔·필터**할 때 쓰는 블록입니다. (홈의 `단어장` 진입 등과 연결 가정)

```
┌─────────────────────────────────────────────┐
│  저장한 단어                    [검색 🔍]      │
├─────────────────────────────────────────────┤
│  [#전체] [#인사] [#어린이] [#교회]  …        │  ← ChipTag 패턴 재사용
├─────────────────────────────────────────────┤
│  ┌─────────────────────────────────────┐    │
│  │ សួស្តី          저장됨 · 인사          │    │
│  │ 안녕하세요                             │    │
│  │ [발음] 안녕하세요                      │    │  ← secondaryContainer pill
│  └─────────────────────────────────────┘    │
│  ┌─────────────────────────────────────┐    │
│  │ … 다음 행 …                           │    │
│  └─────────────────────────────────────┘    │
└─────────────────────────────────────────────┘
```

```dart
// 제안 프로퍼티 (Flutter)
class SavedWordsOverviewProps {
  final String title;                    // e.g. '저장한 단어'
  final String? query;
  final ValueChanged<String>? onQueryChanged;
  final List<String> categories;         // category 키
  final String? selectedCategory;
  final ValueChanged<String?>? onCategoryChanged;
  final List<SavedWordItem> items;
  final VoidCallback? onItemTap;
  final void Function(SavedWordItem item)? onRemoveSaved;
}

class SavedWordItem {
  final String khmer;
  final String korean;
  final String pronunciation;
  final String category;                 // greeting | kids | church …
  final DateTime? savedAt;
}
```

**스타일 핵심**

- 화면 배경: `Scaffold` → `Colors.white` (현행과 동일).
- 섹션 타이틀: Plus Jakarta Sans, `onSurface`, 홈 `_FeaturedLesson`과 동일 위계.
- 필터 칩: 홈 `_ChipTag`와 동일 — 배경 `surfaceContainerLow`, 텍스트 `onSurfaceVariant`, 선택 시 `primary` 테두리 또는 `primaryContainer` 채움.
- 행 카드: 흰 배경, `radius.card`, `outlineVariant` @ 12% 보더, `shadows.cardLift` 수준.
- 행 내 크메르: `khmerTextStyle`, 색 `primary`.
- 행 내 한국어: Be Vietnam Pro, `onSurface`.
- 발음 한 줄: `secondaryContainer` 캡슐 + `onSecondaryContainer` (학습 카드 발음 블록과 통일).
- 빈 상태: 일러스트 또는 아이콘 + `onSurfaceVariant` 안내 문구, CTA는 `primary` filled.

---

## 2.6 Organism: `ThreeStepPhraseLayout` — 3단계 성구 레이아웃

학습 카드(`_StudyCard`)에서 **의미 단계가 위→아래로 고정**된 레이아웃입니다.

1. **KOREAN** — 목표 문장(학습자 모국어)  
2. **PRONUNCIATION** — 청각·발음 앵커  
3. **KHMER** — 현지어 표현  

```
        ┌── category 아이콘 원 (secondaryContainer)
        │
┌───────┴───────────────────────────────────────┐
│                                               │
│                    KOREAN                     │  ← Be Vietnam Pro 라벨
│              [한국어 본문, Plus Jakarta Bold]   │
│                                               │
│         ╭─────────────────────────╮           │
│         │ PRONUNCIATION           │           │  ← secondaryContainer pill
│         │ [ 발음 문자열 ]           │           │
│         ╰─────────────────────────╯           │
│                                               │
│                    KHMER                      │  ← Kantumruy Pro 라벨
│              [크메르 본문, Kantumruy Bold]     │
│                                               │
└───────────────────────────────────────────────┘
              ● 볼륨 FAB (primary, 하단 중앙 살짝 돌출)
```

```dart
// 제안 프로퍼티
class ThreeStepPhraseLayoutProps {
  final String korean;
  final String pronunciation;
  final String khmer;
  final String category;                 // categoryIcon 매핑용
  final VoidCallback onPlayAudio;
  /// 카드 높이는 shortest side 기준 반응형 (phrase_study_screen._StudyResponsive)
  final double cardWidth;
  final double cardHeight;
}
```

**스타일 핵심**

- 외곽: 흰 배경, 둥근 모서리(반응형 ~16–26), 미세 보더, 소프트 섀도.
- 상단 **11 : 하단 9** 세로 비율(`Expanded` flex)로 한국어+발음 구역과 크메르 구역 분리.
- 라벨(`KOREAN` / `KHMER`): Be Vietnam Pro, bold, letterSpacing ~2, 각각 `secondary`·`primary` 50% 알파.
- 발음 pill: `secondaryContainer`, 내부 캡션 + 본문 2단, 그림자는 `onSecondaryContainer` @ 12% 정도.
- 하단 FAB: `primary` 원, `Icons.volume_up_rounded`, 흰 아이콘, elevation 8.
- 스케일: `_StudyResponsive.studyCardInnerScale`로 짧은 카드에서 폰트 축소.

---

## 3. 토큰 ↔ 구현 매핑

| 문서 토큰 | 코드 위치 |
|-----------|-----------|
| 코어 색상 | `lib/theme/app_theme.dart` → `AppColors` |
| 테마 조립 | `buildAppTheme()` |
| 크메르 타이포 | `khmerTextStyle()` |
| 카테고리 칩·아이콘 | `categoryTagLabel`, `categoryDisplayName`, `categoryIcon` |

---

## 4. 변경 시 체크리스트

- [ ] 하단 내비(`BottomNavBar`)에 **프로필 탭을 두지 않을 것**(수업·레슨 · 사전·어휘 · 연습·실습 3탭만).
- [ ] 새 색이 들어가면 `AppColors`에 먼저 추가하고, 화면 하드코딩을 점진적으로 치환할 것.
- [ ] 한글/영문 UI는 Plus Jakarta Sans vs Be Vietnam Pro 역할이 뒤바뀌지 않도록 유지할 것.
- [ ] 크메르 문자열은 반드시 `Kantumruy Pro` 경로로 렌더할 것.
- [ ] `SavedWordsOverview`·`ThreeStepPhraseLayout`을 구현할 때 본 문서의 반지름·섀도를 홈/학습과 동기화할 것.
