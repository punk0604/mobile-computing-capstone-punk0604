class Swipe {
  final int? id;
  final int userId;
  final int jobId;
  final String type; // "like" or "dislike"
  final DateTime? timestamp;

  Swipe({
    this.id,
    required this.userId,
    required this.jobId,
    required this.type,
    this.timestamp,
  });

  // Convert Swipe to Map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'job_id': jobId,
      'type': type,
      'timestamp':
          timestamp?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }

  // Create Swipe from Map (database query)
  factory Swipe.fromMap(Map<String, dynamic> map) {
    return Swipe(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      jobId: map['job_id'] as int,
      type: map['type'] as String,
      timestamp: map['timestamp'] != null
          ? DateTime.parse(map['timestamp'] as String)
          : null,
    );
  }

  Swipe copyWith({
    int? id,
    int? userId,
    int? jobId,
    String? type,
    DateTime? timestamp,
  }) {
    return Swipe(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      jobId: jobId ?? this.jobId,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}
