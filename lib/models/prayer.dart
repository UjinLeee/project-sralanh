class Prayer {
  final String id;
  final String title;
  final List<Content> content;

  Prayer({required this.id, required this.title, required this.content});

  factory Prayer.fromJson(Map<String, dynamic> json) {
    var contentList = json['content'] as List;
    List<Content> contentItems = contentList
        .map((i) => Content.fromJson(i))
        .toList();
    return Prayer(id: json['id'], title: json['title'], content: contentItems);
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> contentItems = content
        .map((i) => i.toJson())
        .toList();
    return {'id': id, 'title': title, 'content': contentItems};
  }
}

class Content {
  final String korean;
  final String pronunciation;
  final String khmer;

  Content({
    required this.korean,
    required this.pronunciation,
    required this.khmer,
  });

  factory Content.fromJson(Map<String, dynamic> json) {
    return Content(
      korean: json['korean'],
      pronunciation: json['pronunciation'],
      khmer: json['khmer'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'korean': korean, 'pronunciation': pronunciation, 'khmer': khmer};
  }
}
