class Task {
  final String id;
  final String title;
  final String description;
  final int xpReward;
  final int sustainabilityPoints;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? submissionType; // 'camera' or 'voice'
  final String? submissionData; // image path or voice transcript
  final bool isCompleted;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.xpReward,
    required this.sustainabilityPoints,
    required this.createdAt,
    this.completedAt,
    this.submissionType,
    this.submissionData,
    this.isCompleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'xpReward': xpReward,
      'sustainabilityPoints': sustainabilityPoints,
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'submissionType': submissionType,
      'submissionData': submissionData,
      'isCompleted': isCompleted,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      xpReward: map['xpReward'] ?? 0,
      sustainabilityPoints: map['sustainabilityPoints'] ?? 0,
      createdAt: DateTime.parse(map['createdAt']),
      completedAt: map['completedAt'] != null
          ? DateTime.parse(map['completedAt'])
          : null,
      submissionType: map['submissionType'],
      submissionData: map['submissionData'],
      isCompleted: map['isCompleted'] ?? false,
    );
  }
}
