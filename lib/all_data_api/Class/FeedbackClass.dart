class FeedbackClass {
  final String feedback;

  FeedbackClass({
    required this.feedback,
  });

  Map<String, dynamic> toJson() {
    return {
      'feedback': feedback,
    };
  }

  factory FeedbackClass.fromJson(Map<String, dynamic> json) {
    return FeedbackClass(
      feedback: json['feedback'] as String,
    );
  }
}
