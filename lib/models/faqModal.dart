class FAQ {
  final String title;
  final String subtitle;

  FAQ({required this.title, required this.subtitle});

  factory FAQ.fromJson(Map<String, dynamic> json) {
    return FAQ(
      title: json['question'] ?? '',
      subtitle: json['answer'] ?? '',
    );
  }

  @override
  String toString() {
    return 'FAQ(title: $title, subtitle: $subtitle)';
  }
}
