class Phrase {
  const Phrase({
    required this.id,
    required this.category,
    required this.korean,
    required this.khmer,
    required this.pronunciation,
  });

  final int id;
  final String category;
  final String korean;
  final String khmer;
  final String pronunciation;

  factory Phrase.fromJson(Map<String, dynamic> json) {
    return Phrase(
      id: json['id'] as int,
      category: json['category'] as String,
      korean: json['korean'] as String,
      khmer: json['khmer'] as String,
      pronunciation: json['pronunciation'] as String,
    );
  }
}
