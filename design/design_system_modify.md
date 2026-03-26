# Sralanh — 3단계 성구 이원화 & 예배(긴 글) 확장 설계

> **상위 문서**: `design_system.md`, `design_system_showcase_final.html`  
> **시각 데모**: `design_system_showcase_modify.html`  
> **데이터**: 짧은 학습 `assets/data/phrases.json` · 예배/긴 글 `assets/data/prayers.json`

---

## 1. 목적

동일한 콘텐츠 모델 **{ korean, pronunciation, khmer }**와 동일한 **인지 순서(한국어 → 발음 → 크메르)**를 유지하면서,

| 모드 | 데이터 | 특성 | 권장 레이아웃 토큰 |
|------|--------|------|-------------------|
| **Compact** | `phrases.json` | 단어·짧은 문장, 카드 1장에 1구절 | `ThreeStepPhraseLayout` — 기존 학습 카드 |
| **Long-form (Liturgy)** | `prayers.json` | 절이 많고 문장이 길며 연속 낭독 | 아래 **안 A / B / C** 중 선택 또는 혼합 |

현재 앱(`worship_screen.dart`)은 Long-form을 **절마다 Compact형 카드를 세로 반복**한 상태입니다. 본 문서는 **긴 글 전용 UX 3안**을 정의합니다.

---

## 2. 공통 원칙 (두 모드 공통)

- 크메르: `Kantumruy Pro`, **line height ≥ 1.3** (긴 글은 **1.35~1.45** 권장).
- 한국어 제목·강조: **Gowun Dodum**; 캡션·발음·메타: **Noto Sans KR**.
- 색: `primary` / `secondary` / `surfaceContainer*` / `accentTeal` — `design_system.md` §2.1 준수.
- 오디오: 절 단위 또는 기도문 단위 재생 시, Compact와 동일하게 **primary FAB** 또는 앱바 액션으로 일관.

---

## 3. Long-form 전용 — 설계 안 3가지

### 안 A — `LiturgyVerseStream` (연속 절 스트림)

**한 줄 요약**: 한 스크롤로 전 절을 읽되, 절마다 **리듬(구분선·좌측 액센트)**으로 호흡을 나눈다.

| 항목 | 스펙 |
|------|------|
| 구조 | `ListView` / `SliverList`로 `content[]` 순회. 각 절은 **하나의 행 블록**(카드 또는 플랫 패널). |
| 구분 | 절 왼쪽 `primary` 3~4px 세로 바 또는 `primaryContainer` @ 낮은 알파 배경 띠. |
| 메타 | 절 인덱스 `3 / 9` 를 작은 **Noto** 캡슐로 블록 상단 좌측. |
| 3단계 | 세로 순서 유지. 발음은 **전폭이 아닌** `secondaryContainer` pill (Compact보다 약간 낮은 패딩). |
| 타이포 | 한국어·크메르 본문 폰트 크기를 Compact보다 **1~2sp 축소**해 스크롤 길이 완화. |
| 적합 | 한 번에 흐름 읽기, 인쇄물·성경책 스크롤에 익숙한 사용자. |

**Flutter 메모**: `Prayer.content` map → `VerseBlock` 위젯. 선택 시 `ScrollablePositionedList`로 특정 절 점프 가능.

---

### 안 B — `LiturgyVersePager` (절 단위 풀스크린 페이저)

**한 줄 요약**: **한 번에 한 절만** 크게 보여 주고, `StudyChrome`과 유사한 **이전 / 도트 / 다음**으로만 이동.

| 항목 | 스펙 |
|------|------|
| 구조 | `PageView` + `PageController`, 또는 `TabBarView` 대체. |
| 카드 | 화면 폭의 ~92%, 세로는 SafeArea 내 가용 높이; 3단계는 **중앙 정렬**, 줄바꿈 허용. |
| 크메르 | 짧은 모드보다 **조금 작게** 시작해 `FittedBox`/`LayoutBuilder`로 오버플로 방지. |
| 하단 | `StudyFooter` 패턴 재사용: `PREVIOUS` · 절 도트(최대 N개 가시) · `NEXT` 캡슐. |
| 상단 | 기도문 제목(`title`) + `주기도문` ↔ `사도신경` 세그먼트는 **페이저 바깥** 고정. |
| 적합 | 집중 낭독, 한 손 엄지 조작, 스크롤 피로 감소. |

**Flutter 메모**: `prayers.json`에서 `Prayer` 선택 후 `content.length`로 `PageView` 빌드. 세그먼트 변경 시 `jumpToPage(0)`.

---

### 안 C — `LiturgyCollapsiblePron` (접이식 발음 사다리)

**한 줄 요약**: 기본 화면에서는 **한국어 + 크메르**를 강조하고, **발음은 접힌 상태**(한 줄 요약 또는 "발음 보기")로 두어 세로 길이를 줄인다.

| 항목 | 스펙 |
|------|------|
| 구조 | 절 블록마다 `ExpansionTile` / `AnimatedCrossFade` / `showModalBottomSheet` 중 하나. |
| 기본 | `KOREAN` 라벨 + 한국어 본문 → `KHMER` 라벨 + 크메르 본문. |
| 발음 | 접힘: `surfaceContainerHigh` 바에 "발음 · 탭하여 펼치기" (Noto 12~13). 펼침: 기존 **pron pill** 전체. |
| 대안 | 발음만 **바텀시트**로 분리(긴 로마자/한글 발음이 줄을 많이 먹을 때). |
| 적합 | 발음은 가끔만 참고하고, 크메르 정독이 우선인 사용자. |

**Flutter 메모**: `ExpansionTile`의 `tilePadding`을 타이트하게; 크메르 블록은 항상 펼침 유지.

---

## 4. 안별 비교 요약

| | A 스트림 | B 페이저 | C 접이식 발음 |
|--|----------|----------|----------------|
| 스크롤량 | 많음 | 적음(절 내만) | 중간(발음 접으면 감소) |
| 맥락 파악(전체) | 쉬움 | 어려움(목차/점프 UI 보강) | 중간 |
| 구현 난이도 | 낮음 | 중간(PageView+크롬) | 중간(상태·애니메이션) |
| 오디오 동기화 | 절 하이라이트 추천 | 현재 절만 강조 | 현재 절 + 펼친 발음 |

---

## 5. JSON · 모델 (변경 없음)

`prayers.json` 구조는 그대로 두고, 위 안들은 **표현층**만 바꿉니다.

```json
{
  "id": "lords_prayer",
  "title": "주기도문",
  "content": [
    { "korean": "…", "pronunciation": "…", "khmer": "…" }
  ]
}
```

---

## 6. 권장 도입 순서

1. **안 A**로 스트림+리듬만 정리(현행과 가장 유사, 디자인만 다듬기).  
2. 사용자 설정 또는 실험 플래그로 **안 B** 제공(집중 모드).  
3. 설정에서 **안 C**(발음 기본 접힘) 옵션 추가.

---

## 7. 체크리스트 (예배 화면 수정 시)

- [ ] Compact(`phrase_study_screen`)와 **폰트·색 토큰** 공유.  
- [ ] 긴 글 크메르 **line height** §2 및 본 문서 §2 준수.  
- [ ] 선택한 안(A/B/C)을 `design_system.md` §2.7 링크와 함께 코드 주석 또는 README에 명시.  
- [ ] `design_system_showcase_modify.html`과 시각적으로 불일치 없도록 주기적 동기화.
