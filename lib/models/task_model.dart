class CommentModel {
  final String author;
  final String role; // 'Siswa' or 'Guru'
  final String text;
  final String timestamp;

  CommentModel({
    required this.author,
    required this.role,
    required this.text,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'author': author,
      'role': role,
      'text': text,
      'timestamp': timestamp,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      author: map['author'] ?? '',
      role: map['role'] ?? 'Siswa',
      text: map['text'] ?? '',
      timestamp: map['timestamp'] ?? '',
    );
  }
}

class TaskModel {
  String title;
  String subject;
  String className;
  String teacher;
  String description;
  String givenDate;
  String deadline;
  String status; // Not final so we can simulate status toggle/completion
  String priority;
  String? grade;
  String? feedback;
  String? submissionLink;
  String? submittedDate;
  List<CommentModel> comments;

  TaskModel({
    required this.title,
    required this.subject,
    required this.className,
    required this.teacher,
    required this.description,
    required this.givenDate,
    required this.deadline,
    required this.status,
    required this.priority,
    this.grade,
    this.feedback,
    this.submissionLink,
    this.submittedDate,
    List<CommentModel>? comments,
  }) : comments = comments ?? [];

  // Factory constructor to create from Map
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      title: map['title'] ?? '',
      subject: map['subject'] ?? '',
      className: map['className'] ?? '',
      teacher: map['teacher'] ?? '',
      description: map['description'] ?? '',
      givenDate: map['givenDate'] ?? '',
      deadline: map['deadline'] ?? '',
      status: map['status'] ?? 'Belum Dikerjakan',
      priority: map['priority'] ?? 'Sedang',
      grade: map['grade'],
      feedback: map['feedback'],
      submissionLink: map['submissionLink'],
      submittedDate: map['submittedDate'],
      comments: map['comments'] != null
          ? List<CommentModel>.from(map['comments']?.map((x) => CommentModel.fromMap(x)))
          : [],
    );
  }

  // Convert to Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'subject': subject,
      'className': className,
      'teacher': teacher,
      'description': description,
      'givenDate': givenDate,
      'deadline': deadline,
      'status': status,
      'priority': priority,
      'grade': grade,
      'feedback': feedback,
      'submissionLink': submissionLink,
      'submittedDate': submittedDate,
      'comments': comments.map((x) => x.toMap()).toList(),
    };
  }
}

class SubjectModel {
  final String name;
  final String teacher;
  final String code;
  final String className;
  final String createdBy;
  final String major;

  SubjectModel({
    required this.name,
    required this.teacher,
    required this.code,
    required this.className,
    required this.createdBy,
    required this.major,
  });
}
