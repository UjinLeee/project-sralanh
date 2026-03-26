import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:project_sralanh/models/phrase.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 로컬에 저장된 단어(문구) ID 목록을 관리합니다.
class WordBookProvider extends ChangeNotifier {
  WordBookProvider() {
    _load();
  }

  static const String _prefsKey = 'word_book_saved_phrase_ids';

  final List<int> _savedIds = [];
  bool _loaded = false;

  bool get isLoaded => _loaded;

  List<int> get savedIds => List<int>.unmodifiable(_savedIds);

  bool isSaved(int phraseId) => _savedIds.contains(phraseId);

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_prefsKey);
      if (raw != null && raw.isNotEmpty) {
        final decoded = jsonDecode(raw);
        if (decoded is List<dynamic>) {
          _savedIds
            ..clear()
            ..addAll(
              decoded
                  .map((e) => e is int ? e : int.tryParse('$e'))
                  .whereType<int>(),
            );
        }
      }
    } catch (e) {
      debugPrint('WordBookProvider load error: $e');
    } finally {
      _loaded = true;
      notifyListeners();
    }
  }

  Future<void> _persist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsKey, jsonEncode(_savedIds));
    } catch (e) {
      debugPrint('WordBookProvider persist error: $e');
    }
  }

  /// 저장되어 있으면 제거하고, 없으면 목록 끝에 추가합니다.
  Future<void> toggleSave(Phrase phrase) async {
    final id = phrase.id;
    if (_savedIds.contains(id)) {
      _savedIds.remove(id);
    } else {
      _savedIds.add(id);
    }
    notifyListeners();
    await _persist();
  }

  List<Phrase> resolveSaved(List<Phrase> allPhrases) {
    if (_savedIds.isEmpty) return [];
    final byId = {for (final p in allPhrases) p.id: p};
    return _savedIds.map((id) => byId[id]).whereType<Phrase>().toList();
  }
}
