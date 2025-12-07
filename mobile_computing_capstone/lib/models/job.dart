class Job {
  final int? id;
  final String title;
  final String company;
  final String description;
  final double? salary;
  final String tags; // JSON string
  final String applyUrl;
  final bool saved;

  Job({
    this.id,
    required this.title,
    required this.company,
    required this.description,
    this.salary,
    required this.tags,
    required this.applyUrl,
    this.saved = false,
  });

  // Convert Job to Map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'company': company,
      'description': description,
      'salary': salary,
      'tags': tags,
      'apply_url': applyUrl,
      'saved': saved ? 1 : 0,
    };
  }

  // Create Job from Map (database query)
  factory Job.fromMap(Map<String, dynamic> map) {
    return Job(
      id: map['id'] as int?,
      title: map['title'] as String,
      company: map['company'] as String,
      description: map['description'] as String,
      salary: map['salary'] as double?,
      tags: map['tags'] as String,
      applyUrl: map['apply_url'] as String,
      saved: map['saved'] == 1,
    );
  }

  // Helper methods to work with tags as List<String>
  List<String> getTagsList() {
    if (tags.isEmpty) return [];
    // Remove brackets and split by comma
    return tags
        .replaceAll('[', '')
        .replaceAll(']', '')
        .split(',')
        .map((tag) => tag.trim().replaceAll('"', ''))
        .where((tag) => tag.isNotEmpty)
        .toList();
  }

  static String tagsListToString(List<String> tagsList) {
    return tagsList.map((tag) => '"$tag"').join(',');
  }

  Job copyWith({
    int? id,
    String? title,
    String? company,
    String? description,
    double? salary,
    String? tags,
    String? applyUrl,
    bool? saved,
  }) {
    return Job(
      id: id ?? this.id,
      title: title ?? this.title,
      company: company ?? this.company,
      description: description ?? this.description,
      salary: salary ?? this.salary,
      tags: tags ?? this.tags,
      applyUrl: applyUrl ?? this.applyUrl,
      saved: saved ?? this.saved,
    );
  }
}
