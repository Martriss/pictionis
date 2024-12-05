class MessageEvent {
  final String user;
  final String message;
  final int timestamp;

  MessageEvent(
      {required this.user, required this.message, required this.timestamp});

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'message': message,
      'timestamp': timestamp,
    };
  }

  factory MessageEvent.fromJson(Map<String, dynamic> json) {
    return MessageEvent(
      user: json['user'] as String,
      message: json['message'] as String,
      timestamp: json['timestamp'] as int,
    );
  }
}
