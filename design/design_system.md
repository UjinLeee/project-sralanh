# Sralanh — 앱 전용 디자인 시스템

> **기준**: `lib/theme/app_theme.dart`, `lib/screens/main_shell_screen.dart`, `home_tab_screen.dart`, `phrase_study_screen.dart`, `worship_screen.dart`, `saved_words_screen.dart`에 구현된 색·타이포·패턴을 정리하고, 동일 톤으로 확장 컴포넌트를 정의합니다.  
> **플랫폼**: Flutter (Material 3)  
> **쇼케이스 HTML**: `design/design_system_showcase_final.html`  
> **3단계 성구 이원화·예배(긴 글) 확장안**: `design/design_system_modify.md`, `design/design_system_showcase_modify.html`

---

## 1. 공통 컴포넌트 식별

### 1.1 식별 방법론

실제 코드에서 **반복되는 UI 패턴**을 추출했습니다. 일부는 `AppColors`·`ThemeData`와 연동되고, 일부는 화면 로컬 상수(틸 액센트, 슬레이트 톤)로 보강됩니다.

### 1.2 식별·정의된 컴포넌트

| Level | 컴포넌트 | 등장·용도 | 설명 |
|-------|---------|-----------|------|
| **Token** | `AppColors` + `buildAppTheme` | 전체 | M3 계열 팔레트, `GoogleFonts` 기반 텍스트 테마 |
| **Atom** | `khmerTextStyle` | 홈, 학습, 예배 | 크메르어 전용 `Kantumruy Pro`, **줄간격(height) ≥ 1.3** |
| **Atom** | `GlassIconButton` (패턴) | 상단바 | 틸 포그라운드 + 민트 반투명 배경 원형 버튼 |
| **Atom** | `PrimaryFAB` (패턴) | 홈, 학습 카드 | `AppColors.primary` 원형 + 볼륨 아이콘 |
| **Atom** | `ChipTag` | 홈 오늘의 문장 | `surfaceContainerLow` 캡슐 태그 |
| **Molecule** | `PhraseOfDayCard` | 홈 | 그라데이션 글로우 + 흰 카드 + 배지 + 크메르/한국어 |
| **Molecule** | `QuickActionGrid` | 홈 | 메인 CTA 타일 + 보조 2분할 타일 |
| **Molecule** | **`SavedWordsOverview`** | 단어장 탭 | 저장 단어 목록·필터·빈 상태 — [§2.5](#25-molecule-savedwordsoverview--저장한-단어-모아보기) |
| **Organism** | `BlurredTopBar` | 홈·단어장·예배·학습 | `BackdropFilter` + `glassMint` — 프로필 아바타 대신 검색 등 보조 슬롯 |
| **Organism** | `BottomNavBar` | 루트 | 상단 라운드 글래스, 틸 선택 필 — **홈 · 단어장 · 예배**(프로필 탭 없음) |
| **Organism** | `StudyChrome` | 학습 | 진행 헤더 + 하단 네비/도트 + `NEXT` 캡슐 |
| **Organism** | **`ThreeStepPhraseLayout` (Compact)** | `phrase_study_screen`, `phrases.json` | 단어·짧은 문장용 카드형 3단계 — [§2.6](#26-organism-threestepphraselayout-compact--단어--짧은-문장) |
| **Organism** | **`ThreeStepLiturgyLayout` (Long-form)** | `worship_screen`, `prayers.json` | 주기도문·사도신경 등 **절 단위 긴 본문**용 3단계. 현행은 Compact와 유사한 절 카드 반복. **대안 3안은 [§2.7](#27-예배긴-글-3단계--확장-안) 및 `design_system_modify.md`** |

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

  // 쇼케이스·구현 공통 보조 토큰
  static const Color accentTeal = Color(0xFF0D9488);
  static const Color titleSlate = Color(0xFF1E293B);
  static const Color mutedSlate = Color(0xFF64748B);
  // glassMint, accentTealSurface, accentTealBorder, shadowSoft, shadowNav — getter로 알파 적용
}
```

#### 화면에서 추가로 쓰이는 보조색

| 토큰명(문서용) | HEX / 알파 | 용도 |
|----------------|------------|------|
| `accentTeal` | `#0D9488` | 글래스 바 아이콘, 하단 탭 **선택** 필 |
| `accentTealSurface` | `#CCFBF1` @ 35~50% | 상·하단 바 버튼 배경 |
| `accentTealBorder` | `#CCFBF1` @ 35% | 글래스 바 하단/상단 보더 |
| `glassMint` | `#F0FDFA` @ 82% | 상단 블러 배경 |
| `titleSlate` | `#1E293B` | 앱바·섹션 타이틀 (한글 제목 폰트 위에 얹는 색) |
| `mutedSlate` | `#64748B` | 비활성 탭 |
| `footerMuted` | `#6F7977` | 학습 푸터 `PREVIOUS` |
| `shadowSoft` / `shadowNav` | `#071E27` @ 4~6% | 카드·하단 네비 |

**사용 규칙 (요약)**  
(기존과 동일: CTA·진행바·발음 pill·본문 위계·카드 보더·히어로 글로우.)

### 2.2 Typography — 폰트 스택 (쇼케이스·앱 정렬)

| 역할 | 폰트 | 용도 |
|------|------|------|
| **Display / 제목** | **Gowun Dodum** | 화면·섹션 타이틀, 학습 카드 한국어 강조 |
| **Body / UI** | **Noto Sans KR** | 본문, 캡션, 버튼·칩, 발음 표기, 하단 탭 라벨 |
| **Khmer** | **Kantumruy Pro** | 크메르 본문 (`khmerTextStyle`), **height ≥ 1.3** |

구현: `buildAppTheme()`에서 본문 계열에 Noto Sans KR, 타이틀/헤드라인에 Gowun Dodum을 적용합니다.

**타이포 스케일 (참고)**

| 용도 | 폰트 | 크기·굵기 (참고) |
|------|------|------------------|
| 홈 섹션 타이틀 | Gowun Dodum | 22px, bold |
| 앱바 타이틀 | Gowun Dodum | 20px, bold |
| 오늘의 문장 크메르 | Kantumruy Pro | ~32px, bold, `primary`, height ≥ 1.3 |
| 오늘의 문장 한국어 | Noto Sans KR | 20px, w500 |
| 학습 카드 한국어 | Gowun Dodum | 반응형 ~28sp, bold |
| 학습 카드 발음 | Noto Sans KR | 캡션 ~10sp / 본문 ~24sp, w600~w800 |
| 하단 탭 라벨 | Noto Sans KR | ~8.5sp, w600 |
| 예배 절(긴 글) 크메르 | Kantumruy Pro | 본문 24~28sp, **height 1.35~1.45** 권장 |

### 2.3 Spacing & Radius

```dart
const spacing = {
  'xs': 4, 'sm': 8, 'md': 12, 'lg': 16, 'xl': 20,
  '2xl': 24, '3xl': 32, '4xl': 40,
};

const radius = {
  'card': 24,
  'cardInner': 16,
  'pill': 999,
  'bottomSheet': 48,
  'liturgyVerse': 20,   // 긴 글 절 카드 (제안)
};
```

### 2.4 Shadow 프리셋

```dart
// 개념적 프리셋 — AppColors.shadowSoft / shadowNav 와 동일 계열
```

---

## 2.5 Molecule: `SavedWordsOverview` — 저장한 단어 모아보기

(레이아웃·프로퍼티 다이어그램은 기존과 동일.)

**스타일 핵심 (폰트만 갱신)**

- 섹션 타이틀: **Gowun Dodum**, `onSurface`.
- 행 내 한국어: **Noto Sans KR**, `onSurface`.
- 나머지(칩, 카드, 크메르, 발음 pill)는 §2.1·§2.2와 동일 패턴.

---

## 2.6 Organism: `ThreeStepPhraseLayout` (Compact) — 단어 / 짧은 문장

**데이터**: `assets/data/phrases.json` — 카테고리·짧은 구절.  
**화면**: `phrase_study_screen.dart`의 `_StudyCard` 패턴.

학습 카드에서 **의미 단계가 위→아래로 고정**됩니다.

1. **KOREAN**  
2. **PRONUNCIATION**  
3. **KHMER**

**스타일 핵심**

- 외곽: 흰 배경, 둥근 모서리(반응형 ~16–26), 미세 보더, 소프트 섀도.
- 상단 **11 : 하단 9** 세로 비율로 한국어+발음 구역과 크메르 구역 분리.
- 라벨: **Noto Sans KR**, bold, letterSpacing ~2, 색은 `secondary` / `primary` 50% 알파.
- 한국어 본문 강조: **Gowun Dodum** bold.
- 발음 pill: `secondaryContainer` + `onSecondaryContainer`.
- 하단 FAB: `primary` + `Icons.volume_up_rounded`.
- 스케일: `_StudyResponsive.studyCardInnerScale`.

```dart
class ThreeStepPhraseLayoutProps {
  final String korean;
  final String pronunciation;
  final String khmer;
  final String category;
  final VoidCallback onPlayAudio;
  final double cardWidth;
  final double cardHeight;
}
```

---

## 2.7 예배(긴 글) 3단계 — 확장 안

**데이터**: `assets/data/prayers.json` — 기도문 단위 `title` + `content[]` 절, 각 절 `{ korean, pronunciation, khmer }`.  
**화면**: `worship_screen.dart` (현재는 절마다 Compact와 유사한 세로 스택 카드를 반복).

긴 글은 **한 화면 정보 밀도·스크롤 길이·집중도**가 Compact와 다릅니다. 동일한 3단계 **순서**는 유지하되, 레이아웃·내비게이션은 아래 문서에서 **3가지 설계안**으로 구체화합니다.

| 문서 / 파일 | 내용 |
|-------------|------|
| `design_system_modify.md` | 모드 비교표, 안 A/B/C 스펙, Flutter·JSON 매핑 메모 |
| `design_system_showcase_modify.html` | Compact vs 긴 글 3안 시각 데모 |

---

## 3. 토큰 ↔ 구현 매핑

| 문서 토큰 | 코드 위치 |
|-----------|-----------|
| 코어·보조 색상 | `lib/theme/app_theme.dart` → `AppColors` |
| 테마 조립 | `buildAppTheme()` |
| 크메르 타이포 | `khmerTextStyle()` |
| 카테고리 칩·아이콘 | `categoryTagLabel`, `categoryDisplayName`, `categoryIcon` |
| 루트 탭 | `main_shell_screen.dart` |
| Compact 3단계 | `phrase_study_screen.dart` |
| 예배 3단계(현행) | `worship_screen.dart` |

---

## 4. 변경 시 체크리스트

- [ ] 하단 내비에 **프로필 탭 없음** — **홈 · 단어장 · 예배**만.
- [ ] 새 색은 `AppColors`에 먼저 추가 후 화면 하드코딩 치환.
- [ ] 한글 UI: **제목 Gowun Dodum**, **본문·캡션 Noto Sans KR** 역할 유지.
- [ ] 크메르는 **Kantumruy Pro**, **height ≥ 1.3** (긴 글은 modify 문서 권장값 참고).
- [ ] `phrases.json` → Compact, `prayers.json` → Long-form; 예배 UI 변경 시 `design_system_modify.md`와 동기화.
- [ ] `SavedWordsOverview`·카드 반지름·섀도는 홈·학습·예배 간 일관 유지.
